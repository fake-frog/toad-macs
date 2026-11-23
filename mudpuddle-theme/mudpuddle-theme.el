;;; mudpuddle-theme.el --- A calm toad in warm, muddy water. -*- lexical-binding: t; -*-

;;; Commentary:
;; A low-key dark theme for toad-macs.  Where magic-toad is bright and
;; contrasty, mudpuddle sticks to familiar syntax colours at an even
;; brightness on warm charcoal grays.
;;
;; Inspired by the Claude desktop app's dark mode: the grays come from its
;; UI, and the syntax roles follow the One Dark palette its Code tab uses
;; (keywords violet, strings green, functions blue, types pink, numbers
;; orange, constants and operators aqua), drawn in Claude's softer tints.
;; Every syntax colour sits at roughly 6-7:1 contrast on the background.

;;; Code:

(require 'cl-lib)

(deftheme mudpuddle
  "A calm toad in warm, muddy water."
  :kind 'color-scheme
  :family 'toad-macs
  :background-mode 'dark)

(defun mudpuddle--blend (color base alpha)
  "Mix ALPHA (0.0-1.0) of hex COLOR over hex BASE; return \"#rrggbb\"."
  (cl-flet ((rgb (c) (mapcar (lambda (i) (string-to-number (substring c i (+ i 2)) 16))
                             '(1 3 5))))
    (apply #'format "#%02x%02x%02x"
           (cl-mapcar (lambda (a b) (round (+ (* alpha a) (* (- 1 alpha) b))))
                      (rgb color) (rgb base)))))

(let* (;; Grays
       (bg        "#1a1a19")             ; editor background
       (bg-dark   "#111110")             ; inactive mode line, ANSI black
       (fg        "#c3c2b7")             ; body text
       (fg-bright "#f0efec")             ; emphasis, headings, current items
       (fg-muted  "#898781")             ; comments, secondary text
       (border    "#383835")             ; dividers, borders
       (bg-hl     (mudpuddle--blend fg bg 0.05))   ; current line
       (bg-alt    (mudpuddle--blend fg bg 0.09))   ; mode line, popups, headers
       (fg-faint  (mudpuddle--blend fg-muted bg 0.60)) ; line numbers
       ;; Colours
       (red       "#ec7e7e")
       (orange    "#ec835a")
       (pink      "#e87ba4")
       (green     "#55bf50")
       (aqua      "#3bbd8c")
       (blue      "#6da7ec")
       (violet    "#a096eb")
       ;; Tinted backgrounds
       (bg-blue          (mudpuddle--blend blue bg 0.22))
       (bg-pink          (mudpuddle--blend pink bg 0.28))
       (added-bg         (mudpuddle--blend green bg 0.13))
       (added-bg-strong  (mudpuddle--blend green bg 0.26))
       (removed-bg       (mudpuddle--blend red bg 0.13))
       (removed-bg-strong (mudpuddle--blend red bg 0.26))
       ;; ANSI colours: (name normal bright)
       (ansi `(("black"   ,bg-dark ,fg-muted)
               ("red"     ,red     ,red)
               ("green"   ,green   ,green)
               ("yellow"  ,pink    ,pink)
               ("blue"    ,blue    ,blue)
               ("magenta" ,violet  ,violet)
               ("cyan"    ,aqua    ,aqua)
               ("white"   ,fg      ,fg-bright))))

  ;; rustic colours cargo output with xterm-color, which has its own palette.
  (custom-theme-set-variables
   'mudpuddle
   `(xterm-color-names ,(apply #'vector (mapcar #'cadr ansi)))
   `(xterm-color-names-bright ,(apply #'vector (mapcar #'caddr ansi))))

  (apply
   #'custom-theme-set-faces 'mudpuddle
   (append
    (cl-loop for (name normal bright) in ansi
             for face = (intern (concat "ansi-color-" name))
             collect `(,face ((t (:foreground ,normal :background ,normal))))
             collect `(,(intern (concat "ansi-color-bright-" name))
                       ((t (:foreground ,bright :background ,bright))))
             collect `(,(intern (concat "vterm-color-" name)) ((t (:inherit ,face)))))
    `(
      ;;;; Base
      (default ((t (:foreground ,fg :background ,bg))))
      (cursor ((t (:background ,orange))))
      (region ((t (:background ,bg-blue :extend t))))
      (secondary-selection ((t (:background ,border :extend t))))
      (highlight ((t (:background ,bg-alt))))
      (hl-line ((t (:background ,bg-hl :extend t))))
      (shadow ((t (:foreground ,fg-muted))))
      (fringe ((t (:foreground ,fg-faint :background ,bg))))
      (vertical-border ((t (:foreground ,border))))
      (window-divider ((t (:foreground ,border))))
      (fill-column-indicator ((t (:foreground ,border))))
      (header-line ((t (:foreground ,fg :background ,bg-alt))))
      (link ((t (:foreground ,blue :underline t))))
      (link-visited ((t (:foreground ,violet :underline t))))
      (button ((t (:inherit link))))
      (escape-glyph ((t (:foreground ,aqua))))
      (homoglyph ((t (:foreground ,aqua))))
      (trailing-whitespace ((t (:background ,red))))
      (minibuffer-prompt ((t (:foreground ,blue :weight bold))))
      (help-key-binding ((t (:foreground ,blue :background ,bg-alt))))
      (read-multiple-choice-face ((t (:foreground ,orange :weight bold))))
      (tooltip ((t (:foreground ,fg :background ,bg-alt))))
      (eldoc-highlight-function-argument ((t (:foreground ,orange :weight bold))))

      ;;;; Status
      (error ((t (:foreground ,red :weight bold))))
      (warning ((t (:foreground ,pink :weight bold))))
      (success ((t (:foreground ,green :weight bold))))

      ;;;; Font lock
      (font-lock-comment-face ((t (:foreground ,fg-muted :slant italic))))
      (font-lock-comment-delimiter-face ((t (:inherit font-lock-comment-face))))
      (font-lock-doc-face ((t (:foreground ,fg-muted :slant italic))))
      (font-lock-string-face ((t (:foreground ,green))))
      (font-lock-keyword-face ((t (:foreground ,violet))))
      (font-lock-builtin-face ((t (:foreground ,pink))))
      (font-lock-function-name-face ((t (:foreground ,blue))))
      (font-lock-variable-name-face ((t (:foreground ,fg))))
      (font-lock-type-face ((t (:foreground ,pink))))
      (font-lock-constant-face ((t (:foreground ,aqua))))
      (font-lock-number-face ((t (:foreground ,orange))))
      (font-lock-escape-face ((t (:foreground ,aqua))))
      (font-lock-warning-face ((t (:foreground ,pink))))
      (font-lock-negation-char-face ((t (:foreground ,red))))
      (font-lock-operator-face ((t (:foreground ,aqua))))
      (font-lock-punctuation-face ((t (:foreground ,fg))))
      (font-lock-preprocessor-face ((t (:foreground ,violet))))
      (font-lock-regexp-grouping-construct ((t (:foreground ,orange))))
      (font-lock-regexp-grouping-backslash ((t (:foreground ,orange))))

      ;;;; Rust
      (rust-string-interpolation ((t (:foreground ,orange))))
      (rust-ampersand-face ((t (:foreground ,aqua))))
      (rust-question-mark ((t (:foreground ,aqua :weight bold))))
      (rust-unsafe ((t (:foreground ,red :weight bold))))
      (rust-builtin-formatting-macro ((t (:foreground ,blue))))

      ;;;; Shell
      (sh-quoted-exec ((t (:foreground ,aqua))))
      (sh-heredoc ((t (:foreground ,green))))

      ;;;; Racket
      (racket-keyword-argument-face ((t (:foreground ,orange))))
      (racket-selfeval-face ((t (:foreground ,aqua))))
      (racket-here-string-face ((t (:inherit font-lock-string-face))))
      (racket-xp-def-face ((t (:background ,bg-alt :underline (:color ,fg-muted)))))
      (racket-xp-use-face ((t (:background ,bg-alt))))
      (racket-xp-tail-target-face ((t (:background ,bg-alt :underline (:color ,violet :style wave)))))
      (racket-xp-tail-position-face ((t (:background ,bg-alt))))
      (racket-xp-unused-face ((t (:foreground ,fg-muted :strike-through t))))
      (racket-xp-error-face ((t (:underline (:color ,red :style wave)))))
      (racket-repl-prompt ((t (:foreground ,blue :weight bold))))
      (racket-repl-value ((t (:foreground ,fg))))
      (racket-repl-error-message ((t (:foreground ,red))))
      (racket-repl-error-location ((t (:foreground ,fg-muted :underline t))))

      ;;;; Geiser (Scheme)
      (geiser-font-lock-repl-prompt ((t (:foreground ,blue :weight bold))))
      (geiser-font-lock-repl-output ((t (:foreground ,fg))))
      (geiser-font-lock-repl-output-error ((t (:foreground ,red))))
      (geiser-font-lock-autodoc-identifier ((t (:foreground ,blue))))
      (geiser-font-lock-autodoc-current-arg ((t (:foreground ,orange :weight bold))))
      (geiser-font-lock-error-link ((t (:foreground ,red :underline t))))
      (geiser-font-lock-doc-link ((t (:inherit link))))

      ;;;; Rainbow delimiters
      (rainbow-delimiters-depth-1-face ((t (:foreground ,blue))))
      (rainbow-delimiters-depth-2-face ((t (:foreground ,violet))))
      (rainbow-delimiters-depth-3-face ((t (:foreground ,aqua))))
      (rainbow-delimiters-depth-4-face ((t (:foreground ,pink))))
      (rainbow-delimiters-depth-5-face ((t (:foreground ,green))))
      (rainbow-delimiters-depth-6-face ((t (:foreground ,orange))))
      (rainbow-delimiters-depth-7-face ((t (:foreground ,fg-bright))))
      (rainbow-delimiters-depth-8-face ((t (:foreground ,fg))))
      (rainbow-delimiters-depth-9-face ((t (:foreground ,fg-muted))))
      (rainbow-delimiters-unmatched-face ((t (:foreground ,red :weight bold))))
      (rainbow-delimiters-mismatched-face ((t (:foreground ,red :weight bold))))

      ;;;; Line numbers and parens
      (line-number ((t (:foreground ,fg-faint :background ,bg))))
      (line-number-current-line ((t (:foreground ,fg :background ,bg-hl))))
      (show-paren-match ((t (:foreground ,fg-bright :background ,border :weight bold))))
      (show-paren-mismatch ((t (:foreground ,bg :background ,red :weight bold))))

      ;;;; Mode line (mood-line)
      (mode-line ((t (:foreground ,fg :background ,bg-alt))))
      (mode-line-inactive ((t (:foreground ,fg-muted :background ,bg-dark))))
      (mode-line-buffer-id ((t (:foreground ,fg-bright :weight bold))))
      (mode-line-emphasis ((t (:foreground ,fg-bright :weight bold))))
      (mode-line-highlight ((t (:foreground ,fg-bright :background ,border))))
      (mood-line-unimportant ((t (:foreground ,fg-muted))))
      (mood-line-encoding ((t (:foreground ,fg-muted))))
      (mood-line-frame-status-client ((t (:foreground ,fg-muted))))
      (mood-line-buffer-status-read-only ((t (:foreground ,fg-muted))))
      (mood-line-buffer-status-modified ((t (:foreground ,orange))))
      (mood-line-buffer-status-narrowed ((t (:foreground ,violet))))
      (mood-line-status-neutral ((t (:foreground ,fg-muted))))
      (mood-line-status-error ((t (:foreground ,red :weight bold))))
      (mood-line-status-warning ((t (:foreground ,pink))))
      (mood-line-status-info ((t (:foreground ,blue))))
      (mood-line-status-success ((t (:foreground ,green))))

      ;;;; Search
      (isearch ((t (:foreground ,bg :background ,orange :weight bold))))
      (isearch-fail ((t (:foreground ,red))))
      (lazy-highlight ((t (:foreground ,fg-bright :background ,bg-pink))))
      (match ((t (:foreground ,fg-bright :background ,bg-blue))))

      ;;;; Minibuffer completion (vertico, orderless, consult)
      (completions-common-part ((t (:foreground ,blue))))
      (completions-first-difference ((t (:foreground ,fg-bright :weight bold))))
      (completions-annotations ((t (:foreground ,fg-muted))))
      (completions-highlight ((t (:background ,bg-blue))))
      (vertico-current ((t (:foreground ,fg-bright :background ,bg-blue :extend t))))
      (vertico-multiline ((t (:foreground ,fg-muted))))
      (vertico-group-title ((t (:foreground ,fg-muted :slant italic))))
      (vertico-group-separator ((t (:foreground ,fg-muted :strike-through t))))
      (orderless-match-face-0 ((t (:foreground ,blue :weight bold))))
      (orderless-match-face-1 ((t (:foreground ,violet :weight bold))))
      (orderless-match-face-2 ((t (:foreground ,green :weight bold))))
      (orderless-match-face-3 ((t (:foreground ,orange :weight bold))))
      (consult-preview-insertion ((t (:background ,bg-alt))))
      (consult-preview-line ((t (:background ,bg-alt :extend t))))
      (consult-file ((t (:foreground ,fg))))

      ;;;; In-buffer completion (corfu)
      (corfu-default ((t (:foreground ,fg :background ,bg-alt))))
      (corfu-current ((t (:foreground ,fg-bright :background ,bg-blue))))
      (corfu-annotations ((t (:foreground ,fg-muted))))
      (corfu-border ((t (:background ,border))))
      (corfu-bar ((t (:background ,fg-muted))))

      ;;;; Diagnostics (flycheck, flymake, eglot)
      (flycheck-error ((t (:underline (:color ,red :style wave)))))
      (flycheck-warning ((t (:underline (:color ,pink :style wave)))))
      (flycheck-info ((t (:underline (:color ,blue :style wave)))))
      (flycheck-fringe-error ((t (:foreground ,red))))
      (flycheck-fringe-warning ((t (:foreground ,pink))))
      (flycheck-fringe-info ((t (:foreground ,blue))))
      (flymake-error ((t (:underline (:color ,red :style wave)))))
      (flymake-warning ((t (:underline (:color ,pink :style wave)))))
      (flymake-note ((t (:underline (:color ,blue :style wave)))))
      (eglot-highlight-symbol-face ((t (:background ,border))))
      (eglot-inlay-hint-face ((t (:foreground ,fg-faint))))
      (eglot-type-hint-face ((t (:foreground ,fg-faint))))
      (eglot-parameter-hint-face ((t (:foreground ,fg-faint))))
      (eglot-diagnostic-tag-unnecessary-face ((t (:foreground ,fg-muted))))
      (eglot-diagnostic-tag-deprecated-face ((t (:foreground ,fg-muted :strike-through t))))

      ;;;; Diffs and version control (diff-hl, magit)
      (diff-added ((t (:background ,added-bg :extend t))))
      (diff-removed ((t (:background ,removed-bg :extend t))))
      (diff-refine-added ((t (:background ,added-bg-strong))))
      (diff-refine-removed ((t (:background ,removed-bg-strong))))
      (diff-indicator-added ((t (:foreground ,green))))
      (diff-indicator-removed ((t (:foreground ,red))))
      (diff-header ((t (:foreground ,fg :background ,bg-alt))))
      (diff-file-header ((t (:foreground ,fg-bright :background ,bg-alt :weight bold))))
      (diff-hl-insert ((t (:foreground ,green :background ,green))))
      (diff-hl-delete ((t (:foreground ,red :background ,red))))
      (diff-hl-change ((t (:foreground ,pink :background ,pink))))
      (diff-hl-margin-insert ((t (:foreground ,green :background ,green))))
      (diff-hl-margin-delete ((t (:foreground ,red :background ,red))))
      (diff-hl-margin-change ((t (:foreground ,pink :background ,pink))))
      (magit-section-heading ((t (:foreground ,blue :weight bold))))
      (magit-section-highlight ((t (:background ,bg-hl))))
      (magit-branch-local ((t (:foreground ,blue))))
      (magit-branch-remote ((t (:foreground ,green))))
      (magit-branch-current ((t (:foreground ,blue :box (:line-width -1 :color ,blue)))))
      (magit-hash ((t (:foreground ,fg-muted))))
      (magit-diff-file-heading ((t (:foreground ,fg-bright :weight bold))))
      (magit-diff-file-heading-highlight ((t (:background ,bg-alt :weight bold))))
      (magit-diff-hunk-heading ((t (:foreground ,fg-muted :background ,bg-alt))))
      (magit-diff-hunk-heading-highlight ((t (:foreground ,fg :background ,border))))
      (magit-diff-context ((t (:foreground ,fg-muted))))
      (magit-diff-context-highlight ((t (:foreground ,fg :background ,bg-hl))))
      (magit-diff-added ((t (:foreground ,green :background ,added-bg))))
      (magit-diff-added-highlight ((t (:foreground ,green :background ,added-bg-strong))))
      (magit-diff-removed ((t (:foreground ,red :background ,removed-bg))))
      (magit-diff-removed-highlight ((t (:foreground ,red :background ,removed-bg-strong))))
      (magit-diffstat-added ((t (:foreground ,green))))
      (magit-diffstat-removed ((t (:foreground ,red))))

      ;;;; Jumping (avy, ace-window)
      (avy-lead-face ((t (:foreground ,bg :background ,orange :weight bold))))
      (avy-lead-face-0 ((t (:foreground ,bg :background ,blue :weight bold))))
      (avy-lead-face-1 ((t (:foreground ,bg :background ,violet :weight bold))))
      (avy-lead-face-2 ((t (:foreground ,bg :background ,green :weight bold))))
      (avy-background-face ((t (:foreground ,fg-faint))))
      (aw-background-face ((t (:foreground ,fg-faint))))
      (aw-leading-char-face ((t (:foreground ,orange :weight bold))))
      (aw-minibuffer-leading-char-face ((t (:foreground ,orange :weight bold))))

      ;;;; Compilation and cargo (rustic)
      (compilation-error ((t (:foreground ,red :weight bold))))
      (compilation-warning ((t (:foreground ,pink :weight bold))))
      (compilation-info ((t (:foreground ,blue))))
      (compilation-line-number ((t (:foreground ,fg-muted))))
      (compilation-column-number ((t (:foreground ,fg-muted))))
      (compilation-mode-line-exit ((t (:foreground ,green :weight bold))))
      (compilation-mode-line-fail ((t (:foreground ,red :weight bold))))
      (compilation-mode-line-run ((t (:foreground ,pink :weight bold))))
      (rustic-compilation-error ((t (:inherit compilation-error))))
      (rustic-compilation-warning ((t (:inherit compilation-warning))))
      (rustic-compilation-info ((t (:inherit compilation-info))))
      (rustic-compilation-line ((t (:inherit compilation-line-number))))
      (rustic-compilation-column ((t (:inherit compilation-column-number))))
      (rustic-message ((t (:foreground ,fg))))

      ;;;; Dired
      (dired-directory ((t (:foreground ,blue :weight bold))))
      (dired-symlink ((t (:foreground ,aqua))))
      (dired-header ((t (:foreground ,fg-bright :weight bold))))
      (dired-marked ((t (:foreground ,orange :weight bold))))

      ;;;; Org and Markdown
      (org-level-1 ((t (:foreground ,blue :weight bold))))
      (org-level-2 ((t (:foreground ,violet :weight bold))))
      (org-level-3 ((t (:foreground ,green :weight bold))))
      (org-level-4 ((t (:foreground ,pink :weight bold))))
      (org-code ((t (:foreground ,orange))))
      (org-verbatim ((t (:foreground ,aqua))))
      (org-block ((t (:background ,bg-hl :extend t))))
      (org-block-begin-line ((t (:foreground ,fg-muted :background ,bg-hl :extend t))))
      (org-block-end-line ((t (:inherit org-block-begin-line))))
      (markdown-header-face-1 ((t (:inherit org-level-1))))
      (markdown-header-face-2 ((t (:inherit org-level-2))))
      (markdown-header-face-3 ((t (:inherit org-level-3))))
      (markdown-code-face ((t (:inherit org-block))))
      (markdown-inline-code-face ((t (:inherit org-code))))

      ;;;; which-key
      (which-key-key-face ((t (:foreground ,blue :weight bold))))
      (which-key-command-description-face ((t (:foreground ,fg))))
      (which-key-group-description-face ((t (:foreground ,violet))))
      (which-key-separator-face ((t (:foreground ,fg-muted))))))))

(provide-theme 'mudpuddle)

;;; mudpuddle-theme.el ends here
