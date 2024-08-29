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

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
      "amd_iommu=on"
      # "nvidia-derm.fbdev=1"
      # "NVreg_EnableGpuFirmware=0"
  ];

  # Graphics
  hardware.graphics = {
      enable = true;
      enable32Bit = true;
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  hardware.xpadneo.enable = true;

  services.jackett.enable = true;

  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
    server string = File Server
    map to guest = bad user
    # usershare allow guests = yes
    name resolve order = bcast host
    '';
    shares.Media = {
      path = "/home/ms45/Media";
      writeable = "yes";
      browseable = "yes";
      "public" = "yes";
      "read only" = "no";
      "guest ok" = "yes";
      # "force user" = "nobody";
      # "force user" = "smbuser";
      # "force group" = "smbgroup";
      "create mask" = "0664";
      "directory mask" = "0775";
      "force create mode" = "0664";
    };
  };

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
