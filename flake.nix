{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim_overlay.url = "github:nix-community/neovim-nightly-overlay";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
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
        pkgs = import nixpkgs { inherit mac-system; };
      in {
        "local-hostname" = nix-darwin.lib.darwinSystem {
          inherit inputs mac-system pkgs;
          modules = [
            ./hosts/MacBook
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${user} = {
                  imports = [./hosts/home.nix];
                };
              }
          ];
          specialArgs = { inherit inputs; };
        };
      };
  };
}
