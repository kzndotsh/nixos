# flake.nix
{
  # Define the inputs for the flake
  inputs = {
    # The main Nix package set from the nixos-23.11 branch of the NixOS/nixpkgs repository
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    # The Home Manager configuration for the release-23.11 branch
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      # Make sure Home Manager uses the same Nixpkgs package set defined above
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Alejandra
    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Define the outputs for the flake
  outputs = inputs:
    with inputs; let
      # Declare a specialArgs variable which contains the inputs and the self references.
      specialArgs = {
        inherit inputs self;
      };
    in {
      # Define NixOS configurations which we can build and switch to.
      nixosConfigurations = {
        # NixOS configuration for the "ikigai" system
        ikigai = nixpkgs.lib.nixosSystem {
          # Pass the specialArgs to the nixosSystem function.
          inherit specialArgs;

          # Specify the modules that make up this system
          modules = [
            # Integrate Home Manager
            home-manager.nixosModules.home-manager

            # Additional NixOS modules from local files
            ./modules/nixos
            ./hosts/ikigai

            # Configuration specific to Home Manager
            {
              home-manager.useGlobalPkgs = true; # Use packages from the system
              home-manager.useUserPackages = true; # Allow the user to define their own packages

              # The Home Manager configuration for user "kaizen" on system "ikigai"
              home-manager.users.kaizen = import ./home/kaizen/ikigai.nix;

              # Passing specialArgs to Home Manager configuration
              home-manager.extraSpecialArgs = specialArgs;
            }
          ];
        };
      };

      # Define Home Manager configurations (for users)
      homeConfigurations = {
        # Home Manager configuration for the "kaizen" user on the "ikigai" system
        "kaizen@ikigai" = home-manager.lib.homeManagerConfiguration {
          # Specify the Nix packages system architecture
          pkgs = import nixpkgs {
            system = "x86_64-linux";
          };
          # Include local Home Manager modules
          modules = [
            ./modules/home
            ./home/kaizen
          ];
        };
      };
    };
}
