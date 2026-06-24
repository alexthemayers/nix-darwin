{
  pkgs,
  config,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    postgresql_18

    # Go Toolchain
    go
    gopls
    golangci-lint
    gotools
    delve
    go-outline
    # for cgo support
    pkg-config
    # for confluent kakfa client library
    rdkafka

    # Docs
    openapi-generator-cli

    # Ops tools
    openstackclient
    kubernetes-helm
    kubectl
    opentofu
    argocd
    awscli

    # Kafka client
    kaf
    # Bento stream processor
    bento

    # Frontend
    nodejs
    yarn
    playwright-test

    gnumake
    python3
    podman
    podman-compose
  ];
  homebrew.casks = [
    "luanti"
    "google-chrome"
  ];
}
