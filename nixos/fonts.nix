{ pkgs, inputs, ... }: {
  fonts = {
	packages = with pkgs; [
	  noto-fonts-emoji
	  nerd-fonts.fira-code
	  nerd-fonts.jetbrains-mono
	  inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd
	];
  };

  enableDefaultPackages = false;

  fontconfig = {
	defaultFonts = {
	  monospace = [ "JetBrainsMono" "Noto Color Emoji" ];
	  serif = [ "SFProDisplay Nerd Font" "Noto Color Emoji" ];
	  sansSerif = [ "SFProDisplay Nerd Font" "Noto Color Emoji" ];
	  emoji = [ "Noto Color Emoji" ];
	};
  };
}
