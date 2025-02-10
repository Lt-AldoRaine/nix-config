{
  programs.nixvim = {
    globals = {
      mapLeader = " ";
      mapLocalLeader = " ";
      loaded_netrw = 1;
      loaded_netrwPlugin = 1;
    };  

	clipboard = {
	  register = "unnamedplus";
	  providers.wl-copy.enable = true;
	};

    opts = {
      relativenumber = true;

      shiftwidth = 4;
      softtabstop = 0;
      tabstop = 4;
      scrolloff = 8;

      wrap = false;

      swapfile = false;
      backup = false;

      pumheight = 15;

      hlsearch = false;
      incsearch = true;

      # vim.wo.number = true

      mouse = "a";


      breakindent = true;

      undofile = true;

      ignorecase = true;
      smartcase = true;

      # vim.wo.signcolumn = "yes"

      updatetime = 250;
      timeoutlen = 300;

      termguicolors = true;
    };
  }; 
}
