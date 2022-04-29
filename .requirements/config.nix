{
  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "user-utils";
      paths = [
        apg
        bash-completion
        bashInteractive_5
        bc
        claws-mail
        cmatrix
        cmus
        coreutils-full
        cowsay
        curl
        dash
        dmenu
        docker-compose
        exa
        figlet
        findutils
        fortune
        fzf
        gitAndTools.gitFull
        gnugrep
        gnumake
        gnupg1
        gnused
        graphviz
        gron
        htop
        i3
        i3status
        jq
        less
        lsb-release
        lynx
        man
        mutt
        neofetch
        netcat
        newsboat
        nodejs
        pandoc
        pass
        playerctl
        python38Full
        python38Packages.pip
        python39Packages.py3status
        qrencode
        ranger
        rsync
        sbcl
        screen
        shellcheck
        sqlite
        stow
        tmux
        tree
        unixtools.watch
        vim
        vlc
        wget
        whois
        xclip
        xfce.thunar
        zsh
      ];
    };
  };
}
