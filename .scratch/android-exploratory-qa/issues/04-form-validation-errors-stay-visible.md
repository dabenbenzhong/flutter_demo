# 04 — 表单空提交后再填写有效值，错误提示仍然残留

Status: resolved

Severity: medium

## Summary

新增事项和新增待办表单在空提交后会显示“请填写”。用户随后输入有效值时，错误提示仍然显示在字段下方，直到再次点击保存。

## Environment

- 设备：SM S931U，Android 15 (API 35)
- 包名：`com.example.my_flutter_demo`
- 构建：debug APK

## Steps to Reproduce

事项表单：

1. 在日历页点击“新增事项”。
2. 不填写任何字段，点击“保存”。
3. 输入标题 `QAEvent`、开始时间 `10:00`、结束时间 `11:00`、备注 `Note`。
4. 观察三个必填字段下方。

待办表单：

1. 在待办页点击“新增待办”。
2. 不填写标题，点击“保存”。
3. 输入标题 `Task1`。
4. 观察标题字段下方。

## Expected

字段内容变为有效后，对应的“请填写”错误提示应消失，或者表单应即时重新校验该字段。

## Actual

字段已填写有效内容，但错误提示仍显示：

- 事项标题、开始时间、结束时间下方仍显示“请填写”。
- 待办标题下方仍显示“请填写”。

## Evidence

- 事项表单：`.scratch/android-exploratory-qa/artifacts/03-event-stale-errors.png`
- 待办表单：`.scratch/android-exploratory-qa/artifacts/07-todo-stale-errors.png`

## Comments

### 2026-07-17 修复记录

已修复新增事项和新增待办表单在空提交后错误提示残留的问题。表单输入框现在按字段使用 `AutovalidateMode.onUserInteraction`，用户输入有效内容后对应字段会即时重新校验并清除“请填写”提示，同时不会在提交前提前校验未触碰字段。

验证：

- 新增回归测试覆盖事项表单和待办表单错误提示随输入消失，以及提交前不提前校验未触碰字段。
- `flutter test test/widget_test.dart` 通过，29 项测试全部通过。
- `flutter analyze` 通过，无静态分析问题。
- `flutter test` 通过，46 项测试全部通过。
- 已检查本次修改涉及的中文文本，未发现乱码。
