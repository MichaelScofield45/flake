{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "Iosevka";
      font-size = 15.0;
      theme = "tokyonight_night";
      window-padding-x = 8;
      window-decoration = false;
      background-opacity = 0.7;
      background-blur-radius = 50;
      keybind = [
        "ctrl+alt+h=goto_split:left"
        "ctrl+alt+j=goto_split:bottom"
        "ctrl+alt+k=goto_split:top"
        "ctrl+alt+l=goto_split:right"
      ];
    };
  };
}
