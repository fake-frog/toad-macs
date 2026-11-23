;;; magic-toad-common.el --- Shared faces for the magic-toad themes -*- lexical-binding: t; -*-

;;; Commentary:
;; Face definitions shared by magic-toad (dark) and magic-toad-light.  Each
;; theme file passes its palette to `magic-toad--set-faces'.  This file is
;; not a theme itself; the theme files `load' it, so edits here take effect
;; the next time a magic-toad theme is loaded.
;;
;; Palette roles:
;;   bg  bg-slight  bg-soft  bg-raised   backgrounds, from flat to most raised
;;   fg  fg-dim                          text and de-emphasised text
;;   accent      red:    errors, types, headings
;;   accent-alt  pink:   strings, operators, current completion candidate
;;   special     green:  keywords, cursor, warnings, additions
;;   purple              preprocessor, info, changes

;;; Code:

(require 'cl-lib)

(defun magic-toad--blend (color base alpha)
  "Mix ALPHA (0.0-1.0) of hex COLOR over hex BASE; return \"#rrggbb\".
Parses the hex strings directly so the result is the same in terminal
frames, where `color-values' would approximate."
  (cl-flet ((rgb (c) (mapcar (lambda (i) (string-to-number (substring c i (+ i 2)) 16))
                             '(1 3 5))))
    (apply #'format "#%02x%02x%02x"
           (cl-mapcar (lambda (a b) (round (+ (* alpha a) (* (- 1 alpha) b))))
                      (rgb color) (rgb base)))))

(cl-defun magic-toad--set-faces (theme &key bg bg-slight bg-soft bg-raised
                                       fg fg-dim accent accent-alt special purple)
  "Apply the magic-toad faces to THEME using the given palette colours."
  (let* (;; Tinted backgrounds for diffs.
         (added-bg          (magic-toad--blend special bg 0.15))
         (added-bg-strong   (magic-toad--blend special bg 0.30))
         (removed-bg        (magic-toad--blend accent bg 0.15))
         (removed-bg-strong (magic-toad--blend accent bg 0.30))
         ;; ANSI colours: (name normal bright).
         (ansi `(("black"   ,bg         ,fg-dim)
                 ("red"     ,accent     ,accent)
                 ("green"   ,purple     ,purple)
                 ("yellow"  ,special    ,special)
                 ("blue"    ,fg         ,bg-raised)
                 ("magenta" ,accent-alt ,accent-alt)
                 ("cyan"    ,fg         ,fg)
                 ("white"   ,fg         ,fg)))
         (ansi-faces
          (cl-loop for (name normal bright) in ansi
                   for face = (intern (concat "ansi-color-" name))
                   collect `(,face ((t (:foreground ,normal :background ,normal))))
                   collect `(,(intern (concat "ansi-color-bright-" name))
                             ((t (:foreground ,bright :background ,bright))))
                   ;; term-color-* already inherit ansi-color-*; vterm may not.
                   collect `(,(intern (concat "vterm-color-" name))
                             ((t (:inherit ,face)))))))

    ;; rustic colours cargo output with xterm-color, which has its own palette.
    (custom-theme-set-variables
     theme
     `(xterm-color-names ,(apply #'vector (mapcar #'cadr ansi)))
     `(xterm-color-names-bright ,(apply #'vector (mapcar #'caddr ansi))))

    (apply
     #'custom-theme-set-faces theme
     (append
      ansi-faces
      `(
        ;;;; Base
        (default ((t (:foreground ,fg :background ,bg))))
        (cursor ((t (:background ,special))))
        (region ((t (:foreground ,bg :background ,fg))))
        (secondary-selection ((t (:background ,bg-raised))))
        (highlight ((t (:background ,bg-soft))))
        (hl-line ((t (:background ,bg-slight))))
        (shadow ((t (:foreground ,fg-dim))))
        (fringe ((t (:foreground ,fg :background ,bg))))
        (vertical-border ((t (:foreground ,bg-raised :background ,bg-raised))))
        (header-line ((t (:foreground ,fg :background ,bg-soft))))
        (link ((t (:foreground ,accent :underline t))))
        (link-visited ((t (:foreground ,purple :underline t))))
        (button ((t (:foreground ,accent :background ,bg-soft))))
        (trailing-whitespace ((t (:background ,accent))))
        (minibuffer-prompt ((t (:foreground ,accent :weight bold))))
        (help-key-binding ((t (:foreground ,accent :background ,bg))))
        (read-multiple-choice-face ((t (:foreground ,accent :weight bold))))

        ;;;; Status
        (error ((t (:foreground ,accent :weight bold))))
        (warning ((t (:foreground ,special :weight bold))))
        (success ((t (:foreground ,fg :weight bold))))

        ;;;; Font lock
        (font-lock-comment-face ((t (:foreground ,fg-dim :background ,bg-soft))))
        (font-lock-doc-face ((t (:foreground ,accent))))
        (font-lock-string-face ((t (:foreground ,accent-alt))))
        (font-lock-keyword-face ((t (:foreground ,special))))
        (font-lock-builtin-face ((t (:foreground ,fg))))
        (font-lock-function-name-face ((t (:foreground ,fg :slant italic))))
        (font-lock-variable-name-face ((t (:foreground ,fg))))
        (font-lock-type-face ((t (:foreground ,accent))))
        (font-lock-constant-face ((t (:foreground ,fg))))
        (font-lock-warning-face ((t (:foreground ,fg-dim))))
        (font-lock-negation-char-face ((t (:foreground ,purple))))
        (font-lock-operator-face ((t (:foreground ,accent-alt))))
        (font-lock-punctuation-face ((t (:foreground ,purple))))
        (font-lock-preprocessor-face ((t (:foreground ,purple))))

        ;;;; Rust
        (rust-string-interpolation ((t (:foreground ,fg))))
        (rust-ampersand-face ((t (:foreground ,accent-alt))))
        (rust-question-mark ((t (:foreground ,accent-alt))))
        (rust-unsafe ((t (:foreground ,special))))
        (rust-builtin-formatting-macro ((t (:foreground ,fg))))

        ;;;; Shell
        (sh-quoted-exec ((t (:foreground ,accent))))
        (sh-heredoc ((t (:foreground ,fg))))

        ;;;; Racket
        (racket-keyword-argument-face ((t (:foreground ,purple))))
        (racket-selfeval-face ((t (:foreground ,fg))))
        (racket-here-string-face ((t (:inherit font-lock-string-face))))
        (racket-xp-def-face ((t (:background ,bg-raised :underline (:color ,fg-dim)))))
        (racket-xp-use-face ((t (:background ,bg-raised))))
        (racket-xp-tail-target-face ((t (:background ,bg-raised :underline (:color ,purple :style wave)))))
        (racket-xp-tail-position-face ((t (:background ,bg-raised))))
        (racket-xp-unused-face ((t (:foreground ,fg-dim :strike-through t))))
        (racket-xp-error-face ((t (:underline (:color ,accent :style wave)))))
        (racket-repl-prompt ((t (:foreground ,special :weight bold))))
        (racket-repl-value ((t (:foreground ,fg))))
        (racket-repl-error-message ((t (:foreground ,accent))))
        (racket-repl-error-location ((t (:foreground ,fg-dim :underline t))))

        ;;;; Geiser (Scheme)
        (geiser-font-lock-repl-prompt ((t (:foreground ,special :weight bold))))
        (geiser-font-lock-repl-output ((t (:foreground ,fg))))
        (geiser-font-lock-repl-output-error ((t (:foreground ,accent))))
        (geiser-font-lock-autodoc-identifier ((t (:foreground ,accent))))
        (geiser-font-lock-autodoc-current-arg ((t (:foreground ,accent-alt :weight bold))))
        (geiser-font-lock-error-link ((t (:foreground ,accent :underline t))))
        (geiser-font-lock-doc-link ((t (:inherit link))))

        ;;;; Rainbow delimiters
        (rainbow-delimiters-depth-1-face ((t (:foreground ,purple))))
        (rainbow-delimiters-depth-2-face ((t (:foreground ,special))))
        (rainbow-delimiters-depth-3-face ((t (:foreground ,accent-alt))))
        (rainbow-delimiters-depth-4-face ((t (:foreground ,fg))))
        (rainbow-delimiters-depth-5-face ((t (:foreground ,purple))))
        (rainbow-delimiters-depth-6-face ((t (:foreground ,special))))
        (rainbow-delimiters-depth-7-face ((t (:foreground ,accent-alt))))
        (rainbow-delimiters-depth-8-face ((t (:foreground ,fg))))
        (rainbow-delimiters-depth-9-face ((t (:foreground ,fg-dim))))
        (rainbow-delimiters-unmatched-face ((t (:foreground ,bg :background ,accent :weight bold))))
        (rainbow-delimiters-mismatched-face ((t (:foreground ,bg :background ,accent :weight bold))))

        ;;;; Line numbers and parens
        (line-number ((t (:foreground ,fg-dim :background ,bg))))
        (line-number-current-line ((t (:foreground ,special :background ,bg))))
        (show-paren-match ((t (:foreground ,fg :background ,bg :weight bold))))
        (show-paren-mismatch ((t (:foreground ,accent :background ,bg :weight bold))))

        ;;;; Mode line (mood-line)
        (mode-line ((t (:foreground ,accent-alt :background ,bg-soft :slant italic))))
        (mode-line-inactive ((t (:foreground ,fg-dim :background ,bg-slight
                                 :box (:line-width 1 :color ,bg-raised)))))
        (mode-line-buffer-id ((t (:weight bold))))
        (mood-line-unimportant ((t (:foreground ,fg-dim))))
        (mood-line-encoding ((t (:foreground ,fg-dim))))
        (mood-line-frame-status-client ((t (:foreground ,fg-dim))))
        (mood-line-buffer-status-read-only ((t (:foreground ,fg-dim))))
        (mood-line-buffer-status-modified ((t (:foreground ,accent))))
        (mood-line-status-neutral ((t (:foreground ,fg-dim))))
        (mood-line-status-error ((t (:foreground ,accent :weight bold))))
        (mood-line-status-warning ((t (:foreground ,special))))
        (mood-line-status-info ((t (:foreground ,purple))))
        (mood-line-status-success ((t (:foreground ,fg))))

        ;;;; Search
        (isearch ((t (:foreground ,fg :background ,bg-soft :weight bold))))
        (isearch-fail ((t (:foreground ,accent))))
        (lazy-highlight ((t (:foreground ,fg :background ,bg-raised :underline t))))
        (match ((t (:foreground ,fg :background ,bg-soft))))

        ;;;; Minibuffer completion (vertico, orderless, consult)
        (completions-common-part ((t (:foreground ,fg :background ,bg-soft))))
        (completions-annotations ((t (:foreground ,fg-dim))))
        (vertico-current ((t (:foreground ,accent-alt :background ,bg-raised :extend t))))
        (vertico-multiline ((t (:foreground ,accent))))
        (vertico-group-title ((t (:foreground ,fg-dim))))
        (vertico-group-separator ((t (:foreground ,fg-dim :strike-through t))))
        (orderless-match-face-0 ((t (:foreground ,accent-alt :weight semi-bold))))
        (orderless-match-face-1 ((t (:foreground ,special :weight semi-bold))))
        (orderless-match-face-2 ((t (:foreground ,purple :weight semi-bold))))
        (orderless-match-face-3 ((t (:foreground ,accent :weight semi-bold))))
        (consult-preview-insertion ((t (:background ,bg-raised))))
        (consult-preview-line ((t (:background ,bg-raised :extend t))))
        (consult-file ((t (:foreground ,fg))))

        ;;;; In-buffer completion (corfu)
        (corfu-default ((t (:foreground ,fg :background ,bg-slight))))
        (corfu-current ((t (:foreground ,accent-alt :background ,bg-raised))))
        (corfu-annotations ((t (:foreground ,fg-dim))))
        (corfu-border ((t (:background ,bg-raised))))
        (corfu-bar ((t (:background ,fg-dim))))

        ;;;; Diagnostics (flycheck, flymake, eglot)
        (flycheck-error ((t (:underline (:color ,accent :style wave)))))
        (flycheck-warning ((t (:underline (:color ,fg-dim :style wave)))))
        (flycheck-info ((t (:underline (:color ,purple :style wave)))))
        (flycheck-fringe-error ((t (:foreground ,accent))))
        (flycheck-fringe-warning ((t (:foreground ,special))))
        (flycheck-fringe-info ((t (:foreground ,purple))))
        (flymake-error ((t (:underline (:color ,accent :style wave)))))
        (flymake-warning ((t (:underline (:color ,fg-dim :style wave)))))
        (flymake-note ((t (:underline (:color ,purple :style wave)))))
        (eglot-inlay-hint-face ((t (:foreground ,fg-dim))))
        (eglot-type-hint-face ((t (:foreground ,fg-dim))))
        (eglot-diagnostic-tag-unnecessary-face ((t (:foreground ,fg-dim))))
        (eglot-diagnostic-tag-deprecated-face ((t (:foreground ,fg-dim :strike-through t))))

        ;;;; Diffs and version control (diff-hl, magit)
        (diff-added ((t (:background ,added-bg :extend t))))
        (diff-removed ((t (:background ,removed-bg :extend t))))
        (diff-refine-added ((t (:background ,added-bg-strong))))
        (diff-refine-removed ((t (:background ,removed-bg-strong))))
        (diff-indicator-added ((t (:foreground ,special))))
        (diff-indicator-removed ((t (:foreground ,accent))))
        (diff-header ((t (:foreground ,fg :background ,bg-soft))))
        (diff-file-header ((t (:foreground ,fg :background ,bg-soft :weight bold))))
        (diff-hl-insert ((t (:foreground ,special :background ,special))))
        (diff-hl-delete ((t (:foreground ,accent :background ,accent))))
        (diff-hl-change ((t (:foreground ,purple :background ,purple))))
        (diff-hl-margin-insert ((t (:foreground ,special :background ,bg-soft))))
        (diff-hl-margin-delete ((t (:foreground ,accent :background ,bg-soft))))
        (diff-hl-margin-change ((t (:foreground ,purple :background ,bg-soft))))
        (magit-section-heading ((t (:foreground ,accent :weight bold))))
        (magit-section-highlight ((t (:background ,bg-slight))))
        (magit-branch-local ((t (:foreground ,accent))))
        (magit-branch-remote ((t (:foreground ,fg))))
        (magit-branch-current ((t (:foreground ,accent :box (:line-width -1 :color ,accent)))))
        (magit-hash ((t (:foreground ,fg-dim))))
        (magit-diff-file-heading ((t (:foreground ,fg :weight bold))))
        (magit-diff-file-heading-highlight ((t (:background ,bg-soft :weight bold))))
        (magit-diff-hunk-heading ((t (:foreground ,fg-dim :background ,bg-soft))))
        (magit-diff-hunk-heading-highlight ((t (:foreground ,fg :background ,bg-raised))))
        (magit-diff-context ((t (:foreground ,fg-dim))))
        (magit-diff-context-highlight ((t (:foreground ,fg :background ,bg-slight))))
        (magit-diff-added ((t (:foreground ,special :background ,added-bg))))
        (magit-diff-added-highlight ((t (:foreground ,special :background ,added-bg-strong))))
        (magit-diff-removed ((t (:foreground ,accent :background ,removed-bg))))
        (magit-diff-removed-highlight ((t (:foreground ,accent :background ,removed-bg-strong))))
        (magit-diffstat-added ((t (:foreground ,special))))
        (magit-diffstat-removed ((t (:foreground ,accent))))

        ;;;; Jumping (avy, ace-window)
        (avy-lead-face ((t (:foreground ,bg :background ,special))))
        (avy-lead-face-0 ((t (:foreground ,bg :background ,purple))))
        (avy-lead-face-1 ((t (:foreground ,bg :background ,accent))))
        (avy-lead-face-2 ((t (:foreground ,bg :background ,accent-alt))))
        (avy-background-face ((t (:foreground ,fg-dim))))
        (aw-background-face ((t (:foreground ,fg-dim))))
        (aw-leading-char-face ((t (:foreground ,accent :weight bold))))
        (aw-minibuffer-leading-char-face ((t (:foreground ,accent :weight bold))))

        ;;;; Compilation and cargo (rustic)
        (compilation-error ((t (:foreground ,accent :weight bold))))
        (compilation-warning ((t (:foreground ,special :weight bold))))
        (compilation-info ((t (:foreground ,purple))))
        (compilation-line-number ((t (:foreground ,fg-dim))))
        (compilation-column-number ((t (:foreground ,fg-dim))))
        (compilation-mode-line-exit ((t (:foreground ,special :weight bold))))
        (compilation-mode-line-fail ((t (:foreground ,accent :weight bold))))
        (compilation-mode-line-run ((t (:foreground ,accent-alt :weight bold))))
        (rustic-compilation-error ((t (:inherit compilation-error))))
        (rustic-compilation-warning ((t (:inherit compilation-warning))))
        (rustic-compilation-info ((t (:inherit compilation-info))))
        (rustic-compilation-line ((t (:inherit compilation-line-number))))
        (rustic-compilation-column ((t (:inherit compilation-column-number))))
        (rustic-message ((t (:foreground ,fg))))

        ;;;; Dired
        (dired-directory ((t (:foreground ,accent :weight bold))))
        (dired-symlink ((t (:foreground ,accent))))

        ;;;; Org and Markdown
        (org-level-1 ((t (:foreground ,accent :weight bold :height 1.3))))
        (org-level-2 ((t (:foreground ,purple :weight bold :height 1.2))))
        (org-level-3 ((t (:foreground ,fg :weight bold :height 1.1))))
        (org-level-4 ((t (:foreground ,accent :weight bold))))
        (org-code ((t (:foreground ,accent :background ,bg-raised))))
        (org-block ((t (:background ,bg-raised))))
        (org-block-begin-line ((t (:foreground ,accent :background ,bg-raised))))
        (org-block-end-line ((t (:inherit org-block-begin-line))))
        (markdown-header-face-1 ((t (:inherit org-level-1))))
        (markdown-header-face-2 ((t (:inherit org-level-2))))
        (markdown-header-face-3 ((t (:inherit org-level-3))))
        (markdown-code-face ((t (:inherit org-code))))

        ;;;; which-key (built into Emacs 30)
        (which-key-key-face ((t (:foreground ,accent :weight bold))))
        (which-key-command-description-face ((t (:foreground ,fg))))
        (which-key-group-description-face ((t (:foreground ,purple))))

        ;;;; Other packages (not used by the toad-macs config)
        (company-tooltip ((t (:foreground ,fg :background ,bg-raised))))
        (company-tooltip-selection ((t (:foreground ,fg :background ,bg-soft))))
        (company-tooltip-common ((t (:foreground ,accent :weight bold))))
        (ivy-current-match ((t (:foreground ,accent :background ,bg-soft :weight bold))))
        (ivy-minibuffer-match-highlight ((t (:background ,bg-soft))))
        (ivy-minibuffer-match-face-1 ((t (:background ,bg-soft))))
        (ivy-minibuffer-match-face-2 ((t (:foreground ,accent :background ,bg-soft))))
        (helm-selection ((t (:foreground ,accent :background ,bg-soft))))
        (lsp-face-highlight-read ((t (:background ,bg-soft))))
        (lsp-face-highlight-write ((t (:background ,bg-soft))))
        (lsp-face-highlight-textual ((t (:background ,bg-soft))))
        (lsp-ui-doc-background ((t (:background ,bg-soft))))
        (lsp-ui-doc-header ((t (:foreground ,bg-soft))))
        (lsp-ui-peek-filename ((t (:foreground ,accent))))
        (lsp-ui-peek-header ((t (:background ,bg-soft))))
        (lsp-ui-sideline-code-action ((t (:foreground ,accent))))
        (popup-tip-face ((t (:foreground ,fg :background ,bg-soft)))))))))

(provide 'magic-toad-common)
;;; magic-toad-common.el ends here
