{ nixvim, pkgs, ... }: {
  programs.nixvim.plugins.treesitter = {
    enable = true;
    nixvimInjections = true;
    nixGrammars = true;

    settings = {
      ensure_installed = [
		"nix"
		"go"
		"python"
		"javascript"
		"c"
		"rust"
		"lua"
		"markdown"
		"json"
		"toml"
		"yaml"
	  ];
      indent.enable = true;

      highlight = {
        enable = true;
        clearOnCursonMove = false;
      };
    };
  };
}
