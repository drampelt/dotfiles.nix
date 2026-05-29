{ pkgs, lib, ... }:
{
  # Nix configuration ------------------------------------------------------------------------------

  nix.enable = false;
  determinateNix.enable = true;

  nix.settings.substituters = [
    "https://cache.nixos.org/"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
  nix.settings.trusted-users = [
    "@admin"
  ];

  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  ids.gids.nixbld = 30000;

  system.primaryUser = "daniel";

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [];

  # https://github.com/nix-community/home-manager/issues/423
  #environment.variables = {
  #  TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
  #};
  programs.nix-index.enable = true;

  environment.shells = [pkgs.zsh];

  # Fonts
  fonts.packages = with pkgs; [
     recursive
     nerd-fonts.jetbrains-mono
   ];

  # Keyboard
  # system.keyboard.enableKeyMapping = true;
  # system.keyboard.remapCapsLockToEscape = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.daniel = {
    name = "daniel";
    home = "/Users/daniel";
  };


  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
    global.brewfile = true;

    taps = [
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/services"
      "macos-fuse-t/homebrew-cask"
      "jurplel/tap" # instant-space-switcher
    ];

    casks = [
      "apparency"
      "appcleaner"
      "audacity"
      "avidemux"
      "balenaetcher"
      "bettertouchtool"
      "betterzip"
      "calibre"
      "codex-app"
      "codexbar"
      "crunch-app"
      "cyberduck"
      "devcleaner"
      "discord"
      "domzilla-caffeine"
      "finicky"
      "firefox"
      "fuse-t"
      "fuse-t-sshfs"
      "ghostty"
      "gitup-app"
      "google-chrome"
      "gpg-suite"
      "heynote"
      "hex-fiend"
      "hiddenbar"
      "iina"
      "inkscape"
      "instant-space-switcher"
      "iterm2"
      "itsycal"
      "jetbrains-toolbox"
      "karabiner-elements"
      "keka"
      "keybase"
      "losslesscut"
      "mediainfoex"
      "miniwol"
      "moonlight"
      "musicbrainz-picard"
      "numi"
      "obsidian"
      "orbstack"
      "parsec"
      "plex"
      "plexamp"
      "prismlauncher"
      "qlmarkdown"
      "qlstephen"
      "quicklook-video"
      "raycast"
      "sequel-ace"
      "slack"
      "soduto"
      "shottr"
      "steam"
      "sublime-text"
      "syntax-highlight"
      "tailscale-app"
      "utm"
      "visual-studio-code"
      "whatsapp"
      "xcodes-app"
      "xld"
      "zerotier-one"
      "zed"
      "zoom"
    ];

    masApps = {
      Bitwarden = 1352778147;
    };
  };

  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      ApplePressAndHoldEnabled = false;
      AppleShowAllFiles = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSStatusItemSelectionPadding = 4;
      NSStatusItemSpacing = 4;
      "com.apple.keyboard.fnState" = true;
      "com.apple.trackpad.scaling" = 1.5;
    };

    dock = {
      autohide = true;
      mru-spaces = false;
      persistent-apps = [
        "/Applications/Firefox.app"
        "/Applications/Google Chrome.app"
        "/Applications/Ghostty.app"
        "/Applications/Zed.app"
        "/Applications/Codex.app"
        "/Applications/Discord.app"
        "/Applications/WhatsApp.app"
        "/Applications/Numi.app"
        "/System/Applications/Music.app"
        "/Applications/Plexamp.app"
      ];
      show-recents = false;
      tilesize = 64;
      wvous-br-corner = 1;
    };

    finder = {
      AppleShowAllFiles = true;
      FXPreferredViewStyle = "Nlsv";
      ShowExternalHardDrivesOnDesktop = false;
      ShowHardDrivesOnDesktop = false;
      ShowRemovableMediaOnDesktop = false;
    };

    screencapture = {
      location = "/Users/daniel/Pictures/Screenshots";
    };

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };

    controlcenter = {
      Bluetooth = false;
      Display = false;
      FocusModes = false;
      NowPlaying = true;
      Sound = true;
    };

    hitoolbox.AppleFnUsageType = "Do Nothing";

    CustomUserPreferences = {
      NSGlobalDomain = {
        AppleLanguages = [ "en-CA" ];
        AppleLocale = "en_CA";
      };

      "com.apple.dock" = {
        "persistent-others" = [
          {
            "tile-data" = {
              arrangement = 2;
              displayas = 1;
              "file-data" = {
                "_CFURLString" = "file:///Users/daniel/Downloads/";
                "_CFURLStringType" = 15;
              };
              "file-label" = "Downloads";
              preferreditemsize = -1;
              showas = 2;
            };
            "tile-type" = "directory-tile";
          }
          {
            "tile-data" = {
              arrangement = 1;
              displayas = 1;
              "file-data" = {
                "_CFURLString" = "file:///Applications/";
                "_CFURLStringType" = 15;
              };
              "file-label" = "Applications";
              preferreditemsize = -1;
              showas = 0;
            };
            "tile-type" = "directory-tile";
          }
        ];
        "wvous-br-modifier" = 0;
      };

      "com.apple.HIToolbox" = {
        AppleCurrentKeyboardLayoutInputSourceID = "com.apple.keylayout.Canadian";
        AppleEnabledInputSources = [
          {
            InputSourceKind = "Keyboard Layout";
            "KeyboardLayout ID" = 29;
            "KeyboardLayout Name" = "Canadian";
          }
          {
            InputSourceKind = "Keyboard Layout";
            "KeyboardLayout ID" = 12825;
            "KeyboardLayout Name" = "Colemak";
          }
        ];
        AppleSelectedInputSources = [
          {
            InputSourceKind = "Keyboard Layout";
            "KeyboardLayout ID" = 29;
            "KeyboardLayout Name" = "Canadian";
          }
        ];
      };
    };

    ".GlobalPreferences" = {
      "com.apple.mouse.scaling" = 2.0;
    };
  };

  launchd.user.agents = {
    # See https://github.com/stuartdochertymusic/KRK_stayawake
    "krk-speaker-tone" = {
      command = "/usr/bin/afplay -d ${./10hz_tone.wav}";
      serviceConfig = {
        RunAtLoad = true;
        StartInterval = 300; # every 5 minutes
        StandardErrorPath = "/tmp/krk-speaker-tone.err";
        StandardOutPath = "/tmp/krk-speaker-tone.out";
      };
    };
  };

  system.stateVersion = 5;
}
