{ pkgs, inputs, ... }: {
  stylix = {
    enable = true;

    # base16Scheme = "${pkgs.base16-schemes}/share/themes/pandora.yaml";

    base16Scheme = {
      base00 = "#131213";
      base01 = "#2f1823";
      base02 = "#472234";
      base03 = "#ffbee3";
      base04 = "#9b2a46";
      base05 = "#f15c99";
      base06 = "#81506a";
      base07 = "#632227";
      base08 = "#b00b69";
      base09 = "#ff9153";
      base0A = "#ffcc00";
      base0B = "#9ddf69";
      base0C = "#714ca6";
      base0D = "#008080";
      base0E = "#a24030";
      base0F = "#a24030";
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono Nerd Font";
      };
      sansSerif = {
        package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
        name = "SFProDisplay Nerd Font";
      };
      serif = {
        package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
        name = "SFProDisplay Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 14;
        desktop = 14;
        popups = 14;
        terminal = 14;
      };
    };

    polarity = "dark";
    image = ./wallpapers/Anime-Girl-Rain.png;
  };

}
