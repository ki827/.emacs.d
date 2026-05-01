;;; lang-markdown.el --- Markdown support -*- lexical-binding: t; -*-

;; `.md' files default to gfm-mode (GitHub-flavoured), since most markdown
;; in this repo's universe is going to land on a GitHub README.
;; `.markdown' is a legacy extension; route to plain markdown-mode.
(use-package markdown-mode
  :mode (("\\.md\\'"       . gfm-mode)
         ("\\.markdown\\'" . markdown-mode))
  :hook ((markdown-mode . visual-line-mode)
         (gfm-mode      . visual-line-mode))
  :init
  (setq markdown-fontify-code-blocks-natively t
        markdown-asymmetric-header             t
        markdown-hide-urls                     nil
        markdown-enable-math                   t
        markdown-list-indent-width             2
        markdown-italic-underscore             t))

;; apheleia ships an alist entry for `markdown-mode' / `gfm-mode' that
;; runs `prettier' on save when prettier is in PATH; nothing else needed.

;; Mermaid: standalone editing for .mmd files, plus syntax fontification
;; inside ```mermaid ... ``` fenced blocks (via markdown's native code-
;; block fontification). Compilation to PNG/SVG via `M-x mermaid-compile'
;; calls the external `mmdc' CLI.
(use-package mermaid-mode
  :mode (("\\.mmd\\'"     . mermaid-mode)
         ("\\.mermaid\\'" . mermaid-mode))
  :init
  (setq mermaid-mmdc-location (or (executable-find "mmdc") "mmdc")
        mermaid-output-format ".png"))

(provide 'lang-markdown)
;;; lang-markdown.el ends here
