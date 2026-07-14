# Domain Docs

工程技能探索本仓库前，应按这里的规则读取领域文档。

## 探索前读取

- 根目录 `CONTEXT.md`
- 如果存在根目录 `CONTEXT-MAP.md`，则按其中指向读取相关 context 的 `CONTEXT.md`
- `docs/adr/` 中与当前工作区域相关的 ADR

如果这些文件不存在，静默继续。不要仅因为缺失就建议创建；`/domain-modeling` 会在术语或决策真正被确认时按需创建。

## 文件结构

本仓库使用 single-context 布局：

```text
/
├── CONTEXT.md
├── docs/adr/
└── lib/
```

## 使用 glossary 词汇

当输出中需要命名领域概念时，使用 `CONTEXT.md` 中定义的术语。不要漂移到 glossary 明确避免的同义词。

如果需要的概念还不在 glossary 中，说明可能存在领域语言缺口；在 `/domain-modeling` 中处理。

## 标出 ADR 冲突

如果输出与现有 ADR 冲突，必须显式说明，而不是静默覆盖。
