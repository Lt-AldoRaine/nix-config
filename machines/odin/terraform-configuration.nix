{ lib }:
let
  terranix = import ../../modules/terranix { inherit lib; };
  inherit (terranix.base) mkConfig mkRequiredProviders mkOutput merge;
  inherit (terranix.hcloud)
    mkTokenVariable
    mkProviderConfig
    mkSshKeyData
    mkServer
    mkServerOutputs;
in
merge [
  (mkRequiredProviders {
    hcloud = {
      source = "hetznercloud/hcloud";
      version = "1.56.0";
    };
  })
  (mkTokenVariable { })
  (mkProviderConfig { })
  (mkSshKeyData { name = "homelab"; })
  (mkServer {
    name = "odin";
    serverType = "cpx11";
    image = "nixos-25.05";
    location = "ash";
    sshKeyName = "homelab";
    labels = {
      hostname = "odin";
      role = "vps";
    };
  })
  (mkConfig [
    (mkOutput "server_ip" {
      value = "\${hcloud_server.odin.ipv4_address}";
    })
    (mkOutput "server_ipv6" {
      value = "\${hcloud_server.odin.ipv6_address}";
    })
  ])
  (mkServerOutputs "odin")
]

