;;; core-prog.el --- Programming infrastructure -*- lexical-binding: t; -*-

;;; ---- Tree-sitter ---------------------------------------------------------

(setq major-mode-remap-alist
      '((c-mode        . c-ts-mode)
        (c++-mode      . c++-ts-mode)
        (c-or-c++-mode . c-or-c++-ts-mode)))

(add-to-list 'auto-mode-alist '("\\.rs\\'"        . rust-ts-mode))
(add-to-list 'auto-mode-alist '("\\.go\\'"        . go-ts-mode))
(add-to-list 'auto-mode-alist '("/go\\.mod\\'"    . go-mod-ts-mode))

(setq treesit-language-source-alist
      '((c     "https://github.com/tree-sitter/tree-sitter-c")
        (cpp   "https://github.com/tree-sitter/tree-sitter-cpp")
        (go    "https://github.com/tree-sitter/tree-sitter-go")
        (gomod "https://github.com/camdencheek/tree-sitter-go-mod")
        (rust  "https://github.com/tree-sitter/tree-sitter-rust")
        (cmake "https://github.com/uyha/tree-sitter-cmake")
        (toml  "https://github.com/tree-sitter/tree-sitter-toml")
        (json  "https://github.com/tree-sitter/tree-sitter-json")
        (yaml  "https://github.com/ikatyang/tree-sitter-yaml")))

(defun my/treesit-install-active-grammars ()
  "Install tree-sitter grammars used out-of-the-box if missing.
`gomod' is included because `go-mod-ts-mode' is on `auto-mode-alist'
for go.mod files; without the grammar, opening one errors out."
  (interactive)
  (dolist (lang '(c cpp go gomod rust))
    (unless (treesit-language-available-p lang)
      (message "Installing tree-sitter grammar: %s" lang)
      (treesit-install-language-grammar lang))))

(add-hook 'after-init-hook #'my/treesit-install-active-grammars)

;;; ---- Eglot (LSP) ---------------------------------------------------------

(use-package eglot
  :ensure nil
  :hook ((c-ts-mode         . eglot-ensure)
         (c++-ts-mode       . eglot-ensure)
         (c-or-c++-ts-mode  . eglot-ensure)
         (go-ts-mode        . eglot-ensure)
         (rust-ts-mode      . eglot-ensure))
  :bind (:map eglot-mode-map
              ("C-c l a" . eglot-code-actions)
              ("C-c l r" . eglot-rename)
              ("C-c l f" . eglot-format)
              ("C-c l h" . eldoc))
  :init
  (setq eglot-autoshutdown t
        eglot-events-buffer-size 0
        eglot-extend-to-xref t
        eglot-sync-connect 1))

(use-package eldoc
  :ensure nil
  :init
  (setq eldoc-echo-area-use-multiline-p nil
        eldoc-idle-delay 0.2))

;;; ---- Format on save (async) ---------------------------------------------

(use-package apheleia
  :config
  (apheleia-global-mode 1))

;;; ---- Snippets ------------------------------------------------------------

(use-package tempel
  :bind (("M-+" . tempel-complete)
         ("M-*" . tempel-insert))
  :init
  (defun my/tempel-setup-capf ()
    (setq-local completion-at-point-functions
                (cons #'tempel-complete completion-at-point-functions)))
  (add-hook 'prog-mode-hook #'my/tempel-setup-capf)
  (add-hook 'text-mode-hook #'my/tempel-setup-capf))

(use-package tempel-collection
  :after tempel)

;;; ---- Debugger -----------------------------------------------------------

(use-package dape
  :init
  (setq dape-buffer-window-arrangement 'right)
  :config
  (add-hook 'kill-emacs-hook #'dape-breakpoint-save)
  (add-hook 'after-init-hook #'dape-breakpoint-load))

;;; ---- Discoverability ----------------------------------------------------

(use-package which-key
  :ensure nil
  :init
  (setq which-key-idle-delay 0.5)
  :config
  (which-key-mode 1))

;;; ---- Diagnostics --------------------------------------------------------

(use-package flymake
  :ensure nil
  :hook (prog-mode . flymake-mode)
  :bind (:map flymake-mode-map
              ("M-n" . flymake-goto-next-error)
              ("M-p" . flymake-goto-prev-error))
  :init
  (setq flymake-no-changes-timeout 0.5))

(provide 'core-prog)
;;; core-prog.el ends here
