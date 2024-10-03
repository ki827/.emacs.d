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
  :hook ((org-mode . auto-fill-mode)
	 (org-mode . (lambda () (company-mode -1)))))

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
