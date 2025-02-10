{ inputs, config, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./options.nix
	# ./keymaps.nix
    ./plugins
  ];


  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    nixpkgs.useGlobalPackages = true;

    performance = {
	  combinePlugins = {
        enable = true;
	    standalonePlugins = [
	      "hmts.nvim"
		  "neorg"
		  "nvim-treesitter"
	    ];
	  };
	  byteCompileLua.enable = true;
    };

    luaLoader.enable = true;

  };

}
