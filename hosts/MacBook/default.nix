{
  config,
  pkgs,
  user,
  ...
}: {
  imports = [
    ../../modules/headless.nix
  ];
}
