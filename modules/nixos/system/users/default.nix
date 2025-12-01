{ config, pkgs, lib, ... }:
let 
  inherit (config.var) username;
  # Check for password secret (supports both username-based and legacy "connor" naming)
  passwordSecretName = "${username}-password-hash";
  legacySecretName = "connor-password-hash";
  hasPasswordSecret = builtins.hasAttr passwordSecretName (config.sops.secrets or {});
  hasLegacySecret = builtins.hasAttr legacySecretName (config.sops.secrets or {});
  passwordSecret = if hasPasswordSecret then passwordSecretName else legacySecretName;
in {
  programs.zsh.enable = true;
  users = {
    defaultUserShell = pkgs.zsh;
    users."${username}" = {
      home = "/home/${username}";
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      # Use mkDefault so Clan can override if it manages the user
      hashedPasswordFile = lib.mkDefault (
        if hasPasswordSecret || hasLegacySecret then
          config.sops.secrets.${passwordSecret}.path
        else
          null
      );
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBuobqAqi0hDAk4k5q0GY0EEmFYlcxvGRPZS05Yf9tRu connor@ConnorPC"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NT5AAAAILPD9PF+1YAxWjupCw/jCj9FzuchqJPYXFyKFfaTqZXl homelab@odin"
      ];
    };
  };
}
