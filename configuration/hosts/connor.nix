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
  # No password hash - set password manually with 'passwd' if needed
  users.users = {
    connor = {
      isNormalUser = true;
      home = "/home/connor";
      inherit extraGroups;
      shell = pkgs.zsh;
      uid = 1000;
      # No password hash - set password manually if needed
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBuobqAqi0hDAk4k5q0GY0EEmFYlcxvGRPZS05Yf9tRu connor@ConnorPC"
      ];
    };
  };
}


