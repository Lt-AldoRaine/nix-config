{ lib }:
{
  base = import ./base.nix { inherit lib; };
  hcloud = import ./hcloud.nix { inherit lib; };
}

