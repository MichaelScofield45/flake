{
  config,
  pkgs,
  user,
  ...
}: {
  nix = {
    # package = pkgs.nixFlakes;
    settings.experimental-features = ["nix-command" "flakes"];
  };
  imports = [
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-server"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Mexico_City";

  # X server options
  services.libinput.enable = true;
  services.xserver = {
    enable = true;
    # xkb.variant = "colemak_dh";
  };
  console.useXkbConfig = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Graphics
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
  };

  services.jackett.enable = true;

  networking.firewall.allowedTCPPorts = [
    8096
    8081
  ];

  networking.firewall.allowedUDPPorts = [
    8096
    8081
  ];

  services.samba.enable = true;
  services.samba.settings = {
    global = {
      security = "user";
      "server string" = "File Server";
      "map to guest" = "bad user";
      "name resolve order" = "bcast host";
      # usershare allow guests = yes
    };
    Media = {
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

  services.jellyfin.enable = true;
  services.openssh.enable = true;
  environment.systemPackages = with pkgs; [
    qbittorrent-nox
  ];
  systemd.services.qbittorrent-nox-startup = {
    description = "Start qbittorrent-nox as a daemon when server is started";
    script = ''
      qbittorrent-nox -d
    '';
    wantedBy = ["multi-user.target"];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd" "dialout"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      bash
      bat
      neovim
      ripgrep
      fd
    ];
    shell = pkgs.fish;
  };

  system.stateVersion = "22.11"; # Did you read the comment?
}
