{ collectModules }:
{
  services = collectModules ./services;
  system = collectModules ./system;
}

