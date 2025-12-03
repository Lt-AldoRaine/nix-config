# Common home-manager configurations
{ pkgs, ... }: {
  # Common packages and settings
  home.packages = with pkgs; [
    # Basic utilities
    curl
    wget
    git
    htop
    tree
  ];
}

