import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/models/todo_item.dart';
import 'package:my_flutter_demo/ui/components/app_components.dart';
import 'package:my_flutter_demo/ui/theme/app_theme.dart';

class TodoFormSheet extends StatefulWidget {
  const TodoFormSheet({this.initialTodo, super.key});

  final TodoItem? initialTodo;

  @override
  State<TodoFormSheet> createState() => _TodoFormSheetState();
}

class _TodoFormSheetState extends State<TodoFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  bool get _isEditing => widget.initialTodo != null;

  @override
  void initState() {
    super.initState();
    final todo = widget.initialTodo;
    if (todo == null) {
      return;
    }

    _titleController.text = todo.title;
    _notesController.text = todo.notes;
  }

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
      title: _isEditing ? '编辑待办项' : '新增待办项',
      formKey: _formKey,
      onSubmit: _save,
      submitLabel: _isEditing ? '保存修改' : '保存',
      children: [
        AppFormTextField(
          controller: _titleController,
          labelText: '标题',
          semanticLabel: '待办项标题',
          textInputAction: TextInputAction.next,
          validator: _requiredTextValidator,
        ),
        SizedBox(height: tokens.spacing.sm),
        AppFormTextField(
          controller: _notesController,
          labelText: '备注',
          semanticLabel: '待办项备注',
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
      widget.initialTodo?.copyWith(
            title: _titleController.text.trim(),
            notes: _notesController.text.trim(),
          ) ??
          TodoItem(
            title: _titleController.text.trim(),
            notes: _notesController.text.trim(),
            createdAt: DateTime.now(),
          ),
    );
  }
}
