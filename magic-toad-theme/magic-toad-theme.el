;;; magic-toad-theme.el --- A magical toad has many tricks. -*- lexical-binding: t; -*-

(require 'magic-toad-common
	 (expand-file-name "magic-toad-common" (file-name-directory load-file-name)))

(deftheme magic-toad
  "A magical toad has many tricks."
  :kind 'color-scheme
  :family 'magic-toad
  :background-mode 'dark)

(magic-toad--set-faces
 'magic-toad
 "#100000"   ; bg
 "#111111"   ; bg-slight
 "#1f1d1d"   ; bg-soft
 "#252121"   ; bg-raised
 "#dababa"   ; fg
 "#696262"   ; fg-dim
 "#f66151"   ; accent
 "#f666aa"   ; accent-alt
 "#53997b"   ; special
 "#dc8add")  ; purple

(provide-theme 'magic-toad)

;;; magic-toad-theme.el ends here
