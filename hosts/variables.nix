{ config, ... }: {
  imports = [ ../nixos/variables-config.nix ];
  config.var = {
    hostname = "aldoraine";
    username = "connor";

    configDirectory = "/home/" + config.var.username + "/nix-config";

    keyboardLayout = "us";

    location = "Chicago";
    timeZone = "Chicago";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "en_US.UTF-8";

    git = {
      username = "Lt-AldoRaine";
      email = "harambefallon@gmail.com";
    };

    autoGarbageCollector = true;

    theme = import ../themes/var/dark.nix;
  };
}
