(use-package org
  :hook
  ((org-mode . org-indent-mode))
  :config
  (setq org-plantuml-jar-path "~/.emacs.d/plantuml.jar")
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((C . t)
     (java . t)
     (plantuml . t)))
  (nconc org-babel-default-header-args:java
       '((:dir . nil)))
  :bind
  (("C-c o a" . 'org-agenda)))

(provide 'init-org)
