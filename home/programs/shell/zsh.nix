{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "ls -la";
      ll = "ls -l";

      update-workspace =
        "sudo nixos-rebuild switch --flake ~/nix-config#workspace";

	  test-workspace = "sudo nixos-rebuild test --flake ~/nix-config#workspace";
    };

    initExtra = "eval $(starship init zsh)";
  };
}
