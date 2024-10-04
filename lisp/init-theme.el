(use-package modus-themes
  :config
  (setq modus-themes-headings
        '((1 . (semibold 1.3))
          (2 . (semibold 1.2))
          (3 . (semibold 1.1))
          (t . (semibold 1.0))))
  (modus-themes-load-theme 'modus-operandi-tinted)) 

(provide 'init-theme)
