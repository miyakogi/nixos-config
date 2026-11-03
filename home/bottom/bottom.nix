{ ... }: {
  programs.bottom.enable = true;

  xdg.configFile."bottom/bottom.toml" = {
    source = ./bottom.toml;
  };
}
