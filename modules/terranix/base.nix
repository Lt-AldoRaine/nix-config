{
  config,
  pkgs,
  lib,
  ...
}:
let
  secretsFile = ../../sops/secrets.yaml;
in
{
  terraform.required_providers.external.source = "hashicorp/external";
  terraform.required_providers.hcloud.source = "hetznercloud/hcloud";

  # Fetch hcloud token using sops decryption
  data.external.hcloud-token = {
    program = [
      (lib.getExe (
        pkgs.writeShellApplication {
          name = "get-hcloud-token";
          runtimeInputs = [ pkgs.sops pkgs.jq ];
          text = ''
            secret="$(sops --decrypt --extract '["hcloud-token"]' ${secretsFile})"
            jq -n --arg secret "$secret" '{"secret":$secret}'
          '';
        }
      ))
    ];
  };

  provider.hcloud.token = config.data.external.hcloud-token "result.secret";
}
