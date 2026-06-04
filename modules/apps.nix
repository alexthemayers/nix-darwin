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
    curl
    direnv
    git
    ghostty-bin
    jq
    neovim
    tree
    (lib.setPrio (-15) uutils-coreutils-noprefix)
    watch
    wget
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  #
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      cleanup = "zap";
      # https://github.com/nix-darwin/nix-darwin/issues/1787
      extraFlags = [ "--force-cleanup" ];
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
      "grandperspective"
      "intellij-idea"
      "rectangle"
      "spotify"
      "stats"
    ];
  };
}
