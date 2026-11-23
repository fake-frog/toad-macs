;;; init-defaults.el --- Core editor behaviour  -*- lexical-binding: t; -*-

;;; Commentary:
;; Built-in settings that aren't about looks or keys: backups, history,
;; and general editing behaviour.

;;; Code:

;;;; Backups and auto-saves
;; Keep them in ~/.emacs.d instead of littering project directories.
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups" user-emacs-directory))))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "autosaves/" user-emacs-directory) t)))
(setq version-control t           ; numbered backups
      delete-old-versions t
      kept-new-versions 5
      kept-old-versions 2)

;;;; History
(savehist-mode 1)                 ; persist minibuffer history
(recentf-mode 1)                  ; track recent files (C-c b, dashboard [r])

;;;; Editing
(electric-pair-mode 1)            ; auto-close brackets (disabled under paredit)

;; Re-enable commands that Emacs disables by default.
(put 'downcase-region 'disabled nil)

(provide 'init-defaults)
;;; init-defaults.el ends here
