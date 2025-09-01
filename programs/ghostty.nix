{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  cfg = config;
in {
  options.mine.ghostty = {
    enable = lib.mkEnableOption "ghostty with custom settings";
    blur = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.mine.ghostty.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        font-family = "Iosevka Term";
        font-size = 15.0;
        theme = "flexoki-dark";
        window-padding-x = 8;
        window-decoration = false;
        background-blur = lib.mkIf cfg.mine.ghostty.blur true;
        background-opacity = lib.mkIf cfg.mine.ghostty.blur 0.7;
        keybind = [
          "ctrl+alt+h=goto_split:left"
          "ctrl+alt+j=goto_split:down"
          "ctrl+alt+k=goto_split:up"
          "ctrl+alt+l=goto_split:right"
          "ctrl+left_bracket=esc:"
        ];
      };
    };
  };
}
