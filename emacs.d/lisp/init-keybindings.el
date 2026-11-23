;;; init-keybindings.el --- All key bindings  -*- lexical-binding: t; -*-

;;; Commentary:
;; Global bindings first, then per-mode overrides.  Mode maps that shadow a
;; global binding (cc-mode, paredit) re-assert it below.

;;; Code:

;;;; Separate C-i from TAB

;; Emacs reads C-i as TAB, so binding C-i would also steal the Tab key.
;; In graphical frames we can tell them apart: turn C-i into its own
;; [C-i] event while the Tab key keeps indenting.  Terminals send the
;; same byte for both, so there C-i stays TAB.
(defun my/distinguish-C-i (&optional frame)
  "Make C-i a separate key from TAB in FRAME if it is graphical."
  (with-selected-frame (or frame (selected-frame))
    (when (display-graphic-p)
      (define-key input-decode-map [?\C-i] [C-i]))))

(my/distinguish-C-i)
(add-hook 'after-make-frame-functions #'my/distinguish-C-i)  ; daemon / new frames

;;;; Editing

(global-set-key (kbd "C-d")     #'delete-backward-char)
(global-set-key (kbd "C-u")     #'undo)
(global-set-key (kbd "C-r")     #'undo-redo)
(global-set-key (kbd "M-;")     #'mc/mark-next-like-this)

;;;; Search and navigation

(global-set-key (kbd "C-s")     #'consult-line)
(global-set-key (kbd "M-s")     #'isearch-backward)
(global-set-key (kbd "M-j")     #'avy-goto-char)   ; works in the terminal
(global-set-key [C-i]          #'avy-goto-char)   ; GUI only, see above
(global-set-key (kbd "M-n")     #'forward-paragraph)
(global-set-key (kbd "M-p")     #'backward-paragraph)

;;;; Buffers, files and windows

(global-set-key (kbd "C-x b")   #'consult-buffer)
(global-set-key (kbd "C-x o")   #'ace-window)
(global-set-key (kbd "C-c b")   #'recentf)

;;;; Tools

(global-set-key (kbd "C-c C-c") #'compile)
(global-set-key (kbd "C-x g")   #'magit-status)
(global-set-key (kbd "C-c r")   #'rustic-cargo-run)

;;;; Mode-specific overrides

(with-eval-after-load 'cc-mode
  (define-key c-mode-base-map (kbd "C-d")     #'delete-backward-char)
  (define-key c-mode-base-map (kbd "C-c C-c") #'compile))

;; LSP actions (only in buffers eglot manages).  Diagnostics: C-c ! n / C-c ! p
;; to move between them, C-c ! l for the list.
(with-eval-after-load 'eglot
  (define-key eglot-mode-map (kbd "C-c l r") #'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c l a") #'eglot-code-actions)
  (define-key eglot-mode-map (kbd "C-c l f") #'eglot-format-buffer)
  (define-key eglot-mode-map (kbd "C-c l d") #'eldoc-doc-buffer))

;; C-c f formats the buffer in Rust and Racket.
(with-eval-after-load 'rustic
  (define-key rustic-mode-map (kbd "C-c f") #'rustic-format-buffer))

(with-eval-after-load 'racket-mode
  (define-key racket-mode-map (kbd "C-c f") #'my/raco-fmt-buffer))

;; paredit-mode-map shadows several globals above, so re-assert them:
;;   C-d   paredit-forward-delete -> paredit-backward-delete
;;   M-s   paredit-splice-sexp    -> isearch-backward (splice moved to C-c s)
;;   M-;   paredit-comment-dwim   -> mc/mark-next-like-this
(with-eval-after-load 'paredit
  (define-key paredit-mode-map (kbd "C-d")   #'paredit-backward-delete)
  (define-key paredit-mode-map (kbd "M-s")   #'isearch-backward)
  (define-key paredit-mode-map (kbd "M-;")   #'mc/mark-next-like-this)
  (define-key paredit-mode-map (kbd "C-c s") #'paredit-splice-sexp))

(provide 'init-keybindings)
;;; init-keybindings.el ends here
