{
  config,
  pkgs,
  user,
  ...
}: {
  imports = [ ];

  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
    shell = pkgs.fish;
  };
  system.primaryUser = user;

  # Let Determinate Nix handle the local installation of Nix.
  nix.enable = false;

  # Enable flakes
  nix.settings.experimental-features = "nix-command flakes";

  environment.systemPackages = with pkgs; [
    fish
    gcc
  ];

  homebrew = {
    enable = true;
    casks = [
      "ghostty"
      "kitty"
      "firefox@beta"
    ];
  };

  # Define login shell
  programs.fish.enable = true;

  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
