{ pkgs, ... }: {
  home.packages = with pkgs; [
    niri
    xwayland-satellite
    swaybg # for overview backdrop
    swayidle
  ];

  xdg.dataFile."wayland-sessions/niri-uwsm.desktop".text = ''
    [Desktop Entry]
    Name=Niri (UWSM)
    Comment=Niri Wayland Compositor Session for UWSM Management
    Exec=systemctl --user --wait start niri.service
    Type=Application
  '';

  xdg.configFile."niri/config.kdl" = {
    source = ./config.kdl;
  };
  xdg.configFile."niri/hyprpaper.conf" = {
    source = ./hyprpaper.conf;
  };
}
