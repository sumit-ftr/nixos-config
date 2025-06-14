{ config, pkgs, lib, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment = {
    systemPackages = with pkgs; [
      helix yazi zellij gitui btop
      eza fd ripgrep unzip
      git curl nmap jq
      nixd cht-sh
    ];
    variables = {
      EDITOR = "hx";
      VISUAL = "hx";
      SUDO_EDITOR = "hx";
      _ZO_FZF_OPTS="--scheme=path --bind 'ctrl-equal:reload(zoxide edit increment {2..}),ctrl-minus:reload(zoxide edit decrement {2..}),ctrl-x:reload(zoxide edit delete {2..}),enter:reload(zoxide edit reload),esc:abort,tab:down,btab:up'";
    };
    sessionVariables = {
      PATH = [ "$PATH" "$HOME/.local/scripts" ];
    };
  };

  programs = {
    bash = {
      shellAliases = {
        c = "clear";
        ls = "eza -al --group-directories-first --icons";
        la = "eza -a --group-directories-first --icons";
        lt = "eza -alT --group-directories-first --icons --git-ignore";
        tree = "eza -aT --group-directories-first --icons --git-ignore";
        lf = "yazi";
        tmux = "zellij";
        btop = "btop --force-utf";
        todo = "hx /home/${config.user.name}/topics/todo/*";
      };
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      flags = [ "--cmd cd" ];
    };
    nano.enable = false;
  };

  # adds the sshd.service to path without enabling it
  services.openssh.enable = true;
  systemd.services.sshd.wantedBy = lib.mkForce [];

  # enables the polkit service
  security.polkit.enable = true;

  virtualisation.libvirtd.enable = true;
  # virtualisation.spiceUSBRedirection.enable = true;

  networking = {
    networkmanager.enable = true;
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}
