{ config, ... }:
let
  internalDomain = "homelab-server.tail426372.ts.net";
  externalDomain = "aldoraine.com";

  mkLB = address: { loadBalancer = { servers = [{ url = "${address}"; }]; }; };

  mkTsRouter = { name, middlewares ? [ ] }: {
    inherit middlewares;
    rule =
      "Host(`connor.${internalDomain}`) && Path(`/${name}`) || PathPrefix(`/${name}`)";
    service = name;
    entryPoints = [ "websecure" ];
    tls.certificateresolver = "tailscale";
  };

  mkExtRouter = { subdomain, middlewares ? [ ] }: {
    inherit middlewares;
    rule = "Host(`${subdomain}.${externalDomain}`)";
    service = subdomain;
    entryPoints = [ "websecure" ];
    tls.certresolver = "letsencrypt";
  };

in {

  services = {
    tailscale.permitCertUid = "traefik";

    traefik = {
      enable = true;

      staticConfigOptions = {
        entryPoints = {
          web = {
            address = ":80";
            http.redirections.entrypoint = {
              scheme = "https";
              to = "websecure";
            };
          };

          websecure.address = ":443";
        };
        certificateResolvers = {
          letsencrypt.acme = {
            email = "cpenn@aldoraine.com";
            storage = "${config.services.traefik.dataDir}/acme.json";
            dnsChallenege.provider = "cloudflare";
          };

          tailscale.tailscale = { };
        };

        api.dashboard = true;

        dynamicConfigOptions = {
          https = {
            middlewares = {

            };

            routers = { dash = mkExtRouter { subdomain = "dash"; }; };

            services = {
              dash = mkLB "https://localhost:8082";

              "connor.sync" = mkLB "http://connor${internalDomain}:8384";
            };
          };
        };
      };
    };
  };
}
