{
  programs.nixvim.plugins = {
    telescope = {
      enable = true;

      keymaps = {
        "<leader>gf" = "git_files";
        "<leader>sf" = "find_files";
        "<leader>sr" = "oldfiles";
        "<leader>sh" = "help_tags";
        "<leader>sw" = "grep_string";
        "<leader>sg" = "live_grep";
        "<leader>sd" = "diagnostics";
      };

      settings = {
        defaults = {
          mappints = {
            i = {
              "<C-u>" = false;
              "<C-d>" = false;
              "<C-j>" = {
                __raw = "require('telescope.actions').move_selection_next";
              };
              "<C-k>" = {
                __raw = "require('telescope.actions').move_selection_previous";
              };
            };
          };
        };
      };
    };
  };
}
