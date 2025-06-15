{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];

    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      fish_vi_key_bindings
    '';

    shellAbbrs = {
      lg = "lazygit";
    };

    binds = let
      z-key = "\\;";
    in {
      ${z-key} = {
        command = "__z_fzf ${z-key}";
        mode = "insert";
      };
    };

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

      __z_fzf = {
        description = "binding for quickly fuzzy finding and jumping between directories";
        argumentNames = "key";
        body = ''
          set -l cmd (commandline)
          if test "$cmd" = ""
            set -l result (zoxide query -i)
            if test -n "$result"
              cd "$result"
            end
            commandline -f repaint
          else
            commandline --insert $key
          end
        '';
      };
    };
  };
}

