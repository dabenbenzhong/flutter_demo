import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_event.dart';
import 'package:my_flutter_demo/features/calendar/utils/calendar_time_utils.dart';
import 'package:my_flutter_demo/ui/components/app_components.dart';
import 'package:my_flutter_demo/ui/theme/app_theme.dart';

class EventFormSheet extends StatefulWidget {
  const EventFormSheet({required this.selectedDate, super.key});

  final DateTime selectedDate;

  @override
  State<EventFormSheet> createState() => _EventFormSheetState();
}

class _EventFormSheetState extends State<EventFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _notesController = TextEditingController();
  var _selectedColor = _eventColorOptions.first;

  @override
  void dispose() {
    _titleController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTheme;

    return AppBottomFormShell(
      title: '新增事项',
      subtitle: '日期：${widget.selectedDate.month}月${widget.selectedDate.day}日',
      formKey: _formKey,
      onSubmit: _save,
      children: [
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: '标题'),
          textInputAction: TextInputAction.next,
          validator: _requiredTextValidator,
        ),
        SizedBox(height: tokens.spacing.sm),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _startTimeController,
                decoration: const InputDecoration(labelText: '开始时间'),
                textInputAction: TextInputAction.next,
                validator: _clockTimeValidator,
              ),
            ),
            SizedBox(width: tokens.spacing.sm),
            Expanded(
              child: TextFormField(
                controller: _endTimeController,
                decoration: const InputDecoration(labelText: '结束时间'),
                textInputAction: TextInputAction.next,
                validator: _endTimeValidator,
              ),
            ),
          ],
        ),
        SizedBox(height: tokens.spacing.sm),
        TextFormField(
          controller: _notesController,
          decoration: const InputDecoration(labelText: '备注'),
          maxLines: 2,
        ),
        SizedBox(height: tokens.spacing.md),
        Wrap(
          spacing: tokens.spacing.xs,
          runSpacing: tokens.spacing.xs,
          children: [
            for (final option in _eventColorOptions)
              ChoiceChip(
                label: Text(option.label),
                selected: option == _selectedColor,
                avatar: CircleAvatar(backgroundColor: option.color),
                showCheckmark: false,
                backgroundColor: tokens.colors.surface,
                selectedColor: tokens.colors.primaryAction.withValues(
                  alpha: 0.14,
                ),
                side: BorderSide(
                  color: option == _selectedColor
                      ? tokens.colors.primaryAction
                      : tokens.colors.border,
                ),
                labelStyle: tokens.text.helper.copyWith(
                  color: tokens.colors.textPrimary,
                ),
                onSelected: (_) {
                  setState(() {
                    _selectedColor = option;
                  });
                },
              ),
          ],
        ),
      ],
    );
  }

  String? _requiredTextValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '请填写';
    }

    return null;
  }

  String? _clockTimeValidator(String? value) {
    final requiredError = _requiredTextValidator(value);
    if (requiredError != null) {
      return requiredError;
    }

    if (parseClockTimeToMinutes(value!) == null) {
      return '请使用 HH:mm';
    }

    return null;
  }

  String? _endTimeValidator(String? value) {
    final timeError = _clockTimeValidator(value);
    if (timeError != null) {
      return timeError;
    }

    final startMinutes = parseClockTimeToMinutes(_startTimeController.text);
    final endMinutes = parseClockTimeToMinutes(value!);
    if (startMinutes != null &&
        endMinutes != null &&
        endMinutes <= startMinutes) {
      return '结束时间必须晚于开始时间';
    }

    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      CalendarEvent(
        date: widget.selectedDate,
        time: _startTimeController.text.trim(),
        endTime: _endTimeController.text.trim(),
        title: _titleController.text.trim(),
        notes: _notesController.text.trim(),
        color: _selectedColor.color,
        icon: Icons.event_note_rounded,
        iconBackground: _selectedColor.iconBackground,
      ),
    );
  }
}

class _EventColorOption {
  const _EventColorOption({
    required this.label,
    required this.color,
    required this.iconBackground,
  });

  final String label;
  final Color color;
  final Color iconBackground;
}

const _eventColorOptions = [
  _EventColorOption(
    label: '蓝色',
    color: blueMarker,
    iconBackground: Color(0xffeef4ff),
  ),
  _EventColorOption(
    label: '绿色',
    color: greenMarker,
    iconBackground: Color(0xffeaf8ef),
  ),
  _EventColorOption(
    label: '紫色',
    color: purpleMarker,
    iconBackground: Color(0xfff5edff),
  ),
];
