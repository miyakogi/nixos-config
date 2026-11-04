# Home Manager configuration for `miyaco`

Nix [home-manager](https://github.com/nix-community/home-manager) configuration for user `miyaco` on NixOS (x86_64-linux), the user half of the [NixOS configuration](../README.md) in the repository root.

Personal configuration: dual window manager setup (Hyprland + Niri), Japanese IME (fcitx5 + hazkey), and a set of WM-agnostic shell scripts.

## Overview

- **Dual window managers** — [Hyprland](https://hyprland.org/) (Lua config in `hypr/hyprland.lua`) and [Niri](https://github.com/niri-wm/niri), both launched through [uwsm](https://github.com/Vladimir-csp/uwsm) and sharing the same WM-agnostic scripts and per-WM systemd user units (Waybar, idle daemons)
- **Japanese input** — fcitx5 with [hazkey](https://github.com/aster-void/nix-hazkey), a neural kana-kanji conversion IME, provisioned via the `nix-hazkey` flake input
- **WM-agnostic scripts** — `scripts/` is installed verbatim to `~/bin`; the shared `terminal`, `launch-menu`, `screenshot`, and `leave` are called by name from both Hyprland and Niri keybindings, while `hypr-addws`, `hypr-scratchterm`, and `niri-workspace` stay WM-specific
- **Services and timers** — per-WM Waybar services so one bar can restart without touching the other, idle daemons, ollama, and Taskwarrior notification timers

## Applying

This tree is wired in as `home-manager.users.miyaco`, so it is applied from the repository root with `just switch`:

```sh
sudo nixos-rebuild switch --impure --flake .#nixos-desktop
```

The flake exposes no `homeConfigurations`, so `home-manager switch --flake .#miyaco` does not work here. The rebuild also needs `~/.config/nixos-local/local.nix`, a local file outside the repository, described in the [root README](../README.md#requirements).

> **Warning:** this configuration is optimized for my specific hardware and environment. It is not intended to be used as-is on a different machine, and I do not recommend doing so. Please do not copy it wholesale — treat it only as a reference and build your own setup from scratch.

## Structure

`home.nix` is the root module; each app lives in `<app>/<app>.nix` (a few differ, e.g. `nvim/neovim.nix`). `scripts.nix` installs `scripts/` to `~/bin`, and `services/services.nix` declares systemd user units via `systemd.user.*`.

## Keybindings

`Mod` is the Super key. Representative bindings only — see `hypr/hyprland.lua` and `niri/config.kdl` for the full lists.

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

Configured or installed (see `home.nix` for the full list):

- **Editors** — Neovim, Helix
- **Terminals** — alacritty, foot, kitty, ghostty, rio, wezterm
- **Shell and tools** — fish, starship, atuin, zoxide, zellij, yazi, gitui, lazygit, direnv, eza, bat, broot
- **UI** — waybar (custom build from flake input), quickshell, swaync, fuzzel, tofi, swappy
- **Media and development** — mpv; Rust toolchain (rustup, mold), Node.js/pnpm, LSPs, hyperfine
- **Other** — ollama (Vulkan), opencode, taskwarrior (with notification timers), capacities, QMK tooling

## License

[MIT](../LICENSE)
