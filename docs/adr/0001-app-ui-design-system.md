# 采用应用级设计系统统一 UI

本地日历下一阶段先聚焦 UI 统一和视觉精修，不扩展新的业务功能。应用采用全应用级 UI 基础层承载温暖、克制、精致的视觉语言，通过 `ThemeData` 和 `ThemeExtension` 统一管理颜色、字体、间距、圆角、阴影和共享组件，而不是让各功能页面继续散写 `Color`、`TextStyle`、`EdgeInsets` 等样式细节。

**Consequences**

- 日历页、日程页、待办页和我的页应逐步迁移为消费统一 theme token 和共享组件。
- 新增 UI 时优先扩展 `lib/ui/theme/` 和 `lib/ui/components/`，避免在 feature 页面内新增孤立样式常量。
- 第一轮重构保持现有业务功能和主交互路径不变，只统一视觉基础和页面精修。
