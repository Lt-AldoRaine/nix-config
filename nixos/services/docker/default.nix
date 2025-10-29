{ pkgs, config, ... }: {
  virtualisation.docker.enable = true;
  users.users."${config.var.username}".extraGroups = [ "docker" ];

	environment.systemPackages = with pkgs; [
		docker-compose
	];
}
