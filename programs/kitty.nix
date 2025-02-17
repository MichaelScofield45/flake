{
  config,
  lib,
  ...
}: let
  cfg = config;
in {
  options.mine.kitty.enable = lib.mkEnableOption "kitty terminal with settings";

  config = lib.mkIf cfg.mine.kitty.enable {
    programs.kitty = {
      enable = true;
      themeFile = "tokyo_night_night";
      font = {
        name = "Iosevka";
        size = 15.0;
      };
      settings = {
        window_padding_width = "0 5 0 5";
        enable_audio_bell = false;
      };
      keybindings = {
        "kitty_mod+t" = "launch --cwd=current --type=tab";
        "kitty_mod+enter" = "launch --cwd=current --type=window";
        "kitty_mod+n" = "launch --cwd=current --type=os-window";
      };
    };
  };
}
