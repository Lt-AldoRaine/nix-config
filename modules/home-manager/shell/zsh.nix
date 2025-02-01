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

	plugins = [
		#           {
		#               name = "powerlevel10k-config";
		# src = ./p10k;
		# file = ".p10k.zsh";
		#    }
	    {
	        name = "zsh-powerlevel10k";
		src = "${pkgs.zsh-powerlevel10k}/share/zsh-pwoerlevel10k/";
		file = "powerlevel10k.zsh-theme";
	    }
	];

	    oh-my-zsh = {
                 enable = true;
		 plugins = [
		     "git"
		     "powerlevel10k"
		 ];
	    };
    };
}
