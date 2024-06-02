{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim_overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }: 
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
  };
}
