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
  specialArgs = {
    inherit user inputs;
  };
in {
  desktop = lib.nixosSystem {
    inherit system pkgs specialArgs;
    modules = [
      ./desktop
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${user} = {
            imports = [
              ./home.nix
              ../programs/river.nix
            ];
            blenderHipSupport = true;
          };
        };
      }
    ];
  };

  laptop = lib.nixosSystem {
    inherit system pkgs specialArgs;
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

  server = lib.nixosSystem {
    inherit system pkgs specialArgs;
    modules = [
      ./server
    ];
  };
}
