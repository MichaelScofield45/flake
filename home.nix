{ config, pkgs, ... }:

{
  home.username = "ms45";
  home.homeDirectory = "/home/ms45";
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    bash
    bat
    calibre
    ffmpeg
    firefox-beta-bin
    git
    htop
    jetbrains-mono
    kitty
    less
    neovim
    nnn
    obs-studio
    openssh
    qbittorrent
    tealdeer
    wl-clipboard
    xclip
    xournalpp
    rnote
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "less";
    FOO = "BAR";
  };

  services.syncthing.enable = true;

  fonts.fontconfig.enable = true;

  programs.bash.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      fish_vi_key_bindings
    '';
  };

  programs.starship.enable = true;
  programs.zoxide.enable = true;

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "tokyo-night";
      vim_keys = true;
    };
  };

  programs.zellij = {
    enable = true;
    settings = {
      theme = "default";
      themes.default = { # tokyonight-dark
        fg = "#a9b1d6";
        bg = "#1a1b26";
        black = "#383e5a";
        red = "#f93357";
        green = "#9ece6a";
        yellow = "#e0af68";
        blue = "#7aa2f7";
        magenta = "#bb9af7";
        cyan = "#2ac3de";
        white = "#c0caf5";
        orange = "#ff9e64";
      };
    };
  };

  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
      vo = "gpu";
    };
  };

}
