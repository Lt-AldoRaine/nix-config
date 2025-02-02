{ pkgs, inputs, ... }: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;

    luaLoader.enable = true;
  };
}
