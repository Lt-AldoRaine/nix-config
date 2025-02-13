{ config, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "ls -la";
      ll = "ls -l";

	  vi = "nvim";
	  vim = "nvim";

      update-workspace =
        "sudo nixos-rebuild switch --flake ${config.var.configDirectory}#${config.var.hostname}";

	  test-workspace = "sudo nixos-rebuild test --flake ${config.var.configDirectory}#${config.var.hostname}";
    };

    initExtra = "eval $(starship init zsh)";
  };
}
