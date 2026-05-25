{
  pkgs,
  config,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    age
    sops
    ssh-to-age
  ];
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
      "cpu"
      "diskstats"
      "meminfo"
      "netdev"
      "systemd"
    ];
    port = 9100;
  };
  users.users._prometheus-node-exporter.home = lib.mkForce "/private/var/lib/prometheus-node-exporter";

  services.tailscale.enable = true;

  homebrew.casks = [
    "calibre"
    "discord"
    "firefox"
    "balenaetcher"
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
