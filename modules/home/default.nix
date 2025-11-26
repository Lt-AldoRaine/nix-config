{ collectModules }:
{
  programs = collectModules ./programs;
  services = collectModules ./services;
  system = collectModules ./system;
}

