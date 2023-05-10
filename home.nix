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
    fd
    ffmpeg
    firefox-beta-bin
    git
    htop
    jetbrains-mono
    kitty
    less
    lutris
    neovim
    nnn
    obs-studio
    openssh
    protonup-qt
    qbittorrent
    ripgrep
    tealdeer
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

  services.syncthing.enable = true;

  fonts.fontconfig.enable = true;

  programs.bash.enable = true;

  programs.fish = {
    enable = true;
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

  services.easyeffects = {
    enable = true;
    preset = "Default";
  };
}
