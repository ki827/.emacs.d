;; Org-mode 基本配置
(use-package org
  :ensure t

  :config
  (setq org-hide-leading-stars t
	org-startup-indented t
	org-adapt-indentation t
	org-log-done 'time
	org-ellipsis " ▾"
	org-directory "~/org"
	org-agenda-files '("~/org/agenda.org")
	fill-column 80)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((java . t)
     (C . t)))
  :hook (org-mode . auto-fill-mode))


;; Evil-org 用于定制 org-mode 中的 evil 键绑定
(use-package evil-org
  :ensure t
  :after (evil org)
  :hook (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys)
  (evil-define-key 'normal evil-org-mode-map
    (kbd "t") 'org-todo
    (kbd "H") 'org-metaleft
    (kbd "L") 'org-metaright
    (kbd "J") 'org-metadown
    (kbd "K") 'org-metaup))

(use-package org-bullets
  :ensure t
  :config
  (setq org-bullets-bullet-list '("◉" "●" "✸" "✿")) ;; 定义每个层级的符号
  :hook (org-mode . org-bullets-mode))

;; Org-capture 模板配置
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/agenda.org" "Tasks")
         "* TODO %?\n  %u\n  %a")
        ("n" "Notes" entry (file+headline "~/org/notes.org" "Notes")
         "* %?\n  %u\n  %a")))

(provide 'init-org)
