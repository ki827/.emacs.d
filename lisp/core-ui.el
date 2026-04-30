;;; core-ui.el --- UI configuration -*- lexical-binding: t; -*-

(use-package ef-themes
  :config
  (load-theme 'ef-elea-light t))

(use-package display-line-numbers
  :ensure nil
  :hook ((prog-mode org-mode) . display-line-numbers-mode)
  :init
  (setq display-line-numbers-type t
        display-line-numbers-width 3))

(use-package hl-line
  :ensure nil
  :hook ((prog-mode text-mode) . hl-line-mode))

(column-number-mode 1)

(use-package paren
  :ensure nil
  :init
  (setq show-paren-delay 0
        show-paren-when-point-inside-paren t
        show-paren-when-point-in-periphery t)
  :config
  (show-paren-mode 1))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Font management via cnfonts — the canonical solution for Chinese
;; Emacs users. It picks per-size font pairs so 1 CJK glyph occupies
;; exactly 2 ASCII columns, without manual rescale measurement.
;;
;; First run: `cnfonts-mode' applies a default profile. To pick a size
;; interactively, use `M-x cnfonts-increase-fontsize' /
;; `cnfonts-decrease-fontsize'; the choice persists in
;; ~/.emacs.d/cnfonts/.
(use-package cnfonts
  :hook (after-init . cnfonts-mode)
  :init
  (setq cnfonts-default-fontsize 18
        cnfonts-personal-fontnames
        '(("JetBrains Mono" "Fira Code" "SF Mono" "Menlo")
          ("Sarasa Mono SC" "PingFang SC" "Hiragino Sans GB" "STHeiti")
          ("Sarasa Mono SC")
          ("Sarasa Mono SC"))))

(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(window-divider-mode 1)

(provide 'core-ui)
;;; core-ui.el ends here
