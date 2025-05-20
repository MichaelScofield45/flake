{
  config,
  pkgs,
  user,
  ...
}: {
  imports = [
    ../../modules/headless.nix
  ];

  # Define login shell
  programs.fish.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
