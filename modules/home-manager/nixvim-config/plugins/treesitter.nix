{ nixvim, pkgs, ... }: {
  programs.nixvim.plugins.treesitter = {
    enable = true;
    folding = true;
    nixvimInjections = true;

    settings = {
      highlight = {
        enable = true;
	additional_vim_regex_highlighting = true;
	clearOnCursonMove = false;
      };

      indent.enable = true;
    };
  };
}
