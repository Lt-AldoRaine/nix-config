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
            gI = "implementation";
            K = "hover";
            "<leader>rn" = "rename";
            "<leader>f" = "format";
            "<leader>wa" = "add_workspace_folder";
          };
        };

        servers = {
          clangd.enable = true;
          nixd.enable = true;
          lua_ls.enable = true;
        };
      };
      none-ls = {
        enable = true;

        sources = {
          formatting = {
						#black.enable = true;
						clang_format.enable = true;
						#gofmt.enable = true;
            nixfmt.enable = true;
						#prettierd.enable = true;
            stylua.enable = true;
          };

          diagnostics = {
						#pylint.enable = true;
            statix.enable = true;
						#golangci_lint.enable = true;
          };
        };
      };
    };
  };
}
