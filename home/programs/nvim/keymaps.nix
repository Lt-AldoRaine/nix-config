{ config, lib, ... }: {
  programs.nixvim = {
    globals = {
      mapleader = " ";
      mapLocalleader = " ";
    };

    plugins.which-key = {
      enable = true;
      settings = {
        delay = 600;
        icons = {
          breadcrumb = "»";
          group = "+";
          separator = ""; # ➜
          mappings = false;
        };

      };
    };

    keymaps = let
      normal = lib.mapAttrsToList (key: action: {
        mode = "n";
        inherit action key;
      }) {
        "<Space>" = "<NOP>";

        # "k" = "v:count == 0 ? 'gk' : 'k'";
        # "j" = "v:count == 0 ? 'gj' : 'j'";

        "<C-d>" = "<C-d>zz";
        "<C-u>" = "<C-u>zz";
        "p" = "P";
        "U" = "vim.cmd.redo";
        "n" = "nzzzv";
        "N" = "Nzzzv";
        "<leader>tt" = "<Cmd>Neotree toggle<CR>";
      };
      visual = lib.mapAttrsToList (key: action: {
        mode = "v";
        inherit action key;
      }) {
        "J" = ":m '>+1<CR>gv=gv";
        "K" = ":m '<-2<CR>gv=gv";
      };
    in config.lib.nixvim.keymaps.mkKeymaps { options.silent = true; }
    (normal ++ visual);
  };
}
