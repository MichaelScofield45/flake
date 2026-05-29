{
  inputs,
  lib,
	# nixpkgs,
	# nixpkgs-stable-stable,
  system,
  user,
  home-manager,
  ...
}: let
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [inputs.nvim_overlay.overlays.default];
    config.allowUnfree = true;
  };
  pkgs-stable = import inputs.nixpkgs-stable {
    inherit system;
    overlays = [inputs.nvim_overlay.overlays.default];
    config.allowUnfree = true;
  };
  specialArgs = {
    inherit user inputs pkgs-stable;
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
            imports = [./desktop/home.nix];
            blenderHipSupport = true;
          };
					extraSpecialArgs = {
						inherit pkgs-stable;
					};
        };
      }
		  inputs.copyparty.nixosModules.default
			({ pkgs, ... }: {
			  nixpkgs.overlays = [ inputs.copyparty.overlays.default ];
			  environment.systemPackages = [ pkgs.copyparty ];
			  # services.copyparty.enable = true;
			})
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
          imports = [./laptop/home.nix];
        };
      }
    ];
  };

  server = lib.nixosSystem {
    inherit system pkgs specialArgs;
    modules = [
      ./server
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = {
          imports = [./server/home.nix];
        };
      }
		  inputs.copyparty.nixosModules.default
			({ pkgs, ... }: {
			  nixpkgs.overlays = [ inputs.copyparty.overlays.default ];
			  environment.systemPackages = [ pkgs.copyparty ];
			  services.copyparty.enable = true;
			})
    ];
  };
}
