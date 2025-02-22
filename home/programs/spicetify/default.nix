{ pkgs, lib, config, inputs, ... }:
let
  spicetify = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  ac = "${config.lib.stylix.colors.base0D}";
in {
  impots = [ inputs.spicetify-nix.homeManagerModules.default ];

  stylix.targets.spicetify.enable = false;

  programs.spicetify = {
    enable = true;
    theme = lib.mkForce spicetify.themes.text;

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
