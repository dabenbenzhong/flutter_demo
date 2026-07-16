import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';
import 'package:my_flutter_demo/features/calendar/models/todo_item.dart';

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
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 18,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 18,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      '新增待办项',
                      style: TextStyle(
                        color: warmBrown,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: '关闭',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: '标题'),
                textInputAction: TextInputAction.next,
                validator: _requiredTextValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: '备注'),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('保存'),
                ),
              ),
            ],
          ),
        ),
      ),
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
