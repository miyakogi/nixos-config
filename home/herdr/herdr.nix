{ ... }: {
  programs.herdr = {
    enable = true;
    settings = {
      onboarding = false;
      theme = {
        name = "terminal";
        auto_switch = false;
      };
      ui = {
        toast = {
          delivery = "terminal";
        };
        show_agent_labels_on_pane_borders = true;
      };
      keys = {
        focus_pane_left = [
          "prefix+h"
          "alt+h"
        ];
        focus_pane_down = [
          "prefix+j"
          "alt+j"
        ];
        focus_pane_up = [
          "prefix+k"
          "alt+k"
        ];
        focus_pane_right = [
          "prefix+l"
          "alt+l"
        ];
      };
    };
  };
}
