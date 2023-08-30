(use-package flymake
  :ensure t
  :bind
  (("C-c e p" . 'flymake-goto-prev-error)
   ("C-c e n" . 'flymake-goto-next-error)
   ("C-c e d" . 'flymake-goto-diagnostic)))

(provide 'init-flymake)
