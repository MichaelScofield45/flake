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
    };
  };
}
