(use-package org
  :config
  (setq org-hide-leading-stars t
	org-log-done 'time
	org-ellipsis " ▾"
	org-directory "~/org"
	org-agenda-files '("~/org/agenda.org")
	org-startup-indented t
	org-adapt-indentation t
	org-plantuml-jar-path (expand-file-name "~/plantuml.jar"))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((java . t)
     (C . t)
     (plantuml .t)))
  :hook ((org-mode . (lambda () (company-mode -1)))
	 (org-mode . org-indent-mode)
	 (org-mode . auto-fill-mode)
	 (org-mode . (lambda () (setq fill-column 80)))))

(use-package org-bullets
  :ensure t
  :config
  (setq org-bullets-bullet-list '("◉" "◉" "◉" "◉")) 
  :hook (org-mode . org-bullets-mode))

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/agenda.org" "Tasks")
         "* TODO %?\n  %u\n  %a")
        ("n" "Notes" entry (file+headline "~/org/notes.org" "Notes")
         "* %?\n  %u\n  %a")))

(provide 'init-org)
