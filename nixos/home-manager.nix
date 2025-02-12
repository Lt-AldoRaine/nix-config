{ inputs, username, ... }: {

  home-manager = {
    home-manager.extraSpecialArgs = { inherit inputs; };
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    # home-manager.users."${username}" = home-manager;
  };
}
