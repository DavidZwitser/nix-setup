self: {pkgs, ...}: {
  environment.systemPackages = [ ];

  environment.shells = [pkgs.fish pkgs.bash pkgs.nushell];

  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";
    # optimise.automatic = true;
  };

  programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # System settings
  system = {
    stateVersion = 4;

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
      nonUS.remapTilde = true;
    };

    defaults = {
      finder = {
        AppleShowAllExtensions = true;
        CreateDesktop = true;
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      dock = {
        autohide = false;
        mineffect = "scale";
        orientation = "left";
        show-recents = false;
      };

      trackpad = {
        TrackpadThreeFingerDrag = true;
      };
    };
  };

  # GUI Software
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
    };

    casks = [
      "touchdesigner"
      "blender"
      "sonic-pi"
      "solvespace"
      "affinity-photo"
      "affinity-designer"
      "affinity-publisher"

      "deluge"

      "iterm2"
      "zed"

      "appcleaner"
      "arc"
      "obs"
      "timemator"
      "nordvpn"
      "ollama"
      "utm"
      "blackhole-2ch"

      "1password" "1password-cli"

      "google-drive"
      "bambu-studio"
      "rode-connect"

      "font-zed-mono" "font-zed-mono-nerd-font" "font-zed-sans"
    ];

    masApps = {
      "Final Cut Pro" = 424389933;
      "Logic Pro" = 634148309;
      "Motion" = 434290957;
      "Compressor" = 424390742;
      "Pages" = 409201541;
      "Keynote" = 409183694;
      "Xcode" = 497799835;
      # "1Password for Safari" = 1569813296;
    };
  };

  networking.computerName = "Kraker";
  security.pam.enableSudoTouchIdAuth = true;

  users.users.david = {
    name = "david";
    home = "/Users/david";
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
}
