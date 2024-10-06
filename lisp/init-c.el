(use-package clang-format
  :ensure t
  :bind (:map c++-mode-map
              ("C-c c f" . clang-format-buffer))
  :hook
  ((c++-mode . (lambda () (add-hook 'before-save-hook 'clang-format-buffer nil 'local)))))

(provide 'init-c)
