;;; init-appearance.el --- Theme, font, UI and startup dashboard  -*- lexical-binding: t; -*-

;;; Commentary:
;; Everything about how Emacs looks: UI chrome, font, theme, extra syntax
;; highlighting, the mode line and the TOAD-MACS startup dashboard.

;;; Code:

;;;; UI chrome

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode 1)
(global-hl-line-mode 1)
(setq-default truncate-lines t)
(setq scroll-conservatively 101)    ; scroll line by line, never recenter

;;;; Font

;; Only affects graphical frames; in a terminal the font is Alacritty's.
(set-face-attribute 'default nil :font "Lilex" :height 120)

;;;; Theme

;; Adjust these paths if the theme repos move.
(dolist (dir '("~/toad-macs/magic-toad-theme"
               "~/toad-macs/lilypad-theme"
               "~/toad-macs/mudpuddle-theme"
               "~/system-themes/fashion-nugget"))
  (add-to-list 'custom-theme-load-path dir))

;; Mudpuddle: calm, standard colours.  Alternatives: magic-toad (night toad,
;; bright), magic-toad-light (day toad), lilypad, fashion-nugget.
(load-theme 'mudpuddle t)

;;;; Mode line

(use-package mood-line
  :config
  (mood-line-mode))

;;;; Extra syntax highlighting

;; Highlight operators in C and Rust (the theme decides the colour).
(dolist (mode '(c-mode rustic-mode))
  (font-lock-add-keywords mode '(("[:./*&=><!%+-]" 0 'font-lock-operator-face))))

;;;; Startup dashboard

(setq inhibit-startup-screen t)

(defun my/center-line (s)
  "Return S padded with spaces to centre it in the selected window."
  (let ((pad (max 0 (/ (- (window-width) (length s)) 2))))
    (concat (make-string pad ?\s) s)))

(defun my/dashboard-buffer ()
  "Draw the TOAD-MACS dashboard for the selected window and return its buffer."
  (with-current-buffer (get-buffer-create "*dashboard*")
    (let ((inhibit-read-only t))
      (erase-buffer)
      (let* ((hat '("     ?     "
                    "    / \\    "
                    "   / * \\   "
                    "  / * * \\  "
                    " /_______\\ "))
             (frog '("   @.-.@   "
                     "  (-----)  "
                     " ( >___< ) "
                     " ^^ ~~~ ^^ "))
             (title "* ====== | TOAD-MACS | ====== *")
             (menu "[r]ecent | [o]pen | [c]onfig ")
             (total-lines (+ (length hat) (length frog) 3))
             (vpad (max 0 (/ (- (window-height) total-lines) 2))))
        (insert (make-string vpad ?\n))
        (dolist (line hat)
          (insert (propertize (my/center-line line) 'face 'font-lock-type-face) "\n"))
        (dolist (line frog)
          (insert (propertize (my/center-line line) 'face 'font-lock-string-face) "\n"))
        (insert "\n")
        (insert (propertize (my/center-line title)
                            'face '(:inherit font-lock-keyword-face :weight bold))
                "\n\n")
        (insert (propertize (my/center-line menu) 'face 'default) "\n")))
    (local-set-key "r" #'recentf)
    (local-set-key "o" #'find-file)
    (local-set-key "c" (lambda () (interactive) (find-file user-init-file)))
    (read-only-mode 1)
    (current-buffer)))

(defun my/scratch-dashboard ()
  "Show the dashboard when Emacs starts without file arguments."
  (when (< (length command-line-args) 2)
    (switch-to-buffer (my/dashboard-buffer))))

;; Running as a server (the `e' alias): show the dashboard in each new
;; `emacsclient' frame opened without a file.
(when (daemonp)
  (setq initial-buffer-choice #'my/dashboard-buffer))

(defun my/startup-message ()
  "Greet with a little toad in the echo area."
  (message "%s" (propertize "_^-^_.--* ~~~" 'face '(:foreground "#53997b"))))

(add-hook 'emacs-startup-hook #'my/scratch-dashboard)
(add-hook 'emacs-startup-hook #'my/startup-message)

(provide 'init-appearance)
;;; init-appearance.el ends here
