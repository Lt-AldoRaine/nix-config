{ inputs, username, password, desktop ? "gnome", }:
system:
let
  configuration = import ../nixos/configuration.nix;
  hardware-configuration = import ../nixos/hardware-configuration.nix;
  home-manager = import ../home-manager/home.nix;
  stylixSystem = import ../modules/nixos/style/stylixSystem.nix;

  pkgs = inputs.nixpkgs.legacyPackages.${system};
  stylix = inputs.stylix.nixosModules.stylix;

  enabledDesktopGnome = desktop == "gnome";

in inputs.nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
    hardware-configuration
    configuration

    stylix
    stylixSystem
    {
      environment.systemPackages = with pkgs; [
        git
        gcc
        neofetch
        ripgrep
        wget
		wayland
		nerd-fonts.jetbrains-mono
      ];

      services.displayManager.autoLogin.user = username;

      services.xserver.desktopManager.gnome.enable = enabledDesktopGnome;

      users.users."${username}" = {
        home = "/home/${username}";
        isNormalUser = true;
        password = password;
        shell = pkgs.zsh;
        extraGroups = [ "wheel" ];
      };
    }

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.extraSpecialArgs = { inherit inputs; };
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${username}" = home-manager;
    }

    { stylix.enable = true; }
  ];
}
