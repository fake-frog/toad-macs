
               ?
              / \
             / * \
            / * * \
           /_______\
             @.-.@
            (-----)
           ( >___< )
           ^^ ~~~ ^^

* ====== | TOAD-MACS | ====== *

   A nice emacs config with a
    nice theme to go with it.

           --------

  What's in here
  --------------

  install.sh                 puts everything below in place

  emacs.d/                   the Emacs config (-> ~/.emacs.d)
    early-init.el            startup tuning
    init.el                  loads the modules below
    lisp/init-defaults.el    backups, history, editing basics
    lisp/init-packages.el    every package + LSP (eglot/flycheck)
    lisp/init-appearance.el  theme, mode line, toad dashboard
    lisp/init-terminal.el    clipboard, mouse, glyphs for -nw
    lisp/init-keybindings.el all the keys

  mudpuddle-theme/           calm toad: standard colours, warm grays
                             (the default)
  magic-toad-theme/          night toad (+ magic-toad-light)
  lilypad-theme/             lilypad

  system-colors/             the rest of the desktop, in mudpuddle
    sway/config              -> ~/.config/sway/config
    waybar/config            -> ~/.config/waybar/config
    waybar/style.css         -> ~/.config/waybar/style.css
    alacritty/alacritty.toml -> ~/.config/alacritty/alacritty.toml
    blerc                    -> ~/.blerc   (ble.sh, the bash prompt)

  Made for Debian 13 (trixie), sway, and Emacs 30 in the terminal.

  Install
  -------

  1. Install the dependencies (next section).
  2. Get the repo and run the script:

       git clone git@github.com:fake-frog/toad-macs.git ~/toad-macs
       ~/toad-macs/install.sh

  install.sh only copies files: no sudo, no downloads.  Files it
  would replace are backed up to ~/.toad-macs-backup/ first, and
  it is safe to run again.  It also adds the ble.sh line and the
  `e` alias to ~/.bashrc if they're missing, and reloads sway and
  waybar if they're running.

  Use `./install.sh --link` to symlink instead of copy, so edits in
  the repo apply straight away.

  Emacs loads the themes from ~/toad-macs.  If you clone it
  somewhere else, install.sh links ~/toad-macs to it.

  Dependencies
  ------------

  Everything here needs the internet.

  Packages (apt):

    sudo apt install emacs-pgtk git \
        sway swayidle swaylock waybar alacritty bemenu \
        network-manager-applet dex brightnessctl pulseaudio-utils \
        fonts-font-awesome fontconfig curl unzip make gawk \
        clangd racket guile-3.0 rustup

  Rust toolchain + LSP server (rustup):

    rustup default stable
    rustup component add rust-analyzer

  Fonts (Lilex for the terminal and Emacs, Inclusive Sans for sway
  and waybar):

    mkdir -p ~/.local/share/fonts
    curl -L -o /tmp/Lilex.zip \
        https://github.com/mishamyrt/Lilex/releases/latest/download/Lilex.zip
    unzip -o -q /tmp/Lilex.zip -d /tmp/Lilex
    find /tmp/Lilex -name '*.ttf' -exec cp {} ~/.local/share/fonts/ \;
    curl -L -o ~/.local/share/fonts/InclusiveSans.ttf \
        'https://github.com/google/fonts/raw/main/ofl/inclusivesans/InclusiveSans%5Bwght%5D.ttf'
    curl -L -o ~/.local/share/fonts/InclusiveSans-Italic.ttf \
        'https://github.com/google/fonts/raw/main/ofl/inclusivesans/InclusiveSans-Italic%5Bwght%5D.ttf'
    fc-cache -f

  ble.sh (syntax colours in bash):

    git clone --recursive --depth 1 --shallow-submodules \
        https://github.com/akinomyoga/ble.sh.git /tmp/ble.sh
    make -C /tmp/ble.sh install PREFIX=~/.local

  Racket formatter (C-c f in Racket buffers), optional:

    raco pkg install fmt

  Emacs packages download themselves from MELPA / GNU ELPA the
  first time Emacs starts.

  After installing, log out and back in once so sway restarts
  swayidle with the new lock screen.

           --------

         _^-^_.--* ~~~
