# Android 探索性测试记录

标签：qa, android, exploratory

## Scope

本轮测试在 Android 设备上探索当前 Flutter 本地日历应用，覆盖日历、日程、待办、我的四个功能页面，以及新增/删除事项、新增/完成/删除待办、月份切换、统计、清空本地数据和重启后的本地数据行为。

## Environment

- 日期：2026-07-16
- 设备：SM S931U
- Android：15 (API 35)
- 设备序列号：RFCY301D6TH
- App package：com.example.my_flutter_demo
- Flutter：3.44.4 stable
- 构建：debug APK，`flutter build apk --debug`

## Verification

- `flutter pub get` 通过。
- `flutter test` 通过，36 项测试全部通过。
- debug APK 构建成功并安装到 Android 设备。
- 测试前执行 `adb shell pm clear com.example.my_flutter_demo` 清空应用数据。
- 使用 `adb` 启动、点击、抓取 UI tree、截图和 logcat。

## Artifacts

证据文件位于 `.scratch/android-exploratory-qa/artifacts/`：

- `01-home.png`
- `02-event-required.png`
- `03-event-stale-errors.png`
- `04-event-created.png`
- `05-schedule-page.png`
- `06-non-july-lunar.png`
- `07-todo-stale-errors.png`
- `08-profile-stats.png`
- `09-task-before-restart.png`
- `10-task-after-restart.png`
- `logcat.txt`

