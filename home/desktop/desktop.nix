{ ... }: {
  xdg.desktopEntries = {
    "Video" = {
      name = "Video (Chrome)";
      genericName = "Video player on chrome with gamescope";
      type = "Application";
      icon = "com.google.Chrome";
      exec = "env DRI_PRIME=1 RADV_PERFTEST=ngg,rt,nggc,sam,ge,ngg_culling RADV_DEBUG=novrs,nosam MESA_VK_WSI_PRESENT_MODE=immediate ENABLE_GAMESCOPE_WSI=0 RADV_THREAD_TRACE=1 gamescope -f -w 1920 -r 60 -h 1080 -W 3840 -H 2160 --framerate-limit 60 --filter fsr --sharpness 10 --expose-wayland --backend wayland --cursor-scale-height 1 --prefer-vk-device=1002:73bf -- flatpak run --branch=stable --arch=x86_64 --command=/app/bin/chrome --file-forwarding com.google.Chrome --enable-features=Vulkan --ozone-platform=x11";
    };
    "Zen-Main" = {
      name = "Zen (Main)";
      type = "Application";
      icon = "app.zen_browser.zen";
      exec = ''flatpak run --branch=stable --arch=x86_64 --command=launch-script.sh --file-forwarding app.zen_browser.zen -P "Default (release)" --name zen-main'';
    };
    "Zen-Sub" = {
      name = "Zen (Sub)";
      type = "Application";
      icon = "app.zen_browser.zen";
      exec = "flatpak run --branch=stable --arch=x86_64 --command=launch-script.sh --file-forwarding app.zen_browser.zen -P Sub --name zen-sub";
    };
    "org.chromium.Chromium" = {
      name = "Chromium";
      type = "Application";
      icon = "org.chromium.Chromium";
      exec = "flatpak run --branch=stable --arch=x86_64 --command=/app/bin/chromium --file-forwarding org.chromium.Chromium --ozone-platform=wayland --enable-features=VaapiVideoDecoder,VaapiIgnoreDriverChecks,UseOzonePlatform,Vulkan --disable-backgrounding-occluded-windows --disable-renderer-backgrounding --disable-background-timer-throttling --disable-features=CalculateNativeWinOcclusion,IntensiveWakeUpThrottling @@u %U @@";
    };
    "capacities" = {
      name = "Capacities";
      type = "Application";
      icon = "capacities";
      exec = "capacities --no-sandbox --force-device-scale-factor=1.5 --ozone-platform=wayland";
    };
    "ai.opencode.desktop" = {
      name = "OpenCode (Desktop)";
      type = "Application";
      icon = "opencode-desktop";
      exec = "opencode-desktop --force-device-scale-factor=1.75 --ozone-platform=wayland --disable-smooth-scrolling";
    };
    # GMetronome (flatpak)
    "org.gnome.gitlab.dqpb.GMetronome" = {
      name = "GMetronome";
      type = "Application";
      icon = "org.gnome.gitlab.dqpb.GMetronome";
      exec = "flatpak run --branch=stable --arch=x86_64 --command=gmetronome --env=GDK_SCALE=2 --env=GDK_DPI_SCALE=2.0 org.gnome.gitlab.dqpb.GMetronome";
    };
    "spotify-player" = {
      name = "Spotify Player";
      type = "Application";
      icon = "com.spotify.Client";
      exec = ''wezterm start --class spotify-player zmx attach spotify-player bash -c "sleep 0.3s && spotify_player"'';
    };
  };
}
