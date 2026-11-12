;;; lilypad-theme.el --- A magical toad has many tricks. -*- lexical-binding: t; -*-

(require 'lilypad-common
	 (expand-file-name "lilypad-common" (file-name-directory load-file-name)))

(deftheme lilypad
  "A magical toad has many tricks."
  :kind 'color-scheme
  :family 'lilypad
  :background-mode 'dark)

(lilypad--set-faces
 'lilypad
 "#111111"   ; bg
 "#151515"   ; bg-slight
 "#1f1d1d"   ; bg-soft
 "#252121"   ; bg-raised
 "#dababa"   ; fg
 "#696262"   ; fg-dim
 "#dababa"   ; accent
 "#f666aa"   ; accent-alt
 "#53997b"   ; special
 "#dababa")  ; purple

(provide-theme 'lilypad)

;;; lilypad-theme.el ends here
