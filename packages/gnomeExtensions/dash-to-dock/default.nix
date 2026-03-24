{
  gnomeExtensions,
  fetchzip,
}:
gnomeExtensions.dash-to-dock.overrideAttrs {
  version = "104";
  src = fetchzip {
    url = "https://github.com/micheleg/dash-to-dock/releases/download/extensions.gnome.org-v104/dash-to-dock@micxgx.gmail.com.zip";
    hash = "sha256-VlQpZE7FA6m2Mn3qZMyFlcXxa6cJZslhTK4MhHahmWk=";
    stripRoot = false;
  };
}
