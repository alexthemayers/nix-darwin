{ lib, ... }:
{
  nix = {
    # If this is false, the settings below are ignored; edit /etc/nix/nix.custom.conf instead.
    enable = true;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Enabled despite NixOS/nix#7273 (store link races on Darwin). Revisit if
      # builds fail with "cannot link ... File exists".
      auto-optimise-store = true;
    };

    gc = {
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };
  nixpkgs.config.allowUnfree = true;
}
