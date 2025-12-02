# #########################################################
# NIXOS - Root user configuration
##########################################################
{ pkgs, config, lib, ... }:
{
  sops.secrets = {
    "root-password-hash" = {
      sopsFile = ../../sops/secrets.yaml;
      neededForUsers = true;
    };
  };

  users.users = {
    root = {
      shell = pkgs.zsh;
      hashedPasswordFile = lib.mkIf (config.sops.secrets ? "root-password-hash")
        config.sops.secrets."root-password-hash".path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBuobqAqi0hDAk4k5q0GY0EEmFYlcxvGRPZS05Yf9tRu connor@ConnorPC"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAUbHbQvRblFbKll9PxVzwiwW3PZsPYULJdiIsqHItgU connor@homelab"
      ];
    };
  };

  # Needed so that we can set a root password
  users.mutableUsers = false;
  nix.settings.trusted-users = [ "connor" "homelab" ];

  security.sudo.wheelNeedsPassword = false;
}

