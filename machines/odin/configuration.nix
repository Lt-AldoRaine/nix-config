{
  self,
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [
    # System modules (minimal for clan/terraform)
    ../../modules/nixos/system/users/default.nix
    ../../modules/nixos/system/utils/default.nix
    ../../modules/nixos/system/timezone/default.nix
    ../../modules/nixos/system/home-manager/default.nix
    ../../modules/nixos/system/network-manager/default.nix
    ../../modules/nixos/system/sops/default.nix

    # Odin infrastructure
    ./disko.nix
    ./hardware-configuration.nix
    ./variables.nix
    ./deploy.nix

    # Secrets (for SSH keys and basic secrets)
    ../../configuration/hosts/homelab/secrets/default.nix
  ];

  # For user namespace remapping for docker/podman rootfull containers
  users = {
    users.root = {
      subUidRanges = [
        {
          startUid = 100000;
          count = 65536;
        }
      ];
      subGidRanges = [
        {
          startGid = 100000;
          count = 65536;
        }
      ];
    };
  };

  # Fix nixos build limits
  systemd.settings.Manager.DefaultLimitNOFILE = "8192:524288";

  # Odin is for clan/terraform only - no services needed

  # Set hostname
  networking.hostName = "odin";

  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  home-manager.users."${config.var.username}" = {
    imports = [ ./home.nix ];
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  system.stateVersion = "24.11";
}
