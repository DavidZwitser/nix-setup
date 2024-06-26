self: {pkgs, ...}: {
  environment.systemPackages = [ ];

  environment.shells = [pkgs.fish pkgs.bash pkgs.nushell];

  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";
    optimise.automatic = true;
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
        autohide = true;
        mineffect = "scale";
        orientation = "left";
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

      "iterm2"
      "zed"

      "appcleaner"
      "arc"
      "obs"
      "timemator"
      "nordvpn"
      "ghidra"
      "ollama"
      "utm"

      "rectangle"

      "1password" "1password-cli"

      "google-drive"
      "bambu-studio"
      "steelseries-gg" # Hate that I need this
      "rode-connect"

      "font-zed-mono" "font-zed-mono-nerd-font" "font-zed-sans"
    ];

    masApps = {
      "Final Cut Pro" = 424389933;
      "Logic Pro" = 634148309;
      "Motion" = 434290957;
      "Compressor" = 424390742;
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
