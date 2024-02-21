  (when (string= system-type "darwin")
    (setq mac-command-modifier 'ctrl
	        mac-right-command-modifier 'ctrl
	        mac-option-modifier 'meta
	        mac-right-option-modifier 'meta
	        dired-use-ls-dired nil
	        completion-ignored-extensions (cons ".DS_Store" completion-ignored-extensions)))
  (set-face-attribute 'default nil
		                  :font (format "%s:pixelsize=%d" "Monaco" 20))
  (dolist (charset '(kana han cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font) charset
                      (font-spec :family "Hiragino Sans GB" :size 24.5)))
  (add-hook 'org-mode-hook 'org-indent-mode)
  (add-hook 'evil-insert-state-exit-hook (lambda() (shell-command "macism com.apple.keylayout.ABC")))
