{
  config,
  pkgs,
  user,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  imports = [
    ../common.nix
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["amd_iommu=on"];

  # Nvidia
  services.xserver.videoDrivers = ["nvidia"];
  hardware.opengl.enable = true;
  hardware.nvidia.modesetting.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  hardware.xpadneo.enable = true;

  services.jackett.enable = true;

  virtualisation.libvirtd.enable = true;
  services.jellyfin.enable = true;

  # Enable dconf for easyeffects
  # programs.dconf.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  system.stateVersion = "22.11"; # Did you read the comment?
}
