(use-package modus-themes
  :config
  (setq modus-themes-headings
        '((1 . (semibold 1.0))
          (2 . (semibold 1.0))
          (3 . (semibold 1.0))
          (t . (semibold 1.0))))
  (modus-themes-load-theme 'modus-operandi-tinted)) 

(provide 'init-theme)
