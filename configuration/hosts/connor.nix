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
  users.users = {
    connor = {
      isNormalUser = true;
      home = "/home/connor";
      inherit extraGroups;
      shell = pkgs.zsh;
      uid = 1000;
      hashedPasswordFile = lib.mkIf (config.sops.secrets ? "connor-password-hash")
        config.sops.secrets."connor-password-hash".path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBuobqAqi0hDAk4k5q0GY0EEmFYlcxvGRPZS05Yf9tRu connor@ConnorPC"
      ];
    };
  };
}


