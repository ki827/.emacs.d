;;; lang-c.el --- C / C++ -*- lexical-binding: t; -*-

(use-package c-ts-mode
  :ensure nil
  :init
  (setq c-ts-mode-indent-offset 4
        c-ts-mode-indent-style 'linux))

;; Stop electric-indent from dedenting a half-typed line at the first
;; ':'. Without this, typing 'std:' makes the parser see a label and
;; jump the line to column 0; the line snaps back only after '::' is
;; complete. We trade away auto-dedent of `case`/`goto` labels for a
;; non-jumpy editing experience — those are easy to indent by hand.
(defun my/c-ts-disable-colon-electric ()
  (setq-local electric-indent-chars
              (remove ?: electric-indent-chars)))
(add-hook 'c-ts-mode-hook        #'my/c-ts-disable-colon-electric)
(add-hook 'c++-ts-mode-hook      #'my/c-ts-disable-colon-electric)
(add-hook 'c-or-c++-ts-mode-hook #'my/c-ts-disable-colon-electric)

;; .h auto-detects C vs C++ via heuristics.
(add-to-list 'auto-mode-alist '("\\.h\\'" . c-or-c++-ts-mode))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((c-ts-mode c++-ts-mode c-or-c++-ts-mode)
                 . ("clangd"
                    "--header-insertion=never"
                    "--clang-tidy"
                    "--completion-style=detailed"
                    "--background-index"
                    "-j=4"
                    "--pch-storage=memory"))))

(use-package cmake-ts-mode
  :ensure nil
  :mode (("CMakeLists\\.txt\\'" . cmake-ts-mode)
         ("\\.cmake\\'"          . cmake-ts-mode)))

(provide 'lang-c)
;;; lang-c.el ends here
