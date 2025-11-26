{ mkHost }:
{
  aldoraine = mkHost {
    system = "x86_64-linux";
    modules = [ ./aldoraine/configuration.nix ];
  };

  homelab = mkHost {
    system = "x86_64-linux";
    modules = [ ./homelab/configuration.nix ];
  };
}

