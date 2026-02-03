import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/schedule.dart';
import '../../models/task.dart';
import '../../models/health_data.dart';
import '../../services/database_service.dart';
import '../../utils/constants.dart';
import '../schedule/schedule_list_screen.dart';
import '../task/task_list_screen.dart';
import '../health/health_screen.dart';
import '../profile/profile_screen.dart';
import 'widgets/schedule_card.dart';
import 'widgets/task_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  String? _userName;
  List<Schedule> _todaySchedules = [];
  List<Task> _upcomingTasks = [];
  HealthData? _healthData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final userId = DatabaseService.defaultUserId;
      final userName = 'DailyFit User';

      setState(() => _userName = userName);

      final todayDayOfWeek = DayOfWeek.values[DateTime.now().weekday - 1];
      final schedules =
          await DatabaseService().getSchedulesByDay(userId, todayDayOfWeek);
      final tasks = await DatabaseService().getUpcomingTasks(userId, days: 7);
      final health = await DatabaseService().getLatestHealthData(userId);

      setState(() {
        _todaySchedules = schedules;
        _upcomingTasks = tasks.take(5).toList();
        _healthData = health;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DailyFit Student'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
        ],
      ),
      body: _buildContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          _navigateToPage(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Jadwal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt),
            label: 'Tugas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Kesehatan',
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting with gradient background
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, $_userName! 👋',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(DateTime.now()),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Health Summary Card
            if (_healthData != null) _buildHealthCard(),
            if (_healthData != null) const SizedBox(height: AppSpacing.lg),

            // Today Schedule Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Jadwal Hari Ini',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _navigateToSchedule(),
                  child: const Text(
                    'Lihat Semua',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _todaySchedules.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: const Center(
                      child: Text(
                        'Tidak ada jadwal untuk hari ini',
                        style: TextStyle(color: AppColors.textMedium),
                      ),
                    ),
                  )
                : Column(
                    children: _todaySchedules
                        .map((schedule) => Padding(
                              padding:
                                  const EdgeInsets.only(bottom: AppSpacing.md),
                              child: ScheduleCard(schedule: schedule),
                            ))
                        .toList(),
                  ),
            const SizedBox(height: AppSpacing.lg),

            // Upcoming Tasks Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.task_alt, color: AppColors.success, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Tugas Terdekat',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _navigateToTask(),
                  child: const Text(
                    'Lihat Semua',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _upcomingTasks.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: const Center(
                      child: Text(
                        'Tidak ada tugas yang mendatang',
                        style: TextStyle(color: AppColors.textMedium),
                      ),
                    ),
                  )
                : Column(
                    children: _upcomingTasks
                        .map((task) => Padding(
                              padding:
                                  const EdgeInsets.only(bottom: AppSpacing.md),
                              child: TaskCard(task: task),
                            ))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard() {
    final bmi = _healthData!.getBMI();
    final bmiCategory = _healthData!.getBMICategory();
    final temp = _healthData!.bodyTemperature;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade400, Colors.deepPurple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.favorite, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Status Kesehatan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.straighten, color: Colors.white, size: 28),
                      const SizedBox(height: 8),
                      Text(
                        bmi.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'BMI',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.monitor_weight, color: Colors.white, size: 28),
                      const SizedBox(height: 8),
                      Text(
                        '${_healthData!.weight.toStringAsFixed(1)} kg',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Berat',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.bedtime, color: Colors.white, size: 28),
                      const SizedBox(height: 8),
                      Text(
                        '${_healthData!.sleepHours}h',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Tidur',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (temp != null) ...[
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.thermostat, color: Colors.white, size: 28),
                        const SizedBox(height: 8),
                        Text(
                          '${temp.toStringAsFixed(1)}°C',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Suhu',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  bmiCategory,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 1:
        _navigateToSchedule();
        break;
      case 2:
        _navigateToTask();
        break;
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const HealthScreen()),
        );
        break;
    }
  }

  void _navigateToSchedule() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ScheduleListScreen()),
    );
  }

  void _navigateToTask() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const TaskListScreen()),
    );
  }
}
