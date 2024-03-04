{ config, pkgs, user, ... }:

{
  home.username = "ms45";
  home.homeDirectory = "/home/ms45";
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Terminal related pkgs
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    bat
    fd
    ffmpeg
    file
    gdb
    git
    htop
    jetbrains-mono
    fira-code
    lazygit
    less
    nnn
    ripgrep
    tealdeer
    trash-cli

    # GUI apps
    blender
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
    tridactyl-native
    vscodium
    wineWowPackages.staging
    wl-clipboard
    xclip
    xournalpp
    yuzu-mainline
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
    ".mozilla/native-messaging-hosts/tridactyl.json".text = (builtins.toJSON {
      name = "tridactyl";
      description = "Tridactyl native command handler";
      path = "${pkgs.tridactyl-native}/bin/native_main";
      type = "stdio";
      allowed_extensions = [
        "tridactyl.vim@cmcaine.co.uk"
        "tridactyl.vim.betas@cmcaine.co.uk"
        "tridactyl.vim.betas.nonewtab@cmcaine.co.uk"
      ];
    });
  };

  services.syncthing.enable = true;

  fonts.fontconfig.enable = true;

  programs.bash.enable = true;

  programs.fish = {
    enable = true;
    plugins = [
      { name = "tide"; src = pkgs.fishPlugins.tide.src; }
    ];
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      fish_vi_key_bindings
    '';
    functions = {
      n = {
        wraps = "nnn";
        description = "support nnn quit and change directory";
        body = ''
          # Block nesting of nnn in subshells
          if test -n "$NNNLVL" -a "$NNNLVL" -ge 1
              echo "nnn is already running"
              return
          end

          # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
          # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
          # see. To cd on quit only on ^G, remove the "-x" from both lines below,
          # without changing the paths.
          if test -n "$XDG_CONFIG_HOME"
              set -x NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
          else
              set -x NNN_TMPFILE "$HOME/.config/nnn/.lastd"
          end

          # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
          # stty start undef
          # stty stop undef
          # stty lwrap undef
          # stty lnext undef

          # The command function allows one to alias this function to `nnn` without
          # making an infinitely recursive alias
          command nnn $argv

          if test -e $NNN_TMPFILE
              source $NNN_TMPFILE
              rm $NNN_TMPFILE
          end
        '';
      };
    };
  };

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

  programs.kitty = {
    enable = true;
    theme = "Doom One";
    font = {
      name = "Fira Code";
      size = 13.0;
    };
    settings = {
      window_padding_width = "0 5 0 5";
      enable_audio_bell = false;
    };
    keybindings = {
      "kitty_mod+t" = "launch --cwd=current --type=tab";
      "kitty_mod+enter" = "launch --cwd=current --type=window";
    };
  };

  services.easyeffects = {
    enable = true;
    preset = "Default";
  };
}
