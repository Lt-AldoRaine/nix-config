{ config, ... }: {
  imports = [ ../../nixos/variables-config.nix ];
  config.var = {
    hostname = "homelab";
    username = "connor";

    configDirectory = "/home/" + config.var.username + "/nix-config";

    keyboardLayout = "us";

    location = "America/Chicago";
    timeZone = "America/Chicago";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "en_US.UTF-8";

    git = {
      username = "Lt-AldoRaine";
      email = "harambefallon@gmail.com";
    };

    autoGarbageCollector = true;

    theme = import ../../themes/var/dracula.nix;
  };
}
