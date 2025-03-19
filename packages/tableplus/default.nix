{
  stdenv,
  fetchurl,
  lib,
  wrapGAppsHook3,
  cpio,
  rpm,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  gtksourceview,
  json-glib,
  krb5,
  libgee,
  libsecret,
  pango,
  sqlite,
}: let
  version = "1.2.4-260";

  rpath =
    lib.makeLibraryPath [
      cairo
      gdk-pixbuf
      glib
      gtk3
      gtksourceview
      json-glib
      krb5.lib
      libgee
      libsecret
      pango
      sqlite
    ]
    + ":${stdenv.cc.cc.lib}/lib";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux"
    then
      fetchurl {
        url = "https://yum.tableplus.com/rpm/x86_64/tableplus-${version}.x86_64.rpm";
        sha256 = "sha256-jBT4l85kE1hOYnfnXHVrsIq5NfaX6cq7Af8WzanCOvI=";
      }
    else throw "This derivation for TablePlus is not supported on ${stdenv.hostPlatform.system}";
in
  stdenv.mkDerivation {
    pname = "tableplus";
    inherit version;

    system = "x86_64-linux";

    inherit src;

    nativeBuildInputs = [
      wrapGAppsHook3
      glib # For setup hook populating GSETTINGS_SCHEMA_PATH
    ];

    buildInputs = [
      cpio
      rpm
    ];

    unpackPhase = ''
      mkdir -p $out
      rpm2cpio $src | cpio -idmv -D $out
    '';

    installPhase = ''
      mkdir -p $out/bin $out/share/tableplus $out/share/applications
      mv -v $out/opt/tableplus/tableplus.desktop $out/share/applications
      mv -v $out/opt/tableplus $out/share

      ln -sv "$out/share/tableplus/tableplus" "$out/bin/tableplus"

      rm -rf $out/opt $out/usr

      # Otherwise it looks "suspicious"
      chmod -R g-w $out
    '';

    postFixup = ''
      for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* -or -name \*.node\* \) ); do
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
        patchelf --set-rpath ${rpath}:$out/share/tableplus $file || true
      done

      # Fix the desktop link
      substituteInPlace $out/share/applications/tableplus.desktop \
        --replace-fail /usr/local/bin/ $out/bin/ \
        --replace-fail /opt/tableplus/ $out/share/tableplus/
    '';

    meta = {
      description = "Database management made easy";
      homepage = "https://tableplus.com/";
      license = lib.licenses.unfree;
      platforms = ["x86_64-linux"];
    };
  }
