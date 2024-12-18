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
  boot.kernelParams = ["intel_iommu=on" "radeon.cik_support=0" "amdgpu.cik_support=1"];

  # Hardware Acceleration
  hardware.graphics = {
      enable = true;
      enable32Bit = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [brlaser];

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
