{ pkgs, ... }: {
	   programs.zsh = {
	       enable = true;
	enableCompletion = true;
	autosuggestion.enable = true;

	shellAliases = {
	           ls = "ls -la";
	    ll = "ls -l";

	    vi = "nvim";
	    vim = "nvim";
	};
   };
}
