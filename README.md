# ~/.emacs.d

精简配置，两个定位：**codex/claude code 的 prompt 编辑器** + org/markdown 笔记。
evil（vim 键位），外部包 13 个：evil、evil-collection、general、markdown-mode、
markdown-preview-mode（浏览器预览）、corfu、cape（补全弹窗）、vertico、orderless、
marginalia、consult（minibuffer）、dashboard、nerd-icons（启动页），
其余用 Emacs 内置功能。

启动页显示最近文件和所有项目的待办需求（TODO/DOING），条目上回车直达；
`r`/`a` 跳到对应区块。
设计记录见 `docs/2026-09-08-notes-config-design.md`。

## 首次启动

首次启动会自动从 MELPA 装包，等一会儿即可。笔记目录默认 `~/org/`。

## 键位表（normal/visual 模式下按 SPC）

| 键 | 功能 |
|---|---|
| `SPC f f / f r / f s / f i` | 打开文件 / 最近文件 / 保存 / 打开 init.el |
| `SPC b b / b d` | 切 buffer / 关 buffer |
| `SPC s s / s n` | 当前文件行搜索 / 笔记目录全文搜索（均实时预览，consult） |
| `SPC y` | buffer/选区入剪贴板（自动去行尾空白、压缩空行） |
| `SPC p n / p f / p s / p i` | prompt 库：新建（选项目→选模板，输新项目名自动建目录）/ 打开 / 全文搜索 / 插入代码文件 |
| `SPC p v / p c` | 剪贴板图片 / 框选截图 → 存所属项目的 `img/`（不在项目里存库根 `img/`），插成 `![]()` 或 `[[file:]]` |
| `SPC p r / p l` | 当前 prompt 登记进项目 `需求.org`（TODO+链接，自动去重）/ 打开项目需求列表 |
| `SPC t i` | 内联图片显示开/关（org 与 markdown 通用；默认不预览） |
| `SPC t m` | markdown 标记符号显示开/关（`**`、`` ` ``、`#`，默认隐藏） |
| `SPC t p` | markdown 浏览器实时预览开/关（保存自动刷新） |
| `SPC o a / o c / o o` | org agenda / capture / 打开笔记目录 |
| `SPC w v / w s / w d / w o / w hjkl` | 分屏、关窗口、窗口间移动 |
| `SPC t t` | 深/浅主题切换 |
| `SPC q q` | 退出 |
| `SPC :` | M-x |
| `C-c f` | 手动补全文件路径，连按轮换候选（`C-x C-f` 保持为 find-file） |

补全弹窗（corfu + cape）：输入路径（`~/`、`/`、`../`）或词语时自动弹出候选，
`C-n/C-p` 选择、TAB 确认。自动弹窗嫌吵可在 init.el 里把 `corfu-auto` 设为 nil，
改用 `C-M-i` 手动触发。

`@文件`引用（仿 claude code）：在 markdown/org 里敲 `@` 立刻弹出代码项目的文件
列表，连着敲字母按子序列模糊过滤（`@iosapple` 能命中 `apps/ios/AppleLogin.swift`），
选中插入 `@相对路径`。代码目录来自 `~/prompts/<项目>/.dir-locals.el` 的
`my/code-root`，第一次用时问一次自动写入；不在 prompt 库里的文件用 project.el
识别的项目根。列表用 `fd` 生成（遵守 .gitignore），30 秒内复用。

## markdown 美化（2026-09-08）

编辑区即成品感：标题按层级放大加粗、`#` 显示为 `◉ ○ ◈ ◇ ▸ ▹`、列表 `-` 显示为
`•`、围栏代码块按语言真高亮、`**`/`` ` `` 等标记默认隐藏（`SPC t m` 看原始文本）。
图标只是显示层替换（标题走 display 属性、列表走 compose），文件内容不变，
代码块内不受影响。正文还会随标题层级缩进（org-indent 风格，标题缩
(层级-1)×2 格、正文缩 层级×2 格，line-prefix 显示层实现，复制/保存不带缩进）。

浏览器预览（`SPC t p`）走本地 multimarkdown（`brew install multimarkdown` 已装）
+ websocket 自动刷新，内容不出本机——没选 grip 就是因为它把内容发 GitHub API
渲染，prompt 里常有工作代码。

## 输入法

自写的极简联动（init.el「输入法联动」一节，不依赖 sis）：回 normal 自动切英文，
回 insert 恢复离开时的输入法（按 buffer 记忆），全异步不卡顿。用什么中文输入法
（系统拼音/搜狗/Rime）都无需改配置。

## 需求列表（GTD）

每个项目一个 `~/prompts/<项目>/需求.org`：条目 = 需求状态 + 指向 prompt 的
相对链接。状态按软件需求生命周期定义：
`NEW`（新提出）→ `TODO`（确认排期）→ `DOING`（开发中）→ `VERIFY`（待验收）→
`DONE`（验收通过）/ `CANCELED`（取消），快速键 n/t/i/v/d/c。
写完 prompt 按 `SPC p r` 登记（初始 TODO；capture 快速记录的想法是 NEW），
`SPC p l` 打开列表，回车跟链接跳到 prompt。所有需求列表自动进 agenda——
`SPC o a` 总览全部项目的需求状态，`t` 键流转状态。启动页显示全部未完结
需求（NEW/TODO/DOING/VERIFY）。md 管内容（发给 agent），org 管状态（GTD）。

## 终端联动

Emacs 启动时开了 server，终端里 `ec 文件`（= `emacsclient -n`，已加进
~/.zshrc）把文件秒开到现有 GUI 窗口。`EDITOR`/`VISUAL` 设为
`emacsclient -a vim`；Emacs 没开则退回 vim。

**Ctrl+G 外部编辑**（claude code/codex）已做专门适配：按下后 Emacs 自动到
前台，临时文件自动按 markdown 处理（软换行/高亮/补全/SPC p 工具都在），光标停在
草稿末尾；写完 `ZZ`（= 保存并返回，也可 `:wq` / `C-x #`），内容回填 CLI 且焦点
自动切回来源终端，全程不碰鼠标。

## prompt 模板

模板是 `~/prompts/templates/` 下的普通 markdown 文件，`SPC p n` 新建时按文件名
选择（「默认」= 内置骨架）。改模板 = 改文件；加一套 = 加一个 .md。现有 10 套，
分两类：**派活**（功能开发、Bug修复、排查诊断、重构、方案设计、代码审查）——
固化验收标准、范围边界、「不要做」；**讨论**（思路讨论、技术选型、唱反调、
讲解学习）——固化讨论规则：先别动手、信息不全先提问、敢反驳别顺着说。

## 中文对齐

英文 Menlo + 中文苹方 rescale 近似两半角一汉字。追求完美等宽（org 表格严格对齐）：
`brew install --cask font-sarasa-gothic`，然后把 init.el 里默认字体和 han 字体
都改成 `Sarasa Mono SC` 并删掉 rescale。

## 已移除（2026-09-08）

- **sis**（输入法自动切英文）：其空闲轮询同步调 im-select 导致全局卡顿，按用户要求移除，改为上面的自写方案
- **valign**（org 表格像素对齐）：挂在 jit-lock 上重绘开销大，是 org 编辑卡顿的嫌疑，按用户要求移除
