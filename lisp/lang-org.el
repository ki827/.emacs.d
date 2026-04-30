;;; lang-org.el --- Org-mode + CJK polish (native only) -*- lexical-binding: t; -*-

;; Pure built-in Org. No third-party packages — Org's native behaviour
;; is enough once font/wrap settings cooperate with CJK content.

(use-package org
  :ensure nil
  :hook ((org-mode . visual-line-mode))
  :init
  (setq org-directory                       (expand-file-name "~/org/")
        org-startup-folded                  'content
        org-startup-indented                t
        org-hide-emphasis-markers           nil   ; show *, /, =, ~ etc.
        org-pretty-entities                 t
        org-fontify-quote-and-verse-blocks  t
        org-fontify-whole-heading-line      t
        org-src-fontify-natively            t
        org-src-tab-acts-natively           t
        org-src-preserve-indentation        t
        org-edit-src-content-indentation    0
        org-confirm-babel-evaluate          nil
        org-image-actual-width              600
        org-tags-column                     -80
        org-log-done                        'time
        org-todo-keywords
        '((sequence "TODO(t)" "DOING(i)" "WAIT(w)"
                    "|" "DONE(d)" "CANCELED(c)"))))

;; CJK-aware soft wrap (Emacs 28+). Without this, `visual-line-mode'
;; cannot break inside Chinese text because it has no whitespace.
(setq-default word-wrap-by-category t)

(provide 'lang-org)
;;; lang-org.el ends here
