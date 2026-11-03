{ ... }: {
  services.flatpak = {
    enable = true;
    packages = [
      "org.mozilla.firefox" # Firefox
      "app.zen_browser.zen" # Zen

      # Chromium
      "org.chromium.Chromium" # Chromium
      "com.google.Chrome" # Google Chrome
      "com.brave.Browser" # Brave
      "com.vivaldi.Vivaldi" # Vivaldi

      # AI
      #"ai.lmstudio.lm-studio"         # LM-Studio
      #"ai.opencode.opencode"          # OpenCode Desktop

      # Flatpak Management
      "com.github.tchx84.Flatseal" # Flatseal

      # E-mail
      #"com.tutanota.Tutanota"         # Tuta Mail

      # Note Taking
      #"com.logseq.Logseq"             # Logseq
      #"md.obsidian.Obsidian"          # Obsidian

      # Task Management
      #"com.ticktick.TickTick"         # TickTick

      # Music Player
      "com.spotify.Client" # Spotify

      # Game
      "com.valvesoftware.Steam" # Steam
      "com.valvesoftware.Steam.CompatibilityTool.Proton-GE" # Proton-GE

      # Others
      "com.obsproject.Studio" # OBS
      "org.gnome.gitlab.dqpb.GMetronome" # GMetronome
      "org.kde.krita" # Krita
    ];
  };
}
