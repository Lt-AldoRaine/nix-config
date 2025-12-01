{ config, lib, ... }: 
{
  services.openssh = {
    enable = true;
    settings = {
      # Allow root login with key only (needed for Clan management)
      # Use mkForce to override the "no" setting from utils/default.nix
      PermitRootLogin = lib.mkForce "prohibit-password";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
    # Open SSH on firewall - needed for initial deployment and clan management
    # After Tailscale is set up, you can access via Tailscale for added security
    openFirewall = lib.mkForce true;
  };

  # Add homelab key to root's authorized keys for Clan management
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAUbHbQvRblFbKll9PxVzwiwW3PZsPYULJdiIsqHItgU connor@homelab"
  ];

  # Allow essential ports through firewall
  networking.firewall = {
    allowedTCPPorts = lib.mkForce [
      22    # SSH - needed for clan management
      80    # HTTP (for ACME challenges)
      443   # HTTPS
    ];
  };
}
