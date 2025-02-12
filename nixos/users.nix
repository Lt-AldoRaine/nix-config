{ config, pkgs, username, password, ... }: {
  programs.zsh.enable = true;
  users = {
    defaultUserShell = pkgs.zsh;
    users."${username}" = {
      home = "/home/${username}";
      isNormalUser = true;
      password = password;
      extraGroups = [ "wheel" "networkmanager" ];
    };
  };
}
