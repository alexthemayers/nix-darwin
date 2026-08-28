{
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # Secrets CLI only; this flake does not wire sops-nix
    age
    sops
    ssh-to-age

    # Client tools, not a local postgres/terraform service
    postgresql_17
    terraform

    iperf3
    zig
  ];

  # Default Darwin collectors are enough; systemd is Linux-only.
  services.prometheus.exporters.node.enable = true;
  # nix-darwin defaults this user home to /var/lib/...; macOS dscl reports
  # /private/var/lib/... because /var -> /private/var. Without this, activation
  # aborts. See https://github.com/nix-darwin/nix-darwin/issues/1256
  users.users._prometheus-node-exporter.home = lib.mkForce "/private/var/lib/prometheus-node-exporter";

  # GUI app is the Tailscale node (Network Extension, sleep/wake). Do not also
  # enable services.tailscale — that starts a second, usually unlogged-in daemon.
  homebrew.casks = [
    "balenaetcher"
    "calibre"
    "discord"
    "firefox"
    "iina"
    "libreoffice"
    "qbittorrent"
    "reaper"
    "tailscale-app"
    "tidal"
    "tinymediamanager"
    "whatsapp"
    "zoom"
  ];
}
