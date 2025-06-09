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
    ../programs/blender.nix
    ../programs/ghostty.nix
    ../programs/kitty.nix
  ];

  options.mine.gui-apps.enable = lib.mkEnableOption "enable common gui tools";
  config = {
    home.packages = with pkgs; [
      foliate
      chromium
      calibre
      firefox-beta
      inkscape
      krita
      lutris
      pavucontrol
      obs-studio
      qbittorrent
      qalculate-qt
      rnote
      vscodium
      wineWowPackages.staging
      wl-clipboard
      xclip
      xournalpp
    ];

    mine.kitty.enable = true;
    mine.ghostty.enable = true;
    mine.blender.enable = true;

    services.syncthing.enable = true;
    fonts.fontconfig.enable = true;

    programs.mpv = {
      enable = true;
      config = {
        hwdec = "auto";
        vo = "gpu";
      };
    };

    services.easyeffects = {
      enable = true;
      preset = "Default";
    };
  };
}
