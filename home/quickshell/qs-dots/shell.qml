import Quickshell

ShellRoot {

  property var color: (Quickshell.env("XDG_CURRENT_DESKTOP") ?? "").includes("niri") ? "#000000" : "#181616"

  Desktop {
    screenName: "DP-1"
    desktopColor: color
  }

  Desktop {
    screenName: "HDMI-A-2"
    desktopColor: color
  }
}
