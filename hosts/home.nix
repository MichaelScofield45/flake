{
  config,
  pkgs,
  user,
  lib,
  ...
}: {
  imports = [
    ../programs/blender.nix
    ../programs/kitty.nix
    ../programs/fish.nix
  ];

  home.username = "ms45";
  home.homeDirectory = "/home/ms45";
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Terminal related pkgs
    (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    bat
    fd
    ffmpeg
    file
    fzf
    gdb
    git
    htop
    jetbrains-mono
    iosevka
    lazygit
    less
    nnn
    ripgrep
    tealdeer
    trash-cli
    luajit
    unzip
    p7zip
    gnumake

    # GUI apps
    calibre
    chromium
    firefox-beta-bin
    inkscape
    kitty
    lutris
    obs-studio
    qbittorrent
    qalculate-qt
    rnote
    vscodium
    wineWowPackages.staging
    wl-clipboard
    xclip
    xournalpp
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.zoxide.enable = true;

  home.sessionVariables = {
    PAGER = "less";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.file = {
    ".mozilla/native-messaging-hosts/tridactyl.json".text = builtins.toJSON {
      name = "tridactyl";
      description = "Tridactyl native command handler";
      path = "${pkgs.tridactyl-native}/bin/native_main";
      type = "stdio";
      allowed_extensions = [
        "tridactyl.vim@cmcaine.co.uk"
        "tridactyl.vim.betas@cmcaine.co.uk"
        "tridactyl.vim.betas.nonewtab@cmcaine.co.uk"
      ];
    };
  };

  services.syncthing.enable = true;

  fonts.fontconfig.enable = true;

  programs.bash.enable = true;

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "onedark";
      vim_keys = true;
    };
  };

  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
      vo = "gpu";
    };
  };

  services.easyeffects = {
    enable = true;
    preset = "Default";
  };
}
