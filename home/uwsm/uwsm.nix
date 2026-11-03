{ pkgs, ... }: {
  home.packages = with pkgs; [
    uwsm
    newt
    app2unit
    xdg-terminal-exec
  ];
  xdg.configFile."uwsm/env" = {
    source = ./env;
  };
  xdg.configFile."uwsm/env-hyprland" = {
    source = ./env-hyprland;
  };
  xdg.configFile."uwsm/env-niri" = {
    source = ./env-niri;
  };
}
