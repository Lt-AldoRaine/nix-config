{ config, ... }: {
  imports = [ ../../nixos/system/variables-config/default.nix ];
  config.var = {
    hostname = "nix-vps";
    username = "root";

    configDirectory = "/home/" + config.var.username + "/nix-config";

    keyboardLayout = "us";

    location = "America/Chicago";
    timeZone = "America/Chicago";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "en_US.UTF-8";

    git = {
			settings = {
				username = "Lt-AldoRaine";
				email = "harambefallon@gmail.com";
			};
    };

    autoGarbageCollector = true;
  };
}
