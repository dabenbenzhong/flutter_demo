# 02 — 日历页底部导航和浮动按钮遮挡横幅内容

Status: resolved

Severity: medium

## Summary

日历页首屏底部的横幅内容会出现在底部导航栏和浮动新增按钮后面，文字被半透明导航栏覆盖，视觉上难以阅读。

## Environment

- 设备：SM S931U，Android 15 (API 35)
- 包名：`com.example.my_flutter_demo`
- 构建：debug APK

## Steps to Reproduce

1. 清空应用数据后启动应用。
2. 停留在默认日历页首屏。
3. 观察页面底部的横幅和底部导航区域。

## Expected

底部导航栏和浮动按钮不应遮挡页面内容；横幅文字应完整可读，内容与导航层之间应有足够安全间距。

## Actual

“每一天，都是更好的自己。”横幅内容部分落在底部导航栏后面，浮动新增按钮也覆盖横幅区域。

## Evidence

- `.scratch/android-exploratory-qa/artifacts/01-home.png`

## Comments

### 2026-07-16 修复记录

已修复日历页底部横幅被底部导航和浮动新增按钮遮挡的问题。页面容器改为顶部对齐；日历页为浮动新增按钮预留横向空间，并在窄屏首屏使用单行紧凑横幅，确保“每一天，都是更好的自己。”完整可读且不被 FAB 覆盖。

验证：

- `flutter test` 通过，39 项测试全部通过。
- `flutter analyze` 通过，无静态分析问题。
- 已检查本次修改涉及的中文文本，未发现乱码。
- Android 设备复测通过，debug APK 安装后清空数据并启动，默认日历页横幅不再被底部导航和浮动新增按钮遮挡。

新增证据：

- `.scratch/android-exploratory-qa/artifacts/13-after-layout-fix-home.png`
