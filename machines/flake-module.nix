{ self, inputs, lib, ... }:
let
  machineName = "odin";
  machineTags = [ "vps" "nixos" ];
  domain = "connor.lan";
  adminPublicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBuobqAqi0hDAk4k5q0GY0EEmFYlcxvGRPZS05Yf9tRu connor@ConnorPC";
in
{
  imports = [
    inputs.terranix.flakeModule
  ];

  flake.clan = {
    inherit self;
    specialArgs = { inherit self; };

    meta = {
      name = "nix-config";
      description = "Personal NixOS infrastructure managed with Clan";
      inherit domain;
    };

    inventory = {
      machines.${machineName} = {
        tags = machineTags;
      };

      instances = {
        admin = {
          roles.default.tags."all" = { };
          roles.default.settings.allowedKeys.connor = adminPublicKey;
        };

        "emergency-access" = {
          roles.default.tags."all" = { };
        };

        "user-connor" = {
          module.name = "users";
          roles.default.tags."all" = { };
          roles.default.machines.${machineName} = { };
          roles.default.settings = {
            user = "connor";
            prompt = true;
          };
        };
      };
    };

    machines.${machineName} = {
      imports = self.lib.baseModules ++ [ ./odin/configuration.nix ];
    };
  };

  perSystem =
    {
      inputs',
      pkgs,
      system,
      ...
    }:
    let
      clanPkg = inputs'.clan-core.packages.default;
      terraformPackage = pkgs.opentofu.withPlugins (p: [
        p.external
        p.hcloud
        p.local
        p.null
        p.tls
      ]);

      moduleArgs = {
        inherit adminPublicKey machineName;
        hcloudSecretName = "hcloud-token";
      };

      terraformModules = [
        ({ _module.args = moduleArgs; })
        self.modules.terranix.base
        self.modules.terranix.hcloud
        ./odin/terraform-configuration.nix
      ];
    in
    {
      packages.clan = clanPkg;

      apps.clan = {
        type = "app";
        program = "${clanPkg}/bin/clan";
      };

      terranix.terranixConfigurations.${machineName} = {
        workdir = "terraform/${machineName}";
        modules = terraformModules;
        terraformWrapper.package = terraformPackage;
        terraformWrapper.extraRuntimeInputs = [ clanPkg ];
      };
    };
}
