{
  programs.nixvim = {
    plugins = {
      lsp-format = {
        enable = true;
	lspServersToEnable = "all";
      };

      lsp = {
        enable = true;

	inlayHints = true;
	
	keymaps = {
          silent = true;
	  lspBuf = {
            gd = "definition";
	    gD = "references";
	    gt = "type_definition";
	    gi = "implementation";
	    K = "hover";
	    "<F2>" = "rename";
	  };
	};
	
        clangd.enable = true;
      };
    };
  };
}
