{
  programs.nixvim = {
    plugins = {
      neo-tree = {
        enable = true;

        filesystem = {
          window = {
            mappings = {
              "<leader>." = "toggle_hidden";
              "H" = "set_root";
            };
          };
        };
        window = {
          mappings = {
            "<leader>t" = "open";
            "<leader>tc" = "close_node";
          };
        };

      };
    };
  };
}
