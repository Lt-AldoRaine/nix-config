{ pkgs, config, ... }:

{
	services.jellyfin = {
		enable = true;
		dataDir = "/var/lib/jellyfin";
		openFirewall = true;
	};

	environment.systemPackages = [
		pkgs.jellyfin
		pkgs.jellyfin-web
		pkgs.jellyfin-ffmpeg
	];

	# Ensure Jellyfin service has access to FFmpeg
	systemd.services.jellyfin = {
		serviceConfig = {
			# Add FFmpeg to PATH
			Environment = [
				"PATH=${pkgs.jellyfin-ffmpeg}/bin:${pkgs.jellyfin}/bin:/run/current-system/sw/bin"
			];
		};
	};
}
