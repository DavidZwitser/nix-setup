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

        abbr -a kr cd "/Users/${username}/Library/Mobile\ Documents/com\~apple\~CloudDocs/Krakinn"
        abbr -a nix-r nix run nix-darwin -- switch --flake ~/.config/nix-setup
        abbr -a nix-e zed ~/.config/nix-setup
        abbr -a ms 'set color "#d54200"; for flag in --top-color --middle-color --bottom-color; rivalcfg $flag $color; end'
      '';
    };

    helix = {
      enable = true;
      languages = builtins.fromTOML (builtins.readFile ../dotfiles/helix/languages.toml);
      settings = builtins.fromTOML (builtins.readFile ../dotfiles/helix/config.toml);
    };

    lf = {
      enable = true;
    };
  };

  home = {
    packages = [
      pkgs.bqn386
      pkgs.direnv
      pkgs.rivalcfg
      pkgs.wget
      pkgs.jre
      pkgs.julia_19-bin
      pkgs.ghidra
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
