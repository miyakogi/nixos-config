{ pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    systemd.enable = false;
    settings = {
      font-family = [
        "Lilex"
        "IBM Plex Sans JP"
      ];
      font-size = 15.0;
      font-feature = [
        "+cv08"
        "+cv15"
      ];

      font-variation = "wght=300";
      font-variation-bold = "wght=600";
      font-variation-italic = "wght=300";
      font-variation-bold-italic = "wght=600";
      # font-style = "Light";
      font-style-bold = "Medium";
      # font-style-italic = "Light";
      font-style-bold-italic = "Medium";

      theme = "opencode";
      background-opacity = 0.98;

      command = "fish";

      shell-integration = "fish";
      shell-integration-features = "cursor,sudo,no-title";

      window-inherit-working-directory = false;
      working-directory = "home";

      cursor-style = "block";
      cursor-style-blink = false;
      cursor-opacity = 0.9;

      window-decoration = false;
      window-padding-x = 12;
      window-padding-y = 12;

      notify-on-command-finish = "never";
      notify-on-command-finish-action = "no-bell,notify";
      notify-on-command-finish-after = "3s";

      quit-after-last-window-closed = false;

      keybind = "ctrl+backspace=text:\\x17";
    };
  };
  xdg.configFile."ghostty/themes" = {
    source = ./themes;
    recursive = true;
  };
}
