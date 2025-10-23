{ config, pkgs, ... }:
let inherit (config.var) username;

in {
  programs.zsh.enable = true;
  users = {
    defaultUserShell = pkgs.zsh;
    users."${username}" = {
      home = "/home/${username}";
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKPhGbF2NAnxBf12gGtNryqnWUv5KVywc3JroO+f40J5 connor@aldoraine"
      ];

    };

    mutableUsers = true;
  };
}
