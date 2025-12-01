{ config, lib, ... }:
let
  deployKey = config.resource.hcloud_ssh_key.odin_deploy;
in
{
  terraform.required_providers.hcloud.source = "hetznercloud/hcloud";
  terraform.required_providers.null.source = "hashicorp/null";

  resource.hcloud_server.odin = {
    name = "odin";
    server_type = "cpx11";
    image = "debian-11";
    location = "ash";
    public_net = {
      ipv4_enabled = true;
      ipv6_enabled = true;
    };
    backups = false;
    ssh_keys = [
      config.resource.hcloud_ssh_key.odin.name
      deployKey.name
    ];
    labels = {
      hostname = "odin";
      role = "vps";
    };
  };

  resource.null_resource.install-odin = {
    triggers = {
      instance_id = "\${hcloud_server.odin.id}";
    };

    provisioner.local-exec = {
      command =
        "clan machines install odin --update-hardware-config nixos-facter --target-host root@\${hcloud_server.odin.ipv4_address} --yes";
    };
  };

  output.server_ip = {
    value = "\${hcloud_server.odin.ipv4_address}";
  };

  output.server_ipv6 = {
    value = "\${hcloud_server.odin.ipv6_address}";
  };
}
