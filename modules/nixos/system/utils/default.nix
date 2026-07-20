{ pkgs, config, ... }:
let inherit (config.var) hostname keyboardLayout;
in {
  networking = {
    hostName = hostname;
    firewall = {
      enable = true;

      allowedTCPPorts = [ 22 53 2049 16262 ];

    };
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

	services.mullvad-vpn.enable = true;
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
        PermitRootLogin = "no";
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
      openFirewall = true;
    };
  };

	 # fileSystems."/mnt/Media" = {
	 #   device = "192.168.2.200:/var/nfs/shared/Jellyfin";
	 # 	fsType = "nfs";
	 # };
		#
	 # boot.supportedFilesystems = [ "nfs" ];

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
		age
  ];
}
