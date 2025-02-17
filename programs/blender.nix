{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  cfg = config;
in {
  options = {
    mine.blender.enable = lib.mkEnableOption "blender";
    blenderHipSupport = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Whether to build blender with HIP support.
      '';
    };
  };

  config = lib.mkIf cfg.mine.blender.enable {
    home.packages = with pkgs; [
      (
        if config.blenderHipSupport
        then blender-hip
        else blender
      )
    ];
  };
}
