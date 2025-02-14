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

  networking.hostName = "nixos-laptop"; # Define your hostname.

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Hardware Acceleration
  hardware.graphics = {
      enable = true;
      enable32Bit = true;
  };

  hardware.bluetooth.enable = true;

  # X server options
  services.libinput.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [brlaser];

  services.pipewire.wireplumber.extraConfig."99-disable-suspend" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            "node.name" = "alsa_output.pci-0000_00_1b.0.analog-stereo";
          }
        ];
        actions = {
          update-props = {
            "session.suspend-timeout-seconds" = 0;
          };
        };
      }
    ];
  };

  # Enable steam
  programs.steam.enable = true;

  # Enable kdeconnect
  programs.kdeconnect.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  system.stateVersion = "22.11"; # Did you read the comment?
}
