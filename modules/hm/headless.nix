{ pkgs, lib, config, ... }:
{
  options = {
    headless.enable = lib.mkEnableOption "disable all gui applications";
  };
}
