# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, user, ... }:

# let
#   user = "ms45";
# in
{
  # Already declared in flake
  # nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports = [
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "amd_iommu=on" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Mexico_City";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.libinput.enable = true;

  # Nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.modesetting.enable = true;


  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  hardware.bluetooth.enable = true;
  hardware.xpadneo.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  # services.pipewire.enable = true;
  # services.pipewire.audio.enable = true;
  # services.pipewire.pulse.enable = true;

  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  services.jackett.enable = true;

  services.samba-wsdd.enable = true; # make shares visible for windows 10 clients

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

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  services.jellyfin.enable = true;

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
    shares.Data = {
      path = "/home/ms45/Data";
      writeable = "yes";
      browseable = "yes";
      "public" = "yes";
      "read only" = "no";
      "guest ok" = "yes";
      "create mask" = "0664";
      "directory mask" = "0775";
      "force create mode" = "0664";
    };
  };

  # Define login shell
  programs.fish.enable = true;

  # Enable dconf for easyeffects
  programs.dconf.enable = true;

  # Enable steam
  programs.steam.enable = true;

  # Enable kdeconnect
  programs.kdeconnect.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  # Define a samba share account and user group
  # users.groups.smbgroup = {};
  # users.users.smbuser = {
  #   isSystemUser = true;
  #   shell = pkgs.shadow;
  #   group = "smbgroup";
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}

