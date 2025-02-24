{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config;
in {
  options.mine.nnn.enable = lib.mkEnableOption "nnn file manager with plugins";

  config = lib.mkIf cfg.mine.nnn.enable {
    programs.nnn = {
      enable = true;
      plugins = {
        src = (pkgs.fetchFromGitHub {
            owner = "jarun";
            repo = "nnn";
            rev = "v5.0";
            sha256 = "sha256-HShHSjqD0zeE1/St1Y2dUeHfac6HQnPFfjmFvSuEXUA=";
            }) + "/plugins";
        mappings = {
          z = "autojump";
          b = "bulknew";
        };
      };
    };
  };
}
