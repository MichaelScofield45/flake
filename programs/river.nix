{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        output = [
          "DP-2"
        ];
        modules-left = [ "river/tags"  ];
        modules-center = [ "river/window" ];
        modules-right = [ "pulseaudio" "clock" ];

        pulseaudio = {
          format = "{volume}% {icon}";
            format-muted =" ";
            format-icons = {
              default = [" " " "];
            };
          scroll-step = 1;
          on-click = "pavucontrol";
          ignored-sinks = [ "Easy Effects Sink" ];
        };

        clock = {
          tooltip = false;
        };
      };
    };

    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: Iosevka, Helvetica, Arial, sans-serif;
          font-size: 12pt;
          min-height: 0;
      }

      window#waybar {
          background: transparent,
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      #window {
        border-radius: 26px;
        background-color: rgba(43, 48, 59, 0.8);
        padding: 0 20px 0 20px;
        margin-top: 5px;
      }

      #tags {
        margin-top: 5px;
        margin-left: 5px;
      }

      #tags button {
        margin-right: 5px;
        border-radius: 26px;
        background-color: transparent;
        padding: 5px 10px;
      }

      #tags button.focused {
        margin-right: 5px;
        border-radius: 26px;
        background-color: #437756;
      }

      #tags button:hover {
        margin-right: 5px;
        border-radius: 26px;
        background-color: rgba(43, 48, 59, 0.7);
      }

      #pulseaudio {
        border-radius: 26px;
        background-color: transparent;
      }

      #clock {
        border-radius: 26px;
        margin-top: 5px;
        margin-right: 5px;
        padding: 5px 10px;
        background-color: #64727D;
      }

      @keyframes blink {
          to {
              background-color: #ffffff;
              color: black;
          }
      }
    '';
  };
  programs.fuzzel.enable = true;
  services.mako.enable = true;

  home.packages = with pkgs; [
    wlr-randr
    swaybg
    swaylock
    swayidle
    pavucontrol
    pamixer
    xfce.xfconf
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
  ];

  wayland.windowManager.river = {
    enable = true;
    settings = {
      default-layout = "rivertile";
      set-repeat = "50 300";
      keyboard-layout = "\'us(altgr-intl)\'";
      spawn = [
        "\'wlr-randr --output DP-2 --mode 2560x1440@180\'"
        "\'swaybg --mode fill --image ~/Pictures/Wallpapers/leaf.jpg\'"
        "waybar"
      ];
      map = {
        normal = {
          "Super+Shift Return" = "spawn ghostty";
          "Super R" = "spawn fuzzel";
          "Super E" = "spawn thunar";
          "Super Q" = "close";
          "Super+Control L" = "spawn 'swaylock -s fit -i ~/Pictures/Wallpapers/leaf.jpg'";
          "Super+Shift E" = "exit";
          "Super K" = "focus-view previous";
          "Super J" = "focus-view next";
          "Super+Shift J" = "swap next";
          "Super+Shift K" = "swap previous";
          "Super Period" = "focus-output next";
          "Super Comma" = "focus-output previous";
          "Super+Shift Period" = "send-to-output next";
          "Super+Shift Comma" = "send-to-output previous";
          "Super Return" = "zoom";
          "Super H" = "send-layout-cmd rivertile 'main-ratio -0.05'";
          "Super L" = "send-layout-cmd rivertile 'main-ratio +0.05'";
          "Super+Shift H" = "send-layout-cmd rivertile 'main-count +1'";
          "Super+Shift L" = "send-layout-cmd rivertile 'main-count -1'";
          "Super+Alt H" = "move left 100";
          "Super+Alt J" = "move down 100";
          "Super+Alt K" = "move up 100";
          "Super+Alt L" = "move right 100";
          "Super+Alt+Control H" = "snap left";
          "Super+Alt+Control J" = "snap down";
          "Super+Alt+Control K" = "snap up";
          "Super+Alt+Control L" = "snap right";
          "Super+Alt+Shift H" = "resize horizontal -100";
          "Super+Alt+Shift J" = "resize vertical 100";
          "Super+Alt+Shift K" = "resize vertical -100";
          "Super+Alt+Shift L" = "resize horizontal 100";
          "Super Space" = "toggle-float";
          "Super F" = "toggle-fullscreen";
        };
      };

      map-pointer = {
        normal = {
          "Super BTN_LEFT" = "move-view";
          "Super BTN_RIGHT" = "resize-view";
          "Super BTN_MIDDLE" = "toggle-float";
        };
      };

      rule-add = {
        "-title" = {
          "'Volume Control'" = "float";
          "'*Thunar'" = "float";
        };
      };
    };

    extraSessionVariables = {};

    extraConfig = ''
      riverctl map normal Super Up    send-layout-cmd rivertile "main-location top"
      riverctl map normal Super Right send-layout-cmd rivertile "main-location right"
      riverctl map normal Super Down  send-layout-cmd rivertile "main-location bottom"
      riverctl map normal Super Left  send-layout-cmd rivertile "main-location left"

      for i in $(seq 1 9)
      do
          tags=$((1 << ($i - 1)))

          # Super+[1-9] to focus tag [0-8]
          riverctl map normal Super $i set-focused-tags $tags

          # Super+Shift+[1-9] to tag focused view with tag [0-8]
          riverctl map normal Super+Shift $i set-view-tags $tags

          # Super+Control+[1-9] to toggle focus of tag [0-8]
          riverctl map normal Super+Control $i toggle-focused-tags $tags

          # Super+Shift+Control+[1-9] to toggle tag [0-8] of focused view
          riverctl map normal Super+Shift+Control $i toggle-view-tags $tags
      done

      for mode in normal locked
      do
          # Control pulse audio volume with pamixer (https://github.com/cdemoulins/pamixer)
          riverctl map $mode None XF86AudioRaiseVolume  spawn 'pamixer -i 5'
          riverctl map $mode None XF86AudioLowerVolume  spawn 'pamixer -d 5'
          riverctl map $mode None XF86AudioMute         spawn 'pamixer --toggle-mute'

          # Control MPRIS aware media players with playerctl (https://github.com/altdesktop/playerctl)
          riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'
          riverctl map $mode None XF86AudioPlay  spawn 'playerctl play-pause'
          riverctl map $mode None XF86AudioPrev  spawn 'playerctl previous'
          riverctl map $mode None XF86AudioNext  spawn 'playerctl next'
      done

      riverctl background-color 0x002b36
      riverctl border-color-focused 0x93a1a1
      riverctl border-color-unfocused 0x586e75

      rivertile -view-padding 6 -outer-padding 6 &
    '';
  };
}

