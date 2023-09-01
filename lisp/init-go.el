(use-package go-mode
  :ensure t
  :config
  (setq tab-width 4
	indent-tabs-mode 1)
  :hook
  ((go-mode . eglot-ensure)))

(provide 'init-go)
