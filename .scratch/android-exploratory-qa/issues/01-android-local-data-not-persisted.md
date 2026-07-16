# 01 — Android 本地数据无法持久化，重启后新增数据丢失

Status: ready-for-agent

Severity: high

## Summary

Android debug APK 中新增事项、删除事项、新增待办、切换待办完成状态时，界面会先更新，但保存到本地文件失败。应用重启后新增的待办会丢失，logcat 记录未处理的 `FileSystemException`。

## Environment

- 设备：SM S931U，Android 15 (API 35)
- 包名：`com.example.my_flutter_demo`
- 构建：debug APK

## Steps to Reproduce

1. 安装并启动应用。
2. 进入待办页。
3. 点击“新增待办”，输入 `Task2` 并保存。
4. 确认待办页显示 `Task2`。
5. 执行 force-stop 后重新启动应用。
6. 再次进入待办页。

## Expected

`Task2` 仍保存在当前设备内，重启后待办页继续显示这条待办。

## Actual

重启后待办页显示“还没有待办”，`Task2` 丢失。

## Evidence

- 新增后可见：`.scratch/android-exploratory-qa/artifacts/09-task-before-restart.png`
- 重启后丢失：`.scratch/android-exploratory-qa/artifacts/10-task-after-restart.png`
- logcat：`.scratch/android-exploratory-qa/artifacts/logcat.txt`

关键日志：

```text
Unhandled Exception: FileSystemException: Creation failed, path = '//my_flutter_demo' (OS Error: Read-only file system, errno = 30)
#2 FileCalendarEventStore.saveData (package:my_flutter_demo/features/calendar/data/calendar_event_store.dart:120:5)
```

同类保存失败也出现在 `_showAddEventSheet`、`_confirmDeleteEvent`、`_showAddTodoSheet`、`_toggleTodo` 路径。

## Notes

代码阅读显示 `FileCalendarEventStore._defaultPath()` 在 Android 环境下会回退到 `Directory.current.path`，导致默认路径拼成 `//my_flutter_demo/calendar_events.json`。Android 上应该使用应用私有可写目录，而不是根目录。

## Comments

