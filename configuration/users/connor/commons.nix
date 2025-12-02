{ config, pkgs, lib, inputs, ... }:
{
  ##############################################################################
  # Common user conf for connor across all hosts
  ##############################################################################

  imports = [
    # Common programs
    ../../../modules/home/programs/git/default.nix
    ../../../modules/home/programs/shell/default.nix
    ../../../modules/home/programs/nvim/default.nix
  ];

  home = {
    username = lib.mkDefault "connor";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "24.11";

    # User-specific configuration
    userconf = {
      user = {
        git = {
          username = "Lt-AldoRaine";
          email = "harambefallon@gmail.com";
        };
      };
    };
  };

  programs = {
    git = {
      enable = true;
      userName = "Connor Pennington";
      userEmail = "harambefallon@gmail.com";

      extraConfig = {
        core.pager = "delta";
        interactive.difffilter = "delta --color-only --features=interactive";
        delta.side-by-side = true;
        delta.navigate = true;
        merge.conflictstyle = "diff3";
      };
    };
  };

  ##############################################################################
  # Common packages for all hosts
  ##############################################################################
  home.packages = with pkgs; [
    # Core utilities
    git
    ripgrep
    zip
    unzip
    pfetch

    # Development
    nodejs
  ];
}

