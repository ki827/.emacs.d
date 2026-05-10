;;; core-ui.el --- UI configuration -*- lexical-binding: t; -*-

(use-package ef-themes
  :config
  (load-theme 'ef-elea-light t))

(use-package display-line-numbers
  :ensure nil
  :hook ((prog-mode org-mode markdown-mode) . display-line-numbers-mode)
  :init
  (setq display-line-numbers-type t
        display-line-numbers-width 4
        display-line-numbers-width-start t
        display-line-numbers-grow-only t))

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

;; Ubuntu Mono — installed under ~/Library/Fonts. CJK glyphs fall
;; through to the system's Chinese font (PingFang SC etc.) via macOS'
;; default fontset, so we don't wire CJK explicitly here.
;; Org-table CJK alignment will need follow-up: PingFang isn't 1:2
;; equal-width with Ubuntu Mono.
(set-face-attribute 'default nil :family "Ubuntu Mono" :height 180)

(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(window-divider-mode 1)

(provide 'core-ui)
;;; core-ui.el ends here
