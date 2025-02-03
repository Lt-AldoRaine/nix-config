{ pkgs, lib, ... }: {
  programs.starship = {
    enable = true;
    # settings = {
    #   add_newline = true;
    #
    # };
    settings = pkgs.lib.importTOML ./starship-themes/bracketed-segments.toml;
  };
}
