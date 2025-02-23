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
    };

    mutableUsers = true;
  };
}
