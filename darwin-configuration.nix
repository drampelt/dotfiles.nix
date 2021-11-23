{ config, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.vim pkgs.lorri pkgs.ncdu pkgs.delta pkgs.git
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  launchd.user.agents = {
    "lorri" = {
      serviceConfig = {
        WorkingDirectory = (builtins.getEnv "HOME");
        EnvironmentVariables = { };
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/var/tmp/lorri.log";
        StandardErrorPath = "/var/tmp/lorri.log";
      };
      script = ''
        source ${config.system.build.setEnvironment}
        exec ${pkgs.lorri}/bin/lorri daemon
      '';
    };
  };

  users.users.daniel = {
    name = "daniel";
    home = "/Users/daniel";
  };

  home-manager.users.daniel = { pkgs, ... }: {
    home.packages = [ pkgs.xh ];

    home.file.".ideavimrc".source = ./ideavimrc;

    programs.git = {
      enable = true;
      userEmail = "drampelt@gmail.com";
      userName = "Daniel Rampelt";
      signing.key = "C7F714686365C406";
      signing.signByDefault = true;
      delta.enable = true;
      delta.options = {
        features = "side-by-side line-numbers decorations";
        whitespace-error-style = "22 reverse";
      };
      ignores = [ "*.swp" ".DS_Store" ];
      extraConfig = {
        alias = {
          lg = "log --graph --date=format:\"%a %b %d, %r\" --pretty=format:\"%Cred%h%Creset - %C(yellow)%ad %Cgreen(%cr)%C(reset)%C(auto) -%d %s %Cblue<%an>%Creset\" --topo-order";
        };
        pull = {
          rebase = true;
        };
        init = {
          defaultBranch = "main";
        };
      };
    };
  };
}
