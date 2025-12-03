{ config, pkgs, lib, ... }:
let 
  inherit (config.var) username;
in {
  programs.zsh.enable = true;
  users = {
    defaultUserShell = pkgs.zsh;
    users."${username}" = {
      home = "/home/${username}";
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      # No password hash - set password manually with 'passwd' if needed
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBuobqAqi0hDAk4k5q0GY0EEmFYlcxvGRPZS05Yf9tRu connor@ConnorPC"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NT5AAAAILPD9PF+1YAxWjupCw/jCj9FzuchqJPYXFyKFfaTqZXl homelab@odin"
      ];
    };
  };
}
