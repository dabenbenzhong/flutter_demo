# 05 — 非 2026 年 7 月日期详情只显示“农历”，文案不完整

Status: resolved

Severity: low

## Summary

切换到非 2026 年 7 月月份后，选中日期详情卡的农历行只显示“农历”，没有后续日期文本，视觉上像缺失内容。

## Environment

- 设备：SM S931U，Android 15 (API 35)
- 包名：`com.example.my_flutter_demo`
- 构建：debug APK

## Steps to Reproduce

1. 在日历页选中 2026 年 7 月 31 日。
2. 点击“下个月”两次，切换到 2026 年 9 月。
3. 观察选中日期详情卡。

## Expected

如果没有可用农历数据，应隐藏农历行或显示明确占位；如果显示“农历”，后面应有对应日期内容。

## Actual

详情卡显示 `9月30日`，农历行只显示“农历”，没有日期内容。

## Evidence

- `.scratch/android-exploratory-qa/artifacts/06-non-july-lunar.png`
- UI tree 中该节点 `content-desc="农历"`。

## Comments

### 2026-07-17 修复记录

已修复非 2026 年 7 月日期详情只显示裸“农历”的问题。选中日期没有可用农历数据时，详情卡会隐藏农历行；有数据的 2026 年 7 月日期仍继续显示完整农历文案。

验证：

- 新增回归测试覆盖切换到 2026 年 9 月 30 日后不再显示裸“农历”。
- `flutter test test/widget_test.dart` 通过，29 项测试全部通过。
- `flutter analyze` 通过，无静态分析问题。
- `flutter test` 通过，46 项测试全部通过。
- 已检查本次修改涉及的中文文本，未发现乱码。
