{ ... }: {
  programs.alacritty.enable = true;

  xdg.configFile."alacritty/alacritty.toml" = {
    source = ./alacritty.toml;
  };
  xdg.configFile."alacritty/carbonfox-vivid-oled.toml" = {
    source = ./carbonfox-vivid-oled.toml;
  };
  xdg.configFile."alacritty/mikado.toml" = {
    source = ./mikado.toml;
  };
}
