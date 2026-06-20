{
  config,
  osConfig,
  pkgs,
  pkgs-stable,
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

  home.username = "ms45";
  home.homeDirectory = "/home/ms45";
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  mine.cli-apps.enable = true;
  mine.gui-apps.enable = true;

  services.jellyfin-mpv-shim.enable = true;

  home.packages = [
    pkgs-stable.lutris
  ];
}
