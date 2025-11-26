{
  programs.nixvim = {
    plugins = {
      neo-tree = {
        enable = true;

        settings = {

        filesystem = {
          window = {
            mappings = {
              "<leader>." = "toggle_hidden";
              "H" = "set_root";
            };
          };
        };
        window = {
          width = 30;

          mappings = {
            "<space>" = {
              command = "toggle_mode";
              nowait = false;
            };

            "<cr>" = "open";
            P = {
              command = "toggle_preview";
              config = { use_float = true; };
            };

            C = "close_node";
            R = "refresh";

            a = {
              command = "add";
              config = { show_path = "relative"; };
            };
            A = "add_directory";
            d = "delete";
            r = "rename";
            c = "copy";
            m = "move";
            q = "close_window";
          };
        };

      };
};
    };
  };
}
