{ lib, ... }: {
  imports = lib.flatten [
    [ ./zsh.nix ]
    [ ./starship.nix ]
  ];
}
