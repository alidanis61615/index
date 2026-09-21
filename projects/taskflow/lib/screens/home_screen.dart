import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Future<void> _openTaskEditor({Task? task}) async {
    final titleController = TextEditingController(text: task?.title ?? '');
    final descriptionController =
        TextEditingController(text: task?.description ?? '');
    var priority = task?.priority ?? TaskPriority.medium;
    var dueDate = task?.dueDate;

    final result = await showModalBottomSheet<Task>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Future<void> pickDate() async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: dueDate ?? now,
                firstDate: DateTime(now.year - 1),
                lastDate: DateTime(now.year + 5),
              );
              if (picked != null) {
                setSheetState(() => dueDate = picked);
              }
            }

            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                0,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      task == null ? 'Yeni Görev' : 'Görevi Düzenle',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      autofocus: task == null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Görev başlığı',
                        prefixIcon: Icon(Icons.task_alt_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Açıklama',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.notes_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<TaskPriority>(
                      initialValue: priority,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Öncelik',
                        prefixIcon: Icon(Icons.flag_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: TaskPriority.low,
                          child: Text('Düşük'),
                        ),
                        DropdownMenuItem(
                          value: TaskPriority.medium,
                          child: Text('Orta'),
                        ),
                        DropdownMenuItem(
                          value: TaskPriority.high,
                          child: Text('Yüksek'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setSheetState(() => priority = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: pickDate,
                      icon: const Icon(Icons.event_outlined),
                      label: Text(
                        dueDate == null
                            ? 'Son tarih seç'
                            : DateFormat('dd.MM.yyyy').format(dueDate!),
                      ),
                    ),
                    if (dueDate != null)
                      TextButton(
                        onPressed: () {
                          setSheetState(() => dueDate = null);
                        },
                        child: const Text('Son tarihi kaldır'),
                      ),
                    const SizedBox(height: 8),
                    FilledButton.icon(
                      onPressed: () {
                        final title = titleController.text.trim();
                        if (title.isEmpty) return;
                        Navigator.of(context).pop(
                          Task(
                            id: task?.id,
                            title: title,
                            description: descriptionController.text.trim(),
                            createdAt: task?.createdAt ?? DateTime.now(),
                            dueDate: dueDate,
                            priority: priority,
                            isCompleted: task?.isCompleted ?? false,
                          ),
                        );
                      },
                      icon: Icon(
                        task == null
                            ? Icons.add_task_rounded
                            : Icons.save_outlined,
                      ),
                      label: Text(task == null ? 'Görevi Ekle' : 'Kaydet'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    titleController.dispose();
    descriptionController.dispose();

    if (result == null) return;
    if (task == null) {
      await db.insertTask(result);
    } else {
      await db.updateTask(result);
    }
    await load();
  }

  String _priorityLabel(TaskPriority priority) {
    return switch (priority) {
      TaskPriority.low => 'Düşük',
      TaskPriority.medium => 'Orta',
      TaskPriority.high => 'Yüksek',
    };
  }

  @override
  Widget build(BuildContext context) {
    final completed = tasks.where((t) => t.isCompleted).length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [IconButton(onPressed: widget.themeController.toggle, icon: Icon(widget.themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode))],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _openTaskEditor(), icon: const Icon(Icons.add), label: const Text('Yeni Görev')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Text('Toplam: ${tasks.length}  •  Aktif: ${tasks.length - completed}  •  Biten: $completed', style: Theme.of(context).textTheme.titleMedium))),
          const SizedBox(height: 12),
          TextField(controller: search, onChanged: (v) => setState(() => query=v), decoration: const InputDecoration(border: OutlineInputBorder(), prefixIcon: Icon(Icons.search), hintText: 'Görevlerde ara...')),
          const SizedBox(height: 12),
          SegmentedButton<TaskFilter>(
            segments: const [ButtonSegment(value: TaskFilter.all, label: Text('Tümü')), ButtonSegment(value: TaskFilter.active, label: Text('Aktif')), ButtonSegment(value: TaskFilter.completed, label: Text('Biten'))],
            selected: {filter}, onSelectionChanged: (s) => setState(() => filter=s.first),
          ),
          const SizedBox(height: 16),
          ...visible.map(
            (t) => Card(
              child: ListTile(
                leading: Checkbox(
                  value: t.isCompleted,
                  onChanged: (value) async {
                    await db.updateTask(
                      t.copyWith(isCompleted: value ?? false),
                    );
                    await load();
                  },
                ),
                title: Text(
                  t.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    decoration: t.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (t.description.isNotEmpty) Text(t.description),
                    const SizedBox(height: 4),
                    Text('Öncelik: ${_priorityLabel(t.priority)}'),
                    if (t.dueDate != null)
                      Text(
                        'Son tarih: ${DateFormat('dd.MM.yyyy').format(t.dueDate!)}',
                      ),
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'edit') {
                      await _openTaskEditor(task: t);
                    } else if (value == 'delete' && t.id != null) {
                      await db.deleteTask(t.id!);
                      await load();
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Düzenle'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Sil'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}