{
  config,
  pkgs,
  user,
  ...
}: {
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
  };
  imports = [
    ../common.nix
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.

  security.pam.services.swaylock = {};
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = "gtk";
  };

  # Input peripheral options
  services.libinput.enable = true;

  # Graphics
  hardware.graphics = {
      enable = true;
      enable32Bit = true;
  };

  # Enable steam
  programs.steam.enable = true;

  # Enable kdeconnect
  programs.kdeconnect.enable = true;

  # Enable dconf for GTK applications
  programs.dconf.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["wheel" "audio" "dialout"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      # WM minimum required apps for functionality
      wlr-randr
      swaybg
      swaylock
      swayidle
      grim
      slurp
      pamixer
      gamemode

      # GUI apps
      xfce.xfconf # Thunar preferences
      xfce.thunar
      xfce.thunar-archive-plugin
      xfce.thunar-volman
      calibre
      papers
    ];
    shell = pkgs.fish;
  };

  system.stateVersion = "22.11"; # Did you read the comment?
}
