{ waybarPackage, ... }: {
  programs.waybar = {
    enable = true;
    # Build from the flake input to stay ahead of the nixpkgs version
    # (needed for niri/workspaces -> ignore-workspaces option).
    package = waybarPackage;
  };

  xdg.configFile."waybar" = {
    source = ./waybar;
    recursive = true;
  };
}
