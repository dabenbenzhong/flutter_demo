# Issue tracker：本地 Markdown

本仓库的 issues 和 specs 写在 `.scratch/` 下。

## 约定

- 每个功能一个目录：`.scratch/<feature-slug>/`
- 规格文件是 `.scratch/<feature-slug>/spec.md`
- 实现 ticket 是 `.scratch/<feature-slug>/issues/<NN>-<slug>.md`，从 `01` 开始编号；不要把多个 tickets 合并到一个文件
- triage 状态写在每个 issue 文件顶部附近的 `Status:` 行中；角色字符串见 `triage-labels.md`
- 评论和会话历史追加到文件底部的 `## Comments` 标题下

## 当技能要求“发布到 issue tracker”时

在 `.scratch/<feature-slug>/` 下创建新文件；如果目录不存在则先创建。

## 当技能要求“读取相关 ticket”时

读取用户提供的路径或 issue 编号对应的文件。

## Wayfinding 操作

供 `/wayfinder` 使用。map 是一个文件，每个 child ticket 是一个独立文件。

- Map：`.scratch/<effort>/map.md`
- Child ticket：`.scratch/<effort>/issues/NN-<slug>.md`
- Blocking：顶部附近使用 `Blocked by: NN, NN`
- Frontier：扫描 `.scratch/<effort>/issues/` 中 open、unblocked、unclaimed 的文件，编号最小者优先
- Claim：开始工作前设置 `Status: claimed`
- Resolve：在 `## Answer` 下追加答案，设置 `Status: resolved`，并把上下文指针追加到 `map.md`
