;;; magic-toad-light-theme.el --- A magical toad, but it's daytime. -*- lexical-binding: t; -*-

(require 'magic-toad-common
	 (expand-file-name "magic-toad-common" (file-name-directory load-file-name)))

(deftheme magic-toad-light
  "A magical toad, but it's daytime."
  :kind 'color-scheme
  :family 'magic-toad
  :background-mode 'light)

(magic-toad--set-faces
 'magic-toad-light
 "#ffffff"   ; bg (was fg)
 "#fafafa"   ; bg-slight (slightly darker than bg)
 "#efefef"   ; bg-soft
 "#ffedfd"   ; bg-raised (most contrast from bg)
 "#221111"   ; fg (was bg)
 "#aaaaaa"   ; fg-dim (darkened a touch for legibility on light bg)
 "#f66151"   ; accent
 "#f666aa"   ; accent-alt
 "#43896b"   ; special
 "#dc8add")  ; purple

(provide-theme 'magic-toad-light)

;;; magic-toad-light-theme.el ends here
