{ pkgs, lib, config, ... }:
{
  options = {
    mine.headless.enable = lib.mkEnableOption "disable all gui applications";
  };
}
