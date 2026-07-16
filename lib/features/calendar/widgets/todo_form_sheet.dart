import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/models/todo_item.dart';
import 'package:my_flutter_demo/ui/components/app_components.dart';
import 'package:my_flutter_demo/ui/theme/app_theme.dart';

class TodoFormSheet extends StatefulWidget {
  const TodoFormSheet({super.key});

  @override
  State<TodoFormSheet> createState() => _TodoFormSheetState();
}

class _TodoFormSheetState extends State<TodoFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTheme;

    return AppBottomFormShell(
      title: '新增待办项',
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
        TextFormField(
          controller: _notesController,
          decoration: const InputDecoration(labelText: '备注'),
          maxLines: 2,
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

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      TodoItem(
        title: _titleController.text.trim(),
        notes: _notesController.text.trim(),
        createdAt: DateTime.now(),
      ),
    );
  }
}
