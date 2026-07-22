{ pkgs, ... }: {
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    wlr.enable = true;
    # No installed portal backend (hyprland, gtk) implements OpenURI - only
    # xdg-desktop-portal-gnome does, which is too heavy for this setup. Forcing
    # xdg-open through the portal here just breaks it with "No such interface
    # org.freedesktop.portal.OpenURI". Let xdg-open resolve mimeapps.list directly.
    xdgOpenUsePortal = false;
    extraPortals = with pkgs; 
			[ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
  };
}
