;;; core-project.el --- Project & VCS -*- lexical-binding: t; -*-

(use-package project
  :ensure nil
  :bind-keymap ("C-x p" . project-prefix-map))

(use-package magit
  :bind (("C-x g"   . magit-status)
         ("C-x M-g" . magit-dispatch))
  :init
  (setq magit-diff-refine-hunk t))

;; macOS GUI Emacs doesn't inherit shell PATH; this fixes that.
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :init
  ;; Use a login + interactive shell so .zprofile AND .zshrc are both
  ;; sourced — most user PATH additions on macOS live in .zshrc, which
  ;; is never sourced under the (faster) non-interactive default.
  (setq exec-path-from-shell-arguments '("-l" "-i")
        exec-path-from-shell-variables
        '("PATH" "MANPATH" "GOPATH" "GOROOT"
          "CARGO_HOME" "RUSTUP_HOME"))
  :config
  (exec-path-from-shell-initialize))

;; direnv bridge: per-project env (loaded transparently from .envrc)
(use-package envrc
  :hook (after-init . envrc-global-mode))

(provide 'core-project)
;;; core-project.el ends here
