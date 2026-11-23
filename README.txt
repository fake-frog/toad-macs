
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

  emacs.d/                   the config (goes in ~/.emacs.d)
    early-init.el            startup tuning
    init.el                  loads the modules below
    lisp/init-defaults.el    backups, history, editing basics
    lisp/init-packages.el    every package + LSP (eglot/flycheck)
    lisp/init-appearance.el  theme, mode line, toad dashboard
    lisp/init-terminal.el    clipboard, mouse, glyphs for -nw
    lisp/init-keybindings.el all the keys

  magic-toad-theme/          night toad (+ magic-toad-light)
  lilypad-theme/             lilypad

  Install
  -------

  Needs Emacs 30.  Made for the terminal (Alacritty).

    git clone git@github.com:fake-frog/toad-macs.git ~/toad-macs
    mkdir -p ~/.emacs.d
    cp -r ~/toad-macs/emacs.d/. ~/.emacs.d/

  Packages install themselves on first start.  The themes are
  loaded from ~/toad-macs; if you clone it somewhere else, fix
  the paths in lisp/init-appearance.el.

  For LSP: clangd (C/C++) and rust-analyzer (Rust).
  For Racket formatting: raco pkg install fmt

  Fast startup: run Emacs as a server and open files with

    alias e='emacsclient -t -a ""'

           --------

         _^-^_.--* ~~~
