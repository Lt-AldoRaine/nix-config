{ config, ... }: {
  programs.nixvim = {
    highlightOverride = {
      FloatBorder.fg = "#${config.lib.stylix.colors.base0D}";
    };
    nixpkgs.config = { allowUnfree = true; };
    plugins = {
      tmux-navigator.enable = true;
      comment.enable = true;
      nvim-autopairs.enable = true;
    };
  };
}
