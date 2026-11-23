;;; early-init.el --- Runs before packages and the first frame  -*- lexical-binding: t; -*-

;;; Code:

;; Don't garbage-collect while starting up (it used to run ~38 times), then
;; settle on a threshold above the 800 KB default, which also suits the
;; bursts of JSON that LSP servers send.
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 32 1024 1024))))

;;; early-init.el ends here
