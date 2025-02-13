{
  programs.nixvim.plugins = {
	harpoon = {
	  enable = true;

	  keymaps = {
		addFile = "<leader>h";
		cmdToggleQuickMenu = "<C-e>";
		navFile = {
		  "1" = "<C-h>";
		  "2" = "<C-t>";
		  "3" = "<C-n>";
		  "4" = "<C-s>";
		};
	  };
	};
  };
}
