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
    ../programs/zk.nix
    ../programs/fish.nix
    ../programs/nnn.nix
  ];

  options.mine.cli-apps.enable = lib.mkEnableOption "enable common cli tools";

  config = {
    home.packages = with pkgs; [
      (python311.withPackages (ps: with ps;[
        numpy
        ipython
        scipy
        ipykernel
        matplotlib
        pandas
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

    programs.fzf.enable = true;
    mine.nnn.enable = true;
    mine.zk.enable = true;

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
  };
}
