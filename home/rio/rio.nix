{ pkgs, ... }: {
  home.packages = with pkgs; [
    unifont
  ];

  programs.rio = {
    enable = true;
  };

  xdg.configFile."rio/config.toml" = {
    source = ./config.toml;
  };
  xdg.configFile."rio/themes" = {
    source = ./themes;
    recursive = true;
  };
  xdg.configFile."rio/themes/wm-theme.toml" = {
    source = ./themes/opencode.toml;
  };
  xdg.configFile."rio-hyprland/config.toml" = {
    source = ./config.toml;
  };
  xdg.configFile."rio-hyprland/themes/wm-theme.toml" = {
    source = ./themes/mikado.toml;
  };
  xdg.configFile."rio-niri/config.toml" = {
    source = ./config.toml;
  };
  xdg.configFile."rio-niri/themes/wm-theme.toml" = {
    source = ./themes/bitmute.toml;
  };
}
