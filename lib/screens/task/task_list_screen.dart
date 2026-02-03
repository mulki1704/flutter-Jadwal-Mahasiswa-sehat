import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';
import '../../services/database_service.dart';
import '../../utils/constants.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> _tasksFuture;
  String? _userId;
  String _filterStatus = 'all'; // all, pending, completed

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    _userId = DatabaseService.defaultUserId;
    if (mounted) {
      setState(() {
        _tasksFuture = DatabaseService().getTasksByUserId(_userId!);
      });
    }
  }

  List<Task> _filterTasks(List<Task> tasks) {
    if (_filterStatus == 'pending') {
      return tasks.where((t) => !t.isCompleted).toList();
    } else if (_filterStatus == 'completed') {
      return tasks.where((t) => t.isCompleted).toList();
    }
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas'),
        elevation: 0,
      ),
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final allTasks = snapshot.data ?? [];
          final filteredTasks = _filterTasks(allTasks);

          return Column(
            children: [
              // Filter Tabs
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                child: Row(
                  children: [
                    _buildFilterChip('all', 'Semua'),
                    const SizedBox(width: AppSpacing.sm),
                    _buildFilterChip('pending', 'Belum Selesai'),
                    const SizedBox(width: AppSpacing.sm),
                    _buildFilterChip('completed', 'Selesai'),
                  ],
                ),
              ),
              Expanded(
                child: filteredTasks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.task_alt,
                              size: 64,
                              color: AppColors.textLight,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            const Text(
                              'Tidak ada tugas',
                              style: TextStyle(color: AppColors.textMedium),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSpacing.md),
                            child: _buildTaskItem(context, task),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
          _loadTasks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _filterStatus == value;
    return FilterChip(
      selected: isSelected,
      onSelected: (selected) => setState(() => _filterStatus = value),
      backgroundColor: Colors.transparent,
      selectedColor: AppColors.primary.withOpacity(0.2),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.border,
        width: isSelected ? 2 : 1,
      ),
      label: Text(label),
    );
  }

  Widget _buildTaskItem(BuildContext context, Task task) {
    final isOverdue =
        task.dueDate.isBefore(DateTime.now()) && !task.isCompleted;
    final daysLeft = task.dueDate.difference(DateTime.now()).inDays;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isOverdue ? AppColors.danger : AppColors.border,
          width: isOverdue ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final updated = task.copyWith(isCompleted: !task.isCompleted);
                  await DatabaseService().updateTask(updated);
                  _loadTasks();
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: task.isCompleted
                          ? AppColors.success
                          : AppColors.textMedium,
                      width: 2,
                    ),
                    color: task.isCompleted
                        ? AppColors.success
                        : Colors.transparent,
                  ),
                  child: task.isCompleted
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMedium,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Edit'),
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EditTaskScreen(task: task),
                        ),
                      );
                      _loadTasks();
                    },
                  ),
                  PopupMenuItem(
                    child: const Text('Hapus',
                        style: TextStyle(color: AppColors.danger)),
                    onTap: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Hapus Tugas'),
                          content: const Text('Apakah Anda yakin?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                  foregroundColor: AppColors.danger),
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed ?? false) {
                        await DatabaseService().deleteTask(task.id!);
                        _loadTasks();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (task.subject != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    task.subject!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              Text(
                isOverdue
                    ? 'Terlambat ${-daysLeft} hari'
                    : 'Deadline: ${DateFormat('dd MMM', 'id_ID').format(task.dueDate)}',
                style: TextStyle(
                  fontSize: 12,
                  color: isOverdue ? AppColors.danger : AppColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
