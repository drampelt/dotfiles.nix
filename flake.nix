{
  description = "Daniel's darwin system";

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    #nixvim.inputs.nixpkgs.follows = "nixpkgs";

    # Other sources
    comma = { url = github:nix-community/comma; flake = false; };
    
  };

  outputs = { self, darwin, nixpkgs, nixpkgs-unstable, home-manager, nixvim, ... }@inputs:
  let 

    inherit (darwin.lib) darwinSystem;
    inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;

    # Configuration for `nixpkgs`
    nixpkgsConfig = {
      config = { allowUnfree = true; };
    }; 
    nvim = { system }: nixvim.legacyPackages."${system}".makeNixvimWithModule { module = ./vim; };
  in
  {
    packages."aarch64-darwin".nvim = nvim { system = "aarch64-darwin"; };
    # My `nix-darwin` configs
      
    darwinConfigurations = rec {
      Daniels-MBP2019 = darwinSystem {
        system = "x86_64-darwin";
        modules = attrValues self.darwinModules ++ [ 
          # Main `nix-darwin` config
          ./darwin/configuration.nix
          # `home-manager` module
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            # `home-manager` config
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.daniel = import ./darwin/home.nix;            
          }
        ];
      };
      Daniels-MBA2024 = darwinSystem rec {
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs;
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
          nixvim = nvim { inherit system; };
        };
        modules = attrValues self.darwinModules ++ [
          # Main `nix-darwin` config
          ./darwin/configuration.nix
          # `home-manager` module
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            # `home-manager` config
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.daniel = import ./darwin/home.nix;
          }
        ];
      };
    };

    # Overlays --------------------------------------------------------------- {{{

    overlays = {
      # Overlays to add various packages into package set
      #  comma = final: prev: {
      #    comma = import inputs.comma { inherit (prev) pkgs; };
      #  };  

      # Overlay useful on Macs with Apple Silicon
        apple-silicon = final: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          # Add access to x86 packages system is running Apple Silicon
          pkgs-x86 = import inputs.nixpkgs-unstable {
            system = "x86_64-darwin";
            inherit (nixpkgsConfig) config;
          };
        }; 
      };

    # My `nix-darwin` modules that are pending upstream, or patched versions waiting on upstream
    # fixes.
    darwinModules = {
      programs-nix-index = 
        # Additional configuration for `nix-index` to enable `command-not-found` functionality with Fish.
        { config, lib, pkgs, ... }:

        {
          config = lib.mkIf config.programs.nix-index.enable {
            programs.fish.interactiveShellInit = ''
              function __fish_command_not_found_handler --on-event="fish_command_not_found"
                ${if config.programs.fish.useBabelfish then ''
                command_not_found_handle $argv
                '' else ''
                ${pkgs.bashInteractive}/bin/bash -c \
                  "source ${config.progams.nix-index.package}/etc/profile.d/command-not-found.sh; command_not_found_handle $argv"
                ''}
              end
            '';
            };
        };
    };
 };
}
