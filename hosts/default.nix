{ inputs, lib, system, user, home-manager, ... } :
{
  desktop = let
    pkgs = import inputs.nixpkgs { 
      inherit system;
      config = {
        allowUnfree = true;
        cudaSupport = true;
      };
    };
  in lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user pkgs inputs; };
    modules = [
      ./desktop
      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user; };
        home-manager.users.${user} = {
          imports = [
            ./home.nix
          ];
        };
      }
    ];
  };

  laptop = let
    pkgs = import inputs.nixpkgs { 
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user pkgs inputs; };
    modules = [
      ./laptop
      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user; };
        home-manager.users.${user} = {
          imports = [
            ./home.nix
          ];
        };
      }
    ];
  };
}
