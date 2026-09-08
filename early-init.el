;;; early-init.el --- 启动前设置 -*- lexical-binding: t; -*-

;; 启动期间放宽 GC，启动完成后在 init.el 里恢复
(setq gc-cons-threshold most-positive-fixnum)

;; 提前关掉 GUI 元素，避免启动闪烁
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq inhibit-startup-screen t)

;; 原生编译告警太吵
(setq native-comp-async-report-warnings-errors 'silent)

;;; early-init.el ends here
