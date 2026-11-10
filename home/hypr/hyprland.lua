-- *** Variables ***
local run      = "app2unit"
local mainMod  = "SUPER"
local left     = "H"
local right    = "L"
local up       = "K"
local down     = "J"
local colWidth = "0.5"

-- *** Source Colors ***
local theme = require("kanagawa-dragon")

-- *** Environment ***
hl.env("TERMINAL", "rio")
hl.env("DRI_PRIME", "1")

-- *** Monitors ***
-- https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
  output               = "DP-1",
  mode                 = "3840x2160@120",
  position             = "0x0",
  scale                = 1,
  bitdepth             = 10,
  cm                   = "srgb",
  sdrbrightness        = 1.12,
  sdrsaturation        = 0.95,
  supports_wide_color  = 1,
  supports_hdr         = 0,         -- 0: auto, 1: force on, -1: off
  sdr_min_luminance    = 0.005,
  sdr_max_luminance    = 225,
  min_luminance        = 0,
  max_luminance        = 1000,
  -- max_avg_luminance = 200,
  sdr_eotf             = "srgb",
  reserved_area        = { top=0, right=32, bottom=0, left=32 },
})

hl.monitor({
  output        = "HDMI-A-2",
  mode          = "preferred",
  position      = "640x2160",
  scale         = 1,
  vrr           = 0,
  bitdepth      = 10,
  cm            = "srgb",
  reserved_area = { top=0, right=32, bottom=0, left=32 },
})

-- *** Misc / Global Config ***
hl.config({
  misc = {
    vrr                    = 1,    -- 0: off, 1: on, 2: fullscreen only
    mouse_move_enables_dpms = true,
    key_press_enables_dpms  = true,
    focus_on_activate       = false,
    disable_splash_rendering = true,
    render_unfocused_fps = 60,
  },
  xwayland = {
    force_zero_scaling = true,
  },
  render = {
    direct_scanout = 0,
  },
})

-- *** Autostart ***
-- https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
  -- Status Bar
  hl.exec_cmd(run .. " -s b -a qs -t service -- qs -c qs-dots")
  -- hl.exec_cmd(run .. " -s b -t service -a waybar -- waybar")

  -- Wallpaper
  hl.exec_cmd(run .. " -s b -a hyprpaper -t service -- hyprpaper")

  -- Capacities
  hl.exec_cmd(run .. " -s b -t service -a capacities -- capacities --force-device-scale-factor=1.5 --ozone-platform=wayland")

  -- OpenCode Desktop (AI)
  hl.exec_cmd(run .. " -s b -t service -- opencode-desktop --force-device-scale-factor=1.75 --ozone-platform=wayland --disable-smooth-scrolling")
end)

-- *** Cursor Theme ***
hl.config({
  cursor = {
    no_hardware_cursors  = false,
    enable_hyprcursor    = true,
    default_monitor      = "DP-1",
  },
})

-- *** Keyboard / Mouse ***
hl.config({
  input = {
    kb_layout    = "us",
    kb_variant   = "",
    kb_model     = "",
    kb_rules     = "",
    follow_mouse = 1,
    repeat_delay = 240,
    repeat_rate  = 42,
    touchpad = {
      natural_scroll = true,
    },
  },
  gestures = {
    workspace_swipe_distance   = 100,
    workspace_swipe_create_new = false,
  },
})

-- for CoolerMaster MM720
hl.device({
  name           = "cooler-master-technology-inc.-mm720-gaming-mouse",
  sensitivity    = 0.0,    -- -1.0 - 1.0, 0 means no modification.
  accel_profile  = "flat",
  natural_scroll = true,
})

-- for CoolerMaster MM710
hl.device({
  name           = "cooler-master-technology-inc.-mm710-gaming-mouse",
  sensitivity    = 0.0,    -- -1.0 - 1.0, 0 means no modification.
  accel_profile  = "flat",
  natural_scroll = true,
})

-- For Glorious Model D
hl.device({
  name           = "glorious-model-d",
  sensitivity    = 0.0,    -- -1.0 - 1.0, 0 means no modification.
  accel_profile  = "flat",
  natural_scroll = true,
})

-- For Perixx Touchpad
hl.device({
  name                  = "sino-wealth-peripad-506-touchpad",
  sensitivity           = 0.4,
  scroll_method         = "2fg",
  disable_while_typing  = false,
  scroll_factor         = 0.5,
})

-- *** Window Management ***
hl.config({
  general = {
    gaps_in   = 8,
    gaps_out  = { top=24, right=16, bottom=16, left=16 },
    border_size = 2,
    col = {
      active_border   = { colors = { theme.green } },
      inactive_border = { colors = { theme.comment } },
    },
    no_focus_fallback = true,
    -- layout = "dwindle",
    layout = "scrolling",
  },
  decoration = {
    rounding = 24,
    blur = {
      enabled = false,
    },
    shadow = {
      enabled      = true,
      range        = 24,
      render_power = 3,
      color        = theme.green,
      color_inactive = 0x80ffffff,
    },
    dim_inactive = false,
  },
  scrolling = {
    fullscreen_on_one_column  = true,
    focus_fit_method          = 1,
    column_width              = colWidth,
    follow_focus              = true,
    explicit_column_widths    = "0.333, 0.5, 0.667, 1.0",
  },
})

-- *** Animations ***
hl.curve("Linear",        { type = "bezier", points = { {0, 0},    {0.5, 1}    } })
hl.curve("easeInOutSine", { type = "bezier", points = { {0, 0.69}, {1, 0.43}   } })
hl.curve("overInOutSine", { type = "bezier", points = { {0, 0.3},  {-0.8, 1.6} } })

hl.animation({ leaf = "windowsIn",   enabled = true,  speed = 1.2,  bezier = "Linear",  style = "popin 50%" })
hl.animation({ leaf = "windowsOut",  enabled = true,  speed = 1.2,  bezier = "Linear",  style = "popin 50%" })
hl.animation({ leaf = "windowsMove", enabled = true,  speed = 1.5,  bezier = "Linear" })
hl.animation({ leaf = "border",      enabled = false, speed = 1.2,  bezier = "Linear" })
hl.animation({ leaf = "borderangle", enabled = false, speed = 20,   bezier = "Linear",  style = "loop" })
hl.animation({ leaf = "fade",        enabled = false, speed = 1,    bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true,  speed = 1.2,  bezier = "Linear",  style = "slidevert" })

-- *** Keybindings ***
-- https://wiki.hypr.land/Configuring/Basics/Binds/

hl.bind(mainMod .. " + RETURN",        hl.dsp.exec_cmd("setsid " .. run .. " -- setsid terminal"))
hl.bind(mainMod .. " + Q",             hl.dsp.window.close())
hl.bind(mainMod .. " + W",             hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + E",     hl.dsp.exec_cmd(run .. " -- leave"))
hl.bind(mainMod .. " + SHIFT + R",     hl.dsp.exec_cmd("systemctl --user restart waybar-hyprland.service"))
hl.bind(mainMod .. " + F",             hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + F",     hl.dsp.window.float({ action = "toggle" }))
local colFitted = false
hl.bind(mainMod .. " + C", function()
  colFitted = not colFitted
  if colFitted then
    hl.dispatch(hl.dsp.layout("fit active"))
  else
    hl.dispatch(hl.dsp.layout("colresize " .. colWidth))
  end
end)

-- Capacities
hl.bind(mainMod .. " + E", hl.dsp.workspace.toggle_special("capacities"))

-- OpenCode Desktop (AI)
hl.bind(mainMod .. " + T", hl.dsp.workspace.toggle_special("opencode"))

-- Scratchpad Terminal
hl.bind("F2", hl.dsp.exec_cmd("hypr-scratchterm"))

-- *** Launcher ***
-- fuzzel
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("fuzzel --launch-prefix='" .. run .. " --fuzzel-compat --'"))
-- tofi
hl.bind(mainMod .. " + CTRL + Space", hl.dsp.exec_cmd(
    "tofi-drun --drun-launch=false --anchor=center --background-color=000000AA | xargs --no-run-if-empty " .. run .. " --"
))
-- tofi (web search)
-- hl.bind(mainMod .. " + CTRL + Space", hl.dsp.exec_cmd("hyprctl dispatch exec " .. run .. " -- tofi-web"))
-- sklauncher
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(run .. " -- launch-menu"))

-- *** Notification ***
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("swaync-client --toggle-panel"))

-- Move focus with mainMod + vim keys / arrow keys
-- hl.bind(mainMod .. " + " .. left,  hl.dsp.focus({ direction = "l" }))
-- hl.bind(mainMod .. " + " .. right, hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + " .. left,  hl.dsp.layout("move -col"))
hl.bind(mainMod .. " + " .. right, hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + " .. up,    hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + " .. down,  hl.dsp.focus({ direction = "d" }))
-- hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "l" }))
-- hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + left",  hl.dsp.layout("move -col"))
hl.bind(mainMod .. " + right", hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "d" }))

-- Move focus with gestures
-- gesture = 3, left, dispatcher, layoutmsg, move +col
hl.gesture({ fingers = 3, direction = "left",  action = function() hl.dispatch(hl.dsp.layout("move +col")) end })
hl.gesture({ fingers = 3, direction = "right", action = function() hl.dispatch(hl.dsp.layout("move -col")) end })
-- hl.gesture({ fingers = 3, direction = "left",  action = function() hl.dispatch(hl.dsp.focus({ direction = "r" })) end })
-- hl.gesture({ fingers = 3, direction = "right", action = function() hl.dispatch(hl.dsp.focus({ direction = "l" })) end })

-- Move window position
hl.bind(mainMod .. " + SHIFT + " .. left,  hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + " .. right, hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + " .. up,    hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + " .. down,  hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "d" }))

-- Switch workspaces with mainMod + [0-9]  /  mainMod + CTRL + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]  /  mainMod + SHIFT + CTRL + [0-9]
for i = 1, 10 do
  local key = tostring(i % 10)   -- 10 maps to key 0
  hl.bind(mainMod .. " + " .. key,               hl.dsp.focus({ workspace = tostring(i) }))
  hl.bind(mainMod .. " + SHIFT + " .. key,       hl.dsp.window.move({ workspace = tostring(i) }))
end
for i = 11, 20 do
  local key = tostring(i % 10)   -- 20 maps to key 0
  hl.bind(mainMod .. " + CTRL + " .. key,        hl.dsp.focus({ workspace = tostring(i) }))
  hl.bind(mainMod .. " + SHIFT + CTRL + " .. key, hl.dsp.window.move({ workspace = tostring(i) }))
end

-- Switch workspace (previous / next on same monitor)
hl.bind(mainMod .. " + bracketleft",   hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + bracketright",  hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + Tab",           hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + SHIFT + Tab",   hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + CTRL + left",   hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + CTRL + right",  hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + O",             hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + P",             hl.dsp.focus({ workspace = "m+1" }))

-- Switch workspace with 3-finger up/down swipe
hl.gesture({ fingers = 3, direction = "up",   action = function() hl.dispatch(hl.dsp.focus({ workspace = "m+1" })) end })
hl.gesture({ fingers = 3, direction = "down",  action = function() hl.dispatch(hl.dsp.focus({ workspace = "m-1" })) end })

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "m-1" }), { mouse = true })
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "m+1" }), { mouse = true })
-- Switch workspace by side button
hl.bind("mouse:276", hl.dsp.focus({ workspace = "m-1" }), { mouse = true })
hl.bind("mouse:275", hl.dsp.focus({ workspace = "m+1" }), { mouse = true })

-- Add new workspace at next lowest number workspace
hl.bind(mainMod .. " + backslash", hl.dsp.exec_cmd("hypr-addws"))
hl.bind(mainMod .. " + G",         hl.dsp.exec_cmd("hypr-addws"))
hl.bind(mainMod .. " + semicolon", hl.dsp.exec_cmd("hypr-addws"))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
-- scrolling layout
hl.bind(mainMod .. " + R", hl.dsp.layout("colresize +conf"))

-- Screenshot
hl.bind("PRINT",         hl.dsp.exec_cmd(run .. " -- screenshot fullscreen"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd(run .. " -- screenshot window"))
hl.bind("CTRL + PRINT",  hl.dsp.exec_cmd(run .. " -- screenshot region"))

-- *** Workspace Assignments ***
-- DP-1 workspaces (1-10)
hl.workspace_rule({ workspace = "1",  monitor = "DP-1",     default = true })
hl.workspace_rule({ workspace = "2",  monitor = "DP-1" })
hl.workspace_rule({ workspace = "3",  monitor = "DP-1" })
hl.workspace_rule({ workspace = "4",  monitor = "DP-1" })
hl.workspace_rule({ workspace = "5",  monitor = "DP-1" })
hl.workspace_rule({ workspace = "6",  monitor = "DP-1" })
hl.workspace_rule({ workspace = "7",  monitor = "DP-1" })
hl.workspace_rule({ workspace = "8",  monitor = "DP-1" })
hl.workspace_rule({ workspace = "9",  monitor = "DP-1" })
hl.workspace_rule({ workspace = "10", monitor = "DP-1" })
-- HDMI-A-2 workspaces (11-20)
hl.workspace_rule({ workspace = "11", monitor = "HDMI-A-2", default = true })
hl.workspace_rule({ workspace = "12", monitor = "HDMI-A-2" })
hl.workspace_rule({ workspace = "13", monitor = "HDMI-A-2" })
hl.workspace_rule({ workspace = "14", monitor = "HDMI-A-2" })
hl.workspace_rule({ workspace = "15", monitor = "HDMI-A-2" })
hl.workspace_rule({ workspace = "16", monitor = "HDMI-A-2" })
hl.workspace_rule({ workspace = "17", monitor = "HDMI-A-2" })
hl.workspace_rule({ workspace = "18", monitor = "HDMI-A-2" })
hl.workspace_rule({ workspace = "19", monitor = "HDMI-A-2" })
hl.workspace_rule({ workspace = "20", monitor = "HDMI-A-2" })

-- Configure gaps/borders on sub-monitor (HDMI-A-2)
hl.workspace_rule({ workspace = "m[HDMI-A-2]", gaps_out = { top=12, right=12, bottom=20, left=12 } })

-- *** Application Rules ***
-- Launcher
hl.window_rule({
  name  = "launcher-float",
  match = { class = ".*sklauncher" },
  float = true,
  center = true,
  size  = { 800, 920 },
})

-- Capacities
hl.workspace_rule({ workspace = "special:capacities", gaps_out = { top=120, right=360, bottom=120, left=360 } })
hl.window_rule({ match = { class = "^Capacities$" }, workspace = "special:capacities" })
hl.window_rule({ match = { class = "^io.capacities.app$" }, workspace = "special:capacities" })

-- OpenCode Desktop (AI)
hl.workspace_rule({ workspace = "special:opencode", gaps_out = { top=120, right=360, bottom=120, left=360 } })
hl.window_rule({ match = { class = "^ai.opencode.desktop$" }, workspace = "special:opencode" })

-- ScratchTerm
hl.workspace_rule({ workspace = "special:scratchterm-dp1", gaps_out = { top=120, right=360, bottom=120, left=360 } })
hl.workspace_rule({ workspace = "special:scratchterm-dp2", gaps_out = { top=120, right=240, bottom=120, left=240 } })
hl.window_rule({ match = { class = ".*scratchterm-dp1" }, workspace = "special:scratchterm-dp1" })
hl.window_rule({ match = { class = ".*scratchterm-dp2" }, workspace = "special:scratchterm-dp2" })

-- Browser
hl.window_rule({ match = { class = "^zen$" },              workspace = "1" })
hl.window_rule({ match = { class = "^zen-twilight$" },     workspace = "1" })
hl.window_rule({ match = { class = "^app.zen_browser.zen$" }, workspace = "1" })
hl.window_rule({ match = { class = "^zen-main$" },         workspace = "1" })
hl.window_rule({ match = { class = "^firefox$" },          workspace = "1" })
hl.window_rule({ match = { class = "^firefox-sub$" },      workspace = "11" })
hl.window_rule({ match = { class = "^org.mozilla.firefox$" }, workspace = "11" })
hl.window_rule({ match = { class = "^zen-sub$" },          workspace = "11" })
hl.window_rule({ match = { class = "^vivaldi-stable$" },   workspace = "1" })
hl.window_rule({ match = { class = "^Vivaldi-stable$" },   workspace = "1" })
hl.window_rule({ match = { class = "^firefox$" },       tile = true })
hl.window_rule({ match = { class = "^firefox-sub$" },   tile = true })
hl.window_rule({ match = { class = "^vivaldi-stable$" }, tile = true })
hl.window_rule({ match = { class = "^Vivaldi-stable$" }, tile = true })
hl.window_rule({ match = { class = "^chrom.*-game$" },          render_unfocused = true, scrolling_width = 0.333 })
hl.window_rule({ match = { class = "^org.chromium.Chromium$" }, render_unfocused = true, scrolling_width = 0.333 })  -- wayland
hl.window_rule({ match = { class = "^Org.chromium.Chromium$" }, render_unfocused = true, scrolling_width = 0.333 })  -- x11
hl.window_rule({ match = { class = "^Vivaldi-home$" }, tile = true })
hl.window_rule({ match = { class = "^discord$" },  workspace = "14" })
hl.window_rule({ match = { class = "^vesktop$" },  workspace = "14" })

-- Media Player
hl.window_rule({ match = { class = "^mpv$" }, no_dim = true })
hl.window_rule({ match = { class = "^[Ss]potify$" },       workspace = "9" })
hl.window_rule({ match = { class = "^[Ss]potify$" },       tile = true })
hl.window_rule({ match = { class = "^[Ss]potify$" },       opacity = 0.97 })
hl.window_rule({ match = { class = ".*spotify-player" },   workspace = "9" })

-- Steam / Proton
hl.window_rule({ match = { class = "^steam$" },         workspace = "7" })
hl.window_rule({ match = { class = "^steamwebhelper$" }, workspace = "7" })
hl.window_rule({ match = { class = "^Steam$" },         workspace = "7" })
hl.window_rule({ match = { title = "^ProtonUp-Qt$" },   workspace = "7" })
hl.window_rule({ match = { class = "^gamescope$" }, float = true })
hl.window_rule({ match = { class = "^gamescope$" }, no_dim = true })
hl.window_rule({ match = { class = "^gamescope$" }, idle_inhibit = "fullscreen" })
hl.window_rule({ match = { class = "^gamescope$" }, workspace = "8" })
hl.window_rule({ match = { class = "^steam_app_.*" },   idle_inhibit = "focus" })
hl.window_rule({ match = { class = "^steam_app_.*" },   workspace = "8" })
hl.window_rule({ match = { class = "^steam_proton$" },  no_dim = true })
hl.window_rule({ match = { class = "^steam_proton$" },  idle_inhibit = "focus" })
hl.window_rule({ match = { class = "^steam_proton$" },  workspace = "8" })

-- misc
hl.window_rule({ match = { class = "^org.pulseaudio.pavucontrol$" }, float = true })
hl.window_rule({ match = { class = "^pavucontrol-qt$" },             float = true })
hl.window_rule({ match = { class = "^XEyes$" },                      float = true })

-- *** Layer Rules ***
hl.layer_rule({ match = { namespace = "qs-desktop" }, order = 1 })

-- *** Plugins ***
