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
  boot.kernelParams = ["intel_iommu=on"];

  # Hardware Acceleration
  hardware.opengl.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable dconf for easyeffects
  # programs.dconf.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  system.stateVersion = "22.11"; # Did you read the comment?
}
