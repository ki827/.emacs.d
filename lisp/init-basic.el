(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(require 'use-package)
(setq use-package-always-ensure t)  

(use-package emacs
  :init
  (pixel-scroll-precision-mode t)
  
  :config
    ;; UI
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (global-display-line-numbers-mode 1)
  (setq column-number-mode t)
  (setq inhibit-startup-screen t)
  ;; Font
  (set-face-attribute 'default nil :font "Ubuntu Mono-20")
  ;; Custom file path
  (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
  ;; MacOS key mapping
  (when (string= system-type "darwin")
    (setq mac-command-modifier 'ctrl
	  mac-option-modifier 'meta))
  ;; Auto save 
  (setq auto-save-default t
        auto-save-interval 200
        auto-save-timeout 30
        auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

  ;; Backups
  (setq backup-directory-alist '(("." . "~/.emacs.d/backups/"))
	make-backup-files t
	version-control t
	kept-new-versions 10
	kept-old-versions 2
	delete-old-versions t
	backup-by-copying t)

  ;; eldoc
  (setq eldoc-echo-area-use-multiline-p 1
	eldoc-current-idle-delay 1)

  ;; GC
  (setq gc-cons-threshold 512000000)  ; 设置为100MB
  (setq gc-cons-percentage 0.6)       ; 设置GC触发时机
  :bind
  (("C-c e l" . (lambda () (interactive) (find-file (expand-file-name "lisp" user-emacs-directory)))))
   ("C-c e i" . (lambda () (interactive) (find-file (expand-file-name "init.el" user-emacs-directory)))))

(use-package electric
  :config
  (electric-pair-mode 1)              
  (electric-indent-mode 1))           

(use-package paren
  :config
  (show-paren-mode 1))                

(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t
        auto-package-update-interval 7)
  (auto-package-update-maybe))

(use-package all-the-icons
  :if (display-graphic-p))

(provide 'init-basic)
