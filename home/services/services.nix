{
  pkgs,
  waybarPackage,
  ...
}:
{
  systemd.user.services.taskwarrior-notify = {
    Unit.Description = "Taskwarrior Due Task Notifier";
    Service = {
      Type = "oneshot";
      ExecStart = "%h/bin/tw-notify";
      Environment = [ "DBUS_SESSION_BUS_ADDRESS=unix:path=%t/bus" ];
    };
    # Deliberately not WantedBy graphical-session.target: a oneshot that waits
    # on notify-send would otherwise gate (Before=) graphical-session.target.
  };

  systemd.user.timers.taskwarrior-notify = {
    Unit.Description = "Taskwarrior Due Task Notifier";
    Timer = {
      OnCalendar = "*:0/10";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  systemd.user.services.taskwarrior-notify-daily = {
    Unit.Description = "Taskwarrior Daily Task Notifier";
    Service = {
      Type = "oneshot";
      ExecStart = "%h/bin/tw-notify-daily";
      Environment = [ "DBUS_SESSION_BUS_ADDRESS=unix:path=%t/bus" ];
    };
    # Deliberately not WantedBy graphical-session.target: a oneshot that waits
    # on notify-send would otherwise gate (Before=) graphical-session.target.
  };

  systemd.user.timers.taskwarrior-notify-daily = {
    Unit.Description = "Taskwarrior Daily Task Notifier";
    Timer = {
      OnCalendar = [
        "*-*-* 07:00:00"
        "*-*-* 19:00:00"
      ];
      OnBootSec = "2min";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  # Installed but intentionally not enabled (no `Install`), so it never
  # auto-starts; start it manually when needed.
  systemd.user.services.ollama = {
    Unit = {
      Description = "Ollama Service";
      Wants = [ "network-online.target" ];
      After = [
        "network.target"
        "network-online.target"
      ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.ollama-vulkan}/bin/ollama serve";
      Environment = [
        "OLLAMA_VULKAN=1"
        "OLLAMA_KEEP_ALIVE=-1"
        "OLLAMA_MAX_LOADED_MODELS=2"
        "OLLAMA_MAX_QUEUE=1"
        "OLLAMA_NUM_PARALLEL=1"
        "OLLAMA_CONTEXT_LENGTH=32768"
        "GGML_VK_CMD_THREADS=8"
        "GGML_VK_MEMORY_POOL_SIZE=8192"
      ];
      Restart = "on-failure";
      RestartSec = 3;
      RestartPreventExitStatus = [ 1 ];
    };
  };

  systemd.user.services.hypridle-hyprland = {
    Unit = {
      Description = "Idle/Sleep Control for Hyprland";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "XDG_CURRENT_DESKTOP=Hyprland";
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.hypridle}/bin/hypridle";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  systemd.user.services.swayidle-niri = {
    Unit = {
      Description = "Idle/Sleep Control for Niri";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "XDG_CURRENT_DESKTOP=niri";
    };
    Service = {
      Type = "simple";
      ExecStart = pkgs.lib.concatStringsSep " " [
        "${pkgs.swayidle}/bin/swayidle"
        "before-sleep 'pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock'"
        "lock ${pkgs.hyprlock}/bin/hyprlock"
        "timeout 600 'pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock'"
        "timeout 1200 'systemctl suspend'"
      ];
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  systemd.user.services.waybar-hyprland = {
    Unit = {
      Description = "Highly customizable Wayland bar";
      Documentation = [ "man:waybar(5)" ];
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "XDG_CURRENT_DESKTOP=Hyprland";
    };
    Service = {
      ExecStart = "${waybarPackage}/bin/waybar";
      ExecReload = "${pkgs.procps}/bin/kill -SIGUSR2 $MAINPID";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  systemd.user.services.waybar-niri = {
    Unit = {
      Description = "Highly customizable Wayland bar for Niri";
      Documentation = [ "man:waybar(5)" ];
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "XDG_CURRENT_DESKTOP=niri";
    };
    Service = {
      ExecStart = "${waybarPackage}/bin/waybar --style %h/.config/waybar/style-niri.css";
      ExecReload = "${pkgs.procps}/bin/kill -SIGUSR2 $MAINPID";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
