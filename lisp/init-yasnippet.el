(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1)
  :bind
  (("M-[" . 'yas-expand)))

(use-package yasnippet-snippets
  :ensure t)

(provide 'init-yasnippet)
