# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nixpkgs.config.permittedInsecurePackages = [
                "openssl-1.1.1v"
              ];
hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
    opengl.driSupport32Bit = true;
    pulseaudio.support32Bit = true;
};

nix.settings = {
    substituters = ["https://nix-gaming.cachix.org"];
    trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
};

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
    
  boot.kernel.sysctl = { "vm.swappiness" = 10;};
  boot.supportedFilesystems = [ "ntfs" ];
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      # assuming /boot is the mount point of the  EFI partition in NixOS (as the installation section recommends).
      efiSysMountPoint = "/boot";
    };
    grub = {
      devices = [ "nodev" ];
      useOSProber = true;
      efiSupport = true;
      enable = true;
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.hostName = "prady"; # Define your hostname.
  

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    # videosDrivers = ["nvidia"];
    displayManager.gdm = {
        enable = true;
        wayland = true;
    };
    desktopManager.gnome = {
      enable = false;
    };
    desktopManager.budgie = {
      enable = true;
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.prady = {
    isNormalUser = true;
    description = "prady";
    extraGroups = [ "networkmanager" "wheel" "kvm" "input" "disk" "libvirtd"];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (pkg: builtins.elem (builtins.parseDrvName pkg.name).name [ "steam" ]);
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  wget
  neofetch
  starship
  brave
  cargo
  celluloid
  clang-tools_9
  direnv
  elinks
  flameshot
  flatpak
  fontconfig
  freetype
  gcc
  gh
  git
  github-desktop
  gnugrep
  gnumake
  gparted
  pkgs.gnome3.gnome-tweaks
  pkgs.waybar
  pkgs.dunst
  hugo
  lutris
  mangohud
  nfs-utils
  ninja
  nomacs
  nushell
  openssl
  protonup-ng
  python3Full
  python3.pkgs.pip
  ripgrep
  steam
  steam-run
  sxhkd
  st
  stdenv
  swaycons
  terminus-nerdfont
  tldr
  tree
  trash-cli
  unzip
  variety
  vscodium
  virt-manager
  xclip
  xdg-desktop-portal-gtk
  xfce.thunar
  xorg.libX11
  xorg.libX11.dev
  xorg.libxcb
  xorg.libXft
  xorg.libXinerama
  xorg.xinit
  xorg.xinput
  (lutris.override {
          extraPkgs = pkgs: [
      # List package dependencies here
      wineWowPackages.stable
      winetricks
          ];
      })
  ];
  environment.gnome.excludePackages = (with pkgs; [
  gnome-photos
  gnome-tour  
  ]) ++ (with pkgs.gnome; [
  cheese # webcam tool
  gnome-music
  gnome-terminal
  gedit # text editor
  epiphany # web browser
  geary # email reader
  evince # document viewer
  gnome-characters
  totem # video player
  tali # poker game
  iagno # go game
  hitori # sudoku game
  atomix # puzzle game
  ]);

  services.xserver.excludePackages = [ pkgs.xterm ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  programs.steam = {
	  enable = true;
	  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
	  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
	};
  

  environment.sessionVariables = {
  # If your cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
  # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };
  
  nix.gc = {
                automatic = true;
                dates = "weekly";
                options = "--delete-older-than 7d";
        };
  virtualisation.libvirtd.enable = true; 
  
  # enable flatpak support
  services.flatpak.enable = true;
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    # wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "mydatabase" ];
    enableTCPIP = true;
    port = 5432;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [5432];
  
  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      source-han-sans
      (nerdfonts.override { fonts = [ "Meslo" ]; })
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
	      monospace = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
	      serif = [ "Noto Serif" "Source Han Serif" ];
	      sansSerif = [ "Noto Sans" "Source Han Sans" ];
      };
    };
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.copySystemConfiguration = true;
  system.autoUpgrade.enable = true;  
  system.autoUpgrade.allowReboot = true; 
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.05";
  
  system.stateVersion = "23.05"; # Did you read the comment?

}
