{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  home.packages = [ ];
  home.pointerCursor = {
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
      exec = "gamemoderun tetrio";
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
    theme.package = pkgs.materia-theme;
    theme.name = "Materia-dark-compact";
    iconTheme.package = pkgs.pop-icon-theme;
    iconTheme.name = "Pop";
    cursorTheme.name = "Bibata-Modern-Ice";
    cursorTheme.size = 24;
    font.name = "CaskaydiaCove Nerd Font Mono";
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # programs.direnv = {
  #   enable = true;
  #   enableZshIntegration = true;
  #   nix-direnv.enable = true;
  # };

  programs.neovim = {
    enable = true;
    # extraLuaPackages = luaPkgs: with pkgs.luajitPackages; [ magick ];
    viAlias = true;
    vimAlias = true;
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
  wayland.windowManager.hyprland.settings =
    let

      monitorattached =
        let
          kbar = inputs.kbar.packages.${pkgs.stdenv.hostPlatform.system}.kbar;
        in
        pkgs.writeShellApplication {
          name = "monitorattached";
          runtimeInputs = with pkgs; [
            kbar
            kitty
            hyprland
            jq
            killall
          ];
          text = # bash
            ''
              MONITORS=$(hyprctl monitors -j | jq -r '.[].name')
              killall kbar -q || true
              IFS=$'\n'
              for monitor in $MONITORS
              do
              kitten panel --edge top -o window_padding_width='3 10' --lines 1 --output-name "$monitor" --name kbar ${kbar}/bin/kbar & disown
              done
            '';
        };

      acpower = pkgs.writeShellApplication {
        name = "acpower";
        runtimeInputs = with pkgs; [
          hyprland
          brightnessctl
        ];
        text = # bash
          ''
            ACPOWER=$(cat /sys/class/power_supply/ADP1/online)
            if [ "$ACPOWER" = '0' ] ; then
                hyprctl --batch "\
                    keyword animations:enabled 0;\
                    keyword decoration:drop_shadow 0;\
                    keyword decoration:blur:enabled 0;\
                    keyword general:gaps_in 0;\
                    keyword general:gaps_out 0;\
                    keyword general:border_size 1;\
                    keyword decoration:rounding 0;\
            	keyword misc:vfr 1;\
            	keyword monitor eDP-1,2560x1440@60,0x0,1.6666;\
                	keyword decoration:active_opacity 2.0;\
                	keyword decoration:inactive_opacity 2.0
            	"
                brightnessctl set 1
                exit
            else 
                brightnessctl set 50%
            fi
          '';
      };
    in
    {
      monitor = [
        "eDP-1,2560x1440@165,0x0,1.6"
        "DP-1,2560x1440@180,1600x-170,1"
        ",preffered,auto,auto"
      ];
      exec-once = [
        "${pkgs.dbus}dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP # for XDPH"
        "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all # for XDPH"
        "${pkgs.systemd}/bin/systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP # for XDPH"
        "${pkgs.dunst}/bin/dunst # start notification demon"
        "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store # clipboard store text data"
        "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store # clipboard store image data"
        "${pkgs.xsetroot}/bin/xsetroot -xcf /home/maxdu/.local/share/icons/Bibata-Modern-Ice/cursors/left_ptr 24"
        "${acpower}/bin/acpower"
        "${pkgs.hyprland}/bin/hyprctl set cursor Bibata-Modern-Ice 24"
        "${pkgs.hyprland-monitor-attached}/bin/hyprland-monitor-attached ${monitorattached}/bin/monitorattached ${monitorattached}/bin/monitorattached"
      ];
      exec = [ "bash -c \"sleep 1 && ${monitorattached}/bin/monitorattached\"" ];
      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_QPA_PLATFORM,wayland"
        "QT_STYLE_OVERRIDE,kvantum"
        "QT_QPA_PLATFORM,wayland"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "MOZ_ENABLE_WAYLAND,1"
        "NVD_BACKEND,direct"
        "HYPRCURSOR_THEME,Bibata-Modern-Ice"
        "HYPRCURSOR_SIZE,24"
        "__GL_VRR_ALLOWED,1"
        "__GL_GYSNC_ALLOWED,1"
        "SDL_VIDEODRIVER,wayland"
        "AQ_NO_ATOMIC,0"

        "LIBVA_DRIVER_NAME,nvidia"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_BACKEND, vulkan"
        "WLR_NO_HARDWARE_CURSORS,1"
        "WLR_DRM_NO_ATOMIC,1"
      ];
      opengl.nvidia_anti_flicker = false;
      cursor = {
        no_hardware_cursors = true;
        sync_gsettings_theme = true;
      };
      xwayland.force_zero_scaling = true;

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        kb_options = "altwin:swap_lalt_lwin, ctrl:nocaps";
        repeat_delay = 250;
        touchpad = {
          natural_scroll = "no";
          disable_while_typing = true;
        };
        sensitivity = 0;
        force_no_accel = 1;
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
      };
      misc = {
        animate_manual_resizes = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        middle_click_paste = false;
      };

      general = {
        gaps_in = 3;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = "rgba(98A4CEff) rgba(191A24ff) 45deg";
        "col.inactive_border" = "rgba(3C3D44ff) rgba(444380ff) 45deg";
        layout = "dwindle";
        resize_on_border = true;
      };
      group = {
        "col.border_active" = "rgba(3C3D44ff) rgba(444380ff) 45deg";
        "col.border_inactive" = "rgba(1C1D21cc) rgba(222938cc) 45deg";
        "col.border_locked_active" = "rgba(404356ff) rgba(43446Aff) 45deg";
        "col.border_locked_inactive" = "rgba(1F2128cc) rgba(202530cc) 45deg";
      };
      decoration = {
        "shadow:enabled" = false;

        blur = {
          enabled = false;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };

      windowrule = [
        "match:title ^(bluetui)$, float on"
        "match:title ^(bluetui)$, center on"
        "match:title ^(Minecraft.*)$, immediate on"
        "match:title ^(.*Cyberpunk.*)$, immediate on"
        "match:title ^(Cyberpunk 2077 (C) 2020 by CD Projekt RED)$, fullscreen on"
        "match:class ^(cs2)$, immediate on"
        "match:class ^(cs2)$, fullscreen_state 2 2, "
        "match:class ^(osu!)$, fullscreen_state 2 2, "
        "match:class ^(osu!)$, immediate on"
        "match:initial_title ^(.*FINALS.*)$, immediate on"
        "match:title ^(iamb)$, workspace name:v,"
        "match:class ^(Element)$, workspace name:v,"
        "match:class ^(vesktop)$, workspace name:v,"
        "match:class ^(qt5ct)$, float on"
        "match:class ^(nwg-look)$,float on"
        "match:class ^(org.kde.ark)$,float on"
        "match:class ^(pavucontrol)$,float on"
        "match:class ^(.blueman-manager-wrapped)$,float on"
        "match:class ^(nm-applet)$,float on"
        "match:class ^(nm-connection-editor)$,float on"
        "match:class ^(org.kde.polkit-kde-authentication-agent-1)$,float on"
        "match:title ^(.*Logisim-evolution.*)$,tile on"
        "match:class ^(Fightcade)$,tile on"
        "match:title launcher, stay_focused on"
        "match:title launcher, dim_around on"
      ];

      layerrule = [
        "match:namespace logout_dialog, dim_around on"
        "match:namespace logout_dialog, blur on"
        "match:namespace logout_dialog, animation fade"
        "match:namespace notifications, blur on"
        "match:namespace notifications, ignore_alpha 0.5"
      ];

      "$mod" = "SUPER";
      "$term" = "kitty";
      "$editor" = "nvim";
      "$file" = "kitty -o confirm_os_window_close=0 vifm";
      "$browser" = "firefox";

      bind =
        let
          toWSNumber = n: (toString (if n == 0 then 10 else n));

          movetoworkspaces = map (n: "$mod SHIFT, ${toString n}, movetoworkspace, ${toWSNumber n}") (
            lib.range 0 9
          );
          switchworkspaces = map (n: "$mod, ${toString n}, workspace, ${toWSNumber n}") (lib.range 0 9);

          kill = pkgs.writeShellApplication {
            name = "kill";
            runtimeInputs = with pkgs; [
              hyprland
              xdotool
              jq
            ];
            text = # bash
              ''
                if [[ $(hyprctl activewindow -j | jq -r ".class") == "Steam" ]]; then
                    xdotool windowunmap "$(xdotool getactivewindow)"
                else
                    hyprctl dispatch killactive ""
                fi
              '';
          };

          openiamb = pkgs.writeShellApplication {
            name = "openiamb";
            runtimeInputs = with pkgs; [
              hyprland
              jq
              inputs.iamb.packages.${pkgs.stdenv.hostPlatform.system}.default
            ];
            text = # bash
              ''
                if [[ -n $(
                hyprctl clients -j | jq '.[] | select(.class=="Element" or .title=="iamb" or .class=="vesktop")'
                ) ]] 
                then 
                hyprctl dispatch focusworkspaceoncurrentmonitor v
                else 
                hyprctl dispatch -- exec "[noinitialfocus]" kitty -o confirm_os_window_close=0 --title iamb ${
                  inputs.iamb.packages.${pkgs.stdenv.hostPlatform.system}.default
                }/bin/iamb
                fi
              '';
          };

          applauncher = pkgs.writeShellApplication {
            name = "applauncher";
            runtimeInputs = with pkgs; [
              hyprland
              sway-launcher-desktop
              jq
            ];
            text = # bash
              ''
                if [[ -n $(hyprctl clients -j | jq '.[] | select(.title=="launcher")') ]] 
                then 
                hyprctl dispatch killactive
                else 
                hyprctl dispatch exec -- "[float on; center on; size (monitor_w*0.25) (monitor_h*0.5); dim_around on; stay_focused on; pin on; ]" kitty -o confirm_os_window_close=0 --title launcher  "env FZF_DEFAULT_OPTS='--height 100% --border sharp --layout reverse --prompt \"∷ \" --pointer ▶ --marker ⇒' ${pkgs.sway-launcher-desktop}/bin/sway-launcher-desktop" 
                fi
              '';
          };

          gamemode = pkgs.writeShellApplication {
            name = "gamemode";
            runtimeInputs = with pkgs; [
              hyprland
              jq
            ];
            text = # bash
              ''
                 if [ "$(hyprctl getoption animations:enabled -j | jq '.int ==1')" == true ]; then 
                	hyprctl --batch "\
                 keyword animations:enabled 0;\
                 keyword general:gaps_in 0;\
                 keyword general:gaps_out 0;\
                 keyword general:border_size 1;\
                 keyword decoration:rounding 0;\
                 keyword decoration:active_opacity 1.5;\
                 keyword decoration:inactive_opacity 1.5
                 "
                 MONITORCHECK=$(hyprctl monitors|grep "ID 1")
                 if [ "$MONITORCHECK" != \'\' ] ; then 
                 hyprctl keyword monitor eDP-1,2560x1440@,0x0,1.6
                 else 
                 hyprctl keyword monitor eDP-1,2560x1440@165,0x0,1
                 fi
                 exit
                 fi
                 hyprctl reload
              '';
          };

        in
        [
          "$mod, Q, exec, ${kill}/bin/kill" # killactive, kill the window on focus
          "ALT, F4, exec, ${kill}/bin/kill" # killactive, kill the window on focus
          "$mod, delete, exec, pkill -f hyprland-monitor-attached"
          "$mod, delete, exit," # kill hyperland session
          "$mod, W, togglefloating," # toggle the window on focus to float
          "$mod, return, fullscreen" # toggle the window on focus to fullscreen
          "$mod SHIFT, space, fullscreenstate, 0 3 toggle" # toggle the window on focus to fake fullscreen
          "$mod, backspace, exec, wlogout" # logout menu
          "$CONTROL, ESCAPE, exec, pkill kbar || ${monitorattached}/bin/monitorattached" # toggle kbar
          "$mod, Y, togglefloating," # toggle the window on focus to float
          "$mod, Y, pin"
          "$mod, Y, resizeactive, exact 25% 25%"
          # Application shortcuts
          "$mod, T, exec, $term -1" # open terminal
          "$mod, E, exec, $file" # open file manager
          "$mod, F, exec, $browser"
          "$mod, V, exec, ${openiamb}/bin/openiamb" # open vesktop on its named workspace
          "$mod, O, exec, obsidian" # open obsidian
          "$CONTROL SHIFT, ESCAPE, exec, kitty btm" # open htop/btop if installed or default to top (system monitor)

          "$mod, A, exec, ${applauncher}/bin/applauncher"

          "$mod, G, exec, ${gamemode}/bin/gamemode" # disable hypr effects for gamemode

          "$mod, P, exec, grimblast --freeze copysave area /tmp/screenshot.png && swappy -f /tmp/screenshot.png"
          "$mod CTRL, P, exec, grimblast save area - | tesseract - - | wl-copy"

          "$mod, x, togglesplit,"

          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"
          "$mod, Tab, movefocus, d"
          "$mod SHIFT, h, movewindow, l"
          "$mod SHIFT, l, movewindow, r"
          "$mod SHIFT, k, movewindow, u"
          "$mod SHIFT, j, movewindow, d"
        ]
        ++ movetoworkspaces
        ++ switchworkspaces;

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      binde = [
        "$mod SHIFT, right, resizeactive, 30 0"
        "$mod SHIFT, left, resizeactive, -30 0"
        "$mod SHIFT, up, resizeactive, 0 -30"
        "$mod SHIFT, down, resizeactive, 0 30"
      ];

      bindl = [
        ", XF86AudioMute, exec, pamixer -t"
        "ALT, 5, exec, pamixer -t"
        ", XF86AudioMicMute, exec, pamixer -m"
        "ALT, 6, exec, pamixer -d 5"
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        " ALT, 7, exec, pamixer -i 5"
        ", XF86AudioPrev, exec, playerctl previous"
        "ALT, 8, exec, playerctl previous"
        ", XF86AudioPlay, exec, playerctl play-pause"
        "ALT, 9, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        "ALT, 0, exec, playerctl next"
        ", XF86Calculator, exec, [animation slide; float; center; size 25% 50%;] kitty -o confirm_os_window_close=0 --title calculator kalc"
        "ALT, Num_lock, exec, [animation slide; float; center; size 25% 50%;] kitty -o confirm_os_window_close=0 --title calculator kalc"
        ", switch:on:Lid Switch, exec, systemctl suspend"

        ", XF86Launch2, exec, ${acpower}/bin/acpower"
      ];

      bindel = [
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%- # decrease brightness"
        "ALT, 2, exec, brightnessctl set 5%- # decrease brightness"
        ", XF86MonBrightnessUp, exec, brightnessctl set +5% # increase brightness"
        "ALT, 3, exec, brightnessctl set +5% # increase brightness"
      ];
    };

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
