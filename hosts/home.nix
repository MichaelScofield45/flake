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
    ../programs/ghostty.nix
    ../programs/fish.nix
    ../modules/hm/headless.nix
  ];
  config = lib.mkMerge [
    ({
      home.username = "ms45";
      home.homeDirectory = "/home/ms45";
      home.stateVersion = "22.11";

      programs.home-manager.enable = true;

      home.packages = with pkgs; [
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
        p7zip
        gnumake
        neovim
        taskwarrior3
        typst
        yazi
      ];

      programs.zoxide.enable = true;
      programs.fzf.enable = true;
      programs.nnn.enable = true;

      home.sessionVariables = {
        EDITOR = "nvim";
        PAGER = "less";
      };

      home.sessionPath = [
        "$HOME/.local/bin"
      ];

      programs.bash.enable = true;
      programs.btop = {
        enable = true;
        settings = {
          color_theme = "tokyo-night";
          vim_keys = true;
        };
      };
    })


    (lib.mkIf (!config.headless.enable) {
      home.packages = with pkgs; [
        # GUI apps
        foliate
        chromium
        calibre
        firefox-beta
        inkscape
        krita
        lutris
        pavucontrol
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

      mine.kitty.enable = true;
      mine.ghostty.enable = true;
      mine.blender.enable = true;

      services.syncthing.enable = true;
      fonts.fontconfig.enable = true;

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
    })
  ];
}
