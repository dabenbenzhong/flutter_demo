# 06 — 表单输入框和待办复选框缺少可访问名称

Status: resolved

Severity: medium

## Summary

Android UI tree 中，新增事项表单、新增待办表单的 `EditText` 节点没有可访问名称，待办项的 `CheckBox` 也没有可访问名称。TalkBack 用户难以知道当前输入框或复选框对应的业务含义。

## Environment

- 设备：SM S931U，Android 15 (API 35)
- 包名：`com.example.my_flutter_demo`
- 构建：debug APK

## Steps to Reproduce

1. 在日历页打开“新增事项”表单。
2. 抓取 UI tree。
3. 在待办页打开“新增待办”表单。
4. 新增一条待办后抓取 UI tree。

## Expected

关键输入控件和可交互状态控件应暴露清晰的可访问名称，例如“标题”“开始时间”“结束时间”“备注”“切换 Task1 完成状态”。

## Actual

UI tree 中多个控件暴露为空名称：

```text
class="android.widget.EditText" content-desc="" bounds="[60,1212][1020,1356]"
class="android.widget.EditText" content-desc="" bounds="[60,1392][522,1536]"
class="android.widget.EditText" content-desc="" bounds="[558,1392][1020,1536]"
class="android.widget.CheckBox" content-desc="" checkable="true"
```

## Evidence

- 事项表单 UI tree：测试会话 log 中打开“新增事项”后的 `EditText content-desc=""`。
- 待办行 UI tree：测试会话 log 中 `CheckBox content-desc=""`，并带有 `NAF="true"`。
- 相关截图：`.scratch/android-exploratory-qa/artifacts/02-event-required.png`、`.scratch/android-exploratory-qa/artifacts/09-task-before-restart.png`

## Comments

### 2026-07-17 修复记录

已修复新增事项表单、新增待办表单输入框和待办复选框缺少可访问名称的问题。表单输入框统一通过 `AppFormTextField` 暴露业务语义名称，待办复选框暴露“切换 <待办项标题> 完成状态”的可访问名称。

验证：

- 新增回归测试覆盖事项表单字段、待办表单字段和待办复选框语义名称。
- `flutter test test/widget_test.dart` 通过，29 项测试全部通过。
- `flutter analyze` 通过，无静态分析问题。
- `flutter test` 通过，46 项测试全部通过。
- 已检查本次修改涉及的中文文本，未发现乱码。
