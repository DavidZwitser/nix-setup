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
  let
    system = "Kraker";
  in
  {
    darwinConfigurations.${system} = nix-darwin.lib.darwinSystem {
      modules = [
        # Home manager setup
        home-manager.darwinModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";

            # User setups
            users.david = import setup/davids_home.nix;
          };
        }

        # Darwin setup
        (import setup/darwin.nix self)
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations.${system}.pkgs;
  };
}
