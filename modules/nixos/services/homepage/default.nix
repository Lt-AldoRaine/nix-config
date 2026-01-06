{ pkgs, ... }: {
  services.homepage-dashboard = {
    enable = true;
    package = pkgs.homepage-dashboard;

		openFirewall = true;

    settings = {
      title = "dashboard";
      headerStyle = "clean";
      layout = {
        media = {
          style = "row";
          columns = 3;
        };
        infra = {
          style = "row";
          columns = 4;
        };
        machines = {
          style = "row";
          columns = 4;
        };
      };
      widgets = [
        {
          search = {
            provider = "google";
            target = "_blank";
          };
        }
        {
          resources = {
            label = "system";
            cpu = true;
            memory = true;
          };
        }
        {
          openmeteo = {
            label = "Cent";
            timezone = "America/Chicago";
            units = "imperial";
          };
        }
      ];
    };

		allowedHosts = "dash.aldoraine.com, localhost:8082";

    services = [{
      media = [{
        Jellyfin = {
          href = "jelly.aldoraine.com";
          description = "Media Management";
          widget = {
            type = "jellyfin";
            url = "jelly.aldoraine.com";
          };
        };
      }];
    }];

    widgets = [ ];

    docker = [{
      minecraft = {
        host = "100.84.95.66";
        port = "25565";
      };
    }];
  };
}
