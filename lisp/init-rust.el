(use-package rust-mode
  :ensure t
  :config
  (setq rust-format-on-save t)
  :hook
  ((rust-mode . eglot-ensure)
   (rust-mode . (lambda () (prettify-symbols-mode)))))

(provide 'init-rust)
