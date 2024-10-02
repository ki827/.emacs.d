(use-package modus-themes
  :ensure t
  :init
  ;; 设置主题相关选项
  (setq modus-themes-org-blocks 'tinted-background)  ;; org-block 使用背景色
  (setq modus-themes-scale-headings t)               ;; 启用标题缩放
  (setq modus-themes-variable-pitch-headings t)      ;; 标题使用可变宽度字体
  (setq modus-themes-bold-constructs nil)            ;; 全局禁用粗体
  (setq modus-themes-headings
        '((1 . (rainbow overline background 1.3))   ;; 一级标题，取消粗体，背景色，放大
          (2 . (rainbow background 1.2))            ;; 二级标题，取消粗体，背景色，放大
          (2 . (rainbow background 1.1))            ;; 三级级标题，取消粗体，背景色，放大
          (t . (rainbow))))                         ;; 默认标题样式
  :config
  (load-theme 'modus-operandi-tritanopia t)  ;; 使用亮色主题 'modus-operandi' 或 'modus-vivendi' 暗色主题

  ;; 自定义 Org 标题样式，确保没有粗体
  (modus-themes-with-colors
    (let ((class '((class color) (min-colors 89))))
      (custom-set-faces
       `(org-level-1 ((,class :inherit outline-1 :weight normal)))
       `(org-level-2 ((,class :inherit outline-2 :weight normal)))
       `(org-level-3 ((,class :inherit outline-3 :weight normal)))
       `(org-level-4 ((,class :inherit outline-4 :weight normal)))
       `(org-level-5 ((,class :inherit outline-5 :weight normal)))
       `(org-level-6 ((,class :inherit outline-6 :weight normal)))
       `(org-level-7 ((,class :inherit outline-7 :weight normal)))
       `(org-level-8 ((,class :inherit outline-8 :weight normal)))))))

(provide 'init-theme)
