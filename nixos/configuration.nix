{ config, pkgs, ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.extraConfig = ''
	options nvidia-drm.modeset=1 
  '';

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

  nixpkgs = { config = { allowUnfree = true; }; };

  nix = {
    settings = {
      auto-optimise-store = true;
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs"
      ];
      trusted-users = [ "@wheel" ];
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
  };

  # FIXME: Add the rest of your current configuration

  networking.hostName = "adloraine";

  programs.zsh.enable = true;
  programs.noisetorch.enable = true;

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  hardware.graphics = { enable = true; };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    xkb.layout = "us";
    xkb.variant = "";
  };

  hardware.nvidia = {
    modesetting.enable = true;

    open = true;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ]; 

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  services.displayManager = {
	autoLogin.enable = false;
	sddm.enable = true;
	sddm.wayland.enable = true;
  };

  services.pulseaudio.enable = false;
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

  users.mutableUsers = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.12";
}
