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
    ./hardware-configuration.nix
    ../../modules/headless.nix
  ];

  mine.headless.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-server"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Mexico_City";

  # X server options
  services.libinput.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Graphics
  hardware.graphics = {
      enable = true;
      enable32Bit = true;
  };

  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    nvidiaSettings = true;
  };

  services.jackett = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.allowedTCPPorts = [
    8096
    8081
  ];

  networking.firewall.allowedUDPPorts = [
    8096
    8081
  ];

  services.samba = {
    openFirewall = true;
    enable = true;
    settings = {
      global = {
        security = "user";
        "server string" = "Media Samba Share";
        # "map to guest" = "bad user";
      };
      Media = {
        path = "/home/ms45/Media";
        browseable = "yes";
        "guest ok" = "yes";
        "read only" = "no";
        # "force user" = "nobody";
        # "force user" = "smbuser";
        # "force group" = "smbgroup";
      };
    };
  };

  services.jellyfin.enable = true;
  services.openssh.enable = true;
  environment.systemPackages = with pkgs; [
    qbittorrent-nox
  ];

  systemd.user.services.qbittorrent-nox-startup = {
    enable = true;
    description = "qbittorrent-nox as a daemon when server is started";
    after = [ "network-online.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox";
      Restart = "always";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.fish.enable = true;
  users.users.${user} = {
    isNormalUser = true;
    linger = true; # Have systemd services start at boot and not login
    extraGroups = ["wheel" "libvirtd" "dialout"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  system.stateVersion = "22.11"; # Did you read the comment?
}
