{ config, lib, adminPublicKey, machineName, ... }:
{
  terraform.required_providers.tls.source = "hashicorp/tls";
  terraform.required_providers.local.source = "hashicorp/local";
  terraform.required_providers.hcloud.source = "hetznercloud/hcloud";

  # Generate SSH deploy key for initial server access
  resource.tls_private_key.ssh_deploy_key = {
    algorithm = "ED25519";
  };

  # Write deploy key to filesystem for SSH access during provisioning
  resource.local_sensitive_file.ssh_deploy_key = {
    filename = "${lib.tf.ref "path.module"}/.terraform-deploy-key";
    file_permission = "600";
    content = config.resource.tls_private_key.ssh_deploy_key "private_key_openssh";
  };

  # Admin SSH key (your personal key)
  resource.hcloud_ssh_key."homelab" = {
    name = "homelab";
    public_key = adminPublicKey;
  };

  # Terraform-generated deploy key for clan installation
  resource.hcloud_ssh_key."clan-${machineName}" = {
    name = "clan-${machineName}";
    public_key = config.resource.tls_private_key.ssh_deploy_key "public_key_openssh";
  };
}
