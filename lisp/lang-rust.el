;;; lang-rust.el --- Rust -*- lexical-binding: t; -*-

(use-package rust-ts-mode
  :ensure nil
  :init
  (setq rust-ts-mode-indent-offset 4))

;; rust-ts-mode (Emacs 30) registers its own `rust-ts-flymake' backend
;; that shells out to `cargo check'. When eglot also manages
;; diagnostics through rust-analyzer, the two race in the process
;; sentinel and emit:
;;   Can't find state for rust-ts-flymake in flymake--state
;; eglot's backend is strictly better here, so drop the built-in one.
(defun my/rust-ts-disable-builtin-flymake ()
  (remove-hook 'flymake-diagnostic-functions 'rust-ts-flymake t))
(add-hook 'rust-ts-mode-hook #'my/rust-ts-disable-builtin-flymake)

(add-to-list 'auto-mode-alist '("/Cargo\\.toml\\'" . conf-toml-mode))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((rust-ts-mode) . ("rust-analyzer")))
  (setq-default eglot-workspace-configuration
                (plist-put eglot-workspace-configuration
                           :rust-analyzer
                           '(:check (:command "clippy")
                             :procMacro (:enable t)
                             :inlayHints (:typeHints (:enable t)
                                          :parameterHints (:enable t)
                                          :chainingHints (:enable t))))))

(provide 'lang-rust)
;;; lang-rust.el ends here
