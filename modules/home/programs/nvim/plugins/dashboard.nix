{ config, lib, ... }:
let
  hasStylix = lib.hasAttrByPath [ "lib" "stylix" "colors" ] config;
  accent = if hasStylix then "#${config.lib.stylix.colors.base0D}" else "#bd93f9";
  muted = if hasStylix then "#${config.lib.stylix.colors.base03}" else "#6272a4";
  foreground = if hasStylix then "#${config.lib.stylix.colors.base05}" else "#f8f8f2";
in {

  programs.nixvim.highlight = {
    AlphaHeaderColor.fg = accent;
    AlphaTextColor.fg = foreground;
    AlphaShortcutColor.fg = muted;
  };

  programs.nixvim.plugins.alpha = {
    enable = true;
    settings.layout = [
      {
        type = "padding";
        val = 4;
      }
      {
        type = "text";
        opts = {
          position = "center";
          hl = "AlphaHeaderColor";
        };
        val = [
          "                                                                     "
          "       ████ ██████           █████      ██                     "
          "      ███████████             █████                             "
          "      █████████ ███████████████████ ███   ███████████   "
          "     █████████  ███    █████████████ █████ ██████████████   "
          "    █████████ ██████████ █████████ █████ █████ ████ █████   "
          "  ███████████ ███    ███ █████████ █████ █████ ████ █████  "
          " ██████  █████████████████████ ████ █████ █████ ████ ██████ "
          "                                                                       "
        ];
      }
      {
        type = "padding";
        val = 4;
      }
      {
        type = "group";

        val = [
          {
            type = "button";
            val = "󰭎  Find file";
            on_press.__raw = "function() vim.cmd[[Telescope find_files]] end";
            opts = {
              shortcut = "<Leader> sf";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "AlphaShortcutColor";
              hl = "AlphaTextColor";
            };
          }
          {
            type = "button";
            val = "  Recently files";
            on_press.__raw = "function() vim.cmd[[Telescope oldfiles]] end";
            opts = {
              shortcut = "<Leader> sr";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "AlphaShortcutColor";
              hl = "AlphaTextColor";
            };
          }
          {
            type = "button";
            val = "󰱽  Find word";
            on_press.__raw = "function() vim.cmd[[Telescope live_grep]] end";
            opts = {
              shortcut = "<Leader> sg";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "AlphaShortcutColor";
              hl = "AlphaTextColor";
            };
          }
        ];

      }
    ];
  };

}
