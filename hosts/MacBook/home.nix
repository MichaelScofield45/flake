{
  config,
  osConfig,
  pkgs,
  user,
  lib,
  ...
}: let
  cfg = config;
  osCfg = osConfig;
in {
  imports = [
    ../../programs/ghostty.nix
    ../../programs/kitty.nix
    ../../programs/fish.nix
    ../../programs/nnn.nix
    ../../programs/zk.nix
  ];

  programs.home-manager.enable = true;
  programs.zoxide.enable = true;
  programs.fzf.enable = true;
  mine.nnn.enable = true;
  programs.bash.enable = true;
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "tokyo-night";
      vim_keys = true;
    };
  };
  mine.ghostty.enable = true;
  programs.ghostty.package = null;
  programs.ghostty.settings= {
    window-decoration = true;
    font-size = 22.0;
  };
  # mine.kitty.enable = true;
  # programs.kitty.package = null;
  mine.zk.enable = true;
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
      vo = "gpu";
    };
  };

  home = {
    stateVersion = "22.11";
    username = "ms45";
    homeDirectory = "/Users/ms45";
    packages = with pkgs; [
      # # GUI apps
      # foliate
      # chromium
      # calibre
      # firefox-beta
      # inkscape
      # krita
      # lutris
      # pavucontrol
      # obs-studio
      # qbittorrent
      # qalculate-qt
      # rnote
      # vscodium
      # wineWowPackages.staging
      # wl-clipboard
      # xclip
      # xournalpp

      # Terminal related pkgs
      (python311.withPackages (ps: with ps;[
        numpy
        ipython
        matplotlib
        pandas
        pynvim
        jupyter-client
      ]))
      bat
      fd
      ffmpeg
      file
      gdb
      git
      htop
      libertine
      jetbrains-mono
      iosevka-bin
      lazygit
      less
      ripgrep
      tealdeer
      trash-cli
      luajit
      luajitPackages.luarocks
      unzip
      stow
      p7zip
      gnumake
      neovim
      taskwarrior3
      typst
      yazi
    ];

    sessionVariables = {
      EDITOR = "nvim";
      PAGER = "less";
    };

    sessionPath = [
      "$HOME/.local/bin"
    ];
  };
  # services.syncthing.enable = true;
  # fonts.fontconfig.enable = true;
}
