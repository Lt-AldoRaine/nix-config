{ pkgs, config, ... }:
let inherit (config.var) hostname keyboardLayout;
in {
  networking = {
    hostName = hostname;
    firewall = {
      enable = true;

      allowedTCPPorts = [ 22 8096 8082 ];
    };

		resolvconf.enable = true;
		resolvconf.useLocalResolver = true;
  };

  services = {
    xserver = {
      enable = true;
      xkb.layout = keyboardLayout;
      xkb.variant = "";

    };
    gnome.gnome-keyring.enable = true;

  };
  console.keyMap = keyboardLayout;

  environment.variables = {
    XDG_DATA_HOME = "$HOME/.local/share";
    PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
    EDITOR = "nvim";
  };

  services.libinput.enable = true;
  programs.dconf.enable = true;
  services = {
    dbus.enable = true;
    gvfs.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    udisks2.enable = true;

    openssh = {
      enable = true;
      settings = {
        # Opinionated: forbid root login through SSH.
        PermitRootLogin = "no";
        KbdInteractiveAuthentication = false;
        # Opinionated: use keys only.
        # Remove if you want to SSH using passwords
        PasswordAuthentication = false;
      };
      openFirewall = true;
    };
  };

  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  hardware.logitech.wireless.enable = true;

  environment.systemPackages = with pkgs; [
    curl
    bc
    fd
    gcc
    git-ignore
    logitech-udev-rules
    libnotify
    nerdfetch
    solaar
    wget
    xdg-utils
  ];
}
