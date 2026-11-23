;;; magic-toad-light-theme.el --- A magical toad, but it's daytime. -*- lexical-binding: t; -*-

;;; Code:

(load (expand-file-name "magic-toad-common"
                        (file-name-directory (or load-file-name buffer-file-name)))
      nil t)

(deftheme magic-toad-light
  "A magical toad, but it's daytime."
  :kind 'color-scheme
  :family 'magic-toad
  :background-mode 'light)

(magic-toad--set-faces
 'magic-toad-light
 :bg         "#ffffff"
 :bg-slight  "#fafafa"
 :bg-soft    "#efefef"
 :bg-raised  "#ffedfd"
 :fg         "#221111"
 :fg-dim     "#aaaaaa"
 :accent     "#f66151"
 :accent-alt "#f666aa"
 :special    "#43896b"
 :purple     "#dc8add")

(provide-theme 'magic-toad-light)

;;; magic-toad-light-theme.el ends here
