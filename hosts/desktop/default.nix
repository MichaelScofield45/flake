{
  config,
  pkgs,
  user,
  ...
}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = [ "root" "${user}" ];
    };
  };
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    ../../modules/headless.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.libinput.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

	hardware.bluetooth.enable = true;

  # Graphics
  hardware.graphics = {
      enable = true;
      enable32Bit = true;
  };

  programs.steam.enable = true;

  programs.kdeconnect.enable = true;

  programs.dconf.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["wheel" "audio" "dialout"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      gamemode
    ];
    shell = pkgs.fish;
  };

  system.stateVersion = "22.11"; # Did you read the comment?
}
