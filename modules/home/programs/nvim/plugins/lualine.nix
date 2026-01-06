{
  programs.nixvim.plugins.lualine = {
    enable = false; # Temporarily disabled due to hash mismatch - will re-enable after nixvim update
    settings = {
      options.disabled_filetypes.statusline =
        [ "dashboard" "alpha" "neo-tree" ];

      alwaysDivideMiddle = true;
      globalstatus = true;
      ignoreFocus = [ "neo-tree" ];
      extensions = [ "fzf" ];
      componentSeparators = {
        left = "|";
        right = "|";
      };
      sectionSeparators = {
        left = ""; # 
        right = ""; # 
      };
      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [ "branch" "diff" "diagnostics" ];
        lualine_c = [ "filename" ];
        lualine_x = [ "filetype" ];
        lualine_y = [ "progress" ];
        lualine_z = [ ''" " .. os.date("%R")'' ];
      };
    };
  };
}
