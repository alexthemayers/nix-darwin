{
  pkgs,
  lib,
  ...
}:
{
  # Shared CLI from nixpkgs. GUI apps are mostly Homebrew: larger catalog on
  # macOS, but not reproducible. See https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    curl
    fastfetch
    git
    ghostty-bin
    jq
    neovim
    tree
    # Negative prio beats BSD / GNU coreutils so `ls`, `date`, etc. are uutils.
    (lib.setPrio (-15) uutils-coreutils-noprefix)
    watch
    wget
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # zap removes formulae/casks (and related files) not listed here, including
      # apps installed by hand. Add every wanted cask below or it will vanish on switch.
      cleanup = "zap";
      # https://github.com/nix-darwin/nix-darwin/issues/1787
      extraFlags = [ "--force-cleanup" ];
    };

    taps = [ ];
    brews = [ ];
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
      "visual-studio-code"
    ];
  };
}
