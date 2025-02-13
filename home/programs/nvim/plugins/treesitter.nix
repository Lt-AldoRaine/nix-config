{ nixvim, pkgs, ... }: {
  programs.nixvim.plugins.treesitter = {
    enable = true;
    nixvimInjections = true;
    nixGrammars = true;

    settings = {
      ensure_installed = "all";
      indent.enable = true;

      highlight = {
        enable = true;
        clearOnCursonMove = false;
      };
    };
  };
}
