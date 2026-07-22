{ pkgs, lib, config, inputs, ... }:
let
  spicetify = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  # ac = "${config.lib.stylix.colors.base0D}";
  ac = "7aa2f7";
in {
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  # stylix.targets.spicetify.enable = false;

  programs.spicetify = lib.mkMerge [
    {
      enable = lib.mkDefault true;
      theme = lib.mkForce spicetify.themes.text;
    }
    {
      colorScheme = lib.mkForce "custom";
      customColorScheme = {
        button = ac;
        button-active = ac;
        tab-active = ac;
      };

      enabledExtensions = with spicetify.extensions; [
        playlistIcons
        lastfm
        hidePodcasts
        fullAppDisplay
        shuffle
        adblock
      ];
    }
  ];
}
