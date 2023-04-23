{ config, pkgs, ... }:

{
  home.username = "ms45";
  home.homeDirectory = "/home/ms45";
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    bash
    bat
    calibre
    ffmpeg
    firefox
    git
    htop
    kitty
    less
    neovim
    nnn
    xournalpp
    zellij
  ];

  programs.bash.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "less";
    FOO = "BAR";
  };

  services.syncthing.enable = true;
}
