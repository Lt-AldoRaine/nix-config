{ config, lib, ... }:
let
  accent = "#${config.lib.stylix.colors.base0D}";
  background-alt = "#${config.lib.stylix.colors.base01}";
in {
  programs.starship = lib.mkMerge [
    { enable = lib.mkDefault true; }
    {
      settings = {
        add_newline = true;
        format = lib.concatStrings [
          "$directory"
          "$git_branch"
          "$git_state"
          "$git_status"
          "$character"
        ];
        directory = { style = accent; };

        character = {
          success_symbol = "[❯](${accent})";
          error_symbol = "[❯](red)";
          vimcmd_symbol = "[❮](cyan)";
        };

        git_branch = {
          symbol = "[](${background-alt}) ";
          style = "fg:${accent} bg:${background-alt}";
          format = "on [$symbol$branch]($style)[](${background-alt}) ";
        };

        git_status = {
          format =
            "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218)($ahead_behind$stashed)]($style)";
          style = "cyan";
          conflicted = "";
          renamed = "";
          deleted = "";
          stashed = "≡";
        };

        git_state = {
          format = "([$state( $progress_current/$progress_total)]($style)) ";
          style = "bright-black";
        };
      };
    }
  ];
}
