# 笔记向 Emacs 配置设计（2026-09-08）

## 需求（用户确认）

- 用途：org-mode 笔记/任务 + markdown，**不含编程开发**
- 键位：vim（evil），SPC leader
- 路线：手写·精简——只装解决明确问题的包，尽量用内置功能
- 环境：macOS，Emacs 31.1；中文用户，需要输入法联动与中文表格对齐

## 结构

`early-init.el` + 单个 `init.el`（分节注释）。体量小，不拆模块。

## 外部包（6 个）及理由

| 包 | 解决的问题 |
|---|---|
| evil + evil-collection | vim 键位 |
| general | SPC leader 定义的可读性 |
| sis | normal 模式自动切英文（配 /opt/homebrew/bin/im-select） |
| valign | org 中文表格像素级对齐 |
| markdown-mode | Emacs 无内置 md mode |

## 用内置替代的选择

- minibuffer 补全：`fido-vertical-mode`（不装 vertico/consult）
- 主题：`modus-operandi`/`modus-vivendi`，SPC t t 切换（不装 doom-themes）
- 键位提示：内置 which-key（Emacs 30+）
- 笔记全文搜索：`my/search-notes` 封装 rg + grep-mode（不装 consult/deadgrep）
- 中文显示：Menlo + PingFang SC rescale 1.2，表格由 valign 兜底

## 明确不做

- LSP / tree-sitter / corfu / magit / 任何编程语言配置（需要写代码时再加）
- 不装 exec-path-from-shell（只需补 /opt/homebrew/bin，手动更快）

## 机器环境备忘

- im-select、rg、fd 在 /opt/homebrew/bin；GUI Emacs 不继承 shell PATH，init.el 手动补
- 无 Sarasa/LXGW 等宽中文字体，只有系统苹方；追求完美等宽可
  `brew install --cask font-sarasa-gothic` 后改字体设置
- 输入法中文源默认系统简体拼音（com.apple.inputmethod.SCIM.ITABC），
  搜狗/Rime 需改 sis 配置
- `emacs --batch` 隐含 -q，不激活已装包；批量测试需先 `(package-initialize)`
