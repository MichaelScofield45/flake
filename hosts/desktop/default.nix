{
  config,
  pkgs,
  user,
  ...
}: {
  nix = {
    package = pkgs.nixFlakes;
    settings.experimental-features = ["nix-command" "flakes"];
  };
  imports = [
    ../common.nix
    ./hardware-configuration.nix
  ];

  networking.enableIPv6 = false;

  boot.kernelPackages = pkgs.linuxPackages_6_8;
  boot.kernelParams = [
      "amd_iommu=on"
      # "nvidia-derm.fbdev=1"
      # "NVreg_EnableGpuFirmware=0"
  ];

  # Nvidia
  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics = {
      enable = true;
      enable32Bit = true;
  };

  hardware.nvidia= {
    open = false;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

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
    extraGroups = ["wheel" "libvirtd" "dialout"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  system.stateVersion = "22.11"; # Did you read the comment?
}
