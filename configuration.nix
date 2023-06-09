# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  nordicTheme = pkgs.nordic;
  # Import the nixpkgs-unstable channel
  unstable = import <nixpkgs> {
    config = {
      packageOverrides = pkgs_: with pkgs_; {
        nixosUnstable = nixos;
      };
    };
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.flatpak.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  programs.gnome-terminal.enable = true;
  # services.gnome.enableUserTheme = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

              nixpkgs.config.permittedInsecurePackages = [
                "electron-12.2.3"
              ];


  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.gnome.gnome-browser-connector.enable = true;

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
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.xserver.displayManager.sessionCommands = ''
   export GTK_THEME=Nordic
   export ICON_THEME=Nordic
  '';

  # services.xserver.desktopManager.gnome.extensions = [
  #  {
  #    name = "dash-to-dock";
  #    uuid = "micxgx@gmail.com";
  #  }
  # ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.giviko = {
    isNormalUser = true;
    description = "Givi Tsvariani";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
	firefox
	kate
	google-chrome
	vscode
	cloc
	htop
	neofetch
	neovim
	# vi
	emacs
	docker
	nodejs
	# npm
	python3
	gnome3.gnome-terminal
	pkgs.gnome3.gnome-tweaks
	gnome3.gnome-shell-extensions
	# belena
	rustup
	# nixos.nordic-theme
	# nixos.ubuntu-fonts
	discord
	gitkraken
	ruby
	go
	etcher
	electron
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

    # Specify the GNOME session for the display manager
  services.xserver.displayManager.defaultSession = "gnome";

  # Apply the changes to the GNOME Shell on startup
  systemd.user.services.gnome-shell-replace.serviceConfig.ExecStart = "gnome-shell --replace";
  systemd.user.services.gnome-shell-replace.enable = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  wget
  nordicTheme
  git
  gnomeExtensions.dash-to-dock
  # balena-etcher-electron
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
