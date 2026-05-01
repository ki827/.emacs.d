;;; init.el --- Main entry point -*- lexical-binding: t; -*-

;;; Load path
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;;; Package archives
(require 'package)
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))
;; Activate installed packages explicitly. In interactive sessions this is
;; usually done automatically before init.el runs, but `emacs --batch'
;; skips it, and calling it twice is harmless.
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;;; use-package (built-in since Emacs 29)
(require 'use-package)
(setq use-package-always-ensure t
      use-package-expand-minimally t
      use-package-compute-statistics nil)

;;; Custom file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file 'noerror 'nomessage))

;;; Modules
(require 'core-ui)
(require 'core-editor)
(require 'core-completion)
(require 'core-project)
(require 'core-prog)
(require 'lang-c)
(require 'lang-go)
(require 'lang-rust)
(require 'lang-org)
(require 'lang-markdown)

;;; Open the configuration manual
(defun my/open-manual ()
  "Open README.org from the user's emacs config directory."
  (interactive)
  (find-file (expand-file-name "README.org" user-emacs-directory)))
(global-set-key (kbd "C-c m") #'my/open-manual)

;;; Restore GC after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 32 1024 1024)
                  gc-cons-percentage 0.1)
            (message "Emacs ready in %.2fs (%d GCs)."
                     (float-time (time-subtract after-init-time before-init-time))
                     gcs-done)))

(provide 'init)
;;; init.el ends here
