{
  pkgs,
  config,
  lib,
  ...
}:
{
  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  #  NOTE: Your can find all available options in:
  #    https://daiderd.com/nix-darwin/manual/index.html
  #
  # TODO Feel free to modify this file to fit your needs.
  #
  ##########################################################################

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    age
    kind
    iperf3
    git
    gnumake
    go
    neovim
    podman
    podman-compose
    python3
    sops
    ssh-to-age
    watch
    wget
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

  #
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      cleanup = "zap";
    };

    taps = [ ];

    # `brew install`
    brews = [ ];

    # `brew install --cask`
    casks = [
      "alfred"
      "antigravity"
      "bitwarden"
      "caffeine"
      "calibre"
      "grandperspective"
      "iina"
      "intellij-idea"
      "iterm2"
      "libreoffice"
      "qbittorrent"
      "reaper"
      "rectangle"
      "spotify"
      "stats"
      "tailscale-app"
      "tidal"
      "tinymediamanager"
      "whatsapp"
      "zoom"
    ];
  };
}
