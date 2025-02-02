{ pkgs, lib, ... }: {
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;

      pkgs.lib.importTOML = ./starship-themes/nerd-font-theme.toml;
    };
  };
}
