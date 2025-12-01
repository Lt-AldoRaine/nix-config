let
  username = "homelab";
in
{
  inherit username;
  configDirectory = "/home/${username}/nix-config";

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
}

