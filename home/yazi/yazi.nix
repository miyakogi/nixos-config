{ ... }: {
  xdg.configFile."yazi/plugins" = {
    source = ./plugins;
    recursive = true;
  };
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    shellWrapperName = "yy";
    settings = {
      mgr = {
        ratio = [
          0
          4
          4
        ];
        sort_by = "natural";
        sort_sensitive = true;
        sort_reverse = false;
        sort_dir_first = true;
      };
      preview = {
        max_width = 1920;
        max_height = 1080;
      };
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          run = "arrow -1";
          on = "<UP>";
        }
        {
          run = "arrow 1";
          on = "<DOWN>";
        }
        {
          run = "plugin smart-enter";
          on = "<Enter>";
        }
      ];
    };
  };
}
