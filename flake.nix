{
  description = "Nix for macOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Non-flake repo. Official skill list is .claude-plugin/plugin.json.
    mattpocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      darwin,
      ...
    }:
    let
      supportedSystems = [
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      sharedModules = [
        ./modules/nix-core.nix
        ./modules/system.nix
        ./modules/apps.nix
        ./modules/host-users.nix
        ./modules/dev-tools.nix
        ./modules/cursor-skills.nix
      ];
      mkDarwinHost =
        {
          hostname,
          username,
          system ? "aarch64-darwin",
          modules,
        }:
        darwin.lib.darwinSystem {
          inherit system modules;
          specialArgs = inputs // {
            inherit username hostname;
            # Hyphenated input names are not valid module arguments.
            mattpocockSkills = inputs.mattpocock-skills;
          };
        };
    in
    {
      darwinConfigurations = {
        "m3pro" = mkDarwinHost {
          hostname = "m3pro";
          username = "alex";
          modules = sharedModules ++ [ ./hosts/m3pro/apps.nix ];
        };
        "work" = mkDarwinHost {
          hostname = "MBAM3-AlexM";
          username = "alexmayers";
          modules = sharedModules ++ [ ./hosts/work/apps.nix ];
        };
      };
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
