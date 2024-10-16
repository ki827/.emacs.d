(use-package eglot
  :config
  (add-to-list 'eglot-server-programs
             '((rust-ts-mode rust-mode) .
               ("rust-analyzer" :initializationOptions (:check (:command "clippy"))))))

(provide 'init-eglot)
