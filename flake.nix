{
  description = "Claude Code plugin for Scooter";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    scooter-cli.url = "github:chadac-me/scooter-cli";
    scooter-cli.inputs.nixpkgs.follows = "nixpkgs";
    scooter-cli.inputs.flake-parts.follows = "flake-parts";
    scooter-cli.inputs.systems.follows = "systems";
  };

  outputs = inputs@{ flake-parts, systems, scooter-cli, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;

      perSystem = { pkgs, system, ... }: {
        # The CLI the plugin drives, pinned.
        packages.scooter = scooter-cli.packages.${system}.scooter;
        packages.default = scooter-cli.packages.${system}.scooter;

        devShells.default = pkgs.mkShell {
          packages = [ scooter-cli.packages.${system}.scooter pkgs.jq pkgs.shellcheck pkgs.just ];
        };
      };
    };
}
