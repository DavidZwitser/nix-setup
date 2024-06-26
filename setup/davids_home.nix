{config, pkgs, lib, ...}:
let
  username = "david";
  home = "/Users/${username}";
  base = home + "/.config/nix-setup";
in
{
  home.username = username;
  home.homeDirectory = home;

  programs = {
    git = {
      enable = true;
      userName = "davidzwitser";
      userEmail = "davidzwitser@gmail.com";
    };

    gh = {
      enable = true;
    };

    fish = {
      enable = true;
      loginShellInit = /*fish*/''
        set -g fish_greeting 'Letsgooo'
        fish_vi_key_bindings

        abbr -a cd z
        abbr -a kr cd "/Users/${username}/Library/Mobile\ Documents/com\~apple\~CloudDocs/Krakinn"
        abbr -a nix-r darwin-rebuild switch --flake ~/.config/nix-setup
      '';
    };

    # Using nushell for data manipulation.
    nushell = {
      enable = true;
      extraConfig = /*nu*/''
        use std "path add"
        path add /run/current-system/sw/bin
        path add /etc/profiles/per-user/${username}/bin

        def lsg [] { ls | sort-by type name -i | grid -c | str trim }
      '';
      environmentVariables = {
        EDITOR = "zed";
      };
      shellAliases = {
        cd = "z";
        kr = "cd '/Users/${username}/Library/Mobile Documents/com~apple~CloudDocs/Krakinn'";
        nix-r = "darwin-rebuild switch --flake ~/.config/nix-setup";
      };
    };

    helix = {
      enable = true;
      languages = builtins.fromTOML (builtins.readFile ../dotfiles/helix/languages.toml);
      settings = builtins.fromTOML (builtins.readFile ../dotfiles/helix/config.toml);
    };

    lf = {
      enable = true;
    };

    zellij = {
      enable = true;
      settings = {
        theme = "gruvbox-dark";
        themes = {
          gruvbox-dark = {
          		fg = "#D5C4A1";
          		bg = "#282828";
          		black = "#3C3836";
          		red = "#CC241D";
          		green = "#98971A";
          		yellow = "#D79921";
          		blue = "#3C8588";
          		magenta = "#B16286";
          		cyan = "#689D6A";
          		white = "#FBF1C7";
          		orange = "#D65D0E";
         	};
        };
      };
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  home = {
    packages = [
      pkgs.bqn386
    ];

    # Using absolute paths since flakes will convert path types to store based paths
    file = let
      link_to = config.lib.file.mkOutOfStoreSymlink;
      zed_folder = "${home}/.config/zed";
      darwin_zed_folder = "${base}/dotfiles/zed";
    in
    {
      # Symlinking zed files so I can edit them both trough zed and in here
      "${zed_folder}/settings.json".source  = link_to "${darwin_zed_folder}/settings.json";
      "${zed_folder}/keymap.json".source    = link_to "${darwin_zed_folder}/keymap.json";
      "${zed_folder}/tasks.json".source     = link_to "${darwin_zed_folder}/tasks.json";
    };

    activation = {
      # Setting up iterm2 to read from my custom settings
      setup_iterm2_dotfiles = lib.hm.dag.entryAfter ["writeBoundry"] /*bash*/ ''
        /usr/bin/defaults write com.googlecode.iterm2 "PrefsCustomFolder" -string "${base}/dotfiles/iterm2"
        /usr/bin/defaults write com.googlecode.iterm2 "LoadPrefsFromCustomFolder" -bool true
      '';
    };

    sessionVariables = {
      EDITOR = "zed";
    };
  };

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
