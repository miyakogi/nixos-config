{ ... }: {
  programs.fuzzel.enable = true;

  xdg.configFile."fuzzel/fuzzel.ini" = {
    source = ./fuzzel.ini;
  };
}
