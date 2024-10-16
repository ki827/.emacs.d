(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 1) 
  :bind
  (:map company-active-map
        ("C-n" . company-select-next)      
        ("C-p" . company-select-previous)  
        ("M-." . company-show-location)    
        ("C-d" . company-show-doc-buffer)  
        ("<tab>" . company-complete-common)) 
  :bind
  ("M-/" . company-complete))

(provide 'init-company)
