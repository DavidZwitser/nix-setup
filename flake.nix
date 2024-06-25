{
  description = "Epic Krakinn system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager }:
  {
    darwinConfigurations.Kraker = nix-darwin.lib.darwinSystem {
      modules = [
        # Darwin setup
        (import ./configs/darwin.nix self)

        # Home manager setup
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          # So overwritten dot files are backed up
          home-manager.backupFileExtension = "backup";
          home-manager.users.david = import ./configs/home.nix;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations.Kraker.pkgs;
  };
}
