{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim_overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, nix-darwin, ... }:
    let
      user = "ms45";
      system = "x86_64-linux";
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = (
        import ./hosts {
          inherit inputs user system home-manager lib;
        }
      );
      darwinConfigurations = let
        mac-system = "x86_64-darwin";
        pkgs = import nixpkgs {
          system = mac-system;
          config.allowBroken = true;
        };
      in {
        Franciscos-MacBook-Pro = nix-darwin.lib.darwinSystem {
          system = mac-system;
          specialArgs = { inherit user; };
          inherit inputs pkgs;
          modules = [
             ./hosts/MacBook
              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${user} = {
                  imports = [./hosts/MacBook/home.nix];
                };
              }
          ];
        };
      };
  };
}
