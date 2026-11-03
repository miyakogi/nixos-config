{ ... }: {
  programs.fastfetch = {
    enable = true;
    # package = null;  # use system's package to support librpm package manager.
  };
  xdg.configFile."fastfetch/config.jsonc".source = ./config.jsonc;
  xdg.configFile."fastfetch/config-short.jsonc".source = ./config-short.jsonc;
}
