{
  inputs,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # Split up your configuration and import pieces of it here:
    ../modules/shell/zsh.nix
    ../modules/style/stylixUser.nix
    ../modules/alacritty.nix
  ];

  home = {
    username = "connor";
    homeDirectory = "/home/connor";
    packages = with pkgs; [
      gcc
      git
      firefox
      neovim
      ripgrep
      zsh
      zsh-powerlevel10k
    ];
    stateVersion = "24.11";
  };

  nixpkgs.config = {
    allowUnfree = false;
    allowUnfreePredicate = _: false;
  };

  #enable home-manager programs
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
