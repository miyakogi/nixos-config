# AGENTS.md

NixOS + home-manager flake for the single host `nixos-desktop` (x86_64-linux). No CI, no tests — evaluation and building are the only verification. Anything under `home/` also follows `home/AGENTS.md`.

## Apply and verify

- `just build` — build the system without activating it
- `just switch` — build and activate
- Both expand to `sudo nixos-rebuild <build|switch> --impure --flake .#nixos-desktop`. `--impure` is required: `configuration.nix` imports `~/.config/nixos-local/local.nix` by absolute path and `throw`s when the file is missing
- Never run `just update` / `nix flake update` unless explicitly asked

## Layout

- Root Nix files are the system side: `flake.nix` (inputs, `nixosConfigurations.nixos-desktop`, `formatter`), `configuration.nix`, `hardware-configuration.nix` (installer-generated), `justfile`
- `home/` is the home-manager tree for user `miyaco`, imported by `flake.nix` as the `users.miyaco` home-manager module; it has its own `AGENTS.md`

## System-side gotchas

- `nixos-hardware` modules are imported for the Intel CPU, the AMD and Intel GPUs, and common PC SSDs. `hardware-configuration.nix` is machine-generated — touch it only for disk layout changes
- home-manager runs as a NixOS module with `useGlobalPkgs` and `useUserPackages`, so the flake exposes no `homeConfigurations`
- Unfree packages are allowlisted by name in `configuration.nix` (`nixpkgs.config.allowUnfreePredicate`), not with `allowUnfree = true` — add a name there to install another unfree package. home-manager shares this `pkgs` through `useGlobalPkgs`, so the same list covers `home/`
- `meltypeSrc` applies `home/patches/nix-meltype-session-vars.patch` to the `nix-meltype` input, and `waybarPackage` rewrites the Waybar input's cava subproject path; keep both when updating those inputs

## Formatting

- `nix fmt <paths>` (flake `formatter` = `nixfmt`); pass explicit paths
- `configuration.nix` and `hardware-configuration.nix` are not nixfmt-formatted, so `nix fmt` on them rewrites the whole file — do not include that reformat in an unrelated change

## Commits

- `[area] lowercase imperative` in English, e.g. `[scx] add lavd` or `[system] move private values to local file`. `area` names the area of the system (a feature such as `kernel`, `scx`, `network`, an app directory under `home/`, or a real example like `[git] drop .jj from gitignore`)
- Ask before committing
- Global preferences (language, commit approval, dependency updates, secrets) live in `home/agents/AGENTS.md`, deployed to `~/.agents/AGENTS.md`, `~/.claude/CLAUDE.md`, and `~/.codex/AGENTS.md`, and wired into opencode via `programs.opencode.context` — do not duplicate them here

## Secrets

- `~/.config/nixos-local/local.nix` holds `nextdnsProfileId`, `backupHost`, and `tailscaleIp`. Never copy those values into the repository
