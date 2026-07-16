# 03 — 日程、待办、我的页面内容整体垂直居中，顶部空白过大

Status: resolved

Severity: medium

## Summary

日程页、待办页和我的页在内容较少时没有从页面顶部开始布局，而是整体落在屏幕中部，导致首屏上方出现大面积空白。列表、空状态和资料卡都会受影响。

## Environment

- 设备：SM S931U，Android 15 (API 35)
- 包名：`com.example.my_flutter_demo`
- 构建：debug APK

## Steps to Reproduce

1. 启动应用。
2. 进入“日程”页，观察列表或空状态位置。
3. 进入“待办”页，观察空状态或待办列表位置。
4. 进入“我的”页，观察应用信息卡位置。

## Expected

页面标题和主要内容应靠近顶部安全区域开始布局，和日历页的页面起点保持一致。

## Actual

短内容页面整体垂直居中：

- 日程页标题约从屏幕中部偏上才开始。
- 待办页空状态在屏幕中部。
- 我的页信息卡也整体位于中部。

## Evidence

- 日程页：`.scratch/android-exploratory-qa/artifacts/05-schedule-page.png`
- 我的页：`.scratch/android-exploratory-qa/artifacts/08-profile-stats.png`
- UI tree 中日程内容容器 bounds 为 `[0,722][1080,1709]`，待办空状态容器 bounds 为 `[0,629][1080,1802]`，我的页容器 bounds 为 `[0,524][1080,1907]`。

## Comments

### 2026-07-16 修复记录

已修复短内容功能页整体垂直居中的问题。共享 `AppPageContainer` 不再用 `Center` 做垂直居中，而是顶部对齐，日程、待办、我的等页面的标题和主要内容会从顶部安全区域附近开始布局。

验证：

- `flutter test` 通过，39 项测试全部通过。
- `flutter analyze` 通过，无静态分析问题。
- 已检查本次修改涉及的中文文本，未发现乱码。
- Android 设备复测通过，日程页和我的页内容从顶部开始布局，不再落在屏幕中部。

新增证据：

- `.scratch/android-exploratory-qa/artifacts/14-after-layout-fix-schedule.png`
- `.scratch/android-exploratory-qa/artifacts/15-after-layout-fix-profile.png`
