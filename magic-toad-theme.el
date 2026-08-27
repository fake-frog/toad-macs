(deftheme magic-toad "A magical toad has many tricks.")

(let ((bg          "#000000")   ; default background
      (bg-slight   "#111111")   ; region, hl-line, mode line
      (bg-soft     "#1f1d1d")   ; region, hl-line, mode line
      (bg-raised   "#252121")   ; popups, org blocks
      (fg          "#dababa")   ; default foreground
      (fg-dim      "#696262")   ; comments, inactive, hints
      (accent      "#f66151")   ; cursor, errors, headings
      (accent-alt  "#f666aa")   ; strings, types, mode line
      (special     "#53997b")   ; dark green, preprocessor 
      (purple      "#dc8add"))  ; keywords, operators, punctuation

  (custom-theme-set-faces
   'magic-toad

   ;; Base faces
   `(default ((t (:foreground ,fg :background ,bg))))
   `(cursor ((t (:background ,special))))
   `(region ((t (:foreground ,bg :background ,fg ))))
   `(highlight ((t (:background ,bg-soft))))
   `(hl-line ((t (:background ,bg-slight))))
   `(fringe ((t (:background ,bg :foreground ,fg))))
   `(vertical-border ((t (:foreground ,bg-raised))))

   ;; Font lock
   `(font-lock-comment-face ((t (:foreground ,fg-dim :slant italic))))
   `(font-lock-doc-face ((t (:foreground ,accent))))
   `(font-lock-string-face ((t (:foreground ,accent-alt))))
   `(rust-string-interpolation ((t (:foreground ,fg))))
   `(font-lock-keyword-face ((t (:foreground ,special))))
   `(font-lock-builtin-face ((t (:foreground ,fg))))
   `(font-lock-function-name-face ((t (:foreground ,fg))))
   `(rust-ampersand-face ((t (:foreground ,accent-alt))))
   `(rust-unsafe ((t (:foreground ,special))))
   `(rust-question-mark ((t (:foreground ,accent-alt))))
   `(rust-question-mark-face ((t (:foreground ,accent-alt))))
   `(rust-builtin-formatting-macro ((t (:foreground ,fg))))
   `(sh-quoted-exec ((t (:foreground ,accent))))
   `(sh-heredoc ((t (:foreground ,fg))))
   `(font-lock-variable-name-face ((t (:foreground ,fg))))
   `(font-lock-type-face ((t (:foreground ,fg :slant italic))))
   `(font-lock-constant-face ((t (:foreground ,fg))))
   `(font-lock-warning-face ((t (:foreground ,fg-dim))))
   `(font-lock-negation-char-face ((t (:foreground ,purple))))
   `(font-lock-operator-face ((t (:foreground ,purple))))
   `(font-lock-punctuation-face ((t (:foreground ,purple))))
   `(font-lock-preprocessor-face ((t (:foreground ,purple))))
   `(button ((t (:foreground ,accent :background ,bg-soft))))

   ;; Mode line
   `(mode-line ((t (:foreground ,accent-alt :background ,bg-soft :slant italic :weigth normal))))
   `(mode-line-inactive ((t (:foreground ,fg-dim :background ,bg-slight :box (:line-width 1 :color ,bg-raised)))))
   `(mode-line-buffer-id ((t (:weight bold))))
   `(mood-line-unimportant ((t (:foreground ,fg-dim))))
   `(mood-line-status-neutral ((t (:foreground ,fg-dim))))
   `(mood-line-frame-status-client ((t (:foreground ,fg-dim))))
   `(mood-line-encoding ((t (:foreground ,fg-dim))))
   `(mood-line-buffer-status-read-only ((t (:foreground ,fg-dim))))

   ;; Minibuffer
   `(minibuffer-prompt ((t (:foreground ,accent :weight bold))))

   ;; Search
   `(isearch ((t (:foreground ,fg :background ,bg-soft :weight bold))))
   `(match ((t (:background ,bg-soft :foreground ,fg))))
   `(completions-common-part ((t (:background ,bg-soft :foreground ,fg))))
   `(lazy-highlight ((t (:foreground ,fg :background ,bg-raised :underline t))))

   ;; Line numbers
   `(line-number ((t (:foreground ,fg-dim :background ,bg))))
   `(line-number-current-line ((t (:foreground ,special :background ,bg))))

   ;; Parentheses matching
   `(show-paren-match ((t (:foreground ,fg :background ,bg :weight bold))))
   `(show-paren-mismatch ((t (:foreground ,accent :background ,bg :weight bold))))

   ;; Error/warning faces
   `(error ((t (:foreground ,accent :weight bold))))
   `(warning ((t (:foreground ,accent :weight bold))))
   `(success ((t (:foreground ,fg :weight bold))))

   `(flycheck-warning ((t (:underline (:color ,fg-dim :style wave)))))
   `(flycheck-error ((t (:underline (:color ,accent :style wave)))))
   `(flycheck-note ((t (:underline (:color ,fg-dim :style wave)))))

   `(flymake-warning ((t (:underline (:color ,fg-dim :style wave)))))
   `(flymake-error ((t (:underline (:color ,accent :style wave)))))
   `(flymake-note ((t (:underline (:color ,fg-dim :style wave)))))

   ;; Diagnostic severity levels
   `(lsp-lsp-flycheck-error-unnecessary-face ((t (:foreground ,bg-soft :underline nil))))
   `(lsp-lsp-flycheck-warning-unnecessary-face ((t (:foreground ,bg-soft :underline nil))))

   ;; LSP UI faces
   `(lsp-ui-doc-background ((t (:background ,bg-soft))))
   `(lsp-ui-doc-header ((t (:foreground ,bg-soft))))
   `(lsp-ui-peek-filename ((t (:foreground ,accent))))
   `(lsp-ui-peek-header ((t (:background ,bg-soft))))
   `(lsp-ui-sideline-code-action ((t (:foreground ,accent))))

   `(lsp-face-highlight-read ((t (:background ,bg-soft))))
   `(lsp-face-highlight-write ((t (:background ,bg-soft))))
   `(lsp-face-highlight-textual ((t (:background ,bg-soft))))

   `(eglot-type-hint-face ((t (:foreground ,fg-dim))))
   `(eglot-inlay-hint-face ((t (:foreground ,fg-dim))))
;;   `(eglot-highlight-symbol-face ((t (:foreground ,fg :background ,bg-soft))))
   `(eglot-diagnostic-tag-unnecessary-face ((t (:foreground ,fg-dim))))
   `(eglot-semantic-declaration ((t (:foreground ,accent :slant italic))))
   `(popup-tip-face ((t (:foreground ,fg :background ,bg-soft))))

   ;; Dired
   `(dired-directory ((t (:foreground ,accent :weight bold))))
   `(dired-symlink ((t (:foreground ,accent))))
   `(dired-executable ((t (:foreground ,fg))))

   `(help-key-binding ((t (:foreground ,accent :background ,bg))))
   `(read-multiple-choice-face ((t (:foreground ,accent :weight bold))))

   ;;Avy
   `(avy-lead-face ((t (:foreground ,bg :background ,special))))
   `(avy-lead-face-0 ((t (:foreground ,bg :background ,purple))))
   `(avy-lead-face-1 ((t (:foreground ,bg :background ,accent))))
   `(avy-lead-face-2 ((t (:foreground ,bg :background ,accent-alt))))
   `(avy-background-face ((t (:foreground ,fg-dim))))

   ;;Ace Window

   `(aw-background-face ((t (:foreground ,fg-dim))))
   `(aw-leading-char-face ((t (:foreground ,accent :weight bold))))
   `(aw-minibuffer-leading-char-face ((t (:foreground ,accent :weight bold))))

   ;; Company
   `(company-tooltip ((t (:foreground ,fg :background ,bg-raised))))
   `(company-tooltip-selection ((t (:foreground ,fg :background ,bg-soft))))
   `(company-tooltip-common ((t (:foreground ,accent :weight bold))))

    ;; Corfu
   `(corfu-current ((t (:foreground ,accent-alt))))
   `(corfu-annotations ((t (:foreground ,fg-dim))))
   `(corfu-default ((t (:foreground ,fg :background ,bg-slight))))
   `(orderless-match-face-0 ((t (:foreground ,accent-alt :weight semi-bold))))
   `(completions-annotations ((t (:foreground ,fg-dim))))

      ;;Vertico
   `(vertico-multiline ((t (:foreground ,accent))))
   `(vertico-group-title ((t (:foreground ,fg-dim))))
   `(vertico-group-separator ((t (:foreground ,fg-dim :strike-through t))))


   ;; Org mode
   `(org-level-1 ((t (:foreground ,accent :weight bold :height 1.3))))
   `(org-level-2 ((t (:foreground ,purple :weight bold :height 1.2))))
   `(org-level-3 ((t (:foreground ,fg :weight bold :height 1.1))))
   `(org-level-4 ((t (:foreground ,accent :weight bold))))
   `(org-code ((t (:foreground ,accent :background ,bg-raised))))
   `(org-block ((t (:background ,bg-raised))))
   `(org-block-begin-line ((t (:foreground ,accent :background ,bg-raised))))
   `(org-block-end-line ((t (:inherit org-block-begin-line))))

   ;; Markdown
   `(markdown-header-face-1 ((t (:inherit org-level-1))))
   `(markdown-header-face-2 ((t (:inherit org-level-2))))
   `(markdown-header-face-3 ((t (:inherit org-level-3))))
   `(markdown-code-face ((t (:inherit org-code))))

   ;; Magit
   `(magit-branch-local ((t (:foreground ,accent))))
   `(magit-branch-remote ((t (:foreground ,fg))))
   `(magit-diff-added ((t (:foreground ,fg :background ,(concat fg "20")))))
   `(magit-diff-removed ((t (:foreground ,accent :background ,(concat accent "20")))))
   `(magit-diff-context ((t (:foreground ,fg))))
   `(diff-hl-margin-change ((t (:foreground ,purple :background ,bg-soft))))
   `(diff-hl-margin-insert ((t (:foreground ,special :background ,bg-soft))))
   `(diff-hl-margin-delete ((t (:foreground ,accent :background ,bg-soft))))

   ;; Which-key
   `(which-key-key-face ((t (:foreground ,accent :weight bold))))
   `(which-key-description-face ((t (:foreground ,fg))))
   `(which-key-group-description-face ((t (:foreground ,purple))))

   ;; Helm/Ivy
   `(helm-selection ((t (:foreground ,accent :background ,bg-soft))))
   `(ivy-current-match ((t (:foreground ,accent :background ,bg-soft :weight bold))))
   `(ivy-minibuffer-match-highlight ((t (:background ,bg-soft))))
   `(ivy-minibuffer-match-1 ((t (:background ,bg-soft))))
   `(ivy-minibuffer-match-face-1 ((t (:background ,bg-soft))))
   `(ivy-minibuffer-match-face-2 ((t (:foreground ,accent :background ,bg-soft))))

   ;; vterm
   `(vterm-color-black ((t (:foreground ,bg :background ,bg))))
   `(vterm-color-red ((t (:foreground ,accent :background ,accent))))
   `(vterm-color-green ((t (:foreground ,fg :background ,fg))))
   `(vterm-color-yellow ((t (:foreground ,fg :background ,fg))))
   `(vterm-color-blue ((t (:foreground ,accent :background ,accent))))
   `(vterm-color-magenta ((t (:foreground ,purple :background ,purple))))
   `(vterm-color-cyan ((t (:foreground ,accent :background ,accent))))
   `(vterm-color-white ((t (:foreground ,fg :background ,fg))))
   ))

(provide-theme 'magic-toad)
