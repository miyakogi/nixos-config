{ pkgs, inputs, ... }: {
  programs.mpv = {
    enable = true;
    package = pkgs.mpv.override {
      scripts = with pkgs.mpvScripts; [
        mpris
        uosc
        thumbfast
        manga-reader
      ];
    };
    config = {
      msg-level = "all=info";
      save-watch-history = true;

      vo = "gpu-next";
      hwdec = "vulkan";
      deband = true;

      gpu-api = "vulkan";
      gpu-context = "waylandvk";
      vulkan-queue-count = 1;
      vulkan-swap-mode = "mailbox";
      vd-lavc-dr = true;

      scale = "ewa_lanczossharp";
      dscale = "mitchell";
      tscale = "mitchell";

      # glsl-shaders = "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Restore_CNN_VL.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl";

      ao = "pipewire";

      hr-seek = "absolute";
      # osc = false;
    };
  };

  xdg.configFile."mpv/input.conf".source = ./input.conf;
  xdg.configFile."mpv/shaders" = {
    source = inputs.shaders;
    recursive = true;
  };
  xdg.configFile."mpv/script-opts/uosc.conf".source = ./uosc.conf;
  xdg.configFile."mpv/script-opts/thumbfast.conf".source = ./thumbfast.conf;
}
