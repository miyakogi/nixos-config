export GOPATH="$HOME/.go"
if type -q rustc
  export RUST_SRC_PATH="(rustc --print sysroot)/lib/rustlib/src/rust/src"
end

export EDITOR=nvim
export MANPAGER="nvim +Man! -u $HOME/.config/nvim/manrc"

export LESS="-iFRSM"
export SYSTEMD_LESS="-iFRSM"

set -gx XDG_DATA_DIRS ~/.local/state/nix/profiles/home-manager/home-path/share ~/.local/share /usr/local/share /usr/share $XDG_DATA_DIRS

# Zoxide option
set -x _ZO_FZF_OPTS "--bind=ctrl-z:ignore --exit-0 --height=40% --info=inline --no-sort --reverse --select-1 --exact"

### Login on TTY1
if test -z "$DISPLAY"; and test "$XDG_VTNR" = 1; and begin test -z "$XDG_SESSION_TYPE"; or test "$XDG_SESSION_TYPE" = tty; or begin type -q uwsm; and uwsm check may-start; end; end
  echo -e -n "\
Select Window Manager of Shell:
> 1) Hyprland [default]
  2) Niri
  3) bash
  4) fish
  5) exit
  *) any executable
"
  read -P '>>> ' choice

  # set default wm candidate
  if test -z "$choice"
    set choice 1
  end

  switch (string lower -- "$choice")
    case 1 hypr hyprland
      set wm "Hyprland"
    case 2 niri
      set wm "niri"
    case 3 bash sh
      exec bash
    case 4 fish
      exec fish
    case 5 exit
      exit 0
    case *
      set wm "$choice"
  end

  if ! command -q uwsm
    export GTK_THEME=Adwaita:dark
    export GTK_USE_PORTAL=1

    export QT_QPA_PLATFORMTHEME=qt6ct
    export QT_QPA_PLATFORM="wayland;xcb"

    export XMODIFIERS=@im=fcitx
    #export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export GLFW_IM_MODULE=fcitx

    export GST_VAAPI_ALL_DRIVERS=1

    # hyprland
    export AQ_NO_MODIFIERS=0

    # sway
    export WLR_DRM_NO_MODIFIERS=1

    # app2unit
    export APP2UNIT_SLICES='a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice'

    # XDG
    export XDG_CURRENT_DESKTOP=$wm
    export XDG_SESSION_TYPE=wayland
  end

  # Start wayland session
  wm-start $wm
end
