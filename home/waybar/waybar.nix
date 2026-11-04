{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  programs.waybar = {
    enable = true;
    # Build from the flake input to stay ahead of the nixpkgs version
    # (needed for niri/workspaces -> ignore-workspaces option).
    package = inputs.waybar.packages.${system}.default;
  };

  xdg.configFile."waybar" = {
    source = ./waybar;
    recursive = true;
  };
}
