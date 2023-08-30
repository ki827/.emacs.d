(use-package eglot
  :ensure t
  :bind
  (("C-c c a" . 'eglot-code-actions)
   ("C-c c d" . 'eglot-find-declaration)
   ("C-c c i" . 'eglot-find-implementation)
   ("C-c c t" . 'eglot-find-typeDefinition)
   ("C-c c r" . 'eglot-rename)))

(provide 'init-eglot)
