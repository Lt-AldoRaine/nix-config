{ pkgs, lib, config, inputs, ... }:
let
  spicetify = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  ac = "${config.lib.stylix.colors.base0D}";
in {
  imports = [ inputs.spicetify-nix.homeModules.default ];

  stylix.targets.spicetify.enable = false;

  programs.spicetify = lib.mkMerge [
    {
      enable = lib.mkDefault true;
    theme = lib.mkForce spicetify.themes.text;
    }
    {
    colorScheme = "custom";
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
