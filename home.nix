{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  home.packages = [ ];
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;

  };
  xdg.desktopEntries = {
    davinci-resolve = {
      name = "Davinci Resolve";
      genericName = "Video editor";
      exec = "env -u QT_QPA_PLATFORM nvidia-offload davinci-resolve";
      icon = "davinci-resolve";
    };
    "TETR.IO" = {
      name = "TETR.IO";
      genericName = "tetris";
      exec = "XDG_SESSION_TYPE=x11 gamemoderun tetrio";
      icon = "TETR.IO";
    };
    "com.github.wwmm.easyeffects" = {
      name = "Easy Effects";
      genericName = "Equalizer, Compressor and Other Audio Effects";
      exec = ''env GTK_THEME="" easyeffects'';
      icon = "com.github.wwmm.easyeffects";
      categories = [
        "GTK"
        "AudioVideo"
        "Audio"
      ];
    };
    "osu!" = {
      name = "osu!";
      genericName = "osu";
      exec = "gamemoderun osu!";
      icon = "osu";
    };
    "bluetui" = {
      name = "bluetui";
      genericName = "bluetooth manager";
      exec = "kitty --title bluetui bluetui";
    };
    "fcade-quark" = {
      type = "Application";
      name = "Fightcade Replay";
      exec = "steam-run /home/maxdu/Downloads/Fightcade/emulator/fcade.sh %U";
      terminal = false;
      mimeType = [ "x-scheme-handler/fcade" ];
    };
  };
  gtk = {
    enable = true;
    theme.package = pkgs.yaru-remix-theme;
    theme.name = "Yaru-remix-dark";
    iconTheme.package = pkgs.pop-icon-theme;
    iconTheme.name = "Pop";
    cursorTheme.name = "Bibata-Modern-Ice";
    cursorTheme.size = 24;
    font.name = "CaskaydiaCove Nerd Font Mono";
    gtk4 = {
      theme = null;
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };

  # programs.direnv = {
  #   enable = true;
  #   enableZshIntegration = true;
  #   nix-direnv.enable = true;
  # };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    sideloadInitLua = true;
    extraPackages = with pkgs; [
      tree-sitter
      python3Packages.jupytext
      nixd
      rust-analyzer
      clang-tools
      lua-language-server
      ltex-ls
      vale-ls
      pyright
      jdt-language-server
    ];
    withRuby = false;
    withPython3 = true;
    withNodeJs = false;
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      audio = "yt-dlp -x --audio-format mp3";
      ssh = "kitty +kitten ssh";
      dr = "dragon";
      vi = "nvim";
      update-shutdown = # bash
        ''
          sudo sh -c "cd /etc/nixos; nix flake update; nixos-rebuild switch --log-format internal-json -v |& nom --json; nix store optimise; shutdown now || shutdown now"
        '';
      update = # bash
        ''
          sudo sh -c "cd /etc/nixos; nix flake update; nixos-rebuild switch --log-format internal-json -v |& nom --json; nix store optimise;"
        '';
      rebuild = # bash
        "sudo sh -c \"nixos-rebuild switch --log-format internal-json -v |& nom --json\"\n";
      sudolazygit = "sudo -E lazygit";
      wg-dns = "nmcli connection up wg-dns; nmcli connection down wg-full";
      wg-full = "nmcli connection up wg-full; nmcli connection down wg-dns";
    };
    initContent = # bash
      ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        fastfetch --config ~/.config/fastfetch/mini.jsonc --processing-timeout 1
        export EDITOR=nvim
        ZVM_VI_INSERT_ESCAPE_BINDKEY=kj
        POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=True
      '';
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      # {
      #   name = "zsh-autocomplete";
      #   src = pkgs.zsh-autocomplete;
      #   file = "share/zsh-autocomplete/zsh-autocomplete.plugin.zsh";
      # }
    ];
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--height 60%"
      "--border sharp"
      "--layout reverse"
      "--prompt '∷ '"
      "--pointer ▶"
      "--marker ⇒"
      "--highlight-line"
      "--info=inline-right"
      "--layout=reverse"
      "--color=bg+:#283457"
      "--color=fg:#c0caf5"
      "--color=gutter:#16161e"
      "--color=header:#ff9e64"
      "--color=hl+:#2ac3de"
      "--color=hl:#2ac3de"
      "--color=info:#545c7e"
      "--color=marker:#ff007c"
      "--color=pointer:#ff007c"
      "--color=prompt:#2ac3de"
      "--color=query:#c0caf5:regular"
      "--color=scrollbar:#27a1b9"
      "--color=separator:#ff9e64"
      "--color=spinner:#ff007c"
    ];
    enableZshIntegration = true;
  };
  programs.kitty = {
    enable = true;
    font.name = "CaskaydiaCove Nerd Font Mono";
    font.size = 9.0;
    shellIntegration.enableZshIntegration = true;
    settings = {
      window_padding_width = 25;
      foreground = "#c0caf5";
      background = "#000000";
      color0 = "#15161e";
      color1 = "#f7768e";
      color2 = "#9ece6a";
      color3 = "#e0af68";
      color4 = "#7aa2f7";
      color5 = "#bb9af7";
      color6 = "#7dcfff";
      color7 = "#a9b1d6";

      color8 = "#414868";
      color9 = "#ff899d";
      color10 = "#9fe044";
      color11 = "#faba4a";
      color12 = "#8db0ff";
      color13 = "#c7a9ff";
      color14 = "#a4daff";
      color15 = "#c0caf5";
      selection_background = "#283457";
      selection_foreground = "#c0caf5";
      url_color = "#73daca";
      cursor = "#c0caf5";
      cursor_text_color = "#1a1b26";

      active_tab_background = "#7aa2f7";
      active_tab_foreground = "#16161e";
      inactive_tab_background = "#292e42";
      inactive_tab_foreground = "#545c7e";
      tab_bar_background = "#15161e";

      active_border_color = "#7aa2f7";
      inactive_border_color = "#292e42";
      tab_bar_style = "fade";
      tab_fade = "1";
      active_tab_font_style = "bold";
      inactive_tab_font_style = "bold";
      macos_titlebar_color = "#16161e";
      wayland_enable_ime = "no";
      #sync_to_monitor = "yes";
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";
      shell_integration = "enabled";
      cursor_trail = 1;
      enable_audio_bell = "no";
      visual_bell_duration = 0.1;
      remember_window_size = "no";
    };
    extraConfig = ''
      action_alias kitty_scrollback_nvim kitten /home/maxdu/.local/share/nvim/lazy/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py
      			'';
    keybindings = {
      "kitty_mod+h" = "kitty_scrollback_nvim";
      "kitty_mod+g" = "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";
    };
  };
  programs.wlogout = {
    enable = true;
    style = # css
      ''
          * {
        	background-image: none;
          }
          window {
        	background-color: rgba(12, 12, 12, 0.0);
          }
          button {
              color: #6F87E0;
        	background-color: rgba(0, 0, 0, 0.8);
        	/* border-style: solid;
        	border-width: 2px; */
        	background-repeat: no-repeat;
        	background-position: center;
        	background-size: 25%;
          }

          button:focus, button:active, button:hover {
        	color: #000000;
        	background-color: #6F87E0;
        	outline-style: none;
          }

          #lock { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png")); }

          #logout { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png")); }

          #suspend { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png")); }

          #hibernate { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png")); }

          #shutdown { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png")); }

          #reboot { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png")); }
        	    '';
  };
  programs.firefox = {
    configPath = ".mozilla/firefox";
    enable = true;
    languagePacks = [ "en-US" ];
    profiles.default.settings = {
      "privacy.resistFingerprinting" = false;
      "widget.use-xdg-desktop-portal.file-picker" = 1;
      "sidebar.verticalTabs" = true;
      "sidebar.revamp" = true;
      "layout.css.prefers-color-scheme.content-override" = 0;
      "dom.enable_user_timing" = false;
      "dom.webaudio.enabled" = false;
      "geo.enabled" = false;
      "geo.wifi.uri" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
      "dom.netinfo.enabled" = false;
      "dom.telephony.enabled" = false;
      "beacon.enabled" = false;
      "media.webspeech.recognition.enable" = false;
      "media.webspeech.synth.enabled" = false;
      "device.sensors.enabled" = false;
      "browser.send_pings.require_same_host" = true;
      "dom.gamepad.enabled" = false;
      "dom.vr.enabled" = false;
      "dom.vibrator.enabled" = false;
      "webgl.min_capability_mode" = true;
      "dom.maxHardwareConcurrency" = 2;
      "camera.control.face_detection.enabled" = false;
      "browser.search.countryCode" = "US";
      "browser.search.region" = "US";
      "browser.search.geoip.url" = "";
      "intl.accept_languages" = "en-US, en";
      "browser.search.geoSpecificDefaults" = false;
      "javascript.use_us_english_locale" = true;
      "browser.urlbar.trimURLs" = false;
      "security.fileuri.strict_origin_policy" = true;
      "browser.urlbar.filter.javascript" = true;
      "media.video_stats.enabled" = false;
      "general.buildID.override" = "20100101";
      "browser.startup.homepage_override.buildID" = "20100101";
      "browser.display.use_document_fonts" = 0;
      "extensions.blocklist.enabled" = true;
      "services.blocklist.update_enabled" = true;
      "extensions.blocklist.url" =
        "https://blocklist.addons.mozilla.org/blocklist/3/%APP_ID%/%APP_VERSION%/";
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr" = false;
      "devtools.webide.enabled" = false;
      "devtools.webide.autoinstallADBHelper" = false;
      "devtools.webide.autoinstallFxdtAdapters" = false;
      "devtools.debugger.remote-enabled" = false;
      "devtools.chrome.enabled" = false;
      "devtools.debugger.force-local" = true;
      "toolkit.telemetry.enabled" = false;
      "toolkit.telemetry.unified" = false;
      "toolkit.telemetry.archive.enabled" = false;
      "experiments.supported" = false;
      "experiments.enabled" = false;
      "experiments.manifest.uri" = "";
      "network.allow-experiments" = false;
      "breakpad.reportURL" = "";
      "browser.tabs.crashReporting.sendReport" = false;
      "browser.crashReports.unsubmittedCheck.enabled" = false;
      "dom.flyweb.enabled" = false;
      "browser.uitour.enabled" = false;
      "privacy.trackingprotection.enabled" = true;
      "privacy.trackingprotection.pbmode.enabled" = true;
      "privacy.userContext.enabled" = true;
      "network.prefetch-next" = false;
      "network.dns.disablePrefetch" = true;
      "network.dns.disablePrefetchFromHTTPS" = true;
      "network.predictor.enabled" = false;
      "network.http.speculative-parallel-limit" = 0;
      "browser.aboutHomeSnippets.updateUrl" = "";
      "browser.search.update" = false;
      "security.csp.experimentalEnabled" = true;
      "security.csp.enable" = true;
      "security.sri.enable" = true;
      "network.cookie.thirdparty.sessionOnly" = true;
      "privacy.clearOnShutdown.cookies" = true;
      "privacy.clearOnShutdown.offlineApps" = true;
      "browser.sessionstore.privacy_level" = 2;
      "browser.helperApps.deleteTempFileOnExit" = true;
      "browser.pagethumbnails.capturing_disabled" = true;
      "security.tls.enable_kyber" = true;
      "browser.ai.control.default" = "blocked";
      "browser.ai.control.linkPreviewKeyPoints" = "blocked";
      "browser.ai.control.pdfjsAltText" = "blocked";
      "browser.ai.control.sidebarChatbot" = "blocked";
      "browser.ai.control.smartTabGroups" = "blocked";
    };
    policies = {
      AppAutoUpdate = false;
      BackgroundAppUpdate = false;

      DisableBuiltinPDFViewer = false;
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxScreenshots = true;
      DisableForgetButton = true;
      DisableMasterPasswordCreation = true;
      DisableProfileImport = true;
      DisableProfileRefresh = true;
      DisableSetDesktopBackground = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFormHistory = true;
      DisablePasswordReveal = true;

      # Access Restrictions
      BlockAboutConfig = false;
      BlockAboutProfiles = true;
      BlockAboutSupport = true;

      # UI and Behavior
      DisplayMenuBar = "never";
      DontCheckDefaultBrowser = true;
      HardwareAcceleration = true;
      OfferToSaveLogins = false;

    };

    profiles.default.search = {
      force = true;
      default = "ddg";
      privateDefault = "ddg";

      engines = {
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };

        "Nix Options" = {
          urls = [
            {
              template = "https://search.nixos.org/options";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@no" ];
        };

        "NixOS Wiki" = {
          urls = [
            {
              template = "https://wiki.nixos.org/w/index.php";
              params = [
                {
                  name = "search";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@nw" ];
        };
      };
    };

  };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.package = null;
  wayland.windowManager.hyprland.portalPackage = null;
  wayland.windowManager.hyprland.configType = "lua";
  wayland.windowManager.hyprland.xdph.settings.screencopy.force_shm = true;

  wayland.windowManager.hyprland.extraConfig =
    let
			kbar = inputs.kbar.packages.${pkgs.stdenv.hostPlatform.system}.kbar;
      iamb = inputs.iamb.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    # lua
    ''
      ---------------------------------------------------------------------------
      -- Paths from the Nix store
      ---------------------------------------------------------------------------
      local hyprctl         = "${pkgs.hyprland}/bin/hyprctl"
      local brightnessctl   = "${pkgs.brightnessctl}/bin/brightnessctl"
      local xdotool         = "${pkgs.xdotool}/bin/xdotool"
      local iamb            = "${iamb}/bin/iamb"
      local sway_launcher   = "${pkgs.sway-launcher-desktop}/bin/sway-launcher-desktop"

      ---------------------------------------------------------------------------
      -- Variables
      ---------------------------------------------------------------------------
      local mod     = "SUPER"
      local term    = "kitty"
      local file    = "kitty -o confirm_os_window_close=0 vifm"
      local browser = "firefox"

      ---------------------------------------------------------------------------
      -- Monitors
      ---------------------------------------------------------------------------
      hl.monitor({ output = "eDP-1", mode = "2560x1440@165", position = "0x0",       scale = 1.6 })
      hl.monitor({ output = "DP-1",  mode = "2560x1440@180", position = "1600x-170", scale = 1 })
      hl.monitor({ output = "",      mode = "preferred",     position = "auto",      scale = "auto" })

      ---------------------------------------------------------------------------
      -- Environment
      ---------------------------------------------------------------------------
      hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
      hl.env("XDG_SESSION_TYPE", "wayland")
      hl.env("XDG_SESSION_DESKTOP", "Hyprland")
      hl.env("QT_QPA_PLATFORM", "wayland")
      hl.env("QT_STYLE_OVERRIDE", "kvantum")
      hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
      hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
      hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
      hl.env("MOZ_ENABLE_WAYLAND", "1")
      hl.env("NVD_BACKEND", "direct")
      hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
      hl.env("HYPRCURSOR_SIZE", "24")
      hl.env("__GL_VRR_ALLOWED", "1")
      hl.env("__GL_GSYSNC_ALLOWED", "1")
      hl.env("SDL_VIDEODRIVER", "wayland")
      hl.env("AQ_NO_ATOMIC", "0")

      hl.env("LIBVA_DRIVER_NAME", "nvidia")
      hl.env("GBM_BACKEND", "nvidia-drm")
      hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
      hl.env("WLR_BACKEND", "vulkan")
      hl.env("WLR_NO_HARDWARE_CURSORS", "1")
      hl.env("WLR_DRM_NO_ATOMIC", "1")

      ---------------------------------------------------------------------------
      -- Config
      ---------------------------------------------------------------------------
      hl.config({
        opengl = { nvidia_anti_flicker = false },

        cursor = {
          no_hardware_cursors = true,
          sync_gsettings_theme = true,
        },

        xwayland = { force_zero_scaling = true },

        input = {
          kb_layout = "us",
          kb_options = "altwin:swap_lalt_lwin, ctrl:nocaps",
          follow_mouse = 1,
          repeat_delay = 250,
          sensitivity = 0,
          force_no_accel = true,
          touchpad = {
            natural_scroll = false,
            disable_while_typing = true,
          },
        },

        dwindle = {
          -- pseudotile = true,
          preserve_split = true,
        },

        misc = {
          animate_manual_resizes = true,
          disable_hyprland_logo = true,
          disable_splash_rendering = true,
          middle_click_paste = false,
        },

        general = {
          gaps_in = 3,
          gaps_out = 8,
          border_size = 2,
          col = {
            active_border   = { colors = { "rgba(98A4CEff)", "rgba(191A24ff)" }, angle = 45 },
            inactive_border = { colors = { "rgba(3C3D44ff)", "rgba(444380ff)" }, angle = 45 },
          },
          layout = "dwindle",
          resize_on_border = true,
        },

        group = {
          col = {
            border_active          = { colors = { "rgba(3C3D44ff)", "rgba(444380ff)" }, angle = 45 },
            border_inactive        = { colors = { "rgba(1C1D21cc)", "rgba(222938cc)" }, angle = 45 },
            border_locked_active   = { colors = { "rgba(404356ff)", "rgba(43446Aff)" }, angle = 45 },
            border_locked_inactive = { colors = { "rgba(1F2128cc)", "rgba(202530cc)" }, angle = 45 },
          },
        },

        decoration = {
          shadow = { enabled = false },
          blur   = { enabled = false },
        },

        animations = { enabled = true },
      })

      ---------------------------------------------------------------------------
      -- Animations
      ---------------------------------------------------------------------------
      hl.curve("wind",   { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
      hl.curve("winIn",  { type = "bezier", points = { { 0.1, 1.1 },  { 0.1, 1.1 } } })
      hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
      hl.curve("liner",  { type = "bezier", points = { { 1, 1 },      { 1, 1 } } })

      hl.animation({ leaf = "windows",     enabled = true, speed = 6,  bezier = "wind",   style = "slide" })
      hl.animation({ leaf = "windowsIn",   enabled = true, speed = 6,  bezier = "winIn",  style = "slide" })
      hl.animation({ leaf = "windowsOut",  enabled = true, speed = 5,  bezier = "winOut", style = "slide" })
      hl.animation({ leaf = "windowsMove", enabled = true, speed = 5,  bezier = "wind",   style = "slide" })
      hl.animation({ leaf = "border",      enabled = true, speed = 1,  bezier = "liner" })
      hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "liner",  style = "loop" })
      hl.animation({ leaf = "fade",        enabled = true, speed = 10, bezier = "default" })
      hl.animation({ leaf = "workspaces",  enabled = true, speed = 5,  bezier = "wind" })

      ---------------------------------------------------------------------------
      -- Window rules
      ---------------------------------------------------------------------------
      hl.window_rule({ match = { title = "^(bluetui)$" }, float = true, center = true })

      -- Games
      hl.window_rule({ match = { title = "^(Minecraft.*)$" }, immediate = true })
      hl.window_rule({ match = { title = "^(.*Cyberpunk.*)$" }, immediate = true })
      hl.window_rule({ match = { title = "^(Cyberpunk 2077 (C) 2020 by CD Projekt RED)$" }, fullscreen = true })
      hl.window_rule({ match = { class = "^(cs2)$" }, immediate = true, fullscreen_state = "2 2" })
      hl.window_rule({ match = { class = "^(osu!)$" }, immediate = true, fullscreen_state = "2 2" })
      hl.window_rule({ match = { initial_title = "^(.*FINALS.*)$" }, immediate = true })

      -- Chat apps live on workspace "v"
      hl.window_rule({ match = { title = "^(iamb)$" }, workspace = "name:v" })
      hl.window_rule({ match = { initial_title = "^(Element)$" }, workspace = "name:v" })
      hl.window_rule({ match = { class = "^(vesktop)$" }, workspace = "name:v" })

      -- Floating utilities
      hl.window_rule({
        match = {
          class = "^(qt5ct|nwg-look|org.kde.ark|pavucontrol|.blueman-manager-wrapped|nm-applet|nm-connection-editor|org.kde.polkit-kde-authentication-agent-1)$",
        },
        float = true,
      })

      hl.window_rule({ match = { title = "^(.*Logisim-evolution.*)$" }, tile = true })
      hl.window_rule({ match = { class = "^(Fightcade)$" }, tile = true })

      -- App launcher (see app_launcher below)
      hl.window_rule({ match = { title = "launcher" }, stay_focused = true, dim_around = true })

      -- Keil uVision popups
      hl.window_rule({
        match = { class = "^(uv4.exe)$", title = "^()$" },
        float = true,
        size = "0 0",
        opacity = "0",
        no_anim = true,
      })
      hl.window_rule({ match = { class = "^(uv4.exe)$", title = "^(SECSplashWnd)$" }, float = true })

      ---------------------------------------------------------------------------
      -- Layer rules
      ---------------------------------------------------------------------------
      hl.layer_rule({ match = { namespace = "logout_dialog" }, dim_around = true, blur = true, animation = "fade" })
      hl.layer_rule({ match = { namespace = "notifications" }, blur = true, ignore_alpha = 0.5 })

      ---------------------------------------------------------------------------
      -- Autostart
      ---------------------------------------------------------------------------
      hl.on("hyprland.start", function()
        -- for XDPH
        hl.exec_cmd("${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
        hl.exec_cmd("${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all")
        hl.exec_cmd("${pkgs.systemd}/bin/systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

        hl.exec_cmd("${pkgs.dunst}/bin/dunst") -- notification daemon

        -- clipboard history
        hl.exec_cmd("${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store")
        hl.exec_cmd("${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store")

        hl.exec_cmd("${pkgs.xsetroot}/bin/xsetroot -xcf /home/maxdu/.local/share/icons/Bibata-Modern-Ice/cursors/left_ptr 24")
        hl.exec_cmd(hyprctl .. " setcursor Bibata-Modern-Ice 24")

        ac_power()

      end)

			hl.on("monitor.added", function(m)
				hl.exec_cmd(
              "kitten panel --edge top -o window_padding_width='3 10' --lines 1 --output-name '" .. m.name .. "' --name kbar ${kbar}/bin/kbar & disown"
				)
			end)

      ---------------------------------------------------------------------------
      -- Helper functions (replace the old shell scripts)
      ---------------------------------------------------------------------------

      -- Battery / AC profile. Called at startup and by XF86Launch2.
      function ac_power()
        local f = io.open("/sys/class/power_supply/ADP1/online", "r")
        local online = f and f:read("*l") or "1"
        if f then f:close() end

        if online == "0" then
          hl.config({
            animations = { enabled = false },
            general    = { gaps_in = 0, gaps_out = 0, border_size = 1 },
            decoration = {
              rounding = 0,
              active_opacity = 2.0,
              inactive_opacity = 2.0,
              shadow = { enabled = false },
              blur   = { enabled = false },
            },
            misc = { vfr = true },
          })
          hl.monitor({ output = "eDP-1", mode = "2560x1440@60", position = "0x0", scale = 1.6666 })
          hl.exec_cmd(brightnessctl .. " set 1")
        else
          hl.exec_cmd(brightnessctl .. " set 50%")
        end
      end

      -- Gamemode toggle: strip effects, or `hyprctl reload` to restore.
      local gamemode_on = false
      local function gamemode()
        if gamemode_on then
          gamemode_on = false
          hl.exec_cmd(hyprctl .. " reload")
          return
        end

        gamemode_on = true
        hl.config({
          animations = { enabled = false },
          general    = { gaps_in = 0, gaps_out = 0, border_size = 1 },
          decoration = { rounding = 0, active_opacity = 1, inactive_opacity = 1 },
        })

        if #hl.get_monitors() > 1 then
          hl.monitor({ output = "eDP-1", mode = "2560x1440", position = "0x0", scale = 1.6 })
        else
          hl.monitor({ output = "eDP-1", mode = "2560x1440@165", position = "0x0", scale = 1 })
        end
      end

      -- Steam is hidden instead of killed.
      local function kill_active()
        local win = hl.get_active_window()
        if win and win.class == "Steam" then
          hl.exec_cmd(xdotool .. " windowunmap \"$(" .. xdotool .. " getactivewindow)\"")
        else
          hl.dispatch(hl.dsp.window.close())
        end
      end

      -- Focus the chat workspace if any chat client is open, otherwise start iamb.
      local function open_iamb()
        local found = false
        for _, w in ipairs(hl.get_windows()) do
          if w.initial_title == "Element" or w.title == "iamb" or w.class == "vesktop" then
            found = true
            break
          end
        end

        if found then
          hl.dispatch(hl.dsp.focus({ workspace = "name:v", on_current_monitor = true }))
        else
          hl.exec_cmd(
            "kitty -o confirm_os_window_close=0 --title iamb " .. iamb,
            { no_initial_focus = true }
          )
        end
      end

      -- Toggle the floating sway-launcher-desktop window.
      local function app_launcher()
        local open = false
        for _, w in ipairs(hl.get_windows()) do
          if w.title == "launcher" then
            open = true
            break
          end
        end

        if open then
          hl.dispatch(hl.dsp.window.close())
        else
          hl.exec_cmd(
						[=[kitty -o confirm_os_window_close=0 --title launcher env FZF_DEFAULT_OPTS='--height 100% --border sharp --layout reverse --prompt "∷ " --pointer ▶ --marker ⇒' ]=] .. sway_launcher,
            {
              float = true,
              center = true,
              size = "(monitor_w*0.25) (monitor_h*0.5)",
              dim_around = true,
              stay_focused = true,
              pin = true,
            }
          )
        end
      end

      local function quit_session()
        hl.dispatch(hl.dsp.exit())
      end

      -- Float + pin + shrink to 25% (picture-in-picture style)
      local function pip()
        hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
        hl.dispatch(hl.dsp.window.pin({ action = "toggle" }))
				local mon = hl.get_active_monitor()
				local w = math.floor(mon.width / mon.scale * 0.25)
				local h = math.floor(mon.height / mon.scale * 0.25)
				hl.dispatch(hl.dsp.window.resize({ x = w, y = h, relative = false }))
      end

			local function toggle_kbar()
				local layers = hl.get_layers()
				for _, l in pairs(layers) do
					if l.namespace == "kitty-panel" then
						hl.exec_cmd("killall kbar")
						return
					end
				end
				local monitors = hl.get_monitors()
				for _, m in pairs(monitors) do
					hl.exec_cmd("kitten panel --edge top -o window_padding_width='3 10' --lines 1 --output-name '" .. m.name .. "' --name kbar /nix/store/3lq7r8j8rzn5vpdkhhj0jfkd84i3jfhl-kbar/bin/kbar & disown")
				end
			end

      ---------------------------------------------------------------------------
      -- Binds
      ---------------------------------------------------------------------------
      hl.bind(mod .. " + Q", kill_active)
      hl.bind("ALT + F4", kill_active)
      hl.bind(mod .. " + delete", quit_session)
      hl.bind(mod .. " + W", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mod .. " + return", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
      hl.bind(mod .. " + SHIFT + space", hl.dsp.window.fullscreen_state({ internal = 0, client = 3, action = "toggle" })) -- fake fullscreen
      hl.bind(mod .. " + backspace", hl.dsp.exec_cmd("wlogout"))
      hl.bind("CTRL + ESCAPE", toggle_kbar)
      hl.bind(mod .. " + Y", pip)

      -- Applications
      hl.bind(mod .. " + T", hl.dsp.exec_cmd(term .. " -1"))
      hl.bind(mod .. " + E", hl.dsp.exec_cmd(file))
      hl.bind(mod .. " + F", hl.dsp.exec_cmd(browser))
      hl.bind(mod .. " + V", open_iamb)
      hl.bind(mod .. " + O", hl.dsp.exec_cmd("obsidian"))
      hl.bind("CTRL + SHIFT + ESCAPE", hl.dsp.exec_cmd("kitty btm"))
      hl.bind(mod .. " + A", app_launcher)
      hl.bind(mod .. " + G", gamemode)

      -- Screenshots / OCR
      hl.bind(mod .. " + P", hl.dsp.exec_cmd("grimblast --freeze copysave area /tmp/screenshot.png && swappy -f /tmp/screenshot.png"))
      hl.bind(mod .. " + CTRL + P", hl.dsp.exec_cmd("grimblast save area - | tesseract - - | wl-copy"))

      hl.bind(mod .. " + X", hl.dsp.layout("togglesplit"))

      -- Workspace scrolling
      hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

      -- Focus / move (vim keys)
      hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
      hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
      hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
      hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))
      hl.bind(mod .. " + Tab", hl.dsp.focus({ direction = "down" }))
      hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
      hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
      hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
      hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

      hl.bind(mod .. " + space", hl.dsp.workspace.swap_monitors({ monitor1 = 0, monitor2 = 1 }))
      hl.bind(mod .. " + SHIFT + V", hl.dsp.window.move({ workspace = "name:v" }))

      -- Workspaces 1-9, with 0 mapped to workspace 10
      for i = 0, 9 do
        local ws = (i == 0) and 10 or i
        hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = ws }))
        hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = ws, on_current_monitor = true }))
      end

      -- Mouse (bindm)
      hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- Resize (binde)
      hl.bind(mod .. " + SHIFT + right", hl.dsp.window.resize({ x = 30,  y = 0,   relative = true }), { repeating = true })
      hl.bind(mod .. " + SHIFT + left",  hl.dsp.window.resize({ x = -30, y = 0,   relative = true }), { repeating = true })
      hl.bind(mod .. " + SHIFT + up",    hl.dsp.window.resize({ x = 0,   y = -30, relative = true }), { repeating = true })
      hl.bind(mod .. " + SHIFT + down",  hl.dsp.window.resize({ x = 0,   y = 30,  relative = true }), { repeating = true })

      -- Locked binds (bindl)
      local calc_rules = { animation = "slide", float = true, center = true, size = "25% 50%" }
      local calc_cmd   = "kitty -o confirm_os_window_close=0 --title calculator qalc"

      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"), { locked = true })
      hl.bind("ALT + 5", hl.dsp.exec_cmd("pamixer -t"), { locked = true })
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pamixer -m"), { locked = true })
      hl.bind("ALT + 6", hl.dsp.exec_cmd("pamixer -d 5"), { locked = true })
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"), { locked = true })
      hl.bind("ALT + 7", hl.dsp.exec_cmd("pamixer -i 5"), { locked = true })
      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
      hl.bind("ALT + 8", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("ALT + 9", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
      hl.bind("ALT + 0", hl.dsp.exec_cmd("playerctl next"), { locked = true })
      hl.bind("XF86Calculator", hl.dsp.exec_cmd(calc_cmd, calc_rules), { locked = true })
      hl.bind("ALT + Num_Lock", hl.dsp.exec_cmd(calc_cmd, calc_rules), { locked = true })
      hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("systemctl suspend"), { locked = true })
      hl.bind("XF86Launch2", ac_power, { locked = true })

      -- Locked + repeating (bindel)
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
      hl.bind("ALT + 2", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), { locked = true, repeating = true })
      hl.bind("ALT + 3", hl.dsp.exec_cmd("brightnessctl set +5%"), { locked = true, repeating = true })
    '';

  services.hyprpaper = {
    enable = true;
    settings = {
      wallpaper = [
        {
          monitor = "";
          path = "/home/maxdu/Pictures/wallpaper.jpg";
          fit_mode = "cover";
        }
      ];
      splash = false;
    };
  };

  home.stateVersion = "23.11"; # Did you read the comment?
}
