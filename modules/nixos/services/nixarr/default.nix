{ pkgs, lib, ... }:

{
  nixarr = {
    enable = true;
    mediaDir = "/media";
    stateDir = "/media/.state/nixarr";

    jellyfin = {
      enable = true;
      openFirewall = true;
    };
    lidarr.enable = true;
    jellyseerr = {
      enable = true;
      openFirewall = true;
    };
    prowlarr = {
      enable = true;
      openFirewall = true;
    };
    radarr = {
      enable = true;
      openFirewall = true;
    };
    sonarr = {
      enable = true;
      openFirewall = true;
    };
    sabnzbd = {
      enable = true;
      openFirewall = true;
      guiPort = 8085;
    };
  };

  # Keep Arr services from starting before the NFS media mount exists.
  systemd.services = {
    sonarr = {
      requires = [ "mnt-Media.mount" ];
      after = [ "mnt-Media.mount" ];
    };
    radarr = {
      requires = [ "mnt-Media.mount" ];
      after = [ "mnt-Media.mount" ];
    };
    prowlarr = {
      requires = [ "mnt-Media.mount" ];
      after = [ "mnt-Media.mount" ];
    };
    jellyfin = {
      requires = [ "mnt-Media.mount" ];
      after = [ "mnt-Media.mount" ];
    };
    sabnzbd = {
      requires = [ "mnt-Media.mount" ];
      after = [ "mnt-Media.mount" ];
      serviceConfig = {
        UMask = lib.mkDefault "0002";
        SupplementaryGroups = [ "users" ];
      };
    };
  };

  # Recreate state directories if they were deleted and enforce ownership.
  systemd.tmpfiles.rules = [
    "d /media/.state 0755 root root -"
    "d /media/.state/nixarr 0755 root root -"
    "d /media/.state/nixarr/sonarr 0755 sonarr sonarr -"
    "d /media/.state/nixarr/radarr 0755 radarr radarr -"
    "d /media/.state/nixarr/prowlarr 0755 prowlarr prowlarr -"
    "d /media/.state/nixarr/sabnzbd 0755 sabnzbd sabnzbd -"
    "d /media/.state/nixarr/jellyfin 0755 jellyfin jellyfin -"
    "d /media/.state/nixarr/jellyfin/data 0755 jellyfin jellyfin -"
    "d /media/.state/nixarr/jellyfin/data/plugins 0755 jellyfin jellyfin -"
  ];
}
