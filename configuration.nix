#land in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.extraOptions = "keep-outputs = true\nkeep-derivations = true\n";

  networking.networkmanager.enable = true;

  systemd.services.NetworkManager-wait-online.enable = false;
  services.journald.extraConfig = "SystemMaxUse=100M";

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
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  services.printing.enable = false;

  users.users.maxdu = {
    isNormalUser = true;
    description = "maxdu";
    extraGroups = [
      "networkmanager"
      "wheel"
      "gamemode"
      "libvirtd"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [ ];
  nixpkgs.config.element-web.conf = {
    show_labs_settings = true;
    default_theme = "dark";
    features = {
      feature_video_rooms = true;
      feature_group_calls = true;
      feature_element_call_video_rooms = true;
    };
  };

  environment.systemPackages = with pkgs; [
    yt-dlp
    git
    gh
    fastfetch
    fzf
    zip
    unzip
    ripgrep
    jq
    nh
    nix-output-monitor
    nvd
    vifm
    nixfmt
		screen
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  environment.variables.EDITOR = "nvim";

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        nerdFontsVersion = 3;
        border = "single";
      };
    };
  };
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

}
