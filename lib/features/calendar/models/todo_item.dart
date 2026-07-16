class TodoItem {
  const TodoItem({
    required this.title,
    this.notes = '',
    this.isCompleted = false,
    required this.createdAt,
  });

  final String title;
  final String notes;
  final bool isCompleted;
  final DateTime createdAt;

  TodoItem copyWith({String? title, String? notes, bool? isCompleted}) {
    return TodoItem(
      title: title ?? this.title,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }
}
