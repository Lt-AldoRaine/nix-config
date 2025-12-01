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
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBuobqAqi0hDAk4k5q0GY0EEmFYlcxvGRPZS05Yf9tRu connor@ConnorPC"
      ];

    };
  };
}
