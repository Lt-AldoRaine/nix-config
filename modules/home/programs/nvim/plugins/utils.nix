{ config, pkgs, lib, ... }:
let
  hasStylix = lib.hasAttrByPath [ "lib" "stylix" "colors" ] config;
  accent = if hasStylix then "#${config.lib.stylix.colors.base0D}" else "#bd93f9";
in {
  home.packages = with pkgs; [ ctags ];
  programs.nixvim = {
    highlightOverride = {
      FloatBorder.fg = accent;
      SignColumn.fg = "none";
      LineNr.fg = "none";
      LineNrAbove.fg = "none";
      LineNrBelow.fg = "none";
    };
    nixpkgs.config = { allowUnfree = true; };

    plugins = {
			#lazy.enable = true;
      tmux-navigator.enable = true;
      comment.enable = true;
      nvim-autopairs.enable = true;
      web-devicons.enable = true;
      gitsigns = {
        enable = true;
        settings = { current_line_blame = false; };

      };
      snacks = {
        enable = true;
        settings = {
          words = {
            enable = true;
            debounce = 100;
          };
        };
      };
      trouble.enable = true;
    };
  };
}
