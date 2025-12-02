{ mkHost }:
{
  aldoraine = mkHost {
    system = "x86_64-linux";
    modules = [ ../configuration/hosts/aldoraine/configuration.nix ];
  };

  homelab = mkHost {
    system = "x86_64-linux";
    modules = [ ../configuration/hosts/homelab/configuration.nix ];
  };
}

