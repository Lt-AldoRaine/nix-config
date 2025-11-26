{ lib, config, ... }: {
  programs.zsh = lib.mkMerge [
    {
      enable = lib.mkDefault true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    }

    {
      shellAliases = {
      ls = "ls -la";
      ll = "ls -l";

      vi = "nvim";
      vim = "nvim";

      gc = "git commit";
      gs = "git status";
      gl = "git log";

      update-workspace =
        "sudo nixos-rebuild switch --flake ${config.var.configDirectory}#${config.var.hostname}";

      test-workspace =
        "sudo nixos-rebuild test --flake ${config.var.configDirectory}#${config.var.hostname}";
    };
    }
    {
      initContent = "eval $(starship init zsh)";
    }
  ];
}
