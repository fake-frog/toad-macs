;;; -*- lexical-binding: t; -*-

;; -----------------------[ MISC ]------------------------

(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms `((".*" "~/.emacs.d/autosaves/" t)))
(setq delete-old-versions t)
(setq version-control t)      ;; use numbered backups
(setq kept-new-versions 5)
(setq kept-old-versions 2)
(put 'downcase-region 'disabled nil)

;; ---------------------[ APPERANCE ]---------------------

;; -- SPASH SCREEN --

(setq inhibit-startup-screen t)
(defun my/center-line (s)
  (let ((pad (max 0 (/ (- (window-width) (length s)) 2))))
    (concat (make-string pad ?\s) s)))

(defun my/scratch-dashboard ()
  (when (< (length command-line-args) 2)
    (with-current-buffer (get-buffer-create "*dashboard*")
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
        (insert (propertize (my/center-line title) 'face '(:inherit font-lock-keyword-face :weight bold)) "\n\n")
        (insert (propertize (my/center-line menu) 'face 'font-lock-defaults) "\n"))
      (local-set-key "r" #'recentf)
      (local-set-key "o" #'find-file)
      (local-set-key "c" (lambda () (interactive) (find-file "~/.emacs")))
      (read-only-mode 1))
    (switch-to-buffer "*dashboard*")))
(add-hook 'emacs-startup-hook #'my/scratch-dashboard)

(add-hook 'emacs-startup-hook
          (lambda ()
            (message "%s" (propertize "_^-^_.--* ~~~"
                                      'face '(:foreground "#53997b")))))

;; -------------

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq-default truncate-lines t)
(setq scroll-conservatively 101)
(electric-pair-mode 1)
(global-display-line-numbers-mode 1)
(add-to-list 'custom-theme-load-path "~/toad-macs/magic-toad-theme") 
(add-to-list 'custom-theme-load-path "~/toad-macs/lilypad-theme") 
(add-to-list 'custom-theme-load-path "~/system-themes/fashion-nugget") 

(global-hl-line-mode 1)

;;(load-theme 'magic-toad t) ;; night toad
;;(load-theme 'magic-toad-light t) ;; day toad
;;(load-theme 'lilypad t) 
(load-theme 'fashion-nugget t) 


;; highlight operators in c 
;; (font-lock-add-keywords
;;  'c-mode 
;;  '(("[:./*&=><!%+-]" 0 'font-lock-string-face)))

;; (font-lock-add-keywords
;;  'lua-mode 
;;  '(("[:./*&=><!%+-]" 0 'font-lock-string-face)))


;; (font-lock-add-keywords
;;  'rustic-mode 
;;  '(("[:./*&=><!%+-]" 0 'font-lock-string-face)))

;; ---------------------[ PACKAGES ]----------------------

;; ---------------------[ PACKAGES ]----------------------

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(dolist (pkg '(swiper
               avy
               ivy
               clang-format
               multiple-cursors
               magit
               rustic
               flycheck
               flycheck-eglot
               corfu
               orderless
               cape
               corfu-terminal
               diff-hl
               vertico
               marginalia
               consult
               mood-line
               ace-window
               lua-mode))
  (unless (package-installed-p pkg)
    (package-refresh-contents)
    (package-install pkg)))


;; ---- Editing / navigation ----
(use-package multiple-cursors)
(use-package ace-window)
(use-package clang-format)
(use-package magit)
(use-package lua-mode)

(use-package avy
  :custom (avy-background t))

(use-package diff-hl
  :config (global-diff-hl-mode 1))

(use-package savehist
  :ensure nil
  :config (savehist-mode 1))

(use-package mood-line
  :config (mood-line-mode))

;; ---- Minibuffer completion ----
(use-package vertico
  :init (vertico-mode))

(use-package marginalia
  :init (marginalia-mode))

(use-package consult
  :bind (("C-s"   . consult-line)
         ("C-x b" . consult-buffer))
  :config
  (add-to-list 'consult-buffer-filter "\\`\\*.*\\*\\'"))

(use-package orderless
  :custom (completion-styles '(orderless basic)))

;; ---- In-buffer completion ----
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 1)
  :init (global-corfu-mode))

(use-package cape
  :init (add-to-list 'completion-at-point-functions #'cape-file))

;; (use-package corfu-terminal
;;   :after corfu
;;   :config
;;   (unless (display-graphic-p)
;;     (corfu-terminal-mode +1)))

;; ---- LSP ----
(defun my/eglot-trim-features ()
  "Turn off Eglot extras that clutter the buffer or fight the theme."
  (eglot-semantic-tokens-mode -1)
  (eglot-inlay-hints-mode -1))

(use-package eglot
  :ensure nil
  :hook (((c-mode c++-mode lua-mode rustic-mode) . eglot-ensure)
         (eglot-managed-mode . my/eglot-trim-features)))
  ;; For clippy via rust-analyzer:
  ;; :config
  ;; (setq-default eglot-workspace-configuration
  ;;   '(:rust-analyzer (:check (:command "clippy")))))

(use-package rustic
  :custom (rustic-lsp-client 'eglot))

;; ---- Diagnostics ----
;; Eglot reports through Flymake; flycheck-eglot bridges it into Flycheck.
(use-package flycheck
  :demand t
  :custom (flycheck-indication-mode 'right-fringe))

(use-package flycheck-eglot
  :after flycheck
  :demand t
  :config (global-flycheck-eglot-mode 1))

;; Flymake's own indicators are off since Flycheck draws them.
(use-package flymake
  :ensure nil
  :custom
  (flymake-fringe-indicator-position nil)
  (flymake-indicator-type nil))

(setq eldoc-display-functions '(eldoc-display-in-echo-area)
      eldoc-echo-area-use-multiline-p nil)   ; always one line
;; ----------------------[ KEY MAP ]----------------------

(with-eval-after-load 'cc-mode
  (define-key c-mode-base-map (kbd "C-d") 'delete-backward-char))

(with-eval-after-load 'cc-mode
  (define-key c-mode-base-map (kbd "C-c C-c") 'compile))

(global-set-key (kbd "C-d")     'delete-backward-char)
(global-set-key (kbd "C-u")     'undo)
(global-set-key (kbd "C-r")     'undo-redo)
(global-set-key (kbd "M-s")     'isearch-backward)
(global-set-key (kbd "M-n")     'forward-paragraph)
(global-set-key (kbd "M-p")     'backward-paragraph)
(global-set-key (kbd "C-c C-c") 'compile)
(global-set-key (kbd "C-x g")   'magit-status)
(global-set-key (kbd "C-i")     'avy-goto-char)
(global-set-key (kbd "C-x o")     'ace-window)
(global-set-key (kbd "M-;")     'mc/mark-next-like-this)
(global-set-key (kbd "C-c f")   'rust-format-buffer)
(global-set-key (kbd "C-c b")   'recentf)
(global-set-key (kbd "C-c r")   'rustic-cargo-run)
(setq aw-keys '(?a ?s ?d ?f ?j ?k ?l))       
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(ace-window cape clang-format consult corfu-terminal diff-hl flycheck
		lua-mode magit marginalia mood-line multiple-cursors
		orderless rustic swiper vertico)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
