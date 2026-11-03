{ ... }: {
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    flags = [
      # "--disable-up-arrow"
    ];
    settings = {
      enter_accept = false;
      search_mode = "daemon-fuzzy";
      search_mode_shell_up_key_binding = "prefix";
      filter_mode_shell_up_key_binding = "directory";
      inline_height_shell_up_key_binding = 16;
      show_preview = true;
      style = "full";
      search = {
        shells = "all";
        filters = [
          "global"
          "directory"
          "session"
          "host"
        ];
      };
      daemon = {
        enabled = true;
        autostart = true;
      };
    };
  };
}
