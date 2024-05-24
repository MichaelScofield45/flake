{
  inputs,
  lib,
  system,
  user,
  home-manager,
  ...
}: let
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [inputs.nvim_overlay.overlays.default];
    config = {
      allowUnfree = true;
    };
  };
in {
  desktop = lib.nixosSystem {
    inherit system;
    specialArgs = {inherit user pkgs inputs;};
    modules = [
      ./desktop
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = {
          imports = [./home.nix];
          blenderCudaSupport = true;
        };
      }
    ];
  };

  laptop = lib.nixosSystem {
    inherit system;
    specialArgs = {inherit user pkgs inputs;};
    modules = [
      ./laptop
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = {
          imports = [./home.nix];
        };
      }
    ];
  };
}
