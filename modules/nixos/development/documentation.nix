{pkgs, ...}: {
  # Man Pages
  # https://nixos.wiki/wiki/Man_pages

  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
  ];

  documentation = {
    dev.enable = true;
    doc.enable = true;
    info.enable = true;

    man = {
      enable = true;

      # In order to enable to mandoc man-db has to be disabled.
      man-db.enable = false;
      mandoc.enable = true;
    };
  };
}
