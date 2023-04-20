{ config, pkgs, ... }:

{
  home.username = "ms45";
  home.homeDirectory = "/home/ms45";
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    bash
    bat
    ffmpeg
    git
    htop
    neovim
    nnn
    zellij
  ];

  programs.bash.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    FOO = "BAR";
  };
}
