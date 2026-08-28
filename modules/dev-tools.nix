{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Go toolchain (gopls covers modern editor integration; go-outline is unused)
    go
    gopls
    golangci-lint
    gotools
    delve

    gnumake
    python3
    podman
    podman-compose
  ];
}
