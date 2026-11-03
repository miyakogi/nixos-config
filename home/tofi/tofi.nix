{ ... }: {
  programs.tofi.enable = true;

  xdg.configFile."tofi/config" = {
    source = ./config;
  };
}
