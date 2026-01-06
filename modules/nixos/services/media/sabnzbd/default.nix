{ pkgs, lib, ... }:

{
  services.sabnzbd = {
    enable = true;
    openFirewall = true;
  };

  # Configure SABnzbd systemd service to create files with correct group permissions
  systemd.services.sabnzbd = {
    serviceConfig = {
      # Set umask to 0002 (allows group write permissions)
      # This ensures files created by SABnzbd are group-writable
      UMask = lib.mkDefault "0002";
      
      # Add supplementary groups so SABnzbd can create files with the correct group
      # Replace 'users' with 'media' if you have a media group
      SupplementaryGroups = [ "users" ];
    };
  };
}
