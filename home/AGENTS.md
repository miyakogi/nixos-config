# AGENTS.md

Nix home-manager tree for user `miyaco`, part of the NixOS flake in the repository root. Apply, verify, format, and commit rules are in `../AGENTS.md`; this file covers only what is specific to `home/`.

## Layout

- `home.nix` is the root module; most apps have `dir/name.nix` listed in its `imports` (a few differ, e.g. `nvim/neovim.nix`)
- `scripts/` is copied verbatim to `~/bin` (recursive, all executable) by `scripts.nix` — WM keybindings call these scripts by name
- `services/services.nix` declares systemd user units (services/timers) via `systemd.user.*`

## Gotchas

- Both Hyprland and Niri are configured, launched via uwsm, and share the WM-agnostic scripts (`terminal`, `launch-menu`, `screenshot`, `leave`) while keeping their own workspace scripts
- Systemd user units are enabled declaratively (`.wants` live in the HM generation), so `just switch` starts/restarts/stops changed units automatically. `ollama.service` has no `Install` and is intentionally never auto-started

## Conventions

- Shell scripts: clean shellharden warnings before committing; `is-4k` (in `~/bin`) reports whether the focused monitor is DP-1 for monitor-specific behavior
