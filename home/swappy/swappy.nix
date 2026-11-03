{ pkgs, ... }: {
  home.packages = with pkgs; [
    grim
    slurp
  ];

  programs.swappy.enable = true;

  xdg.configFile."swappy/config" = {
    source = ./config;
  };
}
