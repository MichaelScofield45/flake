{ pkgs, lib, config, ... }:
{
  options = {
    headless.enable = lib.mkEnableOption "disable all gui applications";
  };

  config = lib.mkIf config.headless.enable {
    programs.ghostty.enable = false;
    programs.kitty.enable = false;
    services.syncthing.enable = false;
    fonts.fontconfig.enable = false;
    programs.mpv.enable = false;
    services.easyeffects.enable = false;
  };
}
