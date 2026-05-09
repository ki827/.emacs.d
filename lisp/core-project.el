;;; core-project.el --- Project & VCS -*- lexical-binding: t; -*-

;; `project' (built-in) already binds `C-x p' to `project-prefix-map'
;; in Emacs 28+, so no explicit configuration is needed here.

(use-package magit
  :bind (("C-x g"   . magit-status)
         ("C-x M-g" . magit-dispatch))
  :init
  (setq magit-diff-refine-hunk t))

;; macOS GUI Emacs doesn't inherit shell PATH; this fixes that.
;;
;; A login + interactive zsh costs 200-1000ms per startup. We cache
;; the resolved env to a file and re-run only when any shell rc has
;; been modified more recently than the cache. Touch any of those
;; files (or delete the cache) to force a refresh.
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :init
  (setq exec-path-from-shell-arguments '("-l" "-i")
        exec-path-from-shell-variables
        '("PATH" "MANPATH" "GOPATH" "GOROOT"
          "CARGO_HOME" "RUSTUP_HOME"))
  :config
  (let* ((cache (expand-file-name "exec-path-cache.el" user-emacs-directory))
         (mtime (lambda (f)
                  (and (file-exists-p f)
                       (float-time (file-attribute-modification-time
                                    (file-attributes f))))))
         (rc-mtime (apply #'max 0
                          (delq nil
                                (mapcar (lambda (f) (funcall mtime (expand-file-name f)))
                                        '("~/.zshenv" "~/.zprofile" "~/.zshrc")))))
         (cache-mtime (or (funcall mtime cache) 0)))
    (if (> cache-mtime rc-mtime)
        (load cache 'noerror 'nomessage)
      (exec-path-from-shell-initialize)
      (with-temp-file cache
        (insert ";;; -*- lexical-binding: t; no-byte-compile: t -*-\n")
        (dolist (v exec-path-from-shell-variables)
          (when-let ((val (getenv v)))
            (insert (format "(setenv %S %S)\n" v val))))
        (insert (format "(setq exec-path '%S)\n" exec-path))))))

;; direnv bridge: per-project env (loaded transparently from .envrc)
(use-package envrc
  :hook (after-init . envrc-global-mode))

(provide 'core-project)
;;; core-project.el ends here
