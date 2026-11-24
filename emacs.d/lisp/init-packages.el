;;; init-packages.el --- Package setup and configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Every package is declared here with `use-package'.  Anything missing is
;; installed from MELPA/GNU ELPA on startup.  Key bindings live in
;; init-keybindings.el; theme, font and UI settings in init-appearance.el.

;;; Code:

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(require 'use-package)
(setq use-package-always-ensure t)  ; install declared packages if missing

;;;; Editing and navigation

(use-package multiple-cursors)

(use-package avy
  :defer t
  :custom
  (avy-background t))

(use-package ace-window
  :defer t
  :custom
  (aw-keys '(?a ?s ?d ?f ?j ?k ?l)))

(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :custom
  ;; Use the theme's `error' face so the colour follows the active theme.
  (hl-todo-keyword-faces '(("TODO"  . error)
                           ("FIXME" . error)
                           ("HACK"  . error)
                           ("NOTE"  . error))))

;;;; Minibuffer completion

(use-package vertico
  :init (vertico-mode))

(use-package marginalia
  :init (marginalia-mode))

(use-package orderless              ; fuzzy / out-of-order matching
  :custom
  (completion-styles '(orderless basic))
  ;; Eglot defaults its completions to its own flex style; use orderless there too.
  (completion-category-overrides '((eglot (styles orderless))
                                   (eglot-capf (styles orderless)))))

(use-package consult
  :defer t
  :config
  ;; Hide *special* buffers from `consult-buffer'.
  (setq consult-buffer-filter
        (append consult-buffer-filter '("\\`\\*.*\\*\\'"))))

;;;; In-buffer completion

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 1)
  :init
  (global-corfu-mode))

(use-package corfu-terminal
  :after corfu
  :config
  (unless (display-graphic-p)
    (corfu-terminal-mode 1)))

(use-package cape                   ; extra completion sources
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  ;; Eglot caches completions per prefix; with corfu-auto that cache goes
  ;; stale as you type.  Bust it so the popup always reflects the server.
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster))

;;;; Version control

(use-package magit
  :defer t)

(use-package diff-hl
  :demand t                         ; :hook alone would defer loading
  :hook (magit-post-refresh . diff-hl-magit-post-refresh)  ; refresh after commits
  :config
  (global-diff-hl-mode 1))

;;;; LSP and diagnostics
;; Eglot runs clangd (C/C++) and rust-analyzer (Rust).  Its diagnostics are
;; routed into Flycheck by flycheck-eglot, so every language shares one set
;; of fringe markers, one error list (C-c ! l) and one mode-line counter,
;; and Rust isn't checked twice (Flycheck's own cargo checker stays off).

;; LSP servers send large JSON replies; read them in bigger chunks.
(setq read-process-output-max (* 1024 1024))

(use-package eglot
  :ensure nil                       ; built in
  :hook ((c-mode c++-mode) . eglot-ensure)  ; rustic starts eglot itself
  :custom
  (eglot-ignored-server-capabilities '(:inlayHintProvider))  ; no inlay hints
  (eglot-events-buffer-config '(:size 0 :format full))  ; no JSON logging (much faster);
                                                        ; set :size 2000000 to debug a server
  (eglot-autoshutdown t)            ; stop a server when its last buffer closes
  (eglot-extend-to-xref t)          ; library files opened via M-. reuse the server
  ;; For clippy lints instead of plain `cargo check', uncomment:
  ;; :config
  ;; (setq-default eglot-workspace-configuration
  ;;               '(:rust-analyzer (:check (:command "clippy"))))
  )

(use-package flycheck
  :defer t                          ; switched on by flycheck-eglot
  :custom
  ;; Terminals have no fringe, so mark errors in the right margin
  ;; (diff-hl already uses the left margin in a terminal).
  (flycheck-indication-mode 'right-margin))

(use-package flycheck-eglot
  :after eglot
  :config
  (global-flycheck-eglot-mode 1))

;;;; C / C++

(use-package clang-format
  :defer t)

;;;; Rust

(use-package rustic
  :defer t                          ; loads on the first .rs file (saves ~0.6s at startup)
  :custom
  (rustic-lsp-client 'eglot))

(provide 'init-packages)
;;; init-packages.el ends here
