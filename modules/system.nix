{ pkgs, ... }:
# macOS defaults are listed explicitly (including some Apple defaults) so
# upgrades cannot silently change them.
# https://daiderd.com/nix-darwin/manual/index.html#sec-options
{
  system = {
    stateVersion = 6;

    defaults = {
      menuExtraClock.Show24Hour = true;
      controlcenter = {
        AirDrop = false;
        BatteryShowPercentage = false;
        Bluetooth = false;
        Display = false;
        FocusModes = false;
        NowPlaying = false;
        Sound = false;
      };
      dock = {
        autohide = true;
        autohide-time-modifier = 1.0;
        enable-spring-load-actions-on-all-items = false;
        expose-animation-duration = 1.0;
        expose-group-apps = false;
        largesize = 32; # 16-128
        launchanim = true;
        magnification = false;
        mineffect = "genie"; # one of "genie", "suck", "scale"
        minimize-to-application = false;
        mouse-over-hilite-stack = false;
        mru-spaces = true;
        orientation = "bottom"; # one of "bottom", "left", "right"
        show-process-indicators = true;
        show-recents = false;
        showDesktopGestureEnabled = true;
        showhidden = true;
        showLaunchpadGestureEnabled = false;
        showMissionControlGestureEnabled = true;
        slow-motion-allowed = false;
        static-only = true;
        tilesize = 16;
      };
      finder = {
        _FXEnableColumnAutoSizing = false;
        _FXShowPosixPathInTitle = false;
        _FXSortFoldersFirst = false;
        _FXSortFoldersFirstOnDesktop = false;
        # Match NSGlobalDomain so Finder and open/save panels agree.
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        CreateDesktop = true;
        FXDefaultSearchScope = "SCcf"; # Current folder
        FXEnableExtensionChangeWarning = true;
        FXPreferredViewStyle = "Nlsv"; # "icnv" = Icon view, "Nlsv" = List view, "clmv" = Column View, "Flwv" = Gallery View
        FXRemoveOldTrashItems = false;
        NewWindowTarget = "Home"; # one of "Computer", "OS volume", "Home", "Desktop", "Documents", "Recents", "iCloud Drive", "Other"
        QuitMenuItem = true;
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = true;
        ShowMountedServersOnDesktop = true;
        ShowPathbar = true;
        ShowRemovableMediaOnDesktop = true;
        ShowStatusBar = true;
      };
      LaunchServices.LSQuarantine = false;
      NSGlobalDomain = {
        _HIHideMenuBar = true;
        AppleInterfaceStyle = "Dark";
        AppleInterfaceStyleSwitchesAutomatically = false;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        AppleShowScrollBars = "Always";
        NSDocumentSaveNewDocumentsToCloud = false;
      };
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
      swapLeftCommandAndLeftAlt = false;
      swapLeftCtrlAndFn = false;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableBashCompletion = true;
    enableCompletion = true;
    enableFzfCompletion = true;
    enableSyntaxHighlighting = true;
    enableGlobalCompInit = true;
    # Instant prompt belongs near the top of zshrc. ''${ below is Nix
    # string escaping so the generated file contains a literal ${.
    interactiveShellInit = ''
      if [[ -r "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    '';
    promptInit = ''
      zstyle ':completion:*' menu select
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';
  };
  programs.direnv = {
    enable = true;
  };
  programs.nix-index.enable = true;
  environment.systemPackages = with pkgs; [
    zsh-completions
    zsh-powerlevel10k
    zsh-vi-mode
  ];
  environment.variables = {
    LC_ALL = "C";
  };
}
