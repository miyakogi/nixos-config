# Home Manager configuration for `miyaco`

Nix [home-manager](https://github.com/nix-community/home-manager) configuration for user `miyaco` on NixOS (x86_64-linux), the user half of the [NixOS configuration](../README.md) in the repository root.

Personal configuration: dual window manager setup (Hyprland + Niri), Japanese IME (fcitx5 + hazkey), and a set of WM-agnostic shell scripts.

## Overview

- **Dual window managers** — [Hyprland](https://hyprland.org/) (Lua config in `hypr/hyprland.lua`) and [Niri](https://github.com/niri-wm/niri), both launched through [uwsm](https://github.com/Vladimir-csp/uwsm) and sharing the same scripts and services
- **Japanese input** — fcitx5 with [hazkey](https://github.com/aster-void/nix-hazkey), a neural kana-kanji conversion IME.
- **WM-agnostic scripts** — `scripts/` is installed verbatim to `~/bin`; window manager keybindings call these by name
- **Systemd user services** — per-WM Waybar and idle daemons (hypridle/swayidle), ollama, Taskwarrior notification timers
- **Many terminals configured** — alacritty, foot, kitty, ghostty, rio, wezterm

## Applying

This tree is wired in as `home-manager.users.miyaco`, so it is applied from the repository root with `just switch`:

```sh
sudo nixos-rebuild switch --impure --flake .#nixos-desktop
```

The flake exposes no `homeConfigurations`, so `home-manager switch --flake .#miyaco` does not work here. The rebuild also needs `~/.config/nixos-local/local.nix`, a local file outside the repository, described in the [root README](../README.md#requirements).

> **Warning:** this configuration is optimized for my specific hardware and environment. It is not intended to be used as-is on a different machine, and I do not recommend doing so. Please do not copy it wholesale — treat it only as a reference and build your own setup from scratch.

## Structure

`home.nix` is the root module, imported by the root `flake.nix` as the `users.miyaco` home-manager module.

```
home/
├── home.nix                     # root module (packages, imports)
├── scripts.nix                  # installs scripts/ to ~/bin
├── <app>/<app>.nix              # per-app home-manager modules
├── scripts/                     # WM-agnostic shell scripts
└── services/services.nix        # systemd user units via systemd.user.*
```

`home.nix` imports each module; most apps live in `<app>/<app>.nix`, though a few differ, e.g. `nvim/neovim.nix` for Neovim.

## Highlights

- **Scripts shared by both WMs** — `terminal`, `launch-menu`, `screenshot`, and `leave` are called by name from both Hyprland and Niri keybindings. The window-manager-specific ones stay separate: `hypr-addws` and `hypr-scratchterm` are Hyprland only, `niri-workspace` is Niri only
- **Taskwarrior notifications** — `tw-notify` / `tw-notify-daily` run on systemd timers and notify due tasks
- **Home-managed IME** — hazkey is provisioned via the `nix-hazkey` flake input and wired into fcitx5
- **Per-WM Waybar** — separate services (`waybar-hyprland.service`, `waybar-niri.service`) so the bar can restart without touching the other WM

## Keybindings

`Mod` is the Super key. Bindings below are representative; both WMs share the same scripts, but some details differ — see `hypr/hyprland.lua` and `niri/config.kdl` for the full lists.

| Keybind | Action |
| --- | --- |
| `Mod+Return` | Open terminal |
| `Mod+D` | App launcher (fuzzel) |
| `Mod+S` | Launch menu |
| `Mod+Space` | Notifications panel (swaync) |
| `F2` | Scratchpad terminal |
| `Mod+Q` / `Mod+W` | Close window (Hyprland) |
| `Mod+F` | Toggle fullscreen (Hyprland) |
| `Mod+Shift+F` | Toggle floating (Hyprland) |
| `Mod+E` / `Mod+T` | Toggle special workspace (notes / AI) |
| `Mod+1..9` | Switch to workspace |
| `Mod+Shift+1..9` | Move window to workspace |
| `Mod+O` / `Mod+P` | Previous / next workspace |
| `Mod+Shift+E` | Leave (session menu) |
| `Mod+Shift+R` | Restart Waybar |
| `Print` / `Shift+Print` / `Ctrl+Print` | Screenshot fullscreen / window / region |

## Included apps

A selection of what is configured or installed:

- **Editors** — Neovim, Helix
- **Terminals** — alacritty, foot, kitty, ghostty, rio, wezterm
- **Shell & tools** — fish, starship, atuin, zoxide, zellij, yazi, gitui, lazygit, direnv, eza, bat, broot
- **UI** — waybar (custom build from flake input), quickshell, swaync, fuzzel, tofi, swappy
- **Media** — mpv
- **Development** — Rust toolchain (rustup, mold), Node.js/pnpm, LSPs (ruff, pyright, lua-language-server, bash-language-server, typescript-language-server), hyperfine
- **AI** — ollama (Vulkan), opencode
- **Other** — taskwarrior (with notification timers), capacities, QMK tooling

## License

[MIT](../LICENSE)
