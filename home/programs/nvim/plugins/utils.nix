{ config, pkgs, ... }: {
  home.packages = with pkgs; [ ctags ];
  programs.nixvim = {
    # highlightOverride = {
    #   FloatBorder.fg = "#${config.lib.stylix.colors.base0D}";
    # };
	nixpkgs.config = { allowUnfree = true; };

    plugins = {
      tmux-navigator.enable = true;
      comment.enable = true;
      nvim-autopairs.enable = true;
      web-devicons.enable = true;
      gitsigns = {
        enable = true;
        settings.current_line_blame = false;
      };
      trouble.enable = true;
    };
  };
}
