;; Set up package.el to work with MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(when (not package-archive-contents)
(package-refresh-contents))

(custom-set-faces
 '(default ((t (:inherit nil :stipple nil :background "White" :foreground "Black" :inverse-video nil :box nil :strike-through nil :extend nil :overline nil :underline nil :slant normal :weight normal :height 180 :width normal :foundry "nil" :family "Menlo")))))


(setq mac-command-modifier      'super
      mac-right-command-modifier 'ctrl
      ns-command-modifier       'super
      mac-option-modifier       'meta
      ns-option-modifier        'meta
      ns-right-option-modifier  'meta)

(setq inhibit-startup-screen t)

;; org table 字体设置
(setq fontset-orgtable
      (create-fontset-from-ascii-font "Monaco 19"))
(dolist (charset '(han symbol cjk-misc))
  (set-fontset-font fontset-orgtable charset
		    (font-spec :family "Hiragino Sans GB W3"
			       :size 22)))

(add-hook 'org-mode-hook
	  '(lambda ()
	     (set-face-attribute 'org-table nil
				 :font "Monaco 19"
				 :fontset fontset-orgtable)))

(setq backup-directory-alist
          `((".*" . ,temporary-file-directory)))
    (setq auto-save-file-name-transforms
          `((".*" ,temporary-file-directory t)))

(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))
