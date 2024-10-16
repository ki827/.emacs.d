(use-package rust-mode
  :init
  (setq rust-mode-treesitter-derive t)
  :config
  (setq rust-format-on-save t)
  :hook
  (rust-mode . (lambda () (prettify-symbols-mode)))
  (rust-mode . eglot-ensure))

(provide 'init-rust)
