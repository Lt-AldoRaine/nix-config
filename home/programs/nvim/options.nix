{
  programs.nixvim = {
    globals.mapLeader = "";
    opts = {
      autoindent = true;
      smartindent = true;

      shiftwidth = 2;
      softtabstop = 2;
      tabstop = 2;
      scrolloff = 8;

      clipboard = "unnamedplus";

      cursorline = false;

      swapfile = false;
      backup = false;

      pumheight = 15;

      hlsearch = true;
      incsearch = true;

      mouse = "a";

      number = true;

      relativenumber = true;

      breakindent = true;

      undofile = true;

      signcolumn = "yes";

      ignorecase = true;
      smartcase = true;

      updatetime = 250;
      timeoutlen = 300;

      termguicolors = true;

      wrap = false;
    };
  };
}
