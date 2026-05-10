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
        (cmake "https://github.com/uyha/tree-sitter-cmake")))

(defun my/treesit-install-active-grammars ()
  "Install tree-sitter grammars used out-of-the-box if missing.
`gomod' is included because `go-mod-ts-mode' is on `auto-mode-alist'
for go.mod files; without the grammar, opening one errors out.
`cmake' is included for `cmake-ts-mode' (CMakeLists.txt / .cmake)."
  (interactive)
  (dolist (lang '(c cpp go gomod rust cmake))
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
  ;; Emacs 30's Eglot replaced `eglot-events-buffer-size' with
  ;; `eglot-events-buffer-config'; the old name is no longer bound,
  ;; so setting it had no effect on the events buffer.
  (setq eglot-autoshutdown t
        eglot-events-buffer-config '(:size 0 :format full)
        eglot-extend-to-xref t
        eglot-sync-connect 1))

(use-package eldoc
  :ensure nil
  :init
  (setq eldoc-echo-area-use-multiline-p nil
        eldoc-idle-delay 0.2))

;;; ---- Format on save (async) ---------------------------------------------

(use-package apheleia
  :hook (after-init . apheleia-global-mode))

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
  ;; Defer loading until `M-x dape' (or any other dape entry point)
  ;; is called; only `dape' itself is autoloaded by the package, so
  ;; breakpoint persistence is wired up in `:config' — it runs after
  ;; the first `dape' invocation, which is also the only point where
  ;; new breakpoints could exist to save.
  :commands (dape)
  :init
  (setq dape-buffer-window-arrangement 'right)
  :config
  (dape-breakpoint-load)
  (add-hook 'kill-emacs-hook #'dape-breakpoint-save))

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
