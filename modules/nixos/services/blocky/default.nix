{ lib, ... }:
let
  dnsPort = 53;
  loopbackResolvers = [ "127.0.0.1" "::1" ];
in
{
  networking = {
    nameservers = lib.mkForce loopbackResolvers;
    networkmanager.dns = "none";
    firewall = {
      allowedTCPPorts = lib.mkAfter [ dnsPort ];
      allowedUDPPorts = lib.mkAfter [ dnsPort ];
    };
  };

  services.blocky = {
    enable = true;
    settings = {
      bootstrapDns = [ "9.9.9.9" "1.1.1.1" ];
      ports.dns = dnsPort;

      upstreams.groups.default = [
        "9.9.9.9"
        "149.112.112.112"
        "https://dns.quad9.net/dns-query"
        "tcp-tls:dns.quad9.net"
      ];

      blocking = {
        denylists = {
          ads = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro.txt"
          ];
          fakenews = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-only/hosts"
          ];
          gambling = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/gambling-only/hosts"
          ];
          adult = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/porn-only/hosts"
          ];
        };

        clientGroupsBlock.default = [ "ads" "fakenews" "gambling" "adult" ];
      };
    };
  };
}
