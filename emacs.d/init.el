;;; init.el --- TOAD-MACS entry point  -*- lexical-binding: t; -*-

;;; Commentary:
;; The config is split into modules under lisp/:
;;
;;   init-defaults.el     backups, history, general editing behaviour
;;   init-packages.el     package archives and every package's configuration
;;   init-appearance.el   UI, font, theme, mode line, startup dashboard
;;   init-terminal.el     clipboard, mouse and glyphs for `emacs -nw'
;;   init-keybindings.el  all global and mode-specific key bindings
;;
;; early-init.el (startup GC tuning) runs before all of this.
;; Settings saved through M-x customize go to custom.el.

;;; Code:

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror 'nomessage)

(require 'init-defaults)
(require 'init-packages)
(require 'init-appearance)
(require 'init-terminal)
(require 'init-keybindings)

;;; init.el ends here
