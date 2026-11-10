# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ inputs, config, lib, pkgs, ... }:

let
  # Values that must not be published live outside this repository.
  # Pure evaluation cannot read absolute paths (and pathExists silently
  # returns false there), so fail loudly instead of quietly building with
  # placeholder values: pass --impure.
  localFile = /home/miyaco/.config/nixos-local/local.nix;
  local =
    if builtins.pathExists localFile then
      import localFile
    else
      throw ''
        Missing ${toString localFile}.
        Create it, then run: sudo nixos-rebuild switch --impure --flake .#nixos-desktop
      '';
in
{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 50;
  boot.loader.efi.canTouchEfiVariables = true;

  ### Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Kernel parameters
  boot.resumeDevice="/dev/disk/by-uuid/c08a2aab-4b83-4a85-badb-c112d3228822";
  boot.kernelParams = [
    # "module_blacklist=i915"  # Disable intel iGPU
    "i915.enable_guc=3"        # Enable GuC/HuC (more performance)
    "nowatchdog"
    # "intel_pstate=passive"
    "split_lock_detect=off"
    # "resume=UUID=c08a2aab-4b83-4a85-badb-c112d3228822"
    "resume_offset=104430229"
  ];
  powerManagement.cpuFreqGovernor = "performance";

  # Sysctl
  boot.kernel.sysctl = {
    # enable sysrq
    "kernel.sysrq" = 244;

    # from cachy-settings
    "kernel.nmi_watchdog" = 0;  # disable watchdog
  };

  # SystemD
  systemd.sleep.settings.Sleep.SuspendState = "mem mem mem mem mem";

  # ManPages
  documentation.man = {
    enable = true;
    cache.enable = true;
  };
  environment.extraOutputsToInstall = [ "man" ];

  # Network
  networking.hostName = "nixos-desktop";
  networking.networkmanager.enable = true;
  networking.nameservers = [
    "45.90.28.0#nixos-desktop-host-${local.nextdnsProfileId}.dns.nextdns.io"
    "2a07:a8c0::#nixos-desktop-host-${local.nextdnsProfileId}.dns.nextdns.io"
    "45.90.30.0#nixos-desktop-host-${local.nextdnsProfileId}.dns.nextdns.io"
    "2a07:a8c1::#nixos-desktop-host-${local.nextdnsProfileId}.dns.nextdns.io"
  ];
  services.resolved = {
    enable = true;
    settings.Resolve = {
      Domain = "~.";
      DNSSEC = true;
      DNSOverTLS = true;
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Tailscale/Firewall
  services.tailscale.enable = true;
  services.tailscale.openFirewall = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = ["tailscale0"];
    extraCommands = ''
      iptables -A OUTPUT -d 225.3.19.154 -p udp -j ACCEPT
      iptables -A INPUT -d 225.3.19.154 -p udp -j ACCEPT
      iptables -A INPUT -s 225.3.19.154 -p udp -j ACCEPT
      iptables -A INPUT -s 192.168.1.0/24 -p udp -j ACCEPT
    '';
  };

  # Security
  security.sudo-rs = {
    enable = true;
    extraConfig = ''
      Defaults !pwfeedback
      # Defaults !syslog
    '';
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkDefault "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # SCX Scheduler
  services.scx-loader = {
    enable = true;
    config = {
      default_sched = "scx_cosmos";
      default_mode = "LowLatency";
      scheds = {
        scx_bpfland = {
          auto_mode = [];
          gaming_mode = [
            "-m"
            "performance"
          ];
          lowlatency_mode = [
            "-m"
            "performance"
            "-s"
            "5000"
            "-l"
            "5000"
            "-w"
          ];
          powersave_mode = [
            "-m"
            "powersave"
          ];
        };
        scx_flash = {
          auto_mode = [];
          gaming_mode = [
            "-m"
            "all"
          ];
          lowlatency_mode = [
            "-m"
            "performance"
          ];
          powersave_mode = [
            "-m"
            "powersave"
          ];
        };
        scx_cosmos = {
          auto_mode = [];
          gaming_mode = [
            "-m"
            "all"
          ];
          lowlatency_mode = [
            "-m"
            "performance"
            "-w"
          ];
          powersave_mode = [
            "-m"
            "powersave"
            "-d"
          ];
        };
        scx_lavd = {
          auto_mode = [];
          gaming_mode = [
            "--performance"
          ];
          lowlatency_mode = [
            "--performance"
          ];
          powersave_mode = [
            "--powersave"
          ];
        };
      };
    };
  };

  # Ananicy
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  # ZRAM
  zramSwap = {
    enable = true;
  };

  # Virtual Terminal
  services.kmscon = {
    enable = true;
    config = {
      font-name = "Lilex";
      font-size = 21;
      # Keep the software renderer (drm2d + bbulk): the GL text renderer
      # (drm3d + gltex) intermittently fails to upload glyphs at boot
      # ("text_gltex: cannot load glyph data into OpenGL texture (1282:
      # <INVALID_OPERATION>)"), leaving a black screen with only the cursor.
      hwaccel = false;
      libseat = false;
      term = "kmscon";
    };
    extraOptions = "--mode=[HDMI-A-2]2560x1600@60 --mode=[DP-1]3840x2160@120";
  };

  # Backup
  services.snapper = {
    snapshotInterval = "hourly";
    cleanupInterval = "1d";
    configs = {
      root = {
        SUBVOLUME = "/";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 10;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 0;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_QUARTERLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
      };
      home = {
        SUBVOLUME = "/home";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 10;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 0;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_QUARTERLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
      };
      "arch-root" = {
        SUBVOLUME = "/media/arch-root";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 10;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 0;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_QUARTERLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
      };
      "arch-home" = {
        SUBVOLUME = "/media/arch-home";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 10;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 0;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_QUARTERLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
      };
    };
  };
  services.btrbk = {
    instances = {
      n100 = {
        onCalendar = "daily";
        settings = {
          stream_compress = "zstd";
          snapshot_preserve = "3d";
          snapshot_preserve_min = "3d";
          target_preserve = "3d";
          target_preserve_min = "3d";
          ssh_identity = "/root/.ssh/id_ed25519";
          ssh_user = "root";
          volume = {
            "/" = {
              subvolume = "/";
              snapshot_dir = "/.snapshots";
              target = "ssh://${local.backupHost}/media/hdd/Backup/nixos-root";
            };
            "/home" = {
              subvolume = "/home";
              snapshot_dir = "/home/.snapshots";
              target = "ssh://${local.backupHost}/media/hdd/Backup/nixos-home";
            };
            "/media/arch-root" = {
              subvolume = "/media/arch-root";
              snapshot_dir = "/media/arch-root/.snapshots";
              target = "ssh://${local.backupHost}/media/hdd/Backup/root";
            };
            "/media/arch-home" = {
              subvolume = "/media/arch-home";
              snapshot_dir = "/media/arch-home/.snapshots";
              target = "ssh://${local.backupHost}/media/hdd/Backup/home";
            };
          };
        };
      };
    };
  };

  # dynamic link
  programs.nix-ld.enable = true;

  # Flatpak
  services.flatpak.enable = true;

  # Keyring
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.polkit.enable = true;

  # CoreCtrl
  hardware.amdgpu.overdrive.enable = true;
  programs.corectrl = {
    enable = true;
  };

  # QMK
  services.udev.packages = [ pkgs.qmk-udev-rules ];

  # Steam
  hardware.graphics.enable32Bit = true;

  ### Font Settings
  fonts = {
    packages = with pkgs; [
      googlesans-code
      lilex
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-monochrome-emoji
      nerd-fonts.symbols-only
      ibm-plex  # steam uses ttf font
    ];
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = [
          "Symbols Nerd Font"
          "Lilex"
          "Noto Serif CJK JP"
          "Noto Emoji"
        ];
        sansSerif = [
          "Symbols Nerd Font"
          "Lilex"
          "IBM Plex Sans JP"
          "Noto Emoji"
        ];
        monospace = [
          "Symbols Nerd Font"
          "Lilex"
          "IBM Plex Sans JP"
          "Noto Emoji"
        ];
      };
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <description>Change default fonts for Steam client</description>
          <match>
            <test name="prgname">
              <string>steamwebhelper</string>
            </test>
            <test name="family" qual="any">
              <string>sans-serif</string>
            </test>
            <edit mode="prepend" name="family">
              <string>IBM Plex Sans JP</string>
            </edit>
          </match>
        </fontconfig>
     '';
    };
  };

  # Enable the X11 windowing system.
  #services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  # User account
  users.users.miyaco = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "users"
      "docker"
      "audio"
    ];
  };

  # Use privileges
  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "nice"; type = "-"; value = "-19"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
    { domain = "@audio"; item = "nofile"; type = "soft"; value = "99999"; }
    { domain = "@audio"; item = "nofile"; type = "hard"; value = "99999"; }
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    python3
    fish
    git
    wget
    psmisc  # killall, pstree, etc...
    mesa
    libinput
    lm_sensors
    smartmontools
    dbus
    gcc
    clang
    gnumake
    pkg-config
    rustc
    cargo
    mold
    sccache
    nfs-utils  # for NFS
    openssl
    libsecret
    libiconv
    man
    systemd.man
    man-pages
    man-pages-posix
  ] ++ [
    config.systemd.package.man
  ];

  environment.variables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig:${pkgs.dbus.dev}/lib/pkgconfig";
  };

  environment.memoryAllocator = {
    provider = "libc";
  };

  # environment.sessionVariables = {
  #   LIBVA_DRIVER_NAME = "iHD";
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.11"; # Did you read the comment?

  # Enable commands and flakes support
  nix = {
    settings = {
      auto-optimise-store = true;  # Nix store optimization
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    # Auto-run GC
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Allow unfree software only for these packages, identified by name.
  nixpkgs.config.allowUnfreePredicate =
    p:
    builtins.elem (lib.getName p) [
      "capacities"
      "lsfg-vk"
      "lsfg-vk-ui"
      "zsh-abbr"
    ];

  # Docker
  virtualisation.docker = {
    enable = true;
    #storageDriver = "btrfs";
    daemon = {
      settings = {
        dns = [
          "45.90.28.0"
          "2a07:a8c0::"
          "45.90.30.0"
          "2a07:a8c1::"
        ];
      };
    };
  };

  # voicevox service for discord tts bots
  systemd.services.voicevox-engine = {
    description = "VOICEVOX Engine Server";
    after = [ "docker.service" "tailscaled.service" "network-online.target" ];
    requires = [ "docker.service" ];
    wants = [ "tailscaled.service" "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStartPre = "${pkgs.bash}/bin/bash -c 'until ${pkgs.iproute2}/bin/ip addr show tailscale0 | ${pkgs.gnugrep}/bin/grep -q \"100.\"; do sleep 1; done'";
      ExecStart = "${pkgs.docker}/bin/docker run --rm -p ${local.tailscaleIp}:50021:50021 voicevox/voicevox_engine:cpu-latest";
      KillSignal = "SIGINT";
      TimeoutStartSec = 30;
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  # NFS Client
  services.rpcbind.enable = true;
  systemd.mounts = [{
    type = "nfs";
    mountConfig = {
      Options = "noatime,vers=4";
      TimeoutSec = 20;
    };
    what = "${local.backupHost}:/hdd";
    where = "/media/hdd";
  }];
  systemd.automounts = [{
    wantedBy = [ "multi-user.target" ];
    automountConfig = {
      TimeoutIdleSec = "200";
    };
    where = "/media/hdd";
  }];

  # Sound
  # sound.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Session
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # systemd.globalEnvironment sets TZDIR to the tzdata store path, which the
  # uwsm session unit passes on to every GUI app. Flatpak resolves the sandbox
  # timezone from the host-side TZDIR and only understands /etc/zoneinfo, so
  # keep the GUI session on the same value as /etc/set-environment.
  systemd.user.services."wayland-wm@" = {
    environment.TZDIR = "/etc/zoneinfo";
  };

  # File Manager Support
  services.gvfs.enable = true;  # USB auto-mounting
  services.tumbler.enable = true;  # thumbnail images

  # Programs in system
  programs = {
    # Terminal
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    fish = {
      enable = true;
    };

    # ccache for build
    ccache = {
      enable = true;
    };

    # Hyprland
    hyprland = {
      enable = true;
      withUWSM = true;
    };
  };
}
