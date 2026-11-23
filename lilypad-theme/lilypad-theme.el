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
 "#151515"   ; bg
 "#191919"   ; bg-slight
 "#1f1d1d"   ; bg-soft
 "#252121"   ; bg-raised
 "#dababa"   ; fg
 "#696262"   ; fg-dim
 "#bccca3"   ; accent
 "#86c29b"   ; accent-alt
 "#53997b"   ; special
 "#539992"   ; purple
 "#f66151"   ; error
 "#dc8add"   ; warning
 "#53997b")  ; good
(provide-theme 'lilypad)

;;; lilypad-theme.el ends here
