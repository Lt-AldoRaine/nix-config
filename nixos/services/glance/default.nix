{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.glance ];

  services.glance = {
    enable = true;

    settings = {
      pages = [{
        name = "Home";
        # Optionally, if you only have a single page you can hide the desktop navigation for a cleaner look
        # hide-desktop-navigation = true;
        columns = [
          {
            size = "small";
            widgets = [
              {
                type = "calendar";
                first-day-of-week = "monday";
              }
              {
                type = "twitch-channels";
                channels = [
                  "theprimeagen"
                  "j_blow"
                  "giantwaffle"
                  "cohhcarnage"
                  "christitustech"
                  "EJ_SA"
                ];
              }
            ];
          }
          {
            size = "full";
            widgets = [
              {
                type = "server-stats";
                servers = [{
                  type = "local";
                  name = "home";
                  hide-swap = true;
                  hide-mountpoints-by-default = true;
                  mountpoints = {
                    "/".hide = false;
                    "/nix/".hide = false;
                  };
                }];
              }
              {
                type = "split-column";
                widgets = [
                  {
                    type = "hacker-news";
                    collapse-after = 6;
                  }
                  {
                    type = "lobsters";
                    collapse-after = 6;
                  }
                ];
              }
              {
                type = "monitor";
                sites = [{
                  title = "Jellyfin";
                  url = "https://jellyfin.aldoraine.com";
                }];
              }
              {
                type = "videos";
                channels = [
                  "UCXuqSBlHAE6Xw-yeJA0Tunw" # Linus Tech Tips
                  "UCR-DXc1voovS8nhAvccRZhg" # Jeff Geerling
                  "UCsBjURrPoezykLs9EqgamOA" # Fireship
                  "UCBJycsmduvYEL83R_U4JriQ" # Marques Brownlee
                  "UCHnyfMqiRRG1u-2MsSQLbXA" # Veritasium
                ];
              }
              {
                type = "bookmarks";
                groups = [
                  {
                    title = "";
                    same-tab = true;
                    color = "200 50 50";
                    links = [
                      {
                        title = "ProtonMail";
                        url = "https://proton.me/mail";
                      }
                      {
                        title = "Github";
                        url = "https://github.com";
                      }
                      {
                        title = "Youtube";
                        url = "https://youtube.com";
                      }
                      {
                        title = "Figma";
                        url = "https://figma.com";
                      }
                    ];
                  }
                  {

                    title = "Docs";
                    same-tab = true;
                    color = "200 50 50";
                    links = [

                      {
                        title = "Nixpkgs repo";
                        url = "https://github.com/NixOS/nixpkgs";
                      }
                      {
                        title = "Nixvim";
                        url = "https://nix-community.github.io/nixvim/";
                      }
                      {
                        title = "Hyprland wiki";
                        url = "https://wiki.hyprland.org/";
                      }
                      {
                        title = "Search NixOS";
                        url = "https://search-nixos.hadi.diy";
                      }
                    ];
                  }
                  {
                    title = "Homelab";
                    same-tab = true;
                    color = "100 50 50";
                    links = [
                      {
                        title = "Router";
                        url = "http://192.168.1.1/";
                      }
                      {
                        title = "Cloudflare";
                        url = "https://dash.cloudflare.com/";
                      }
                      {
                        title = "Tailscale";
                        url = "https://login.tailscale.com/admin/machines";
                      }
                    ];
                  }

                ];
              }
            ];
          }

          {
            size = "small";
            widgets = [
              {
                type = "weather";
                location = "Centralia, Illinois, United States";
                units = "imperial"; # alternatively "imperial"
                hour-format = "24h"; # alternatively "24h"

                # Optionally hide the location from being displayed in the widget
                # hide-location = true;
              }
              {
                type = "markets";
                markets = [
                  {
                    symbol = "SPY";
                    name = "S&P 500";
                  }
                  {
                    symbol = "BTC-USD";
                    name = "Bitcoin";
                  }
                  {
                    symbol = "NVDA";
                    name = "NVIDIA";
                  }
                  {
                    symbol = "AAPL";
                    name = "Apple";
                  }
                  {
                    symbol = "MSFT";
                    name = "Microsoft";
                  }
                ];
              }
            ];
          }
        ];
      }];
      server = { host = "100.84.95.66"; };
    };
  };
}
