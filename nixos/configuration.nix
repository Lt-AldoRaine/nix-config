{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      # auto-optimise-store = true;
      # substituters = [ "https://nix-community.cachix.org" ];
      # trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs" ];
      trusted-users = ["@wheel"];
      warn-dirty = false;

      # Enable flakes and new 'nix' command
      experimental-features = [ "nix-command" "flakes" ];
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    # registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    # nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # FIXME: Add the rest of your current configuration

  networking.hostName = "adloraine";

  programs.zsh.enable = true;

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  services.xserver = {
    enable = true;
    displayManager.autoLogin.enable = false;
    layout = "us";
    xkbVariant = "";
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };

  systemd.services."getty#tty1".enable = false;
  systemd.services."autovt#tty1".enable = false;

  environment.systemPackages = [
    pkgs.base16-schemes
  ];

  users.mutableUsers = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.12";
}
