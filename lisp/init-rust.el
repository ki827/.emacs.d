(use-package rust-mode
  :ensure t
  :config
  (setq rust-format-on-save t)
  (add-hook 'rust-mode-hook 'eglot-ensure))

(provide 'init-rust)
