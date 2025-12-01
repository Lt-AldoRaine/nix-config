{
  config,
  lib,
  ...
}:
let
  tf_odin = config.resource.hcloud_server.odin;
in
{
  terraform.required_providers.hcloud.source = "hetznercloud/hcloud";
  terraform.required_providers.null.source = "hashicorp/null";

  #############################################################################
  # Hetzner Cloud instance
  #############################################################################
  # https://www.hetzner.com/cloud/
  # https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server
  # https://docs.hetzner.com/cloud/general/locations/#what-locations-are-there
  resource.hcloud_server.odin = {
    name = "odin";
    server_type = "cpx11";
    image = "debian-11";
    location = "ash"; # Ashburn, Virginia
    public_net = {
      ipv4_enabled = true;
      ipv6_enabled = true;
    };
    backups = false;
    # Include both admin key and terraform-generated deploy key
    ssh_keys = [
      config.resource.hcloud_ssh_key.homelab.name
      config.resource.hcloud_ssh_key."clan-odin".name
    ];
    labels = {
      hostname = "odin";
      role = "vps";
    };
  };

  # Install NixOS on the server using clan
  # Uses the terraform-generated deploy key for SSH access
  resource.null_resource.install-odin = {
    # Ensure deploy key is written before running install
    depends_on = [
      "local_sensitive_file.ssh_deploy_key"
    ];

    triggers = {
      instance_id = "\${hcloud_server.odin.id}";
    };

    provisioner.local-exec = {
      command = ''
        SERVER_IP="''${hcloud_server.odin.ipv4_address}"
        DEPLOY_KEY="${lib.tf.ref "path.module"}/.terraform-deploy-key"
        
        echo "Waiting for SSH to become available on $SERVER_IP..."
        for i in $(seq 1 60); do
          if ssh -i "$DEPLOY_KEY" -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o BatchMode=yes "root@$SERVER_IP" true 2>/dev/null; then
            echo "SSH is ready!"
            break
          fi
          echo "Attempt $i/60: SSH not ready yet, waiting 5 seconds..."
          sleep 5
        done
        
        echo "Starting NixOS installation..."
        clan machines install odin \
          --update-hardware-config nixos-facter \
          --target-host "root@$SERVER_IP" \
          -i "$DEPLOY_KEY" \
          --yes
      '';
    };
  };

  #############################################################################
  # Outputs
  #############################################################################
  output.server_ip = {
    value = tf_odin "ipv4_address";
  };

  output.server_ipv6 = {
    value = tf_odin "ipv6_address";
  };
}
