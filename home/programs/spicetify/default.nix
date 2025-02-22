{ pkgs, lib, config, inputs, ... }:
let
  spicetify = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  ac = "${config.lib.stylix.colors.base0D}";
in {
  programs.spicetify = {
    enable = true;
    theme = lib.mkForce spicetify.themes.text;

    stylix.targets.spicetify.enable = false;

    colorscheme = "custom";

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
  };
}
