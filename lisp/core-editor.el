;;; core-editor.el --- Editor quality of life -*- lexical-binding: t; -*-

(setq-default
 indent-tabs-mode nil
 tab-width 4
 fill-column 100
 truncate-lines t
 require-final-newline t
 sentence-end-double-space nil)

(let ((backups-dir   (expand-file-name "backups/"   user-emacs-directory))
      (auto-save-dir (expand-file-name "auto-save/" user-emacs-directory)))
  (dolist (d (list backups-dir auto-save-dir))
    (unless (file-directory-p d) (make-directory d t)))
  (setq backup-directory-alist            `(("." . ,backups-dir))
        auto-save-file-name-transforms    `((".*" ,auto-save-dir t))))

(setq
 backup-by-copying t
 version-control t
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 create-lockfiles nil
 save-interprogram-paste-before-kill t
 scroll-margin 3
 scroll-conservatively 101
 use-short-answers t
 inhibit-startup-screen t
 ;; CJK glyphs are double-width, so a hard 1-line cap on the echo area
 ;; truncates Chinese messages mid-sentence. `grow-only' lets long
 ;; messages expand vertically; the area collapses back to 1 line once
 ;; the message clears, so there's no persistent drift while editing.
 resize-mini-windows 'grow-only
 max-mini-window-height 0.25
 message-truncate-lines nil)

;; `completion-ignored-extensions' is matched as a suffix list — entries
;; are hidden from minibuffer file completion (find-file etc.) when other
;; candidates exist. Directory candidates carry a trailing `/' in the
;; string being matched, so directory entries here MUST end in `/'.
;; (Emacs's own defaults follow the same rule: .git/, .svn/, CVS/, ...)
(with-eval-after-load 'minibuffer
  (dolist (s '(".DS_Store" ".git/" ".github/" ".idea/" ".vscode/"))
    (add-to-list 'completion-ignored-extensions s)))

;; In c-ts-mode (and some other tree-sitter modes), the default
;; `electric-newline-and-maybe-indent' bound to RET inserts the
;; newline but skips indenting when the new line is still empty —
;; the indent only kicks in once you start typing. Bind RET in
;; `prog-mode-map' to `newline-and-indent' so the cursor lands at
;; the correct column immediately, in every prog-mode descendant.
(with-eval-after-load 'prog-mode
  (define-key prog-mode-map (kbd "RET") #'newline-and-indent))

;; Alternate `set-mark' binding. The default C-SPC is commonly captured
;; by the OS-level input-method switcher on macOS, leaving Emacs unable
;; to start a region selection.  C-; is free in default Emacs and easy
;; to reach on HHKB.
(global-set-key (kbd "C-;") #'set-mark-command)

;; macOS modifier mapping for HHKB layout: Cmd -> Control, Opt -> Meta.
;; Both left and right variants are set so external keyboards behave the
;; same as the built-in one. `mac-*' and `ns-*' are usually aliased on
;; emacs-plus; we set both to stay portable across mac builds.
(when (eq system-type 'darwin)
  (setq mac-command-modifier       'control
        mac-right-command-modifier 'control
        mac-option-modifier        'meta
        mac-right-option-modifier  'meta
        ns-command-modifier        'control
        ns-right-command-modifier  'control
        ns-option-modifier         'meta
        ns-right-option-modifier   'meta))

;; macOS ships BSD `ls' which lacks GNU's --dired/-N flags. If GNU
;; coreutils is installed (brew install coreutils -> /opt/homebrew/bin/gls),
;; point dired at it for full functionality; otherwise drop the
;; --dired option to suppress the noisy warning.
(use-package dired
  :ensure nil
  :hook (dired-mode . dired-omit-mode)
  :init
  (let ((gls (executable-find "gls")))
    (if gls
        (setq insert-directory-program gls
              dired-use-ls-dired       t)
      (setq dired-use-ls-dired nil)))
  :config
  (require 'dired-x)
  ;; Append exact-name matches for noise: macOS metadata, VCS dirs, IDE
  ;; droppings. The base `dired-omit-files' already hides `.' / `..'.
  (setq dired-omit-files
        (concat dired-omit-files
                "\\|\\`\\(?:"
                "\\.DS_Store"
                "\\|\\.git"
                "\\|\\.github"
                "\\|\\.idea"
                "\\|\\.vscode"
                "\\)\\'"))
  (setq dired-omit-verbose nil))

(use-package autorevert
  :ensure nil
  :init
  (setq global-auto-revert-non-file-buffers t
        auto-revert-verbose nil)
  :config
  (global-auto-revert-mode 1))

(use-package savehist
  :ensure nil
  :init
  (setq history-length 1000
        savehist-additional-variables '(register-alist mark-ring))
  :config
  (savehist-mode 1))

(use-package saveplace
  :ensure nil
  :config
  (save-place-mode 1))

(use-package recentf
  :ensure nil
  :init
  ;; Patterns are regexps; anchor `\.cache' and `elpa' so they don't
  ;; match unrelated paths that happen to contain those substrings.
  (setq recentf-max-saved-items 200
        recentf-max-menu-items 25
        recentf-exclude '("/tmp/" "/ssh:" "/var/folders/"
                          "/\\.cache/" "/elpa/"))
  :config
  (recentf-mode 1))

(use-package ws-butler
  :hook ((prog-mode text-mode) . ws-butler-mode))

(use-package elec-pair
  :ensure nil
  :hook (prog-mode . electric-pair-local-mode))

(use-package subword
  :ensure nil
  :hook (prog-mode . subword-mode))

(provide 'core-editor)
;;; core-editor.el ends here
