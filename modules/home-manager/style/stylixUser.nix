{ pkgs, config, lib, inputs, ... }:

let 
  themeName = "nord";
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
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    opacity = {
      terminal = 0.9;
      applications = 0.9;
      popups = 0.6;
    };  

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
        applications = 12;
        desktop = 12;
        terminal = 14;
      };
    };
  };
}
