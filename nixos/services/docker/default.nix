{ pkgs, config, ... }: {
  virtualisation.docker.enable = true;
  users.users."${config.var.username}".extraGroups = [ "docker" ];

	virtualisation.oci-containers.backend = "docker";

	environment.systemPackages = with pkgs; [
		docker-compose
	];
}
