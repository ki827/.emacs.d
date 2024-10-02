(use-package consult
  :ensure t
  :bind (("C-s" . consult-line)        ;; search current buffer
         ("M-y" . consult-yank-pop)    ;; browse kill-ring
         ("C-x b" . consult-buffer)    ;; buffer switch
         ("C-x p b" . consult-project-buffer))  ;; project buffer switch
  :config
  (setq consult-project-root-function #'projectile-project-root))  ;; If using projectile

(provide 'init-consult)
