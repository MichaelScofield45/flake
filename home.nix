{ config, pkgs, ... }:

{
  home.username = "ms45";
  home.homeDirectory = "/home/ms45";
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Terminal related pkgs
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    bash
    bat
    fd
    ffmpeg
    git
    htop
    jetbrains-mono
    lazygit
    less
    neovim
    nnn
    ripgrep
    tealdeer

    # Services
    openssh

    # GUI apps
    blender
    calibre
    firefox-beta-bin
    kitty
    lutris
    obs-studio
    protonup-qt
    qbittorrent
    wineWowPackages.staging
    wl-clipboard
    xclip
    xournalpp
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "less";
    FOO = "BAR";
  };

  home.sessionPath = [ ];

  services.syncthing.enable = true;

  fonts.fontconfig.enable = true;

  programs.bash.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      fish_vi_key_bindings
      set -Ux NNN_FCOLORS "c1e2272e006033f7c6d6abc4" # Set nnn colors for filetypes
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

  programs.starship.enable = true;
  programs.zoxide.enable = true;

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "tokyo-night";
      vim_keys = true;
    };
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "tokyonight";
      editor = {
        line-number = "relative";
        color-modes = true;
      };
      keys.insert = {
        "C-[" = "normal_mode";
      };
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

  programs.kitty = {
    enable = true;
    theme = "Tokyo Night";
    font = {
      name = "JetBrains Mono";
      size = 12.0;
    };
    settings = {
      window_padding_width = "0 5 0 5";
      enable_audio_bell = false;
    };
  };

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        front_end = "WebGpu",
        font = wezterm.font("JetBrains Mono"),
        font_size = 12.0,
        color_scheme = "Tokyo Night (Gogh)",
        hide_tab_bar_if_only_one_tab = true
      }
    '';
  };

  services.easyeffects = {
    enable = true;
    preset = "Default";
  };

  services.kdeconnect.enable = true;
}
