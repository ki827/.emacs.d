(use-package company
  :ensure t
  :config
  (setq company-minimum-prefix-length 1
	company-idle-delay 0
	completion-ignore-case t)
  :bind
  (:map company-active-map
	("C-n" . company-select-next)
	("C-p" . company-select-previous))

  :hook
  ((prog-mode . company-mode)
   (org-mode . company-mode)))

(provide 'init-company)
