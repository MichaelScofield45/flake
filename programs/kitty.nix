{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  programs.kitty = {
    enable = true;
    theme = "Doom One";
    font = {
      name = "JetBrains Mono";
      size = 13.0;
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
}
