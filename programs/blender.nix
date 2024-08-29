{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  options = {
    blenderHipSupport = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Whether to build blender with HIP support.
      '';
    };
  };

  config = {
    home.packages = with pkgs; [
      (
        if config.blenderHipSupport
        then blender-hip
        else blender
      )
    ];
  };
}
