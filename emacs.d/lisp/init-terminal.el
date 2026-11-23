;;; init-terminal.el --- Make `emacs -nw' nicer  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for running Emacs inside a terminal emulator (Alacritty).  They
;; take effect when the terminal is initialised, which happens after the
;; init files load.  In a graphical frame they do nothing.

;;; Code:

;;;; Clipboard
;; Send kills to the system clipboard with the OSC 52 escape sequence, so
;; C-w / M-w can be pasted into other apps.  No xclip or wl-copy needed.
;; Alacritty only allows copying this way; to paste from other apps into
;; Emacs use the terminal's paste (Ctrl+Shift+V), which arrives as one yank.
;; Inside tmux this also needs `set -g set-clipboard on' in ~/.tmux.conf.
(setq xterm-extra-capabilities '(setSelection))

;;;; Mouse
;; Click to move point or pick a window, scroll with the wheel, drag to
;; select or to resize windows.  Hold Shift to use the terminal's own
;; selection instead.
(xterm-mouse-mode 1)

;;;; Window title
;; Show the current buffer name in Alacritty's title bar.
(setq xterm-set-window-title t)

;;;; Glyphs
;; Mark truncated lines with a dim "…" instead of "$".
(unless standard-display-table
  (setq standard-display-table (make-display-table)))
(set-display-table-slot standard-display-table 'truncation
                        (make-glyph-code ?… 'shadow))

(provide 'init-terminal)
;;; init-terminal.el ends here
