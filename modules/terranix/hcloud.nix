{ lib }:
let
  base = import ./base.nix { inherit lib; };

  mkLabelAttrs = labels:
    if labels == null then { } else { inherit labels; };
in
{
  inherit (base)
    merge
    mkVariable
    mkOutput
    mkProvider
    mkResource
    mkData
    mkLocals
    mkTerraform
    mkRequiredProviders
    mkBackend
    mkConfig;

  mkTokenVariable = {
    description ? "Hetzner Cloud API token",
    sensitive ? true,
  }: mkVariable "hcloud_token" {
    inherit description sensitive;
    type = "string";
  };

  mkProviderConfig = { tokenVar ? "\${var.hcloud_token}" }:
    mkProvider "hcloud" {
      token = tokenVar;
    };

  mkSshKeyData = { name }: mkData "hcloud_ssh_key" name { inherit name; };

  mkServer = {
    name,
    serverType,
    image,
    location,
    sshKeyName,
    ipv4 ? true,
    ipv6 ? true,
    backups ? false,
    labels ? { },
    publicNet ? { },
  }:
    mkResource "hcloud_server" name ({
      inherit name image location backups;
      server_type = serverType;
      public_net = {
        ipv4_enabled = ipv4;
        ipv6_enabled = ipv6;
      } // publicNet;
      ssh_keys = [ "\${data.hcloud_ssh_key.${sshKeyName}.id}" ];
    } // mkLabelAttrs labels);

  mkServerOutputs = name:
    mkConfig [
      (mkOutput "${name}_ipv4" {
        value = "\${hcloud_server.${name}.ipv4_address}";
      })
      (mkOutput "${name}_ipv6" {
        value = "\${hcloud_server.${name}.ipv6_address}";
      })
    ];
}

