{ pkgs, ... }: {

  # Neovim configuration
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  # Neovim build requirements and useful tools
  home.packages = with pkgs; [
    # neovim and plugins build requirements
    cargo
    cmake
    curl
    ncurses
    nodejs
    unzip
    yarn

    # Needed by plugins
    fd
    lazygit
    ripgrep
    tree-sitter
    xclip
  ];

}

