{ ... }: {
  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty.conf;
    # Keep kitty.conf's own shell_integration; do not add shell rc integration.
    shellIntegration = {
      mode = null;
      enableBashIntegration = false;
      enableFishIntegration = false;
      enableZshIntegration = false;
    };
  };

  xdg.configFile."kitty/blackmetal-ash.conf" = {
    source = ./blackmetal-ash.conf;
  };
  xdg.configFile."kitty/hybrid.conf" = {
    source = ./hybrid.conf;
  };
  xdg.configFile."kitty/kanagawa_dragon.conf" = {
    source = ./kanagawa_dragon.conf;
  };
  xdg.configFile."kitty/mikado.conf" = {
    source = ./mikado.conf;
  };
  xdg.configFile."kitty/opencode.conf" = {
    source = ./opencode.conf;
  };
}
