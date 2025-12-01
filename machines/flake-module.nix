{ self, inputs, lib, ... }:
let
  machineName = "odin";
  machineTags = [ "vps" "nixos" ];
  domain = "homelab.lan";
  adminPublicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAUbHbQvRblFbKll9PxVzwiwW3PZsPYULJdiIsqHItgU connor@homelab";
in
{
  imports = [
    inputs.terranix.flakeModule
  ];

  flake.clan = {
    # Make flake available in modules
    specialArgs = { inherit self; };
    inherit self;

    meta = {
      name = "nix-config";
      description = "Personal NixOS infrastructure managed with Clan";
      inherit domain;
    };

    inventory = {
      # Only VPS machines are managed via clan
      # Local machines (homelab, aldoraine) use regular nixosConfigurations
      machines.${machineName} = {
        tags = machineTags;
      };

      instances = {
        # Admin service for managing machines
        # This service adds SSH access with the specified keys
        admin = {
          roles.default.tags."vps" = { };
          roles.default.settings.allowedKeys.homelab = adminPublicKey;
        };

        "emergency-access" = {
          roles.default.tags."vps" = { };
        };

        "user-homelab" = {
          module.name = "users";
          roles.default.machines.${machineName} = { };
          roles.default.settings = {
            user = "homelab";
            prompt = true;
          };
        };
      };
    };

    machines.${machineName} = {
      imports = self.lib.baseModules ++ self.lib.clanModules ++ [ ./odin/configuration.nix ];
    };
  };

  perSystem =
    {
      config,
      inputs',
      pkgs,
      ...
    }:
    let
      clanPkg = inputs'.clan-core.packages.default;

      # Terraform/OpenTofu package with required providers
      terraformPackage = pkgs.opentofu.withPlugins (p: [
        p.external
        p.hcloud
        p.local
        p.null
        p.tls
      ]);

      # Module args passed to terranix modules
      moduleArgs = {
        inherit adminPublicKey machineName;
      };
      terranixConfig = config.terranix.terranixConfigurations.terraform;
      workdir = terranixConfig.workdir;
      configPath = terranixConfig.result.terraformConfiguration;

      # Custom wrapper that sets up the config symlink before running tofu
      terraformCli = pkgs.writeShellApplication {
        name = "terraform";
        runtimeInputs = [ terraformPackage clanPkg pkgs.sops ];
        text = ''
          mkdir -p "${workdir}"
          ln -sf ${configPath} "${workdir}/config.tf.json"
          cd "${workdir}"
          tofu "$@"
        '';
      };
    in
    {
      packages.clan = clanPkg;

      apps.clan = {
        type = "app";
        program = "${clanPkg}/bin/clan";
      };

      # Terraform app with config symlink setup
      apps.terraform = {
        type = "app";
        program = lib.getExe terraformCli;
      };

      terranix.terranixConfigurations.terraform = {
        workdir = "terraform/${machineName}";
        modules = [
          ({ _module.args = moduleArgs; })
          self.modules.terranix.base
          self.modules.terranix.hcloud
          ./odin/terraform-configuration.nix
        ];
        terraformWrapper.package = terraformPackage;
        terraformWrapper.extraRuntimeInputs = [ clanPkg pkgs.sops ];
      };
    };
}
