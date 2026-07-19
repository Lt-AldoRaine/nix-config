{ config, pkgs, lib, ... }:
{
  config = {
    services.fail2ban = {
      enable = true;
      jails = {
        sshd = {
          settings = {
            enabled = true;
            filter = "sshd";
            logpath = "/var/log/auth.log";
            maxretry = 5;
            bantime = "1h";
            findtime = "10m";
          };
        };

        recidive = {
          settings = {
            enabled = true;
            filter = "recidive";
            logpath = "/var/log/fail2ban.log";
            action = "iptables-allports[name=recidive]";
            maxretry = 5;
            bantime = "1w";
            findtime = "1d";
          };
        };
      };
    };
  };
}
