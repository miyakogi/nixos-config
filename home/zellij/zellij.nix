{ ... }: {
  programs.zellij = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableZshIntegration = false;
  };

  xdg.configFile."zellij/config.kdl" = {
    source = ./config.kdl;
  };
}
