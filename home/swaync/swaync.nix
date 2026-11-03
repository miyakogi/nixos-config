{ pkgs, ... }: {
  home.packages = with pkgs; [
    swaynotificationcenter
  ];

  xdg.configFile."swaync" = {
    source = ./swaync;
    recursive = true;
  };
}
