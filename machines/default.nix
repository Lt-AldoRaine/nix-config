{ mkHost }:
{
  odin = mkHost {
    system = "x86_64-linux";
    modules = [ ./odin/configuration.nix ];
  };
}

