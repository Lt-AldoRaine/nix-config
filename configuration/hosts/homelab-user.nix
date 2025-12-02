# #########################################################
# NIXOS - User homelab configuration
##########################################################
{ pkgs, config, lib, ... }:
let
  ifTheyExist = groups:
    builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  extraGroups = [ "audio" "video" "wheel" ] ++ ifTheyExist [
    "docker"
    "git"
    "libvirtd"
    "network"
    "networkmanager"
    "plugdev"
    "media"
  ];
in
{
  sops.secrets = {
    "homelab-password" = {
      sopsFile = ../../sops/secrets.yaml;
      neededForUsers = true;
    };
  };

  users.users = {
    homelab = {
      isNormalUser = true;
      home = "/home/homelab";
      inherit extraGroups;
      shell = pkgs.zsh;
      uid = 1001;
      hashedPasswordFile = config.sops.secrets."homelab-password".path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAUbHbQvRblFbKll9PxVzwiwW3PZsPYULJdiIsqHItgU connor@homelab"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBuobqAqi0hDAk4k5q0GY0EEmFYlcxvGRPZS05Yf9tRu connor@ConnorPC"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NT5AAAAILPD9PF+1YAxWjupCw/jCj9FzuchqJPYXFyKFfaTqZXl homelab@odin"
      ];
    };
  };
}


