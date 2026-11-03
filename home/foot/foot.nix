{ ... }: {
  programs.foot.enable = true;

  xdg.configFile."foot/foot.ini" = {
    source = ./foot.ini;
  };
  xdg.configFile."foot/mikado.ini" = {
    source = ./mikado.ini;
  };
  xdg.configFile."foot/kanagawa-dragon.ini" = {
    source = ./kanagawa-dragon.ini;
  };
  xdg.configFile."foot/opencode.ini" = {
    source = ./opencode.ini;
  };
}
