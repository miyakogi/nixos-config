{ pkgs, ... }: {
  home.packages = [
    pkgs.gcr_3 # better for pinentry-gnome3
  ];

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentry = {
      package = pkgs.pinentry-gnome3;
      program = "pinentry-gnome3";
    };
  };
}
