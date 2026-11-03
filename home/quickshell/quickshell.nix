{ ... }: {
  programs.quickshell.enable = true;

  xdg.configFile."quickshell/qs-dots" = {
    source = ./qs-dots;
    recursive = true;
  };
}
