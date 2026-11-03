{ ... }: {
  programs.bat = {
    enable = true;
    config = {
      theme = "ansi";
      italic-text = "always";
      map-syntax = [
        "*.conf:INI"
      ];
    };
  };
}
