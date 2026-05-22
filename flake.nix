{
  description = "Nix for macOS configuration";

  ##################################################################################################################
  #
  # Want to know Nix in details? Looking for a beginner-friendly tutorial?
  # Check out https://github.com/ryan4yin/nixos-and-flakes-book !
  #
  ##################################################################################################################

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    substituters = [
      # Query the mirror of USTC first, and then the official cache.
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
  };

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs =
    inputs@{
      self,
      nixpkgs,
      darwin,
      ...
    }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
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
          };
        };
    in
    {
      darwinConfigurations = {
        "m3pro" = mkDarwinHost {
          hostname = "m3pro";
          username = "alex";
          system = "aarch64-darwin";
          # Modules defined specific to this host
          modules = [
            ./modules/nix-core.nix
            ./modules/system.nix
            ./modules/apps.nix
            ./modules/host-users.nix
            ./hosts/m3pro/apps.nix
          ];
        };
        "work" = mkDarwinHost {
          hostname = "MBAM3-AlexM";
          username = "alexmayers";
          system = "aarch64-darwin";
          # Modules defined specific to this host
          modules = [
            ./modules/nix-core.nix
            ./modules/system.nix
            ./modules/apps.nix
            ./modules/host-users.nix
            ./hosts/work/apps.nix
          ];
        };
      };
      # nix code formatter
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
