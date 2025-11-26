{ pkgs, inputs, ... }: {
  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd
    ];

    enableDefaultPackages = false;

    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono" "Noto Color Emoji" ];
        serif = [ "JetBrainsMonot" "Noto Color Emoji" ];
        sansSerif = [ "JetBrainsMono" "Noto Color Emoji" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
