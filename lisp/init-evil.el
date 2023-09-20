(use-package evil
  :ensure t
  :init
  (evil-mode 1)
  :hook
  ((evil-insert-state-entry . (lambda() (shell-command "macism com.apple.keylayout.ABC")))
   (evil-insert-state-exit . (lambda() (shell-command "macism com.apple.keylayout.ABC")))))
(provide 'init-evil)
