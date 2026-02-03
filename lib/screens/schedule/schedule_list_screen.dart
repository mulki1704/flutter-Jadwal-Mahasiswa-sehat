import 'package:flutter/material.dart';
import '../../models/schedule.dart';
import '../../services/database_service.dart';
import '../../utils/constants.dart';
import 'add_schedule_screen.dart';
import 'edit_schedule_screen.dart';
import 'widgets/schedule_list_widget.dart';

class ScheduleListScreen extends StatefulWidget {
  const ScheduleListScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleListScreen> createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen> {
  late Future<List<Schedule>> _schedulesFuture;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _userId = DatabaseService.defaultUserId;
    _loadSchedules();
  }

  void _loadSchedules() async {
    // Load schedules for all days
    List<Schedule> allSchedules = [];
    for (var day in DayOfWeek.values) {
      final schedules =
          await DatabaseService().getSchedulesByDay(_userId!, day);
      allSchedules.addAll(schedules);
    }
    if (mounted) {
      setState(() {
        _schedulesFuture = Future.value(allSchedules);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal'),
        elevation: 0,
      ),
      body: FutureBuilder<List<Schedule>>(
        future: _schedulesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final schedules = snapshot.data ?? [];

          if (schedules.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 64,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    'Tidak ada jadwal',
                    style: TextStyle(color: AppColors.textMedium),
                  ),
                ],
              ),
            );
          }

          return ScheduleListWidget(
            schedules: schedules,
            onDelete: _handleDeleteSchedule,
            onEdit: _handleEditSchedule,
            onRefresh: _loadSchedules,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddScheduleScreen()),
          );
          _loadSchedules();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _handleDeleteSchedule(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Jadwal'),
        content: const Text('Apakah Anda yakin ingin menghapus jadwal ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await DatabaseService().deleteSchedule(id);
      _loadSchedules();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jadwal berhasil dihapus')),
        );
      }
    }
  }

  Future<void> _handleEditSchedule(Schedule schedule) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditScheduleScreen(schedule: schedule),
      ),
    );
    _loadSchedules();
  }
}
