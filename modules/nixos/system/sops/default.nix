{ inputs, lib, config, ... }:
let
  defaultHostSopsFile = ./../../../../..
    + "/configuration/hosts/${config.networking.hostName}/secrets.yml";
  globalSopsFile = ./../../../../sops/secrets.yaml;
in
{
  imports = [ ];

  sops = {
    defaultSopsFile =
      if builtins.pathExists defaultHostSopsFile then
        defaultHostSopsFile
      else
        globalSopsFile;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    gnupg.sshKeyPaths = [ ];
  };
}
