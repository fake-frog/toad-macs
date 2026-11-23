;;; magic-toad-theme.el --- A magical toad has many tricks. -*- lexical-binding: t; -*-

;;; Code:

(load (expand-file-name "magic-toad-common"
                        (file-name-directory (or load-file-name buffer-file-name)))
      nil t)

(deftheme magic-toad
  "A magical toad has many tricks."
  :kind 'color-scheme
  :family 'magic-toad
  :background-mode 'dark)

(magic-toad--set-faces
 'magic-toad
 :bg         "#151515"
 :bg-slight  "#191919"
 :bg-soft    "#1d1d1d"
 :bg-raised  "#252121"
 :fg         "#dababa"
 :fg-dim     "#696262"
 :accent     "#f66151"
 :accent-alt "#f666aa"
 :special    "#53997b"
 :purple     "#dc8add")

(provide-theme 'magic-toad)

;;; magic-toad-theme.el ends here
