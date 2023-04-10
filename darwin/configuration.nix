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
  nix.configureBuildUsers = true;

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

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

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
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
     recursive
     (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
   ];

  # Keyboard
  # system.keyboard.enableKeyMapping = true;
  # system.keyboard.remapCapsLockToEscape = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
    global.brewfile = true;

    taps = [
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
    ];

    casks = [
      "appcleaner"
      "avidemux"
      "background-music"
      "bettertouchtool"
      "crunch"
      "cyberduck"
      "discord"
      "firefox"
      "google-chrome"
      "gpg-suite"
      "hiddenbar"
      "iina"
      "iterm2"
      "itsycal"
      "jetbrains-toolbox"
      "karabiner-elements"
      "keybase"
      "numi"
      "obsidian"
      "plex"
      "plexamp"
      "raycast"
      "sequel-ace"
      "slack"
      "soduto"
      "shottr"
      "sublime-text"
      "the-unarchiver"
      "visual-studio-code"
      "xcodes"
      "zerotier-one"
    ];

    masApps = {
      Bitwarden = 1352778147;
    };
  };

  system.defaults = {
    NSGlobalDomain = {
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
  };
}
