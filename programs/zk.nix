
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
    mine.zk.enable = lib.mkEnableOption "blender";
  };

  config = lib.mkIf cfg.mine.zk.enable {
    programs.zk = {
      enable = true;
      settings = {
        note = {
          language = "en";
          default-title = "Untitled";
          filename = "{{id}}-{{slug title}}";
          extension = "md";
          # template = "default.md";
          id-charset = "alphanum";
          id-length = 4;
          id-case = "lower";
        };
        group = {
          daily = {
            paths = ["journal"];
            note = {
              filename = "{{format-date now '%Y-%m-%d'}}";
              extension = "md";
              # template = "daily.md";
            };
          };
        };
      };
    };
  };
}
