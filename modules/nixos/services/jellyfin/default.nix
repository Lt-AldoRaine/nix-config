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
			# Remove WorkingDirectory to fix CHDIR errors when copying data directories
			# Jellyfin doesn't need a working directory as it uses explicit paths via CLI args
			WorkingDirectory = null;
		};
	};

	# Ensure backups directory exists with proper permissions
	# This ensures Jellyfin can read backup files from the backups folder
	# Note: This is for nixarr's data directory structure
	systemd.tmpfiles.rules = [
		"d /media/.state/nixarr/jellyfin/data/backups 0755 jellyfin media -"
	];
}
