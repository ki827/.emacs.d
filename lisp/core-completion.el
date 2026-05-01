;;; core-completion.el --- Completion stack -*- lexical-binding: t; -*-

(use-package vertico
  :init
  (setq vertico-cycle t
        vertico-resize nil
        vertico-count 10)
  :config
  (vertico-mode 1))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :config
  (marginalia-mode 1))

(use-package consult
  :bind (("C-s"     . consult-line)
         ("C-x b"   . consult-buffer)
         ("C-x C-r" . consult-recent-file)
         ("M-y"     . consult-yank-pop)
         ("M-g g"   . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g i"   . consult-imenu)
         ("M-s r"   . consult-ripgrep)
         ("M-s f"   . consult-find)
         ("M-s l"   . consult-line))
  :init
  (setq consult-narrow-key "<"
        register-preview-delay 0.2
        register-preview-function #'consult-register-format
        xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref))

(use-package embark
  :bind (("C-." . embark-act)
         ("M-." . embark-dwim)
         ("C-h B" . embark-bindings))
  :config
  ;; Pull in the consult bridge as soon as embark is loaded; otherwise
  ;; Embark's runtime check warns "embark-consult should be installed".
  ;; embark-consult.el itself requires consult at top, so consult loads
  ;; transitively at the same moment.
  (require 'embark-consult))

(use-package embark-consult
  :defer t
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package corfu
  :init
  (setq corfu-cycle t
        corfu-auto t
        corfu-auto-delay 0.1
        corfu-auto-prefix 2
        corfu-quit-no-match 'separator
        corfu-preview-current 'insert
        tab-always-indent 'complete)
  :config
  (global-corfu-mode 1)
  (corfu-popupinfo-mode 1)
  (corfu-history-mode 1))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

(provide 'core-completion)
;;; core-completion.el ends here
