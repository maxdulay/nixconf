{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {
    "net.ipv6.conf.all.forwarding" = true;
    "net.ipv4.ip_forward" = 1;
  };

  age.secrets = {
    "ddclientpass".file = ../secrets/ddclientpass.age;
    "wg-server-private".file = ../secrets/wg-server-private.age;
    "wg-client1-preshared".file = ../secrets/wg-client1-preshared.age;
    "wg-client2-preshared".file = ../secrets/wg-client2-preshared.age;
    "wg-client3-preshared".file = ../secrets/wg-client3-preshared.age;
    "wg-client4-preshared".file = ../secrets/wg-client4-preshared.age;
    "wg-client5-preshared".file = ../secrets/wg-client5-preshared.age;
    "wg-client6-preshared".file = ../secrets/wg-client6-preshared.age;
    "wg-client7-preshared".file = ../secrets/wg-client7-preshared.age;
    "wg-full-preshared".file = ../secrets/wg-full-preshared.age;
    "wg-dns-preshared".file = ../secrets/wg-dns-preshared.age;
    "livekitsecret".file = ../secrets/livekitsecret.age;
    "livekitkey".file = ../secrets/livekitkey.age;
    "livekitkeyfile".file = ../secrets/livekitkeyfile.age;
    "matrix-registration-secret" = {
      file = ../secrets/matrix-registration-secret.age;
      owner = "matrix-synapse";
      group = "matrix-synapse";
    };
  };

  networking.hostName = "nixserver"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  system.autoUpgrade = {
    enable = true;
    dates = "2:00";
    randomizedDelaySec = "45min";
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  fileSystems."/media/hdd" = {
    device = "/dev/disk/by-uuid/bd72103a-4bc8-4076-b3bb-ec6e0e24586d";
    neededForBoot = false;
    options = [ "nofail" ];
  };

  # Enable networking
  networking.networkmanager.enable = false;
  networking.nameservers = [ "127.0.0.1" ];
  services.adguardhome = {
    enable = true;
    settings = {
      host = "10.0.1.100";
      # host = "0.0.0.0";
      http = {
        # You can select any ip and port, just make sure to open firewalls where needed
        address = "10.0.1.100:3000";
      };
      dns = {
        upstream_dns = [ "127.0.0.1:5335" ];
        # upstream_dns = [ "1.1.1.1" ];
        fallback_dns = [
          "1.1.1.1"
          "8.8.8.8"
        ];
        # upstream_dns = [ "1.1.1.1" ];
        bind_hosts = [
          "127.0.0.1"
          "10.0.1.100"
        ];
        # bind_hosts = [ "0.0.0.0" ];
        ratelimit = 0;
      };
      filtering = {
        protection_enabled = true;
        filtering_enabled = true;

        parental_enabled = false; # Parental control-based DNS requests filtering.
        safe_search = {
          enabled = false; # Enforcing "Safe search" option for search engines, when possible.
        };
      };
      # The following notation uses map
      # to not have to manually create {enabled = true; url = "";} for every filter
      # This is, however, fully optional
      filters =
        map
          (url: {
            enabled = true;
            url = url;
          })
          [
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # malicious url blocklist
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_7.txt"
          ];
    };
  };

  services.ddclient = {
    enable = true;
    verbose = true;
    interval = "5m";
    protocol = "cloudflare";
    usev4 = "webv4, webv4=ipify-ipv4";
    usev6 = "webv6, webv6=ipify-ipv6";
    zone = "dulaym.ax";
    domains = [
      "immich.dulaym.ax"
      "dulaym.ax"
      "matrix.dulaym.ax"
      "livekit.dulaym.ax"
      "bridge.dulaym.ax"
    ];
    username = "token";
    passwordFile = config.age.secrets."ddclientpass".path;
  };

  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "enp4s0";
    internalInterfaces = [
      "ve-+"
      "wg0"
    ];
  };

  # networking = {
  #   interfaces."br0".ipv4.addresses = [{
  #     address = "192.168.100.3";
  #     prefixLength = 24;
  #   }];
  # };
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [
        "10.0.0.1/24"
        "fd42:dead:beef::1/64"
      ];
      listenPort = 47111;
      privateKeyFile = config.age.secrets."wg-server-private".path;
      dns = [ "10.0.1.100" ];

      preUp = ''
        iptables -I FORWARD 1 -i enp4s0 -o wg0 -j ACCEPT;
        iptables -I FORWARD 1 -i wg0 -o enp4s0 -j ACCEPT;
        iptables -t nat -I POSTROUTING 1 -s 10.0.0.0/24 -o enp4s0 -j MASQUERADE;
        iptables -I INPUT 1 -i wg0 -j ACCEPT
      '';
      postDown = ''
        iptables -t nat -D POSTROUTING 1 -s 10.0.0.0/24 -o enp4s0 -j MASQUERADE;
        iptables -D FORWARD 1 -i enp4s0 -o wg0 -j ACCEPT;
        iptables -D FORWARD 1 -i wg0 -o enp4s0 -j ACCEPT;
        iptables -D INPUT 1 -i wg0 -j ACCEPT
      '';
      peers = [
        {
          publicKey = "l0GYHM5l7SDvyumnMBPEZzcBqnWHZtiXx3UqJ5vQiQo=";
          presharedKeyFile = config.age.secrets."wg-client1-preshared".path;
          allowedIPs = [ "10.0.0.2/32" ];
        }
        {
          publicKey = "MlXf/7/rUSnQt/H221hqT2HqlcfVIwA4lJQZrP3QBig=";
          presharedKeyFile = config.age.secrets."wg-client2-preshared".path;
          allowedIPs = [ "10.0.0.3/32" ];
        }
        {
          publicKey = "FxcoxEMW22Rf63vdPcgbnTXgvL4UYZWsQPzdZ8BifiE=";
          presharedKeyFile = config.age.secrets."wg-client3-preshared".path;
          allowedIPs = [ "10.0.0.4/32" ];
        }
        {
          publicKey = "L95ZCKqz7zTt3RjvGGcLVrQ5MAjBzLt1L8IsThJMQiE=";
          presharedKeyFile = config.age.secrets."wg-client4-preshared".path;
          allowedIPs = [ "10.0.0.5/32" ];
        }
        {
          publicKey = "CeTn5MOFnBwelxewfjgJWPLSMVad5HU9aZcC6cVPxCg=";
          presharedKeyFile = config.age.secrets."wg-client5-preshared".path;
          allowedIPs = [ "10.0.0.6/32" ];
        }
        {
          publicKey = "tF51wsjjj7LJX1qtItpk0eg8a6LwkEgcpsAqQc/+gXM=";
          presharedKeyFile = config.age.secrets."wg-client6-preshared".path;
          allowedIPs = [ "10.0.0.7/32" ];
        }
        {
          publicKey = "RnXrjhI3SK1rRo2RsVPZj313QiOprAMOcn270sLuz0M=";
          presharedKeyFile = config.age.secrets."wg-client7-preshared".path;
          allowedIPs = [ "10.0.0.8/32" ];
        }
        {
          publicKey = "cE8HWZJJ+u4diBGgDgFbeKnp3bkHDFB/77/J5/EkBjk=";
          presharedKeyFile = config.age.secrets."wg-dns-preshared".path;
          allowedIPs = [
            "10.0.0.9/32"
            "fd42:dead:beef::9/128"
          ];
        }
        {
          publicKey = "+5pDy3qGmaGFx5dvRBNptOiTvf+Es9tuEabejL5XmlA=";
          presharedKeyFile = config.age.secrets."wg-full-preshared".path;
          allowedIPs = [
            "10.0.0.10/32"
            "fd42:dead:beef::10/64"
          ];
        }
      ];
    };
  };

  services.unbound = {
    enable = true;
    settings = {
      server = {
        # When only using Unbound as DNS, make sure to replace 127.0.0.1 with your ip address
        # When using Unbound in combination with pi-hole or Adguard, leave 127.0.0.1, and point Adguard to 127.0.0.1:PORT
        interface = [ "127.0.0.1" ];
        port = 5335;
        access-control = [ "127.0.0.1 allow" ];
        # Based on recommended settings in https://docs.pi-hole.net/guides/dns/unbound/#configure-unbound
        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        prefetch = true;
        edns-buffer-size = 1232;

        # Custom settings
        hide-identity = true;
        hide-version = true;
      };
      # forward-zone = [
      #   # Example config with quad9
      #   {
      #     name = ".";
      #     forward-addr =
      #       [ "9.9.9.9#dns.quad9.net" "149.112.112.112#dns.quad9.net" ];
      #     forward-tls-upstream = true; # Protected DNS
      #   }
      # ];
    };
  };

  services.postgresql.enable = true;

  security.acme = {
    acceptTerms = true;
    defaults.email = "maxdulay@gmail.com";
  };

  systemd.services.lk-jwt-server = {
    enable = true;
    description = "LiveKit Token Management Service";
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.lk-jwt-service}/bin/lk-jwt-service";
    };

    environment = {
      LIVEKIT_URL = "wss://livekit.dulaym.ax:443";
      LIVEKIT_SECRET_FROM_FILE = config.age.secrets."livekitsecret".path;
      LIVEKIT_KEY_FROM_FILE = config.age.secrets."livekitkey".path;
      LIVEKIT_JWT_PORT = "8080";
      LIVEKIT_LOCAL_HOMESERVERS = "dulaym.ax";
    };
    wantedBy = [ "multi-user.target" ];

  };

  systemd.services.livekit =
    let
      livekitConfig = (pkgs.formats.yaml { }).generate "config.yaml" {
        port = 7880;
        bind_addresses = [ "0.0.0.0" ];
        rtc = {
          tcp_port = 7881;
          port_range_start = 50100;
          port_range_end = 50200;
          use_external_ip = true;
          enable_loopback_candidate = false;
        };
        logging.level = "info";
        turn = {
          enabled = false;
          domain = "livekit.dulaym.ax";
          cert_file = "/var/lib/acme/livekit.dulaym.ax/cert.pem";
          key_file = "/var/lib/acme/livekit.dulaym.ax/key.pem";
          tls_port = 5349;
          udp_port = 3478;
          external_tls = true;
        };
      };
    in
    {
      enable = true;
      description = "LiveKit";
      serviceConfig = {
        # WorkingDirectory = "/etc/livekit";
        ExecStart = "${pkgs.livekit}/bin/livekit-server --config ${livekitConfig} --key-file ${
          config.age.secrets."livekitkeyfile".path
        }";
        Restart = "always";
      };
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network.target"
      ];
    };

  services.nginx =
    let
      clientConfig = {
        "m.homeserver".base_url = "https://matrix.dulaym.ax";
        "org.matrix.msc4143.rtc_foci" = [
          {
            type = "livekit";
            livekit_service_url = "https://livekit.dulaym.ax";
          }
        ];
      };
      serverConfig."m.server" = "matrix.dulaym.ax:443";
      mkWellKnown = data: ''
        default_type application/json;
        add_header 'Access-Control-Allow-Origin' '*' always;
        add_header 'Access-Control-Allow-Methods' 'HEAD, GET, POST, PUT, DELETE, OPTIONS';
        add_header 'Access-Control-Allow-Headers' 'X-Requested-With, Content-Type, Authorization';
        return 200 '${builtins.toJSON data}';
      '';
    in
    {
      enable = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      virtualHosts = {
        "dulaym.ax" = {
          forceSSL = true;
          enableACME = true;
          root = "/var/www/dulaym.ax";
          locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
          locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
          locations."=/resume" = {
            alias = "/var/www/dulaym.ax/resume.pdf";
            extraConfig = ''
              default_type application/pdf;
            '';
          };
          listen = [
            {
              port = 8448;
              addr = "0.0.0.0";
              ssl = true;
            }
            {
              port = 443;
              addr = "0.0.0.0";
              ssl = true;
            }
            {
              port = 80;
              addr = "0.0.0.0";
            }
          ];
        };
        "matrix.dulaym.ax" = {
          enableACME = true;
          forceSSL = true;
          listen = [
            {
              port = 8448;
              addr = "0.0.0.0";
              ssl = true;
            }
            {
              port = 443;
              addr = "0.0.0.0";
              ssl = true;
            }
            {
              port = 8448;
              addr = "[::]";
              ssl = true;
            }
            {
              port = 443;
              addr = "[::]";
              ssl = true;
            }
          ];
          locations."/" = {
            proxyPass = "http://localhost:8008";
            extraConfig = ''
              client_max_body_size 50M;
              	'';
          };
        };
        "livekit.dulaym.ax" = {
          enableACME = true;
          forceSSL = true;
          # extraConfig = ''
          #   add_header 'Access-Control-Max-Age' 1728000;
          # '';

          listen = [
            {
              port = 443;
              addr = "0.0.0.0";
              ssl = true;
            }
            {
              port = 80;
              addr = "0.0.0.0";
            }
          ];
          locations."/sfu/get" = {
            proxyWebsockets = true;
            proxyPass = "http://localhost:8080";
          };
          locations."/healthz" = {
            proxyWebsockets = true;
            proxyPass = "http://localhost:8080";
          };

          locations."/" = {
            proxyWebsockets = true;

            extraConfig = ''
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
            '';
            proxyPass = "http://localhost:7880";
          };
        };
        "bridge.dulaym.ax" = {
          listen = [
            {
              port = 443;
              addr = "0.0.0.0";
              ssl = true;
            }
            {
              port = 80;
              addr = "0.0.0.0";
            }
          ];
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            extraConfig = ''
              if ($request_method = HEAD) {
              	set $proxy_method GET;
              }
              if ($proxy_method = '''){
              	set $proxy_method $request_method;
              }
              proxy_method $proxy_method;
            '';
            proxyPass = "http://127.0.0.1:6693";
          };
        };
        "immich.dulaym.ax" = {
          listen = [
            {
              port = 443;
              addr = "0.0.0.0";
              ssl = true;
            }
            {
              port = 80;
              addr = "0.0.0.0";
            }
          ];
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://10.1.1.1:2284";
            proxyWebsockets = true;
            recommendedProxySettings = true;
            extraConfig = ''
              client_max_body_size 50000M;
              proxy_read_timeout   600s;
              proxy_send_timeout   600s;
              send_timeout         600s;
            '';
          };
        };
      };
    };

  services.matrix-synapse = {
    enable = true;
    settings.server_name = "dulaym.ax";
    settings.public_baseurl = "https://matrix.dulaym.ax";
    # settings.enable_registration = true;
    extraConfigFiles = [ config.age.secrets."matrix-registration-secret".path ];
    settings.database.args = {
      database = "new-matrix-synapse";
      user = "new-matrix-synapse";
      password = "1234";
      host = "localhost";
    };
    settings.listeners = [
      {
        port = 8008;
        bind_addresses = [ "::1" "127.0.0.1" ];
        type = "http";
        # tls = true;
        tls = false;
        x_forwarded = true;
        resources = [
          {
            names = [
              "client"
              "federation"
            ];
            compress = true;
          }
        ];
      }
    ];
    settings = {
      media_store_path = "/var/lib/new-matrix-synapse/media_store";
      signing_key_path = "/var/lib/new-matrix-synapse/homeserver.signing.key";
      url_preview_ip_range_blacklist = [
        "127.0.0.0/8"
        "10.0.0.0/8"
      ];
      url_preview_enabled = true;
      experimental_features = {
        msc3266_enabled = true;
        msc4222_enabled = true;
        msc4140_enabled = true;
      };
      max_event_delay_duration = "24h";
      rc_message = {
        per_second = 0.5;
        burst_count = 30;
      };
      rc_delayed_event_mgmt = {
        per_second = 1;
        burst_count = 20;
      };
      app_service_config_files = [ "/var/lib/new-matrix-synapse/registration.yaml" ];
    };
    log.root.level = "WARNING";
  };

  systemd.services.out-of-your-element = {
    enable = true;
    description = "Discord Matrix bridge";
    serviceConfig = {
      Type = "simple";
      User = "maxdu";
      WorkingDirectory = "/home/maxdu/ooye";
      ExecStart = "${pkgs.nodejs}/bin/node start.js";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [
      "network-online.target"
      "matrix-synapse.service"
    ];

  };

  services.immich = {
    host = "0.0.0.0";
    enable = true;
    port = 2283;
    openFirewall = true;
    mediaLocation = "/media/hdd/immich";
    accelerationDevices = null;
  };
  users.users.immich.extraGroups = [
    "video"
    "render"
  ];

  containers.immich = {
    autoStart = true;
    localAddress = "10.1.1.1";
    hostAddress = "10.1.1.0";
    privateNetwork = true;
    bindMounts."/media/friendimmich" = {
      hostPath = "/media/hdd/friendimmich";
      isReadOnly = false;
    };
    config =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {

        services.immich = {
          host = "0.0.0.0";
          enable = true;
          port = 2284;
          openFirewall = true;
          mediaLocation = "/media/friendimmich";
          accelerationDevices = null;
        };
        environment.systemPackages = with pkgs; [ immich ];

        users.users.immich.extraGroups = [
          "video"
          "render"
        ];
        networking.firewall.allowedTCPPorts = [
          80
          443
        ];

        system.stateVersion = "24.11";
      };
  };

  # Set your time zone.
  time.timeZone = "America/New_York";
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.maxdu = {
    isNormalUser = true;
    description = "maxdu";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    # packages = with pkgs; [ ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:2:0:0";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure.customRC = # vim
      ''
        imap kj <Esc>
        set relativenumber
        set number
      '';

  };

  nixpkgs.overlays = [
    (final: prev: {
      ferium = prev.ferium.override (
        let
          rp = pkgs.rustPlatform;
        in
        {
          rustPlatform = rp // {
            buildRustPackage =
              args:
              rp.buildRustPackage (
                args
                // {
                  version = "4.7.0";
                  src = prev.fetchFromGitHub {
                    owner = "gorilla-devs";
                    repo = "ferium";
                    rev = "a36316a68998bb332c92c98553cbfe4296562613";
                    hash = "sha256-jj3BdaxH7ofhHNF2eu+burn6+/0bPQQZ8JfjXAFyN4A=";
                  };
                  cargoHash = "sha256-yedl4KQCpT7Ai1EPvwD5kzhkHesIjGVAcxKjp5k2jmI=";
                }
              );
          };
        }
      );
    })
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
    "dotnet-runtime-6.0.36"
  ];

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages."${system}".default
    nixfmt-classic
    git
    vim
    python312
    cudatoolkit
    screen
    nvtopPackages.full
    ffmpeg
    libopus
    bottom
    dnsutils
    qrencode
    wireguard-tools
    jdk21
    ferium
    gh
    tesseract
    lk-jwt-service
    matrix-synapse
    tshock
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  services.thermald.enable = true;
  services.auto-cpufreq.enable = true;

  services.ollama = {
    package = pkgs.ollama.override { cudaArches = [ "sm_50" ]; };
    enable = true;
    acceleration = "cuda";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.PermitRootLogin = "yes";
  };
  services.fail2ban = {
    enable = true;
    maxretry = 2;
    bantime = "48h";
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    53
    22
    80
    443
    853
    3000
    5439
    7777
    7881
    8008
    8009
    8448
    9005
    25565
  ];
  networking.firewall.allowedUDPPorts = [
    53
    80
    443
    3478
    47111
    19132
    19133
  ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 50100;
      to = 50200;
    }
  ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
