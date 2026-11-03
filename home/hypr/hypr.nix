{ pkgs, ... }: {
  home.packages = with pkgs; [
    hyprpaper
    hypridle
    hyprlock
    hyprpicker
    hyprshutdown
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    package = null;
    configType = "lua";
  };

  services.hyprpolkitagent.enable = true;

  xdg.configFile."hypr/hyprland.lua" = {
    source = ./hyprland.lua;
  };
  xdg.configFile."hypr/kanagawa-dragon.lua" = {
    source = ./kanagawa-dragon.lua;
  };

  xdg.configFile."hypr/hyprpaper.conf" = {
    source = ./hyprpaper.conf;
  };
  xdg.configFile."hypr/hypridle.conf" = {
    source = ./hypridle.conf;
  };
  xdg.configFile."hypr/hyprlock.conf" = {
    source = ./hyprlock.conf;
  };
}
