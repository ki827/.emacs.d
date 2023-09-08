(use-package plantuml-mode
  :ensure t
  :config
  (setq plantuml-default-exec-mode 'jar
	plantuml-jar-path "~/.emacs.d/plantuml.jar")
  (add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode)))

(provide 'init-plantuml)
