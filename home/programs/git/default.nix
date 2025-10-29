{ pkgs, ... }: {
  programs.git = {
    enable = true;
		settings = {
			user.name = "Connor Pennington";
			user.email = "harambefallon@gmail.com";
		};
  };
}
