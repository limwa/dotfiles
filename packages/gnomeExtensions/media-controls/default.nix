{
  fetchFromGitHub,
  gnomeExtensions,
}:
gnomeExtensions.media-controls.overrideAttrs (old: {
  src = fetchFromGitHub {
    owner = "limwa";
    repo = "media-controls";
    rev = "fix/left-click-toggles-menu";
    hash = "sha256-qt2jWqJF6ZFvN5gXKzzwwmgLbcZl50GzVcrX+cWjzFA=";
  };
})
