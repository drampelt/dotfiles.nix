{ pkgs, lib, ... }:
{
  # Nix configuration ------------------------------------------------------------------------------

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
    auto-optimise-store = true
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
    ];

    casks = [
      "apparency"
      "appcleaner"
      "avidemux"
      "balenaetcher"
      "bettertouchtool"
      "betterzip"
      "crunch-app"
      "cyberduck"
      "discord"
      "firefox"
      "fuse-t"
      "fuse-t-sshfs"
      "ghostty"
      "google-chrome"
      "gpg-suite"
      "heynote"
      "hiddenbar"
      "iina"
      "iterm2"
      "itsycal"
      "jetbrains-toolbox"
      "karabiner-elements"
      "keka"
      "keybase"
      "mediainfoex"
      "miniwol"
      "moonlight"
      "musicbrainz-picard"
      "numi"
      "obsidian"
      "plex"
      "plexamp"
      "prismlauncher"
      "qlmarkdown"
      "qlstephen"
      "qlvideo"
      "raycast"
      "sequel-ace"
      "slack"
      "soduto"
      "shottr"
      "steam"
      "sublime-text"
      "syntax-highlight"
      "tailscale-app"
      "visual-studio-code"
      "xcodes-app"
      "zerotier-one"
      "zed"
    ];

    masApps = {
      Bitwarden = 1352778147;
    };
  };

  system.defaults = {
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      AppleShowAllFiles = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };

    dock = {
      autohide = true;
      mru-spaces = false;
      show-recents = false;
    };

    finder.AppleShowAllFiles = true;

    screencapture.location = "/Users/daniel/Pictures/Screenshots";

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
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
