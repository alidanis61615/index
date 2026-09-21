enum TaskPriority { low, medium, high }

class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? dueDate;
  final TaskPriority priority;
  final bool isCompleted;

  const Task({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.priority,
    required this.isCompleted,
    this.dueDate,
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? dueDate,
    bool clearDueDate = false,
    TaskPriority? priority,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'priority': priority.name,
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, Object?> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: (map['description'] as String?) ?? '',
      createdAt: DateTime.parse(map['created_at'] as String),
      dueDate: map['due_date'] == null
          ? null
          : DateTime.parse(map['due_date'] as String),
      priority: TaskPriority.values.firstWhere(
        (value) => value.name == map['priority'],
        orElse: () => TaskPriority.medium,
      ),
      isCompleted: (map['is_completed'] as int? ?? 0) == 1,
    );
  }
}
