(use-package go-mode
  :ensure t
  :config
 :hook
 ((go-mode . (lambda () (setq tab-width 4
			      indent-tabs-mode 1)))))

(defun heell() ())
(provide 'init-go)
