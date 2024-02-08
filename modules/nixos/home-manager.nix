# modules/nixos/home-manager.nix
{
  # NixOS module function parameters
  config,
  lib,
  inputs,
  self,
  ...
}: let
  # Import functions and types from the lib for convenience
  inherit
    (lib)
    mapAttrs
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;

  # Defines a submodule for user-specific Home Manager configurations
  userSubmodule = types.submodule {
    options = {
      # Option to enable Home Manager for the user
      enable = mkEnableOption "home-manager for user";

      # Option for user-specific Home Manager configuration
      extraHomeConfig = mkOption {
        type = types.attrs;
        default = {};
      };
    };
  };

  # Short-hand to access the module's specific configuration
  cfg = config.base.home-manager;
in {
  # Define module options
  options.base.home-manager = {
    # Option to enable Home Manager globally
    enable = mkEnableOption "home-manager";

    # Global extra configuration for all users
    extraHomeConfig = mkOption {
      type = types.attrs;
      default = {};
    };

    # Specifies per-user configuration using the defined userSubmodule
    users = mkOption {
      type = types.attrsOf userSubmodule;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    # Pass inputs and self to the Home Manager as extra attributes
    home-manager.extraSpecialArgs = {
      inherit inputs self;
    };

    # Configure Home Manager to utilize global and user package sets
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    # Generate Home Manager configurations for each user
    home-manager.users =
      mapAttrs
      (name: user:
        mkIf user.enable (mkMerge [
          cfg.extraHomeConfig # Merge the global extra config
          user.extraHomeConfig # with the user-specific extra config
          {
            # Import general home configuration and user-specific for the current host
            imports = [
              ../home
              (../../home/${name} + "/${config.networking.hostName}.nix")
            ];
            programs.home-manager.enable = true; # Ensure Home Manager is enabled for the user
          }
        ]))
      cfg.users;
  };
}
