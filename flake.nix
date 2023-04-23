{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        inherit overlays;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
      overlays = 
        let
          moz-rev = "master";
          moz-url = builtins.fetchTarball { 
            url = "https://github.com/mozilla/nixpkgs-mozilla/archive/${moz-rev}.tar.gz";
            sha256 = "0k3jxk21s28jsfpmqv39vyhfz2srfm81kp4xnpzgsbjn77rhwn03";
          };
          nightlyOverlay = (import "${moz-url}/firefox-overlay.nix");
        in
          [
            nightlyOverlay
          ];
    in {
      nixosConfigurations = {
        ms45 = lib.nixosSystem {
	  inherit pkgs;
          inherit system;
          modules = [ 
            ./configuration.nix 
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ms45 = {
                imports = [ ./home.nix ];
              };
            }
          ];
        };
      };
    };
}
