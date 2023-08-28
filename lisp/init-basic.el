(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

;;; osx
(when (string= system-type "darwin")
  (setq mac-command-modifier 'ctrl
	mac-right-command-modifier 'ctrl
	mac-option-modifier 'meta
	mac-right-option-modifier 'meta
	dired-use-ls-dired nil))

(setq image-types (cons 'svg image-types)
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

(provide 'init-basic)
