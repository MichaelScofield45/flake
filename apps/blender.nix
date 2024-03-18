{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  options = {
    blenderCudaSupport = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Whether to build blender with cuda support.
      '';
    };
  };

  config = {
    home.packages = with pkgs; [
      (
        if config.blenderCudaSupport
        then blender.override {cudaSupport = true;}
        else blender
      )
    ];
  };
}
