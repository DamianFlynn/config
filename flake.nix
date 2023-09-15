{
  description = "My Initial Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    nvim.url = "github:damianflynn/nvim";
  };

  outputs = inputs: {
    darwinConfigurations.Damians-Virtual-Machine = inputs.darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = import inputs.nixpkgs {
        system = "aarch64-darwin";
      };

      modules = [
        ({pkgs, ...}: {
          programs.zsh.enable = true;
          environment = {
            shells = [pkgs.bash pkgs.zsh];
            loginShell = pkgs.zsh;
            systemPackages = [ pkgs.coreutils ];
          };
          nix.extraOptions = ''
            experimental-features = nix-command flakes
          '';
          system.keyboard.enableKeyMapping = true;
          system.keyboard.remapCapsLockToEscape = true;
          fonts.fontDir.enable = true;
          fonts.fonts = [(pkgs.nerdfonts.override {fonts = ["Meslo"];})];
          services.nix-daemon.enable = true;
          system.defaults.finder.AppleShowAllExtensions = true;
          system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
          system.defaults.NSGlobalDomain.InitialKeyRepeat = 14;
          system.defaults.NSGlobalDomain.KeyRepeat = 1;
          system.defaults.finder._FXShowPosixPathInTitle = true;
          system.defaults.dock.autohide = true;
          users.users.damianflynn.home = "/Users/damianflynn";
          system.stateVersion = 4;
        })
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.damianflynn.imports = [
              ({pkgs, ...}: {
                home.stateVersion = "23.05";
                home.packages = [
            		  pkgs.ripgrep 
            		  pkgs.fd 
            		  pkgs.curl 
            		  pkgs.less 
            		  inputs.nvim.packages."aarch64-darwin".default
            		];
                home.sessionVariables = {
                  PAGER = "less";
                  CLICOLOR = 1;
                  EDITOR = "nvim";
                };
                programs.bat.enable = true;
                programs.bat.config.theme = "TwoDark";
                programs.fzf.enable = true;
                programs.fzf.enableZshIntegration = true;
                programs.eza.enable = true;
                programs.git.enable = true;
                programs.zsh.enable = true;
                programs.zsh.enableCompletion = true;
                programs.zsh.enableAutosuggestions = true;
                programs.zsh.syntaxHighlighting.enable = true;
                programs.zsh.shellAliases = {ls = "ls --color=auto -F";};
                programs.starship.enable = true;
                programs.starship.enableZshIntegration = true;
                programs.alacritty = {
                  enable = true;
                  settings.font.normal.family = "MesloLGS Nerd Font Mono";
                  settings.font.size = 16;
                };
              })
            ];
          };
        }
      ];
    };
  };
}
