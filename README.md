# kaizen@ikigai - NixOS Dotfiles

## Structure

```sh
├── flake.nix
├── home
│   └── kaizen 
│       └── ikigai.nix 
├── hosts
│   └── ikigai
│       ├── configuration.nix
│       ├── default.nix
│       └── hardware.nix
└── modules 
    ├── home 
    │   ├── default.nix # <- entry point for home-manager modules
    │   └── sway.nix # <- example home-manager module
    └── nixos
        ├── default.nix # <- entry point for NixOS modules
        └── home-manager.nix < # <- example NixOS module
```

This directory structure represents a NixOS project managed with flakes, an experimental but powerful feature of the Nix package manager designed for reproducible and declarative configuration management. The use of flakes ensures that the system configuration, including all dependencies, can be reproduced exactly in any environment. Here's an overview of the directory structure and the purpose of each file or directory:

### Root Directory

- **`flake.nix`**: This is the central file for a Nix flake. It declares all the inputs (e.g., NixOS, home-manager, or any other dependencies) and outputs of the project. The outputs typically include NixOS configurations, packages, home-manager configurations, and more. This file ties together all the various components of your project and specifies how to build them.

### `home/` Directory

This directory is specifically for configurations related to home-manager, a tool for managing the user's environment using Nix.

- **`kaizen/` Directory**: Represents a user-specific configuration, named `kaizen` in this case. Inside, it may contain various configuration files for different aspects of the user's environment.
  - **`ikigai.nix`**: The main home-manager configuration file for the user `kaizen` on a host named `ikigai`. This file typically imports Nix expressions from other places, sets user-specific options, and defines the packages and services to be enabled for this user.

### `hosts/` Directory

This directory contains configurations for specific machines or hosts. Each subdirectory represents a distinct host and contains Nix expressions for that host's configuration.

- **`ikigai/` Directory**: Represents configurations specific to a host named `ikigai`. This could be a personal computer, a server, or any NixOS-managed device.
  - **`configuration.nix`**: The main NixOS configuration file for this host. This file typically imports Nix expressions from other places, sets system-wide options, and defines the services to be enabled on this host.
  - **`default.nix`**: Offers a way to package the host's configuration as a Nix attribute set. This is particularly useful in conjunction with flakes as it might define how to build or rebuild this host.
  - **`hardware.nix`**: Contains specific configurations related to the host's hardware, like drivers, kernel modules, and any hardware-specific settings.

### `modules/` Directory

This directory hosts reusable Nix expressions or modules that can be imported by various configurations, adding flexibility and modularity to the configurations.

- **`home/` Directory**: Contains modules that are specifically designed to be used with home-manager.
  - **`default.nix`**: A file that likely aggregates various home-manager modules defined in this directory, making them easily importable.
  - **`sway.nix`**: A module that probably contains configurations for the Sway window manager for use in a home-manager environment.
  
- **`nixos/` Directory**: Contains modules for NixOS system configurations.
  - **`default.nix`**: Similar to its counterpart in the `home/` directory, this likely serves as an entry point for importing the NixOS modules contained within this directory.
  - **`home-manager.nix`**: A module that integrates home-manager with NixOS, allowing user configurations to be managed alongside the system configuration in a unified way.

### Purpose and Usage

This structure allows for a highly modular and reusable configuration setup for both NixOS systems and users' environments managed by home-manager. By dividing configurations into distinct files and directories based on their purpose (user environment vs. system configuration, or host-specific vs. reusable modules), it makes managing and understanding the configurations more straightforward.

Each host or user can have its tailored configuration, while common configurations (like the `sway.nix` module for Sway users) can be shared easily across different setups. The use of flakes further ensures that these configurations are reproducible and declarative, making it easier to manage NixOS systems across different machines or environments.
