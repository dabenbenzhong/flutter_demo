# 01 — 应用级主题 token 骨架

**What to build:** 为本地日历建立应用级 UI 主题入口，让应用能通过统一主题读取颜色、文字、间距、圆角和阴影。完成后，基础主题、按钮、输入框和确认弹窗默认样式具备统一视觉方向，后续页面迁移不再需要继续散写基础样式。

**Blocked by:** None — can start immediately.

**Status:** resolved

- [x] 应用通过 `ThemeData` 和 `ThemeExtension` 暴露设计 token。
- [x] 设计 token 覆盖颜色、文字层级、间距尺度、圆角和阴影。
- [x] 颜色 token 使用语义命名，至少区分背景、表面、主要文字、次要文字、边框、主操作、危险操作、事项标记和状态色。
- [x] 文字 token 覆盖页面标题、区块标题、卡片标题、正文、辅助说明、数字统计、按钮和底部导航文本。
- [x] 间距、圆角和阴影使用有限尺度，避免继续新增任意样式值。
- [x] 应用基础主题统一按钮、输入框、底部弹窗和确认弹窗的默认视觉。
- [x] 现有业务功能和页面路径不因主题骨架接入而改变。
- [x] 相关测试或断言覆盖应用主题能提供所需扩展。

## Answer

已新增 `lib/ui/theme/app_theme.dart`，通过 `ThemeData` 和 `ThemeExtension` 暴露应用级颜色、文字、间距、圆角和阴影 token，并在 `CalendarApp` 接入 `AppTheme.light()`。基础主题已覆盖按钮、输入框、底部弹窗、确认弹窗和默认导航栏样式；现有危险确认操作使用危险操作 token。新增 `test/app_theme_test.dart` 覆盖主题扩展、基础组件主题和真实危险确认按钮样式。

验证已通过：`flutter test test\app_theme_test.dart`、`flutter test`、`flutter analyze`，并完成中文/UTF-8 乱码扫描。
