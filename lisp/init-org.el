(use-package org
  :hook
  ((org-mode . org-indent-mode))
  :bind
  (("C-c o a" . 'org-agenda)))

(provide 'init-org)
