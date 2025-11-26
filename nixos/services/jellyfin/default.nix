{ pkgs, ... }:

{
	services.jellyfin = {
		enable = true;
		dataDir = "/media";
	};

	environment.systemPackages = [
		pkgs.jellyfin
		pkgs.jellyfin-web
		pkgs.jellyfin-ffmpeg
	];
}
