{ config, pkgs, ... }: {
  programs.nixvim = {
    home.packages = with pkgs; [ ctags ];

    highlightOverride = {
      FloatBorder.fg = "#${config.lib.stylix.colors.base0D}";
    };
    plugins = {
      tmux-navigator.enable = true;
      comment.enable = true;
      nvim-autopairs.enable = true;
      web-devicons.enable = true;
      noice.enable = true;
      gitsigns = {
        enable = true;
        settings.current_line_blame = false;
      };
      trouble.enable = true;
      bufferline.enable = true;
    };

  };
}
