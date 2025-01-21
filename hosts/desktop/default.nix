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
  # boot.kernelParams = [
  #     # "amd_iommu=on" # for virtualization only
  #     # "nvidia-derm.fbdev=1"
  #     # "NVreg_EnableGpuFirmware=0"
  # ];

  security.pam.services.swaylock = {};
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  # Graphics
  hardware.graphics = {
      enable = true;
      enable32Bit = true;
  };

  hardware.xpadneo.enable = true;

  services.jackett.enable = true;

  # Enable dconf for easyeffects
  # programs.dconf.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd" "audio" "dialout"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  system.stateVersion = "22.11"; # Did you read the comment?
}
