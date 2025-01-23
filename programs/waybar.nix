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
        modules-right = [ "tray" "pulseaudio" "clock" ];

        tray = {
          icon-size = 21;
          spacing = 10;
        };

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
        background: transparent;
        color: #ffffff;
        transition-property: background-color;
        transition-duration: .5s;
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      button {
        box-shadow: inset 0 -3px transparent;
        border: none;
        border-radius: 0;
        text-shadow: none;
      }

      button:hover {
        background: inherit;
        box-shadow: none;
      }

      #window {
        border-radius: 26px;
        background: rgba(43, 48, 59, 0.8);
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
        background: transparent;
        padding: 5px 10px;
        color: white;
      }

      #tags button.focused {
        margin-right: 5px;
        border-radius: 26px;
        background-color: #437756;
      }

      #tags button:hover {
        margin-right: 5px;
        border-radius: 26px;
        background-color: rgba(43, 48, 59, 0.8);
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
    '';
  };
}
