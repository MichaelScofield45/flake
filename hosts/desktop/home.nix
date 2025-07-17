{
  config,
  osConfig,
  pkgs,
  user,
  lib,
  ...
}: let
  cfg = config;
  osCfg = osConfig;
in {
  imports = [
    ../../modules/cli-apps.nix
    ../../modules/gui-apps.nix
  ];

	mine.ghostty.blur = false;

  home.username = "ms45";
  home.homeDirectory = "/home/ms45";
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  mine.cli-apps.enable = true;
  mine.gui-apps.enable = true;

  home.packages = [
    pkgs.azahar
  ];
}
