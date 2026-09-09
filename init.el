;;; init.el --- prompt 编辑器 + org/md 笔记 -*- lexical-binding: t; -*-

;; 定位：codex/claude code 的 prompt 编辑器 + org/md 笔记。
;; 外部包 13 个：evil / evil-collection / general / markdown-mode /
;; markdown-preview-mode / corfu / cape / vertico / orderless /
;; marginalia / consult / dashboard / nerd-icons。
;; 设计记录见 docs/ 与 README.md（键位表）。

;;; ---------- 包管理 ----------
(require 'package)
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))
;; 不在启动时 refresh：已装的包不需要包源索引；
;; 新增包时 use-package 的 ensure 会自己 refresh 再装
(require 'use-package)
(setq use-package-always-ensure t)

;;; ---------- 基础 ----------
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 32 1024 1024))))

(when (eq system-type 'darwin)
  (setq mac-option-modifier 'meta
        mac-command-modifier 'super)
  (keymap-global-set "s-c" #'kill-ring-save)
  (keymap-global-set "s-v" #'yank)
  (keymap-global-set "s-s" #'save-buffer)
  (keymap-global-set "s-z" #'undo)
  ;; GUI Emacs 继承不到 shell 的 PATH；rg / im-select 在 homebrew 下
  (let ((brew "/opt/homebrew/bin"))
    (when (file-directory-p brew)
      (add-to-list 'exec-path brew)
      (setenv "PATH" (concat brew ":" (getenv "PATH"))))))

;; 备份、自动保存等杂物集中到 var/
(defvar my/var-dir (expand-file-name "var/" user-emacs-directory))
(make-directory (expand-file-name "backup" my/var-dir) t)
(make-directory (expand-file-name "auto-save" my/var-dir) t)
(setq backup-directory-alist `(("." . ,(expand-file-name "backup" my/var-dir)))
      auto-save-file-name-transforms `((".*" ,(expand-file-name "auto-save/" my/var-dir) t))
      lock-file-name-transforms `((".*" ,(expand-file-name "auto-save/" my/var-dir) t))
      backup-by-copying t
      delete-old-versions t)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file) (load custom-file))

(setq use-short-answers t
      delete-by-moving-to-trash t        ; 删文件进废纸篓，可后悔
      ring-bell-function 'ignore
      scroll-conservatively 101
      scroll-margin 3)
(setq-default indent-tabs-mode nil)

(global-auto-revert-mode 1)
(electric-pair-mode 1)
(save-place-mode 1)
(savehist-mode 1)
(recentf-mode 1)
(setq recentf-max-saved-items 200)
(which-key-mode 1)                     ; 内置（Emacs 30+），不用装包
(setq which-key-idle-delay 0.2         ; 按下前缀键 0.2s 后弹出提示
      which-key-sort-order 'which-key-key-order-alpha)

;; Emacs server：终端里 `emacsclient -n 文件` 秒开到本 GUI（alias ec）
(when (display-graphic-p)
  (require 'server)
  (unless (server-running-p) (server-start)))

;; minibuffer：vertico 四件套
(use-package vertico
  :init (vertico-mode 1)
  :custom (vertico-cycle t))

;; 乱序多词匹配："el ini" 也能命中 init.el；文件路径保留常规前缀补全
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; 候选旁注：命令文档、文件大小/时间、buffer 模式
(use-package marginalia
  :init (marginalia-mode 1))

;; 增强搜索/切换命令（实时结果 + 预览），键位见 SPC s/b/f/p
(use-package consult)

;;; ---------- 外观 ----------
;; 内置 modus 主题：默认浅色，SPC t t 切换深浅
(setq modus-themes-to-toggle '(modus-operandi modus-vivendi))
(load-theme 'modus-operandi t)

(setq display-line-numbers-type 'relative)
(add-hook 'text-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(global-hl-line-mode 1)
(column-number-mode 1)

;; 英文 Menlo + 中文苹方；rescale 让一个汉字 ≈ 两个半角宽。
;; 要严格等宽对齐就装 Sarasa Mono SC 并改这里（见 README）
(when (display-graphic-p)
  (set-face-attribute 'default nil :family "Menlo" :height 140)
  (dolist (charset '(han cjk-misc symbol))
    (set-fontset-font t charset (font-spec :family "PingFang SC")))
  (setq face-font-rescale-alist '(("PingFang SC" . 1.2))))

;;; ---------- 启动页 ----------
;; dashboard：最近文件 + 各项目需求列表的未完成项（GTD 第一屏）
(use-package nerd-icons)   ; 图标字体，缺字时 M-x nerd-icons-install-fonts

(use-package dashboard
  :custom
  (dashboard-startup-banner 'logo)
  (dashboard-banner-logo-title "写好 prompt，让 agent 干活")
  (dashboard-center-content t)
  (dashboard-vertically-center-content t)
  (dashboard-items '((recents . 8) (agenda . 10)))
  (dashboard-item-names '(("Recent Files:" . "最近文件")
                          ("Agenda for today:" . "待办需求")
                          ("Agenda for the coming week:" . "待办需求")))
  (dashboard-display-icons-p t)
  (dashboard-icon-type 'nerd-icons)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-set-footer nil)
  ;; 需求条目大多没排日期：显示所有未完结状态，按状态排序
  (dashboard-week-agenda nil)
  (dashboard-match-agenda-entry
   "TODO=\"NEW\"|TODO=\"TODO\"|TODO=\"DOING\"|TODO=\"VERIFY\"")
  (dashboard-filter-agenda-entry 'dashboard-no-filter-agenda)
  (dashboard-agenda-sort-strategy '(todo-state-up))
  :config
  (dashboard-setup-startup-hook))

;;; ---------- evil ----------
(use-package evil
  :init
  (setq evil-want-keybinding nil       ; 交给 evil-collection
        evil-respect-visual-line-mode t ; j/k 按屏幕行走（软换行长段落）
        evil-want-C-u-scroll t
        evil-undo-system 'undo-redo
        evil-split-window-below t
        evil-vsplit-window-right t)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; 在 ~/org/ 里全文搜索（rg 已装在机器上）
(defun my/search-notes ()
  "在 `org-directory' 里实时全文搜索。"
  (interactive)
  (consult-ripgrep org-directory))

(use-package general
  :after evil
  :config
  (general-create-definer my/leader
    :states '(normal visual)
    :keymaps 'override
    :prefix "SPC")
  (my/leader
    ":"  '(execute-extended-command :wk "M-x")
    ;; f: 文件
    "f"  '(:ignore t :wk "文件")
    "ff" '(find-file    :wk "打开文件")
    "fr" '(consult-recent-file :wk "最近文件")
    "fs" '(save-buffer  :wk "保存")
    "fi" '((lambda () (interactive)
             (find-file (expand-file-name "init.el" user-emacs-directory)))
           :wk "打开 init.el")
    ;; b: buffer
    "b"  '(:ignore t :wk "buffer")
    "bb" '(consult-buffer      :wk "切换")
    "bd" '(kill-current-buffer :wk "关闭")
    ;; s: 搜索
    "s"  '(:ignore t :wk "搜索")
    "ss" '(consult-line    :wk "当前文件")
    "sn" '(my/search-notes :wk "搜索笔记")
    ;; y: 复制 prompt
    "y"  '(my/copy-prompt :wk "复制 buffer/选区")
    ;; p: prompt 库
    "p"  '(:ignore t :wk "prompt")
    "pn" '(my/prompt-new         :wk "新建")
    "pf" '(my/prompt-find        :wk "打开")
    "ps" '(my/prompt-search      :wk "搜索")
    "pi" '(my/prompt-insert-file :wk "插入代码文件")
    "pv" '(my/prompt-paste-image :wk "粘贴剪贴板图片")
    "pc" '(my/prompt-screenshot  :wk "框选截图")
    "pl" '(my/prompt-requirements :wk "需求列表")
    "pr" '(my/prompt-register     :wk "登记为需求")
    ;; o: org
    "o"  '(:ignore t :wk "org")
    "oa" '(org-agenda  :wk "agenda")
    "oc" '(org-capture :wk "capture")
    "oo" '((lambda () (interactive) (dired org-directory)) :wk "打开笔记目录")
    ;; w: 窗口
    "w"  '(:ignore t :wk "窗口")
    "wv" '(split-window-right   :wk "垂直分屏")
    "ws" '(split-window-below   :wk "水平分屏")
    "wd" '(delete-window        :wk "关闭窗口")
    "wo" '(delete-other-windows :wk "只留当前")
    "wh" '(windmove-left  :wk "←")
    "wj" '(windmove-down  :wk "↓")
    "wk" '(windmove-up    :wk "↑")
    "wl" '(windmove-right :wk "→")
    ;; t: 切换
    "t"  '(:ignore t :wk "切换")
    "tt" '(modus-themes-toggle :wk "深/浅主题")
    "ti" '(my/toggle-images    :wk "内联图片")
    "tm" '(my/markdown-toggle-markup :wk "markdown 标记")
    "tp" '(markdown-preview-mode     :wk "markdown 预览")
    ;; q: 退出
    "q"  '(:ignore t :wk "退出")
    "qq" '(save-buffers-kill-terminal :wk "退出 Emacs")))

;;; ---------- 输入法联动（自写，替代 sis） ----------
;; 行为：回 normal 自动切英文；回 insert 恢复离开时的输入法（按 buffer 记忆）。
;; 全部异步调 im-select，不轮询、不阻塞。中文源用什么就恢复什么，
;; 搜狗/Rime 也不用改配置。
(defconst my/im-select "/opt/homebrew/bin/im-select")
(defconst my/im-english "com.apple.keylayout.ABC")
(defvar-local my/im--insert-source nil
  "本 buffer 上次离开 insert 状态时的输入法 ID。")

(defun my/im--set (source)
  "异步把系统输入法切到 SOURCE。"
  (when (and source (file-executable-p my/im-select))
    (start-process "im-set" nil my/im-select source)))

(defun my/im-save-then-english ()
  "记下当前输入法（异步查询），然后切英文。进 normal 状态时调用。"
  (when (file-executable-p my/im-select)
    (let ((buf (current-buffer)))
      (make-process
       :name "im-get" :buffer (generate-new-buffer " *im-get*")
       :command (list my/im-select)
       :sentinel
       (lambda (proc _event)
         (when (memq (process-status proc) '(exit signal))
           (let ((cur (with-current-buffer (process-buffer proc)
                        (string-trim (buffer-string)))))
             (kill-buffer (process-buffer proc))
             (when (and (buffer-live-p buf) (not (string-empty-p cur)))
               (with-current-buffer buf
                 (setq my/im--insert-source cur))))
           (my/im--set my/im-english)))))))

(defun my/im-restore ()
  "恢复本 buffer 记忆的输入法。进 insert 状态时调用。"
  (my/im--set my/im--insert-source))

(with-eval-after-load 'evil
  (add-hook 'evil-normal-state-entry-hook #'my/im-save-then-english)
  (add-hook 'evil-insert-state-entry-hook #'my/im-restore))

;;; ---------- 补全弹窗（corfu + cape） ----------
;; 输入路径（~/、/、../ 开头）或词语时自动弹候选列表；
;; TAB 确认、C-n/C-p 选择（evil-collection 已适配）。
(use-package corfu
  :init (global-corfu-mode 1)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  :config
  ;; corfu 按默认字体（Menlo，16px）算弹窗行高，但中文用苹方渲染行高 22px，
  ;; 含中文的候选会被裁掉下半截。弹窗内改按两种字体中较大的行高计算。
  (defun my/corfu--cjk-line-height (orig &rest args)
    (let* ((cjk (if-let* (((display-graphic-p))
                          (font (font-at 0 nil "中")))
                    (aref (font-info font) 3)   ; 字体最大高度（含上下伸出）
                  0))
           (dlh (symbol-function 'default-line-height)))
      (cl-letf (((symbol-function 'default-line-height)
                 (lambda (&rest a)
                   (let ((h (apply dlh a)))
                     (if (equal (buffer-name) " *corfu*") (max h cjk) h)))))
        (apply orig args))))
  (advice-add 'corfu--popup-show :around #'my/corfu--cjk-line-height))

(use-package cape
  :init
  ;; 文件路径补全 + 当前 buffer 已出现词语的补全
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-dabbrev))

;;; ---------- 路径补全（手动兜底） ----------
;; C-c f 补全光标前的文件路径；连按可在多个候选间轮换。
;; C-x C-f 保持 Emacs 原生的 find-file 不动。
(defun my/complete-path ()
  "补全光标前的文件路径。"
  (interactive)
  (let ((hippie-expand-try-functions-list
         '(try-complete-file-name-partially try-complete-file-name)))
    (hippie-expand nil)))

(keymap-global-set "C-c f" #'my/complete-path)

;;; ---------- 外部编辑（claude code/codex 的 Ctrl+G） ----------
;; 流程：CLI 按 Ctrl+G → emacsclient 开临时文件 → Emacs 抢到前台 →
;; 编辑完 ZZ / :wq / C-x # → 内容回填 CLI，焦点自动切回来源终端。

(defvar my/server--caller-app nil
  "本次外部编辑的来源 app bundle id，编辑完成后把焦点还给它。")

(defun my/server--frontmost-bundle-id ()
  "当前前台 app 的 bundle id（lsappinfo，无需系统授权）。"
  (let ((out (shell-command-to-string
              "lsappinfo info -only bundleid $(lsappinfo front) 2>/dev/null | cut -d'\"' -f4")))
    (let ((id (string-trim out)))
      (unless (string-empty-p id) id))))

(defun my/server-finish ()
  "保存并结束本次外部编辑（等价 C-x #）。"
  (interactive)
  (save-buffer)
  (server-edit))

(defun my/server--visit-setup ()
  "server 打开文件时：抢焦点；临时 prompt 文件按 markdown 对待。"
  ;; 记住来源终端，把 Emacs 拉到前台
  (when (display-graphic-p)
    (setq my/server--caller-app (my/server--frontmost-bundle-id))
    (select-frame-set-input-focus (selected-frame)))
  ;; Ctrl+G 的临时文件通常无扩展名：在临时目录且没识别出模式就当 markdown
  (when (and buffer-file-name
             (eq major-mode 'fundamental-mode)
             (string-match-p "\\`/\\(?:private/\\)?\\(?:var/folders\\|tmp\\)/"
                             (expand-file-name buffer-file-name)))
    (markdown-mode))
  (goto-char (point-max))               ; 光标停在草稿末尾接着写
  ;; vim 习惯：ZZ = 保存并返回 CLI
  (when (bound-and-true-p evil-local-mode)
    (evil-local-set-key 'normal "ZZ" #'my/server-finish)))

(defun my/server--return-focus ()
  "编辑完成后把焦点交还来源 app。"
  (when my/server--caller-app
    (start-process "return-focus" nil "open" "-b" my/server--caller-app)
    (setq my/server--caller-app nil)))

(with-eval-after-load 'server
  (add-hook 'server-visit-hook #'my/server--visit-setup)
  (add-hook 'server-done-hook #'my/server--return-focus)
  ;; :wq/:q 直接走，不再询问「buffer 仍有客户端」
  (remove-hook 'kill-buffer-query-functions #'server-kill-buffer-query-function))

;;; ---------- prompt 工作流 ----------
;; Emacs 作为 codex/claude code 的 prompt 编辑器：
;; 写完一键入剪贴板、prompt 存库可搜索、代码文件一键插成围栏块。

(defvar my/prompts-dir (expand-file-name "~/prompts/")
  "prompt 库目录。")

(defvar my/prompt-template "# 任务\n\n\n# 背景\n\n\n# 约束\n\n\n# 验收标准\n\n"
  "无模板可选时的默认骨架。")

(defvar my/prompt-templates-dir (expand-file-name "templates/" my/prompts-dir)
  "prompt 模板目录：一个 .md 文件就是一套模板，按文件名选取。")

(defun my/copy-prompt ()
  "把选区（无选区则整个 buffer）复制到系统剪贴板。
顺手清理：去行尾空白、3 个以上连续空行压成 1 个、去首尾空白。"
  (interactive)
  (let ((s (if (use-region-p)
               (buffer-substring-no-properties (region-beginning) (region-end))
             (buffer-substring-no-properties (point-min) (point-max)))))
    (setq s (replace-regexp-in-string "[ \t]+$" "" s))
    (setq s (replace-regexp-in-string "\n\\{3,\\}" "\n\n" s))
    (setq s (string-trim s))
    (kill-new s)
    (deactivate-mark)
    (message "已复制 %d 字符" (length s))))

(defvar my/prompt--project-history nil
  "项目选择历史（vertico 据此把常用项目排前面）。")

(defun my/prompt--projects ()
  "prompt 库下的项目目录列表（排除 templates/img）。"
  (when (file-directory-p my/prompts-dir)
    (seq-filter (lambda (d)
                  (and (file-directory-p (expand-file-name d my/prompts-dir))
                       (not (member d '("templates" "img")))))
                (directory-files my/prompts-dir nil "^[^.]"))))

(defun my/prompt--read-project ()
  "选项目目录；输入新名字自动创建，选「（不分项目）」用库根。"
  (let ((choice (completing-read "项目（可输入新名字）: "
                                 (cons "（不分项目）" (my/prompt--projects))
                                 nil nil nil 'my/prompt--project-history)))
    (if (or (string-empty-p (string-trim choice))
            (equal choice "（不分项目）"))
        my/prompts-dir
      (let ((dir (file-name-as-directory
                  (expand-file-name (string-trim choice) my/prompts-dir))))
        (make-directory dir t)
        dir))))

(defun my/prompt-new (name)
  "在 prompt 库新建时间戳命名的 markdown：先选项目、再选模板。
NAME 非空则追加为文件名后缀。"
  (interactive "s名字（可空）: ")
  (make-directory my/prompts-dir t)
  (let* ((project-dir (my/prompt--read-project))
         (templates (and (file-directory-p my/prompt-templates-dir)
                         (mapcar #'file-name-sans-extension
                                 (directory-files my/prompt-templates-dir
                                                  nil "\\.md\\'"))))
         (choice (if templates
                     (completing-read "模板: " (cons "默认" templates) nil t)
                   "默认"))
         (slug (if (string-empty-p (string-trim name))
                   ""
                 (concat "-" (replace-regexp-in-string
                              "[ \t/]+" "-" (string-trim name)))))
         (file (expand-file-name
                (concat (format-time-string "%Y%m%d-%H%M%S") slug ".md")
                project-dir)))
    (find-file file)
    (when (zerop (buffer-size))
      (if (equal choice "默认")
          (insert my/prompt-template)
        (insert-file-contents
         (expand-file-name (concat choice ".md") my/prompt-templates-dir)))
      ;; 光标停在第一个标题的下一行
      (goto-char (point-min))
      (re-search-forward "^# .*\n" nil t))))

(defun my/prompt-find ()
  "在 prompt 库目录里找文件。"
  (interactive)
  (let ((default-directory my/prompts-dir))
    (call-interactively #'find-file)))

(defun my/prompt-search ()
  "实时全文搜索 prompt 库。"
  (interactive)
  (consult-ripgrep my/prompts-dir))

(defvar my/fence-langs
  '(("el" . "elisp") ("rs" . "rust") ("py" . "python") ("cc" . "cpp")
    ("cxx" . "cpp") ("hpp" . "cpp") ("h" . "c") ("yml" . "yaml")
    ("ts" . "typescript") ("js" . "javascript"))
  "扩展名 → 围栏语言标注；不在表里的直接用扩展名。")

(defun my/prompt-insert-file (file)
  "把 FILE 内容插入为 markdown 围栏代码块，带路径标注。"
  (interactive "f插入代码文件: ")
  (let* ((ext (or (file-name-extension file) ""))
         (lang (or (cdr (assoc ext my/fence-langs)) ext))
         (content (with-temp-buffer
                    (insert-file-contents file)
                    (buffer-string))))
    (insert (format "`%s`:\n```%s\n%s%s```\n"
                    (abbreviate-file-name (expand-file-name file))
                    lang
                    content
                    (if (string-suffix-p "\n" content) "" "\n")))))

;; 图片进 prompt：codex/claude code 能读 prompt 里提到的图片路径，
;; 所以做法是「图片落盘 + 插入绝对路径」。
(defvar my/prompts-img-dir (expand-file-name "img/" my/prompts-dir)
  "prompt 库根的图片目录（不在项目里时的兜底）。")

(defun my/prompt--project-of (file)
  "FILE 所属的项目目录（~/prompts/<项目>/）；不在项目里返回 nil。"
  (when (and file (string-prefix-p my/prompts-dir (expand-file-name file)))
    (let ((top (car (split-string
                     (file-relative-name file my/prompts-dir) "/"))))
      (when (and top
                 (not (member top '("templates" "img")))
                 (file-directory-p (expand-file-name top my/prompts-dir)))
        (file-name-as-directory (expand-file-name top my/prompts-dir))))))

(defun my/prompt--img-dir ()
  "当前 prompt 所属项目的 img/ 目录；不在项目里则用库根 img/。"
  (let ((proj (my/prompt--project-of buffer-file-name)))
    (if proj (expand-file-name "img/" proj) my/prompts-img-dir)))

(defun my/prompt--insert-image-path (file)
  "按当前模式的语法插入图片 FILE（不自动预览，SPC t i 手动开）。
org 用 [[file:...]]，markdown 用 ![文件名](...)——两种写法 agent 都能读到
路径。markdown 的 alt 必须非空：markdown-hide-markup 隐藏链接标记后靠
alt 撑显示，空 alt 会整行不可见，看起来像粘贴失败。"
  (unless (bolp) (insert "\n"))
  (cond
   ((derived-mode-p 'org-mode)
    (insert (format "[[file:%s]]\n" file)))
   ((derived-mode-p 'markdown-mode)
    (insert (format "![%s](%s)\n" (file-name-nondirectory file) file)))
   (t (insert file "\n")))
  (message "已插入图片 %s" (file-name-nondirectory file)))

(defun my/toggle-images ()
  "内联图片显示开/关（org 与 markdown 通用）。"
  (interactive)
  (cond ((derived-mode-p 'org-mode) (org-toggle-inline-images))
        ((derived-mode-p 'markdown-mode) (markdown-toggle-inline-images))
        (t (message "当前模式不支持内联图片"))))

(defun my/prompt-paste-image ()
  "把剪贴板里的图片存到所属项目的图片目录并插入路径。"
  (interactive)
  (let* ((img-dir (my/prompt--img-dir))
         (file (progn (make-directory img-dir t)
                      (expand-file-name
                       (format-time-string "%Y%m%d-%H%M%S.png") img-dir))))
    (if (zerop (call-process "/opt/homebrew/bin/pngpaste" nil nil nil file))
        (my/prompt--insert-image-path file)
      (message "剪贴板里没有图片"))))

(defun my/prompt-screenshot ()
  "框选截图存到所属项目的图片目录并插入路径。"
  (interactive)
  (let* ((img-dir (my/prompt--img-dir))
         (file (progn (make-directory img-dir t)
                      (expand-file-name
                       (format-time-string "%Y%m%d-%H%M%S.png") img-dir))))
    (call-process "/usr/sbin/screencapture" nil nil nil "-i" file)
    (if (file-exists-p file)
        (my/prompt--insert-image-path file)
      (message "已取消截图"))))

;; 需求列表（GTD）：每个项目一个 需求.org，条目=TODO 状态 + 指向 prompt 的
;; 相对链接；全部纳入 org-agenda，SPC o a 总览所有项目的需求状态。
(defconst my/prompt-req-name "需求.org")

(defun my/prompt--req-file (project-dir)
  (expand-file-name my/prompt-req-name project-dir))

(defun my/prompt--agenda-register (file)
  "把需求列表 FILE 加进 agenda（当场生效，重启后由 init 通配收集）。"
  (when (boundp 'org-agenda-files)
    (add-to-list 'org-agenda-files file)))

(defun my/prompt--req-ensure (project-dir)
  "确保项目的需求列表存在并已注册 agenda，返回其路径。"
  (let ((req (my/prompt--req-file project-dir)))
    (unless (file-exists-p req)
      (with-temp-file req
        (insert (format "#+title: %s 需求列表\n\n"
                        (file-name-nondirectory
                         (directory-file-name project-dir))))))
    (my/prompt--agenda-register req)
    req))

(defun my/prompt-requirements ()
  "打开当前项目的需求列表；不在项目里则先选项目。"
  (interactive)
  (let ((proj (or (my/prompt--project-of buffer-file-name)
                  (my/prompt--read-project))))
    (when (equal (expand-file-name proj) (expand-file-name my/prompts-dir))
      (user-error "库根没有需求列表，请选一个具体项目"))
    (find-file (my/prompt--req-ensure proj))))

(defun my/prompt--first-md-heading ()
  "当前 buffer 第一个 markdown 标题的文字，找不到返回 nil。"
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^# +\\(.+\\)$" nil t)
      (string-trim (match-string 1)))))

(defun my/prompt-register ()
  "把当前 prompt 登记进所属项目的需求列表（TODO + 相对链接）。"
  (interactive)
  (let* ((file buffer-file-name)
         (proj (and file (my/prompt--project-of file))))
    (unless proj
      (user-error "当前文件不在 ~/prompts/<项目>/ 里，无法登记"))
    (when (buffer-modified-p) (save-buffer))
    (let* ((req (my/prompt--req-ensure proj))
           (base (file-name-sans-extension (file-name-nondirectory file)))
           (title (if (string-match
                       "\\`[0-9]\\{8\\}-[0-9]\\{4,6\\}-\\(.+\\)\\'" base)
                      (match-string 1 base)
                    (or (my/prompt--first-md-heading) base)))
           (rel (file-relative-name file proj)))
      (with-current-buffer (find-file-noselect req)
        (if (save-excursion (goto-char (point-min))
                            (search-forward (concat "file:" rel) nil t))
            (message "已登记过：%s" title)
          (goto-char (point-max))
          (unless (bolp) (insert "\n"))
          (insert (format "* TODO [[file:%s][%s]]\n" rel title))
          (save-buffer)
          (message "已登记到 %s" (file-relative-name req my/prompts-dir)))))))

;; 写作体验：长段落软换行（CJK 断行规则），modeline 显示字符数
(setq word-wrap-by-category t)
(add-hook 'text-mode-hook #'visual-line-mode)
(add-hook 'text-mode-hook
          (lambda ()
            (setq-local mode-line-misc-info
                        (cons '(:eval (format " %d字" (- (point-max) (point-min))))
                              mode-line-misc-info))))

;;; ---------- @ 文件引用（仿 claude code） ----------
;; 在 prompt 里输入 @ 弹出代码项目的文件列表，选中插入 @相对路径，
;; 和 claude code 的 @文件 写法一致。代码根目录按优先级：
;; buffer 的 my/code-root（来自 ~/prompts/<项目>/.dir-locals.el，
;; 第一次用时问一次并写入）→ project.el 识别的项目根 → 当前目录。

(defvar-local my/code-root nil
  "本 prompt 项目对应的代码根目录（dir-local，@ 补全列它的文件）。")
(put 'my/code-root 'safe-local-variable #'stringp)

(defvar my/at-file--cache nil
  "(root files time)：上次列出的文件表，30 秒内复用。")

(defun my/at-file--files (root)
  "ROOT 下全部文件与目录的相对路径（目录带 /，排除 .git，遵守 .gitignore）。"
  (let* ((default-directory root)
         (cache my/at-file--cache))
    (if (and cache (equal (nth 0 cache) root)
             (< (float-time (time-since (nth 2 cache))) 30))
        (nth 1 cache)
      (let ((files
             (cond
              ((executable-find "fd")
               (process-lines "fd" "--hidden" "--exclude" ".git"
                              "--strip-cwd-prefix"))
              ((executable-find "git")
               (process-lines "git" "ls-files" "--cached" "--others"
                              "--exclude-standard")))))
        ;; 目录统一成一个尾随 /（fd 已带、git 不带）；git ls-files 只有
        ;; 文件，从路径推出中间目录
        (setq files
              (delete-dups
               (cl-loop for f in files
                        if (file-directory-p f)
                        collect (concat (directory-file-name f) "/")
                        else append
                        (let ((dirs nil) (d (file-name-directory f)))
                          (while (and d (not (string-empty-p d)))
                            (push d dirs)
                            (setq d (file-name-directory
                                     (directory-file-name d))))
                          (cons f dirs)))))
        (setq my/at-file--cache (list root files (current-time)))
        files))))

(defun my/at-file--dir-locals-set (dir var value)
  "把 VAR=VALUE 写进 DIR/.dir-locals.el 的 nil 模式类（已有则替换）。"
  (let* ((file (expand-file-name ".dir-locals.el" dir))
         (spec (and (file-exists-p file)
                    (with-temp-buffer
                      (insert-file-contents file)
                      (ignore-errors (read (current-buffer))))))
         (all (alist-get nil spec)))
    (setf (alist-get var all) value)
    (setf (alist-get nil spec) all)
    (with-temp-file file
      (insert ";; 由 my/at-file 自动写入：@ 补全列这个目录的文件\n")
      (pp spec (current-buffer)))))

(defun my/at-file--root ()
  "当前 buffer 的代码根目录（带 /）。prompt 项目里第一次用会问一次并记住。"
  (file-name-as-directory
   (cond
    (my/code-root my/code-root)
    ((my/prompt--project-of buffer-file-name)
     (let* ((proj (my/prompt--project-of buffer-file-name))
            (dir (expand-file-name
                  (read-directory-name
                   (format "项目「%s」的代码目录: "
                           (file-name-nondirectory (directory-file-name proj)))
                   "~/" nil t))))
       (my/at-file--dir-locals-set proj 'my/code-root dir)
       (setq-local my/code-root dir)))
    ((project-current) (project-root (project-current)))
    (t default-directory))))

(defun my/at-file-capf ()
  "光标前是「@路径片段」时补全代码项目的文件；候选带 @ 前缀，整段替换。"
  (let ((beg (1- (save-excursion
                   (skip-chars-backward "^ \t\n@" (line-beginning-position))
                   (point)))))
    (when (and (>= beg (line-beginning-position))
               (eq (char-after beg) ?@)
               ;; @ 前得是行首/空白/括号，foo@bar 这种邮箱不算
               (or (= beg (line-beginning-position))
                   (memq (char-before beg) '(?\s ?\t ?\( ?\[ ?， ?（))))
      (let* ((root (my/at-file--root))
           (cands (mapcar (lambda (f) (concat "@" f)) (my/at-file--files root))))
      (list beg (point)
            (lambda (str pred action)
              (if (eq action 'metadata)
                  '(metadata (category . at-file))
                (complete-with-action action cands str pred)))
            :exclusive 'no)))))

;; 候选按子序列模糊匹配：@ 后连着敲 iosapple 就能命中 apps/ios/AppleLogin.swift
(with-eval-after-load 'orderless
  (orderless-define-completion-style my/orderless-flex
    (orderless-matching-styles '(orderless-flex)))
  (add-to-list 'completion-category-overrides
               '(at-file (styles my/orderless-flex))))

(defun my/at-file--maybe-popup ()
  "在文本 buffer 里敲出 @ 后立刻弹补全。"
  (when (and (eq last-command-event ?@)
             (derived-mode-p 'text-mode)
             (not (minibufferp)))
    (completion-at-point)))

(add-hook 'text-mode-hook
          (lambda ()
            (add-hook 'completion-at-point-functions #'my/at-file-capf -10 t)
            (add-hook 'post-self-insert-hook #'my/at-file--maybe-popup nil t)))

;;; ---------- org ----------
(setq org-directory (expand-file-name "~/org/")
      org-default-notes-file (expand-file-name "inbox.org" org-directory)
      ;; agenda = 笔记目录 + 各项目的需求列表
      org-agenda-files
      (append (list org-directory)
              (file-expand-wildcards
               (concat my/prompts-dir "*/" my/prompt-req-name))))

(with-eval-after-load 'org
  (setq org-startup-indented t
        org-return-follows-link t          ; 需求列表里回车跳转 prompt
        org-image-actual-width 600         ; 图片显示宽度上限（SPC t i 开启时）
        org-hide-emphasis-markers t
        org-log-done 'time
        ;; 需求生命周期：提出 → 确认排期 → 开发 → 验收 → 完结
        org-todo-keywords
        '((sequence "NEW(n)"      ; 新提出，还没想清楚
                    "TODO(t)"     ; 已确认要做，排队中
                    "DOING(i)"    ; 开发中（agent 干活中）
                    "VERIFY(v)"   ; 待验收（agent 交付，等人验）
                    "|"
                    "DONE(d)"     ; 验收通过
                    "CANCELED(c)")) ; 取消/拒绝
        org-todo-keyword-faces
        '(("NEW"    . shadow)                  ; 灰：还在想法池
          ("DOING"  . warning)                 ; 橙：进行中
          ("VERIFY" . font-lock-constant-face)))) ; 蓝：等验收，最该看

(setq org-capture-templates
      '(("t" "待办" entry (file+headline org-default-notes-file "Tasks")
         "* NEW %?\n  %U")
        ("n" "笔记" entry (file+headline org-default-notes-file "Notes")
         "* %?\n  %U")))

;;; ---------- markdown ----------
(use-package markdown-mode
  :mode (("\\.md\\'" . markdown-mode)
         ;; 放在后面 → 压到 auto-mode-alist 更前，优先匹配
         ("README\\.md\\'" . gfm-mode))
  :custom
  (markdown-max-image-size '(600 . nil))   ; 图片显示宽度上限（SPC t i 开启时）
  (markdown-command "multimarkdown")       ; 预览用的渲染器（brew 已装）
  (markdown-header-scaling t)              ; 标题按层级放大加粗
  (markdown-fontify-code-blocks-natively t) ; 围栏代码块按语言真高亮
  (markdown-hide-markup t)                 ; 隐藏 **、`、# 等标记（SPC t m 切换）
  (markdown-header-scaling-values '(1.2 1.15 1.1 1.05 1.0 1.0)) ; 默认 2.0 起太大
  :hook (markdown-mode . my/markdown-icons-setup)
  :config
  ;; header-scaling 相关 defcustom 用 custom-initialize-default，
  ;; :custom 路径不会触发它们的 :set，这里手动应用一次缩放 face
  (markdown-update-header-faces markdown-header-scaling
                                markdown-header-scaling-values))

;; 标题/列表图标化：#→◉○◈…、-→•。只是显示层替换，文件内容不变。
(defconst my/md-header-icons '("◉" "○" "◈" "◇" "▸" "▹")
  "1–6 级标题对应的显示符号。")

;; 正文随标题层级缩进（org-indent 风格）：line-prefix/wrap-prefix 显示层
;; 属性，复制/保存的内容不受影响。标题行缩 (层级-1)*2 格，正文缩 层级*2 格。
(defconst my/md-indent-pads
  (vector "" "  " "    " "      " "        " "          " "            ")
  "0–6 级对应的缩进前缀（每级 2 空格，同层级复用同一字符串）。")

(defun my/markdown-indent-matcher (limit)
  "font-lock matcher：按所属标题层级给行加缩进前缀，处理到 LIMIT。
一次扫完整个区域，总是返回 nil（不产生高亮匹配）。"
  (save-excursion
    (forward-line 0)
    (let ((level (save-excursion       ; 区域起点处所属的标题层级
                   (if (re-search-backward "^\\(#\\{1,6\\}\\)[ \t]" nil t)
                       (- (match-end 1) (match-beginning 1))
                     0))))
      (while (< (point) limit)
        (let ((next (min (line-beginning-position 2) (point-max)))
              (heading (looking-at "\\(#\\{1,6\\}\\)[ \t]")))
          (when heading
            (setq level (- (match-end 1) (match-beginning 1))))
          (let ((pad (aref my/md-indent-pads (if heading (1- level) level))))
            (put-text-property (point) next 'line-prefix pad)
            (put-text-property (point) next 'wrap-prefix pad))
          (goto-char next)))))
  nil)

(defun my/markdown-icons-setup ()
  "给当前 markdown buffer 加标题/列表符号的图标化 font-lock 规则。"
  (font-lock-add-keywords
   nil
   '(;; 层级缩进（见 my/markdown-indent-matcher）
     (my/markdown-indent-matcher)
     ;; 标题：markdown 隐藏「#+空格」用的是 display "" 属性，而 display
     ;; 渲染优先级高于 composition——所以这里直接把 display 覆写成图标。
     ;; 本规则排在 markdown 规则之后，每轮 fontify 都以图标为准；
     ;; display 在 font-lock-extra-managed-props 里，SPC t m 显示原始
     ;; 标记时由 font-lock 自动清掉
     ("^\\(#\\{1,6\\}\\)\\([ \t]+\\)"
      (2 (progn
           (when (and markdown-hide-markup
                      (not (markdown-code-block-at-point-p (match-beginning 0))))
             (put-text-property (match-beginning 1) (match-end 2)
                                'display
                                (concat (nth (1- (- (match-end 1)
                                                    (match-beginning 1)))
                                             my/md-header-icons)
                                        " ")))
           nil)))
     ;; 列表符号 - * + → •（代码块里不动）
     ("^[ \t]*\\([-*+]\\) "
      (1 (progn
           (if (markdown-code-block-at-point-p (match-beginning 0))
               (decompose-region (match-beginning 1) (match-end 1))
             (compose-region (match-beginning 1) (match-end 1) "•"))
           nil))))
   'append))

(defun my/markdown-toggle-markup ()
  "markdown 标记符号显示开/关（**、`、# 与标题图标联动）。"
  (interactive)
  (if (derived-mode-p 'markdown-mode)
      (progn (markdown-toggle-markup-hiding 'toggle)
             (font-lock-flush))              ; 图标规则依赖该变量，需重新 fontify
    (message "当前不是 markdown buffer")))

;; 浏览器实时预览：本地 multimarkdown 渲染 + websocket 自动刷新，
;; 内容不出本机（这也是不选 grip 的原因：grip 把内容发 GitHub API）。
(use-package markdown-preview-mode
  :commands (markdown-preview-mode))

;;; init.el ends here
