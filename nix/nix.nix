{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  autoGarbageCollector = config.var.autoGarbageCollector or true;
  domain = config.networking.domain or null;
in
{
  # Proprietary software
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  hardware.enableRedistributableFirmware = true;

  nix = {
    # Add all flake inputs to registry / CMD: nix registry list
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # Add all flake inputs to legacy / CMD: echo $NIX_PATH | tr ":" "\n"
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    channel.enable = false;

    settings = {
      substituters = [
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      auto-optimise-store = lib.mkDefault true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };

    gc = {
      automatic = autoGarbageCollector;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  environment.systemPackages = with pkgs; [
    git
    nix-index
    gnumake
    cmake
    home-manager
  ];
}

