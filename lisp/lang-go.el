;;; lang-go.el --- Go -*- lexical-binding: t; -*-

(use-package go-ts-mode
  :ensure nil
  :init
  (setq go-ts-mode-indent-offset 4))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((go-ts-mode go-mod-ts-mode) . ("gopls")))
  (setq-default eglot-workspace-configuration
                (plist-put eglot-workspace-configuration
                           :gopls
                           '(:usePlaceholders t
                             :staticcheck t
                             :gofumpt t
                             :hints (:assignVariableTypes t
                                     :compositeLiteralFields t
                                     :compositeLiteralTypes t
                                     :constantValues t
                                     :functionTypeParameters t
                                     :parameterNames t
                                     :rangeVariableTypes t)))))

;; Prefer goimports over gofmt — it manages imports too.
(with-eval-after-load 'apheleia
  (setf (alist-get 'go-ts-mode apheleia-mode-alist) 'goimports)
  (setf (alist-get 'go-mode    apheleia-mode-alist) 'goimports))

(provide 'lang-go)
;;; lang-go.el ends here
