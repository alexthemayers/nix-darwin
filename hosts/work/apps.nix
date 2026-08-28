{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Client tools, not a local postgres service
    postgresql_18

    # cgo / confluent kafka client
    pkg-config
    rdkafka

    # Docs
    openapi-generator-cli

    # Ops tools (opentofu rather than terraform, unlike the personal host)
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
  ];

  homebrew.casks = [
    "google-chrome"
    "luanti"
  ];
}
