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
    "connor-password" = {
      sopsFile = ../../sops/secrets.yaml;
      neededForUsers = true;
    };
  };

  users.users = {
    connor = {
      isNormalUser = true;
      home = "/home/connor";
      inherit extraGroups;
      shell = pkgs.zsh;
      uid = 1000;
      hashedPasswordFile = config.sops.secrets."connor-password".path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBuobqAqi0hDAk4k5q0GY0EEmFYlcxvGRPZS05Yf9tRu connor@ConnorPC"
      ];
    };
  };
}


