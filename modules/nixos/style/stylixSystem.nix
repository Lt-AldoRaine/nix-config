{ pkgs, config, lib, ... }:

let 
  themeName = "tokyo-night";
  themePath = ../../../themes/${themeName};
  themePolarity = lib.removeSuffix "\n" (builtins.readFile ("${themePath}/polarity.txt"));
  backgroundUrl = builtins.readFile "${themePath}/backgroundurl.txt";
  backgroundSha256 = builtins.readFile "${themePath}/backgroundsha.txt";
in
{
  stylix = {
    image = pkgs.fetchurl {
      url = backgroundUrl;
      sha256 = backgroundSha256;
    };

    polarity = themePolarity;

    base16Scheme = "${themePath}/${themeName}.yaml";

    fonts = {
      serif = {
        name = "JetBrainsMono NF";
        package = pkgs.nerdfonts;
      };

      sansSerif = {
        name = "JetBrainsMono NF";
        package = pkgs.nerdfonts;
      };
 
      monospace = {
        name = "JetBrainsMono NF";
        package = pkgs.nerdfonts;
      };

      sizes = {
        applications = 12;
        desktop = 12;
	terminal = 14;
      };
    };

    opacity = {
      terminal = 0.9;
      applications = 0.9;
      popups = 0.6;
    };  

    targets = {
      lightdm.enable = true;
      console.enable = true;
    };
  };
}
