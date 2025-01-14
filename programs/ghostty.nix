{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  programs.ghostty = {
    enable = true;
    font-family = "Iosevka";
    font-size = 15.0;
  };
}
