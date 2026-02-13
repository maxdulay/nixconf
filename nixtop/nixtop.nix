{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  omen-rust = inputs.omen-rust.packages.${pkgs.stdenv.hostPlatform.system}.omen-rust;
  ancs-linux =
    with pkgs;
    rustPlatform.buildRustPackage rec {
      pname = "ancs-linux";
      version = "19f5d0cce5d99b4ce2d77d90e3433215bea65172";

      src = fetchFromGitHub {
        owner = "kmod-midori";
        repo = pname;
        rev = version;
        hash = "sha256-KTEf7YorJDEe3bHkwR5mJwduihyUDREFGX2H1B+gQZI=";
      };
      cargoHash = "sha256-zS8dllpKJUkRRFYeWFw3wc3OOPFPZlc7os48/MwwhGU=";

      nativeBuildInputs = [
        cargo
        rustc
        pkg-config
      ];
      buildInputs = [ dbus ];

      meta = {
        description = "Forward notifications from your iOS devices to your Linux desktop ";
        homepage = "https://github.com/kmod-midori/ancs-linux";
        license = lib.licenses.mit;
        maintainers = [ ];
      };
    };
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  age.secrets = {
    "wg-full-private".file = ../secrets/wg-full-private.age;
    "wg-full-preshared".file = ../secrets/wg-full-preshared.age;
    "wg-dns-private".file = ../secrets/wg-dns-private.age;
    "wg-dns-preshared".file = ../secrets/wg-dns-preshared.age;
    "iphone-mac" = {
      file = ../secrets/iphone-mac.age;
      mode = "777";
    };
  };

  ## Boot

  boot.loader = {
    timeout = 5;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
      fontSize = 48;
    };
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.sshd.enable = true;
  networking.hostName = "nixtop";

  fileSystems."/home/maxdu/Windows" = {
    device = "/dev/disk/by-uuid/D6C6FA39C6FA1987";
    neededForBoot = false;
    options = [ "nofail" ];
  };

  boot.kernel.sysctl = {
    "net.ipv6.conf.all.forwarding" = true;
    "net.ipv4.ip_forward" = 1;
  };

  ## Desktop

  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = [
          "hyprland"
          "gtk"
        ];
        hyprland = {
          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        };
      };
      extraPortals = [
        pkgs.xdg-desktop-portal
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-termfilechooser
      ];
    };
    mime = {
      enable = true;
      addedAssociations = {
        "x-scheme-handler/fcade" = "fcade-quark.desktop";
      };
      defaultApplications = {
        "inode/directory" = [ "vifm.desktop" ]; # Directories
        "application/pdf" = [ "org.pwmt.zathura.desktop" ]; # .pdf
        "application/mscz" = [ "org.musescore.MuseScore.desktop" ];
        "text/*" = [ "nvim.desktop" ]; # Any text files
        "video/*" = [ "mpv.desktop" ]; # Any video files
        "default-web-browser" = [ "firefox.desktop" ]; # Links
        "x-scheme-handler/https" = [ "firefox.desktop" ]; # Links
        "x-scheme-handler/http" = [ "firefox.desktop" ]; # Links
        "x-scheme-handler/mailto" = [ "firefox.desktop" ]; # Links
        "x-scheme-handler/fcade" = [ "fcade-quark.desktop" ]; # Fightcade
        "image/*" = [ "feh.desktop" ]; # Images
        "image/png" = [ "feh.desktop" ];
        "image/jpeg" = [ "feh.desktop" ];
      };
    };
  };

  services.libinput.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };
  environment.loginShellInit = ''
    # Launch Hyprland on TTY1, return to TTY when exiting
    if [ "$(tty)" = "/dev/tty1" ]; then
      start-hyprland # Use `exec start-hyprland` to auto-restart on exit/crash instead
    fi
  '';

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  networking.networkmanager.ensureProfiles = {
    secrets.entries = [
      {
        file = config.age.secrets."wg-full-private".path;
        matchId = "wg-full";
        matchSetting = "wireguard";
        matchType = "wireguard";
        key = "private-key";
      }
      {
        file = config.age.secrets."wg-full-preshared".path;
        matchId = "wg-full";
        matchSetting = "wireguard";
        matchType = "wireguard";
        key = "peers.tXECZ4MMaCopORYz9yMMJNDqbzB7zNqo2ChbZ72jhVU=.preshared-key";
      }
      {
        file = config.age.secrets."wg-dns-private".path;
        matchId = "wg-dns";
        matchSetting = "wireguard";
        matchType = "wireguard";
        key = "private-key";
      }
      {
        file = config.age.secrets."wg-dns-preshared".path;
        matchId = "wg-dns";
        matchSetting = "wireguard";
        matchType = "wireguard";
        key = "peers.tXECZ4MMaCopORYz9yMMJNDqbzB7zNqo2ChbZ72jhVU=.preshared-key";
      }

    ];
    # sudo su -c "cd /etc/NetworkManager/system-connections && nix --extra-experimental-features 'nix-command flakes' run github:Janik-Haag/nm2nix | nix --extra-experimental-features 'nix-command flakes' run nixpkgs#nixfmt-rfc-style"
    profiles = {
      wg-full = {
        connection = {
          autoconnect = "false";
          id = "wg-full";
          interface-name = "wg0";
          timestamp = "1769186732";
          type = "wireguard";
          uuid = "9d607fd3-1b9e-4a53-9b77-f342b498b274";
        };
        ipv4 = {
          address1 = "10.0.0.10/32";
          dns = "10.0.1.100;";
          dns-search = "~;";
          method = "manual";
        };
        ipv6 = {
          addr-gen-mode = "default";
          address1 = "fd42:dead:beef::10/128";
          method = "manual";
        };
        proxy = { };
        wireguard = {
        };
        "wireguard-peer.tXECZ4MMaCopORYz9yMMJNDqbzB7zNqo2ChbZ72jhVU=" = {
          allowed-ips = "0.0.0.0/0;::/0;";
          endpoint = "wg.dulaym.ax:47111";
          persistent-keepalive = "25";
          preshared-key-flags = "1";
        };
      };
      wg-dns = {
        connection = {
          autoconnect = "true";
          id = "wg-dns";
          interface-name = "wg0";
          type = "wireguard";
          uuid = "c06f1c11-2ef9-427a-9860-1f16c59ecf42";
        };
        ipv4 = {
          address1 = "10.0.0.9/32";
          dns = "10.0.1.100;";
          dns-search = "~;";
          method = "manual";
        };
        ipv6 = {
          addr-gen-mode = "default";
          address1 = "fd42:dead:beef::10/128";
          method = "manual";
        };
        proxy = { };
        wireguard = {
        };
        "wireguard-peer.tXECZ4MMaCopORYz9yMMJNDqbzB7zNqo2ChbZ72jhVU=" = {
          allowed-ips = "10.0.1.100/32;fd42:dead:beef::1/64;";
          endpoint = "wg.dulaym.ax:47111";
          persistent-keepalive = "25";
          preshared-key-flags = "1";
        };
      };
    };
  };
  networking.firewall.checkReversePath = false;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.input.General.ClassicBondedOnly = false;
  services.blueman.enable = true;
  systemd.user.services.ancs-linux = {
    enable = true;
    description = "Apple Notifications";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${ancs-linux}/bin/ancs-linux $MAC";
      EnvironmentFile = config.age.secrets.iphone-mac.path;
    };
    wantedBy = [ ];
  };
  services.avahi.enable = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;
  systemd.user.services.shairport-sync = {
    enable = true;
    description = "AirPlay server";
    after = [
      "network.target"
      "sound.target"
      "avahi-daemon.service"
    ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.shairport-sync}/bin/shairport-sync -v -o alsa";
  };
  environment.etc."shairport-sync.conf".source =
    let
      configFormat = pkgs.formats.libconfig { };
    in
    configFormat.generate "shairport-sync.conf" {
      diagnostics = {
        log_verbosity = 1;
      };
      general = {
        name = "Nixtop";
        output_backend = "alsa";
        volume_control_profile = "flat";
        default_airplay_volume = -0.0;
      };
    };
  networking.firewall = {
    enable = true;

    allowedUDPPorts = [
      5353
      6000
      6001
      7011
      27031
      47111
    ];
    allowedTCPPorts = [
      5000
      7000
      7001
      7100
      27031
    ];
    allowedUDPPortRanges = [
      {
        from = 6001;
        to = 6011;
      }
    ];
    allowedTCPPortRanges = [
      {
        from = 7000;
        to = 7005;
      }
    ];
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    wireplumber.enable = true;
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.udev = {
    enable = true;
    extraRules = # udev
      ''
        # Rules for power saving 
        SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${pkgs.su}/bin/su maxdu -c \"${pkgs.hyprland}/bin/hyprctl -i 0 --batch 'keyword animations:enabled 0; keyword decoration:blur:enabled 0; keyword general:gaps_in 0; keyword general:gaps_out 0; keyword general:border_size 1; keyword decoration:rounding 0; keyword monitor eDP-1,2560x1440@60,0x0,1.6666; keyword misc:vfr 1; keyword decoration:active_opacity 2.0; keyword decoration:inactive_opacity 2.0'\""
        SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${pkgs.brightnessctl}/bin/brightnessctl set 5%%"
        SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${pkgs.brightnessctl}/bin/brightnessctl set 50%%"
        SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${pkgs.su}/bin/su maxdu -c \"${pkgs.hyprland}/bin/hyprctl -i 0 reload"

        # Rules for PS3 Eye
        ATTR{idVendor}=="1415", ATTR{idProduct}=="2000", MODE="777"

        # Rules for bluetooth

        SUBSYSTEM=="bluetooth", ACTION=="add", DEVPATH=="/devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10:1.0/bluetooth/hci0/hci0:256", ENV{SYSTEMD_USER_WANTS}+="ancs-linux.service"
      '';
  };

  hardware.graphics = {
    enable = true; # driSupport = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl
      nvidia-vaapi-driver
    ];
  };
  environment.variables.VDPAU_DRIVER = "va_gl";
  environment.variables.LIBVA_DRIVER_NAME = "iHD";
  environment.sessionVariables.VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    forceFullCompositionPipeline = true;
    # Modesetting is required.
    modesetting.enable = true;
    # fix after suspend
    powerManagement.enable = false;
    # offload
    powerManagement.finegrained = true;
    open = true;
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;

  };
  boot.blacklistedKernelModules = [ "nova_core" ];

  hardware.nvidia.prime = {

    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  environment.systemPackages =
    with pkgs;
    let
      #   kalc = rustPlatform.buildRustPackage rec {
      #     pname = "kalc";
      #     version = "v1.4.2";
      #
      #     src = fetchFromGitHub {
      #       owner = "bgkillas";
      #       repo = pname;
      #       rev = version;
      #       hash = "sha256-sea00evxOVE6FXAhaa4zRcngkfIpwfH8mfylaiChb9w=";
      #     };
      #
      #     cargoHash = "sha256-oTXlneosiU1kQuqfuhdmXb8h0HXYadW7DoX53G+AwN8=";
      #
      #     meta = {
      #       description =
      #         "a complex numbers, 2d/3d graphing, arbitrary precision, vector/matrix, cli calculator with real-time output and support for units";
      #       homepage = "https://github.com/bgkillas/kalc";
      #       license = lib.licenses.gpl3Only;
      #       maintainers = [ ];
      #     };
      # buildPhase = ''
      # 	substituteInPlace Cargo.toml \
      # 		--replace "force-cross" "use-system-libs"
      # 	'';
      #     nativeBuildInputs = with pkgs; [ cargo rustc m4 diffutils gcc ];
      #   };
      mmdr = rustPlatform.buildRustPackage rec {
        pname = "mermaid-rs-renderer";
        version = "v0.2.0";

        src = fetchFromGitHub {
          owner = "1jehuang";
          repo = pname;
          rev = version;
          hash = "sha256-FmYiGAUTdHLBHmMrX4I1Lax+WTevLeW2+TSVhV0TUCk=";
        };

        cargoHash = "sha256-EICrvDm97hXvGbmp6zOMSEKCdJ6MPho2Y0llWQ9zHus=";

        nativeBuildInputs = with pkgs; [
          cargo
          rustc
        ];
      };

      hyprland-shader-chooser = pkgs.writeShellApplication {
        name = "shaders";
        runtimeInputs = with pkgs; [
          fzf
          hyprland
        ];
        text = # bash
          ''
            declare -A commands=(
            ["Normal"]="hyprctl keyword decoration:screen_shader '[[EMPTY]]'"
            ["Greyscale"]="hyprctl keyword decoration:screen_shader ~/.config/hypr/shaders/greyscale.glsl"
            ["Bluelight"]="hyprctl keyword decoration:screen_shader ~/.config/hypr/shaders/yellow.glsl"
            ["Inverted"]="hyprctl keyword decoration:screen_shader ~/.config/hypr/shaders/inverted.glsl")
            selected_label=$(printf "%s\n" "''${!commands[@]}" | fzf --prompt="Select command: ")
            if [[ -n "$selected_label" ]]; then
            eval "''${commands[$selected_label]}"
            fi
          '';
      };
    in
    [
      # groovy-language-server
      inputs.iamb.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
      mmdr
      # kalc
      hyprland-shader-chooser
      home-manager
      pamixer
      libnotify
      yt-dlp
      # (tetrio-desktop.override { withTetrioPlus = true; })
      nvidia-vaapi-driver
      gnupg
      autoconf
      procps
      gnumake
      util-linux
      m4
      gperf
      cudatoolkit
      libsForQt5.qt5ct
      kdePackages.qtwayland
      libsForQt5.qt5.qtwayland
      wget
      gcc
      tray-tui
      kitty
      hyprland
      # (floorp.override { libName = pkgs.ffmpeg; })
      firefox
      obsidian
      vesktop
      element-desktop
      rustc
      cargo
      rustfmt
      python3
      fastfetch
      networkmanagerapplet
      meson
      wayland-protocols
      wayland-utils
      wl-clipboard
      pavucontrol
      sway-launcher-desktop
      bottom
      dunst
      appimage-run
      wlogout
      jdk21
      jdk8
      auto-cpufreq
      brightnessctl
      ripgrep
      powertop
      flat-remix-gtk
      gtk3
      gtk4
      gtk2
      zsh
      zsh-powerlevel10k
      ffmpeg_7-full
      ffmpegthumbnailer
      imagemagick
      ghostscript
      grimblast
      tesseract
      swappy
      pinta
      loupe
      pandoc
      texlive.combined.scheme-full
      # musescore
      chatgpt-shell-cli
      nv-codec-headers-12
      (wrapOBS.override
        {
          obs-studio = (obs-studio.override { cudaSupport = true; });
        }
        {
          plugins = with obs-studio-plugins; [
            # distroav
            obs-vkcapture
          ];
        }
      )
      audacity
      libreoffice
      zathura
      opentabletdriver
      peaclock
      cmatrix
      nvtopPackages.full
      killall
      bat
      # LSP
      nixd
      rust-analyzer
      clang-tools
      lua-language-server
      ltex-ls
      vale-ls
      pyright
      jdt-language-server
      python313Packages.jupytext
      lua5_1
      zoxide
      openssl
      (prismlauncher.override { additionalLibs = [ glfw3-minecraft ]; })
      protonup-ng
      mangohud
      r2modman
      mesa
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
      vulkan-tools
      libva
      libva-utils
      dragon-drop
      playerctl
      zoom-us
      logisim-evolution
      osu-lazer-bin
      libimobiledevice
      davinci-resolve
      gnuplot
      ani-cli
      manga-tui
      mpv
      easyeffects
      bluez
      bluetui
      usbmuxd
    ];

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "maxdu" ];

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    package = pkgs.steam.override {
      extraPkgs =
        pkgs: with pkgs; [
          wineWowPackages.waylandFull
          alsa-lib
          atk
          cairo
          cups
          dbus
          expat
          gdk-pixbuf
          glib
          gtk3
          libxcb
          libXcursor
          libXcomposite
          libXdamage
          libXext
          libXfixes
          libXi
          libXrandr
          libXrender
          libXScrnSaver
          libXtst
          nss
          nspr
          pango
          openssl
        ];
    };
    # remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [
      vkd3d-proton
      vkd3d
      dxvk_2
      freetype
    ];
  };
  environment.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/maxdu/.steam/root/compatibilitytools.d";
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      custom =
        let

          gamemodescript = pkgs.writeShellApplication {
            name = "gamemodescript";
            runtimeInputs = with pkgs; [
              omen-rust
              auto-cpufreq
            ];
            text = # bash
              ''
                /run/wrappers/bin/omen-performance-control "$1"
                /run/wrappers/bin/auto-cpufreq --force "$1"
              '';
          };
        in
        {
          start = "${gamemodescript}/bin/gamemodescript performance && ${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${gamemodescript}/bin/gamemodescript powersave && ${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
    };

  };
  environment.variables.GAMEMODERUNEXEC = "nvidia-offload";

  ## "Drivers"

  services.usbmuxd = {
    enable = true;
  };

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  ## Powersave

  security = {
    enableWrappers = true;
    wrappers = {
      omen-performance-control = {
        source = "${omen-rust}/bin/omen-performance-control";
        setuid = true;
        setgid = true;
        owner = "root";
        group = "root";
        program = "omen-performance-control";
      };
      auto-cpufreq = {
        source = "${pkgs.auto-cpufreq}/bin/auto-cpufreq";
        setuid = true;
        setgid = true;
        owner = "root";
        group = "root";
        program = "auto-cpufreq";
      };
    };
  };

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
      };

      charger = {
        governor = "powersave";
        turbo = "auto";
      };
    };
  };

  systemd.services.rustfancontrol = {
    enable = true;
    description = "Omen fancontrol written in rust";
    serviceConfig.ExecStart = "${omen-rust}/bin/omen-rust";
    wantedBy = [ "multi-user.target" ];
  };

  services.thermald.enable = true;

  ## Fonts

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-mono
    nerd-fonts.caskaydia-cove
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];
  system.stateVersion = "23.11"; # Did you read the comment?
}
