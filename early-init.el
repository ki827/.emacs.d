;;; early-init.el --- Pre-init configuration -*- lexical-binding: t; -*-

;; Defer GC during startup; restored in init.el's emacs-startup-hook.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(setq inhibit-default-init t)

;; Suppress chrome before the first frame paints to avoid flash.
(push '(menu-bar-lines . 0)   default-frame-alist)
(push '(tool-bar-lines . 0)   default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Wider than the 80x24 default so the mode line's minor-mode indicators
;; fit without truncation after cnfonts upsizes the font.
(push '(width  . 120) default-frame-alist)
(push '(height . 36)  default-frame-alist)

(setq inhibit-startup-screen t
      inhibit-startup-message t
      initial-scratch-message nil
      ring-bell-function 'ignore)

(when (featurep 'native-compile)
  (setq native-comp-async-report-warnings-errors 'silent
        native-comp-deferred-compilation t))

(set-language-environment "UTF-8")

(provide 'early-init)
;;; early-init.el ends here
