# Partly generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{
  self,
  lib,
  ...
}: {
  programs.dconf = {
    enable = true;

    profiles = {
      user.databases = [
        {
          lockAll = false;
          settings = with lib.gvariant; {
            "org/gnome/TextEditor" = {
              restore-session = false;
            };

            "org/gnome/desktop/background" = {
              picture-options = "zoom";
              picture-uri = "file://${self}/backgrounds/montclair_light.webp";
              picture-uri-dark = "file://${self}/backgrounds/montclair_dark.webp";
            };

            "org/gnome/desktop/datetime" = {
              automatic-timezone = true;
            };

            "org/gnome/desktop/interface" = {
              clock-format = "24h";
              clock-show-weekday = true;
              color-scheme = "prefer-dark";
              enable-hot-corners = false;
              show-battery-percentage = true;
            };

            "org/gnome/desktop/peripherals/touchpad" = {
              two-finger-scrolling-enabled = true;
            };

            "org/gnome/desktop/privacy" = {
              old-files-age = mkUint32 30;
              recent-files-max-age = mkUint32 30;
              remove-old-temp-files = true;
              remove-old-trash-files = true;
              report-technical-problems = true;
            };

            "org/gnome/desktop/screensaver" = {
              picture-options = "zoom";
              picture-uri = "file://${self}/backgrounds/montclair_light.webp";
            };

            "org/gnome/desktop/wm/preferences" = {
              button-layout = "appmenu:minimize,maximize,close";
            };

            "org/gnome/shell/extensions/dash-to-dock" = {
              apply-custom-theme = true;
              background-opacity = 0.8;
              click-action = "focus-minimize-or-previews";
              custom-theme-shrink = true;
              dash-max-icon-size = mkUint32 48;
              disable-overview-on-startup = true;
              dock-position = "BOTTOM";
              height-fraction = 0.9;
              intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
              scroll-action = "cycle-windows";
            };

            "org/gnome/shell/extensions/mediacontrols" = {
              extension-position = "Right";
              fixed-label-width = false;
              label-width = mkUint32 280;
              mouse-action-double = "RAISE_PLAYER";
              mouse-action-left = "PLAY_PAUSE";
              mouse-action-right = "SHOW_POPUP_MENU";
            };

            "org/gnome/system/location" = {
              enabled = true;
            };
          };
        }
      ];
    };
  };
}
