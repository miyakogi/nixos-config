{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  home.username = "miyaco";
  home.homeDirectory = "/home/miyaco";

  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Environment Variables
  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/.npm-global/bin"
  ];
  home.sessionVariables = {
    DRI_PRIME = "1";
    NPM_CONFIG_PREFIX = "$HOME/.npm-global"; # global npm install
  };

  # Input Methods
  services.hazkey = {
    enable = true;
    server.package = inputs.nix-hazkey.packages.${system}.hazkey-server.override {
      enableVulkan = true;
    };
  };
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      inputs.nix-hazkey.packages.${system}.fcitx5-hazkey
      fcitx5-gtk
      libsForQt5.fcitx5-qt
      kdePackages.fcitx5-qt
      kdePackages.fcitx5-configtool
    ];
  };
  programs.meltype = {
    enable = true;
    framework.fcitx5.desktopWorkaround = "none";
  };

  # Keyring
  services.gnome-keyring = {
    enable = true;
    components = [
      "secrets"
      "ssh"
      "pkcs11"
    ];
  };

  # Portal
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gnome # for niri dark theme, see: https://github.com/niri-wm/niri/issues/2878#issuecomment-3573812112
    ];
    config.niri = {
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };
  };

  # Theme
  qt.kvantum = {
    enable = true;
    settings = {
      General = {
        theme = "KvGnomeDark";
      };
    };
  };

  # Install programs
  home.packages =
    with pkgs;
    [
      # ── System / Core ───────────────────────────────────
      curl
      less
      uutils-coreutils-noprefix
      wget
      which

      # ── Documentation ───────────────────────────────────
      man-db
      man-pages
      tlrc

      # ── Archives & Files ────────────────────────────────
      libarchive
      ouch
      unar
      unzip
      zip

      # ── CLI Tools ──────────────────────────────────────
      dua
      fd
      fzf
      jq
      just
      tokei
      trashy
      zmx # terminal session manager

      # ── Container / Isolation ───────────────────────────
      appimage-run
      bubblewrap
      distrobox

      # ── Toolchain / Runtime ─────────────────────────────
      clang
      lua
      nodejs
      pnpm
      poetry
      rustup
      uv

      # ── Build / Libs ────────────────────────────────────
      cmake
      libxkbcommon.dev
      mold
      openssl
      pkgconf

      # ── Benchmark / Coverage ────────────────────────────
      # cargo-llvm-cov
      hyperfine

      # ── Linter / Formatter ──────────────────────────────
      ruff
      shellharden
      typos

      # ── Language Servers ────────────────────────────────
      bash-language-server
      fish-lsp
      lua-language-server
      pyright
      typescript-language-server
      typos-lsp
      vscode-css-languageserver

      # ── AI / Inference ──────────────────────────────────
      ollama-vulkan

      # ── Graphics / GPU ──────────────────────────────────
      libva
      mesa
      nvtopPackages.full
      radeontop
      vulkan-tools

      # ── Desktop / Wayland ───────────────────────────────
      libnotify
      lxqt.pcmanfm-qt
      wl-clipboard-rs
      xdg-utils

      # ── Audio / Music ───────────────────────────────────
      alsa-utils
      lxqt.pavucontrol-qt
      mpc
      ncmpc
      playerctl
      pulsemixer
      spotify-player

      # ── Video ───────────────────────────────────────────
      ffmpeg
      ffmpegthumbnailer
      yt-dlp

      # ── Image ───────────────────────────────────────────
      imagemagick
      imv
      libavif
      pngquant

      # ── Gaming ──────────────────────────────────────────
      gamescope
      lsfg-vk
      lsfg-vk-ui
      mangohud
      prismlauncher

      # ── Theming ─────────────────────────────────────────
      adwaita-icon-theme
      kdePackages.qtstyleplugin-kvantum
      qt6Packages.qt6ct
      rose-pine-cursor

      # ── Hardware / QMK ──────────────────────────────────
      avrdude
      dfu-programmer
      dfu-util
      picotool
      qmk

      # ── Productivity ────────────────────────────────────
      capacities
    ]
    ++ [
      # ── Flake Packages ──────────────────────────────────
      # without pkgs prefix: packages from inputs.* go here
      # example: inputs.<name>.packages.${system}.default
    ];

  imports = [
    # ── Flake Modules ───────────────────────────────────
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    inputs.nix-hazkey.homeModules.hazkey

    # ── System / Base ───────────────────────────────────
    ./services/services.nix
    ./scripts.nix
    ./flatpak/flatpak.nix

    # ── Shells ──────────────────────────────────────────
    ./bash/bash.nix
    ./fish/fish.nix
    ./zsh/zsh.nix

    # ── Docs / VCS / Keys ───────────────────────────────
    ./man/man.nix
    ./git/git.nix
    ./gpg/gpg.nix

    # ── Development / Build ─────────────────────────────
    ./cargo/cargo.nix

    # ── Editors ─────────────────────────────────────────
    ./nvim/neovim.nix
    ./helix/helix.nix

    # ── Terminal Multiplexers ───────────────────────────
    ./zellij/zellij.nix
    ./herdr/herdr.nix

    # ── Terminals ───────────────────────────────────────
    ./alacritty/alacritty.nix
    ./foot/foot.nix
    ./ghostty/ghostty.nix
    ./kitty/kitty.nix
    ./rio/rio.nix
    ./wezterm/wezterm.nix

    # ── CLI Tools ──────────────────────────────────────
    ./atuin/atuin.nix
    ./bat/bat.nix
    ./bottom/bottom.nix
    ./broot/broot.nix
    ./btop/btop.nix
    ./direnv/direnv.nix
    ./eza/eza.nix
    ./fastfetch/fastfetch.nix
    ./gitui/gitui.nix
    ./lazygit/lazygit.nix
    ./macchina/macchina.nix
    ./ripgrep/ripgrep.nix
    ./starship/starship.nix
    ./yazi/yazi.nix
    ./zoxide/zoxide.nix

    # ── Compositors / WM ────────────────────────────────
    ./uwsm/uwsm.nix
    ./hypr/hypr.nix
    ./niri/niri.nix

    # ── Desktop UI / Bars ───────────────────────────────
    ./waybar/waybar.nix
    ./quickshell/quickshell.nix

    # ── Fonts ───────────────────────────────────────────
    ./fontconfig/fontconfig.nix

    # ── Launchers ───────────────────────────────────────
    ./fuzzel/fuzzel.nix
    ./tofi/tofi.nix

    # ── Notifications / Shot ────────────────────────────
    ./swaync/swaync.nix
    ./swappy/swappy.nix

    # ── Media ───────────────────────────────────────────
    ./mpv/mpv.nix

    # ── AI Agents ───────────────────────────────────────
    ./agents/agents.nix
    ./opencode/opencode.nix
    ./pi/pi.nix

    # ── Productivity ────────────────────────────────────
    ./taskwarrior/taskwarrior.nix

    # ── Desktop / Applications ──────────────────────────
    ./desktop/desktop.nix
  ];
}
