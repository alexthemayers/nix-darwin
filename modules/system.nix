{ pkgs, ... }:
###################################################################################
#
#  macOS's System configuration
#
#  All the configuration options are documented here:
#    https://daiderd.com/nix-darwin/manual/index.html#sec-options
#
###################################################################################
{
  system = {
    stateVersion = 6;

    defaults = {
      menuExtraClock.Show24Hour = true; # show 24 hour clock
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
        dashboard-in-overlay = false;
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
        AppleShowAllExtensions = false;
        AppleShowAllFiles = false;
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
      # For better vim use
      remapCapsLockToEscape = true;
      # For when using a normal keyboard
      swapLeftCommandAndLeftAlt = false;
      swapLeftCtrlAndFn = false;
    };
  };

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableBashCompletion = true;
    enableCompletion = true;
    enableFzfCompletion = true;
    enableSyntaxHighlighting = true;
    enableGlobalCompInit = true;
    interactiveShellInit = ''
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    '';
    promptInit = ''
      # Initialize completion system with caching for speed
      autoload -Uz compinit
      compinit -C

      # Enable menu-style selection for completions
      zstyle ':completion:*' menu select
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      # double single quotes ('\') to escape the dollar char
      if [[ -r "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
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

}
