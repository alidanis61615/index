import 'package:flutter/material.dart';
import '../controllers/theme_controller.dart';
import '../models/task.dart';
import '../services/task_database.dart';

enum TaskFilter { all, active, completed }

class HomeScreen extends StatefulWidget {
  final ThemeController themeController;
  const HomeScreen({super.key, required this.themeController});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = TaskDatabase.instance;
  final search = TextEditingController();
  List<Task> tasks = [];
  TaskFilter filter = TaskFilter.all;
  String query = '';

  @override
  void initState() { super.initState(); load(); }

  Future<void> load() async {
    final data = await db.getTasks();
    if (!mounted) return;
    setState(() => tasks = data);
  }

  List<Task> get visible => tasks.where((t) {
    final q = query.trim().toLowerCase();
    final matchesText = q.isEmpty || t.title.toLowerCase().contains(q) || t.description.toLowerCase().contains(q);
    final matchesFilter = filter == TaskFilter.all ||
      (filter == TaskFilter.active && !t.isCompleted) ||
      (filter == TaskFilter.completed && t.isCompleted);
    return matchesText && matchesFilter;
  }).toList();

  Future<void> addTask() async {
    final controller = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Görev'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Başlık')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          FilledButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Ekle')),
        ],
      ),
    );
    controller.dispose();
    if (title == null || title.isEmpty) return;
    await db.insertTask(Task(title: title, description: '', createdAt: DateTime.now(), priority: TaskPriority.medium, isCompleted: false));
    await load();
  }

  @override
  Widget build(BuildContext context) {
    final completed = tasks.where((t) => t.isCompleted).length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [IconButton(onPressed: widget.themeController.toggle, icon: Icon(widget.themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode))],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: addTask, icon: const Icon(Icons.add), label: const Text('Yeni Görev')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Text('Toplam: ' + tasks.length.toString() + '  •  Aktif: ' + (tasks.length-completed).toString() + '  •  Biten: ' + completed.toString(), style: Theme.of(context).textTheme.titleMedium))),
          const SizedBox(height: 12),
          TextField(controller: search, onChanged: (v) => setState(() => query=v), decoration: const InputDecoration(border: OutlineInputBorder(), prefixIcon: Icon(Icons.search), hintText: 'Görevlerde ara...')),
          const SizedBox(height: 12),
          SegmentedButton<TaskFilter>(
            segments: const [ButtonSegment(value: TaskFilter.all, label: Text('Tümü')), ButtonSegment(value: TaskFilter.active, label: Text('Aktif')), ButtonSegment(value: TaskFilter.completed, label: Text('Biten'))],
            selected: {filter}, onSelectionChanged: (s) => setState(() => filter=s.first),
          ),
          const SizedBox(height: 16),
          ...visible.map((t) => Card(child: CheckboxListTile(
            value: t.isCompleted,
            title: Text(t.title),
            subtitle: Text(t.priority.name),
            onChanged: (v) async { await db.updateTask(t.copyWith(isCompleted: v ?? false)); await load(); },
            secondary: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () async { if (t.id != null) { await db.deleteTask(t.id!); await load(); } }),
          ))),
        ],
      ),
    );
  }
}