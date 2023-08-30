(use-package org
  :hook
  ((org-mode . org-indent-mode))
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((C . t)))
  :bind
  (("C-c o a" . 'org-agenda)))

(provide 'init-org)
