{ pkgs, ... }:
{
  home.packages = [
    pkgs.opencode-desktop
  ];
  programs.opencode = {
    enable = true;
    mutableSettings = true;
    settings = {
      default_agent = "plan";
      plugins = [
        "superpowers@git+https://github.com/obra/superpowers.git"
      ];
    };
    cli = {
      theme.name = "system";
      mouse = true;
      animations = true;
      attention = {
        enabled = true;
        notifications = true;
      };
    };
    context = ../agents/AGENTS.md;
  };
}
