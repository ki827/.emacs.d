(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

;;; osx
(when (string= system-type "darwin")
  (setq mac-command-modifier 'ctrl
	mac-right-command-modifier 'ctrl
	mac-option-modifier 'meta
	mac-right-option-modifier 'meta
	dired-use-ls-dired nil
	completion-ignored-extensions (cons ".DS_Store" completion-ignored-extensions)))


(setq image-types (cons 'svg image-types)
      auto-save-visited-file-name t
      inhibit-startup-screen t
      backup-directory-alist '(("." . "~/.emacs.d/backups/")))
(global-display-line-numbers-mode t)
(electric-pair-mode t)

(set-face-attribute 'default nil
		    :font (format "%s:pixelsize=%d" "Monaco" 20))
(dolist (charset '(kana han cjk-misc bopomofo))
  (set-fontset-font (frame-parameter nil 'font) charset
                    (font-spec :family "Hiragino Sans GB" :size 24.5)))

(defun open-elisp-dir()
  ;;; open ~/.emacs.d/lisp dir
  (interactive)
  (when (file-directory-p "~/.emacs.d/lisp")
    (find-file "~/.emacs.d/lisp")))
(global-set-key (kbd "C-c e l") 'open-elisp-dir)

(defun open-emacs-dir()
  ;;; open ~/.emacs.d
  (interactive)
  (when (file-exists-p "~/.emacs.d")
    (find-file "~/.emacs.d")))
(global-set-key (kbd "C-c e d") 'open-emacs-dir)

(defun open-emacs-init()
  ;;; open ~/.emacs.d/init.el
  (interactive)
  (when (file-exists-p "~/.emacs.d/init.el")
    (find-file "~/.emacs.d/init.el")))
(global-set-key (kbd "C-c e i") 'open-emacs-init)

(provide 'init-basic)
