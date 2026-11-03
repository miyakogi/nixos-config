{ pkgs, ... }: {
  home.packages = with pkgs; [
    # font
    googlesans-code
    lilex
    ibm-plex
    noto-fonts
    noto-fonts-cjk-sans
    nerd-fonts.symbols-only
  ];

  fonts.fontconfig.enable = true;
  gtk = {
    gtk3.font = {
      name = "monospace";
      packages = with pkgs; [ lilex ];
    };
    gtk4.font = {
      name = "monospace";
      packages = with pkgs; [ lilex ];
    };
  };
  xdg.configFile."fontconfig/conf.d" = {
    source = ./conf.d;
    recursive = true;
  };
}
