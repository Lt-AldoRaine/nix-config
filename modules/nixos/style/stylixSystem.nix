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
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono";
      };

      sansSerif = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono";
      };

      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono";
      };

      sizes = {
        applications = 14;
        desktop = 14;
	terminal = 16;
      };
    };

    opacity = {
      terminal = 0.9;
      applications = 0.9;
      popups = 0.6;
    };  

    targets = {
      console.enable = true;
    };
  };
}
