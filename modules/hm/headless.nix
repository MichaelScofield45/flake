{ pkgs, lib, config, ... }:
{
  options = {
    headless.enable = lib.mkEnableOption "disable all gui applications";
  };

  config = lib.mkIf config.headless.enable {
    programs.ghostty.enable = lib.mkForce false;
    programs.kitty.enable = lib.mkForce false;
    services.syncthing.enable = lib.mkForce false;
    fonts.fontconfig.enable = lib.mkForce false;
    programs.mpv.enable = lib.mkForce false;
    services.easyeffects.enable = lib.mkForce false;
  };
}
