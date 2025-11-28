{ inputs, lib, ... }:
let
  terraformConfigs = {
    odin = import ./odin/terraform-configuration.nix { inherit lib; };
  };
in
{
  perSystem = { pkgs, system, ... }:
    let
      agenixPackage = inputs.agenix.packages.${system}.default;
      terraformConfig = terraformConfigs.odin;
      terraformJson = pkgs.writeText "terraform-odin.tf.json"
        (lib.generators.toPretty { } terraformConfig);

      repoPath = lib.escapeShellArg (toString ../.);

      terraformRunner = pkgs.writeShellApplication {
        name = "terraform-odin";
        runtimeInputs = [
          pkgs.coreutils
          pkgs.terraform
          agenixPackage
        ];
        text = ''
          set -euo pipefail

          if ! command -v agenix >/dev/null 2>&1; then
            echo "agenix binary not found in PATH" >&2
            exit 1
          fi

          REPO=''${TF_REPO_ROOT:-${repoPath}}
          WORKDIR=''${TF_WORKDIR:-$REPO/terraform/odin}
          mkdir -p "$WORKDIR"
          cd "$WORKDIR"

          SECRET_ROOT="$REPO/hosts/homelab/secrets/terraform/odin"
          if [ ! -d "$SECRET_ROOT" ]; then
            echo "Missing Terraform secrets at $SECRET_ROOT" >&2
            exit 1
          fi

          if [ -n "''${AGENIX_IDENTITY:-}" ]; then
            IDENTITY="''${AGENIX_IDENTITY}"
          elif [ -f "$HOME/.ssh/homelab" ]; then
            IDENTITY="$HOME/.ssh/homelab"
          elif [ -f "$HOME/.ssh/id_ed25519" ]; then
            IDENTITY="$HOME/.ssh/id_ed25519"
          else
            echo "No SSH key found for agenix decryption" >&2
            exit 1
          fi

          decrypt() {
            agenix -i "$IDENTITY" -d "$SECRET_ROOT/$1"
          }

          HCLOUD_TOKEN=$(decrypt hcloud-token.age | tr -d '[:space:]')

          printf 'hcloud_token = "%s"\n' "$HCLOUD_TOKEN" > terraform.tfvars
          chmod 600 terraform.tfvars

          cp ${terraformJson} terraform.tf.json

          export TF_VAR_hcloud_token="$HCLOUD_TOKEN"
          export TF_PLUGIN_CACHE_DIR="$WORKDIR/.terraform.d/plugin-cache"
          mkdir -p "$TF_PLUGIN_CACHE_DIR"

          terraform "$@"
        '';
      };

      mkTerraformApp = name: args:
        let
          wrapper = pkgs.writeShellApplication {
            inherit name;
            runtimeInputs = [ terraformRunner ];
            text = ''
              exec ${terraformRunner}/bin/terraform-odin ${args} "$@"
            '';
          };
        in
        {
          type = "app";
          program = "${wrapper}/bin/${name}";
        };
    in
    {
      formatter = pkgs.nixfmt-rfc-style;

      packages = {
        terraform-odin-config = terraformJson;
        terraform-odin = terraformRunner;
      };

      apps = {
        terraform-odin = {
          type = "app";
          program = "${terraformRunner}/bin/terraform-odin";
        };
        terraform-odin-init = mkTerraformApp "terraform-odin-init" "init";
        terraform-odin-plan = mkTerraformApp "terraform-odin-plan" "plan";
        terraform-odin-apply = mkTerraformApp "terraform-odin-apply" "apply";
        terraform-odin-destroy =
          mkTerraformApp "terraform-odin-destroy" "destroy";
        terraform-odin-output =
          mkTerraformApp "terraform-odin-output" "output";
      };
    };

  flake = {
    terranix = import ../modules/terranix { inherit lib; };
    terraformConfigurations = terraformConfigs;
  };
}

