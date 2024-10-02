(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.0           
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

(use-package company-prescient
  :ensure t
  :config
  (company-prescient-mode 1))


(provide 'init-company)
