#!/usr/bin/env nix-shell
#! nix-shell -i python -p "python3.withPackages (ps: [ps.jinja2])"

import argparse
import json
import os
import subprocess
import sys
from dataclasses import dataclass
from collections import defaultdict

import jinja2

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
TEMPLATE_DIR = os.path.join(SCRIPT_DIR, "templates")

def get_flake_uris_from_environ() -> list[str]:
    """
    Retrieves flake URIs from the environment variable `INPUT_FLAKE_URIS`, which is expected to be a comma-separated string of URIs.
    """

    if "INPUT_FLAKE_URIS" not in os.environ:
        return []

    env_uris = map(lambda u: u.strip(), os.environ["INPUT_FLAKE_URIS"].split(","))
    return [u for u in env_uris if u]

@dataclass
class EvalResultOk:
    uri: str
    system: str

@dataclass
class EvalResultError:
    uri: str
    stderr: str

def eval_flake_uri(uri: str) -> EvalResultOk | EvalResultError:
    """
    Returns the build platform system for the given flake URI by evaluating it with `nix eval`.
    The `stdenv` attribute is used as a convention to determine the build platform, but this may not work for all flakes.
    """

    result = subprocess.run(
        ["nix", "eval", "--raw", f"{uri}.stdenv.buildPlatform.system"],
        capture_output=True,
        text=True,
    )

    if result.returncode != 0:
        stderr = result.stderr.strip()
        return EvalResultError(uri=uri, stderr=stderr)

    system = result.stdout.strip()
    return EvalResultOk(uri=uri, system=system)


def eval_flake_uris(uris: list[str]) -> tuple[list[EvalResultOk], list[EvalResultError]]:
    """
    Evaluates a list of flake URIs and returns a tuple containing two lists: one for successful evaluations (EvalResultOk) and one for errors (EvalResultError).
    """

    eval_oks = list[EvalResultOk]()
    eval_errors = list[EvalResultError]()

    print("Evaluating URIs...", file=sys.stderr)

    for uri in uris:
        print(f"  → {uri}: ", file=sys.stderr, end="", flush=True)

        eval_result = eval_flake_uri(uri)

        if isinstance(eval_result, EvalResultError):
            print("error", file=sys.stderr)
            eval_errors.append(eval_result)
        else:
            print(eval_result.system, file=sys.stderr)
            eval_oks.append(eval_result)

    return eval_oks, eval_errors

@dataclass
class BuildMatrixEntry:
    system: str
    uris: list[str]

def get_build_matrix(eval_oks: list[EvalResultOk]) -> list[BuildMatrixEntry]:
    """
    Groups the successful evaluation results by their build platform system and returns a list of BuildMatrixEntry objects.
    """

    matrix_dict = defaultdict[str, list[str]](list)

    for eval_ok in eval_oks:
        matrix_dict[eval_ok.system].append(eval_ok.uri)

    return [BuildMatrixEntry(system=system, uris=uris) for system, uris in matrix_dict.items()]


def generate_error_report(errors: list[EvalResultError]) -> str:
    """
    Generates a markdown report for the given list of evaluation errors using a Jinja2 template.
    """

    env = jinja2.Environment(loader=jinja2.FileSystemLoader(TEMPLATE_DIR))
    template = env.get_template("report.md.j2")

    return template.render(errors=errors)


def main():
    parser = argparse.ArgumentParser()
    _ = parser.add_argument("--outdir", default=".", help="The directory where the outputs will be written to.")
    _ = parser.add_argument("flake_uris", nargs="*", metavar="flake-uris")

    args = parser.parse_args()

    paths = list[str]()
    paths.extend(args.flake_uris)
    paths.extend(get_flake_uris_from_environ())

    if not paths:
        print("error: no flake URIs provided.", file=sys.stderr)
        parser.print_help(sys.stderr)
        sys.exit(1)

    eval_oks, eval_errors = eval_flake_uris(paths)

    matrix_path = os.path.join(args.outdir, "matrix.json")
    print(f"Writing build matrix to {matrix_path}...", file=sys.stderr)
    
    with open(matrix_path, "w") as f:
        matrix = get_build_matrix(eval_oks)
        _ = f.write(json.dumps(matrix, default=lambda o: o.__dict__, sort_keys=True))
    
    report_path = os.path.join(args.outdir, "report.md")
    print(f"Writing report to {report_path}...", file=sys.stderr)
    
    with open(report_path, "w") as f:
        report = generate_error_report(eval_errors)
        _ = f.write(report)


if __name__ == "__main__":
    main()
