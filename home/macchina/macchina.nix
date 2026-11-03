{ ... }: {
  programs.macchina.enable = true;
  xdg.configFile."macchina/macchina.toml" = {
    source = ./macchina.toml;
  };
  xdg.configFile."macchina/themes" = {
    source = ./themes;
    recursive = true;
  };
}
