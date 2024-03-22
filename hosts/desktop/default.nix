{
  config,
  pkgs,
  user,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  imports = [
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["amd_iommu=on"];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Mexico_City";

  # X server options
  services.xserver = {
    enable = true;
    libinput.enable = true;
    xkb.variant = "colemak_dh";
  };
  console.useXkbConfig = true;

  # Nvidia
  services.xserver.videoDrivers = ["nvidia"];
  hardware.opengl.enable = true;
  hardware.nvidia.modesetting.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  programs.hyprland.enable = true;
  # services.xserver.desktopManager.plasma6.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  hardware.bluetooth.enable = true;
  hardware.xpadneo.enable = true;

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  services.jackett.enable = true;

  networking.firewall.allowedTCPPorts = [
    5357 # wsdd
    445
    8096
    8384 # syncthing
    22000 # syncthing
  ];

  networking.firewall.allowedUDPPorts = [
    3702 # wsdd
    8096
    22000 # syncthing
    21027 # syncthing
  ];

  virtualisation.libvirtd.enable = true;
  services.jellyfin.enable = true;

  # Define login shell
  programs.fish.enable = true;

  # Enable dconf for easyeffects
  # programs.dconf.enable = true;

  # Enable steam
  programs.steam.enable = true;

  # Enable kdeconnect
  programs.kdeconnect.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    gcc
    wget
    patchelf
    virt-manager
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "22.11"; # Did you read the comment?
}
