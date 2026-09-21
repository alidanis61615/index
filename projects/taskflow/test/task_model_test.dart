import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/models/task.dart';

void main() {
  test('Task map dönüşümü veriyi korur', () {
    final task = Task(id: 1, title: 'CV güncelle', description: 'TaskFlow projesini ekle', createdAt: DateTime(2026, 9, 21), priority: TaskPriority.high, isCompleted: false);
    final restored = Task.fromMap(task.toMap());
    expect(restored.id, task.id);
    expect(restored.title, task.title);
    expect(restored.priority, TaskPriority.high);
  });
}