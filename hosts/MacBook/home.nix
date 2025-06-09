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
    ../../programs/ghostty.nix
    ../../programs/kitty.nix
  ];

  home = {
    stateVersion = "22.11";
    username = "ms45";
    homeDirectory = "/Users/ms45";
  };

  programs.home-manager.enable = true;

  mine.cli-apps.enable = true;

  mine.ghostty.enable = true;
  programs.ghostty.package = null;
  programs.ghostty.settings= {
    window-decoration = true;
    font-size = 22.0;
  };
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
      vo = "gpu";
    };
  };

}
