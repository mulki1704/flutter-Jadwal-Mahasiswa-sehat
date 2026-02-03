import '../models/schedule.dart';
import '../models/task.dart';
import '../models/health_data.dart';

class DatabaseService {
  // Static user ID (fixed since no authentication)
  static const String defaultUserId = 'user-001';

  // In-memory storage
  static final List<Schedule> _schedules = [];
  static final List<Task> _tasks = [];
  static final List<HealthData> _healthData = [];

  static int _scheduleIdCounter = 1;
  static int _taskIdCounter = 1;
  static int _healthIdCounter = 1;

  // ==================== SCHEDULE OPERATIONS ====================

  Future<String> insertSchedule(Schedule schedule) async {
    await Future.delayed(
        const Duration(milliseconds: 100)); // Simulate database delay

    final newSchedule = Schedule(
      id: _scheduleIdCounter.toString(),
      userId: defaultUserId,
      title: schedule.title,
      instructor: schedule.instructor,
      room: schedule.room,
      dayOfWeek: schedule.dayOfWeek,
      startTime: schedule.startTime,
      endTime: schedule.endTime,
      type: schedule.type,
    );

    _schedules.add(newSchedule);
    _scheduleIdCounter++;

    return newSchedule.id!;
  }

  Future<int> updateSchedule(Schedule schedule) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final index = _schedules.indexWhere((s) => s.id == schedule.id);
    if (index != -1) {
      _schedules[index] = schedule;
      return 1;
    }
    return 0;
  }

  Future<int> deleteSchedule(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final initialLength = _schedules.length;
    _schedules.removeWhere((s) => s.id == id);
    return initialLength != _schedules.length ? 1 : 0;
  }

  Future<List<Schedule>> getSchedulesByDay(String userId, DayOfWeek day) async {
    await Future.delayed(const Duration(milliseconds: 100));

    return _schedules
        .where((s) => s.userId == userId && s.dayOfWeek == day)
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  Future<List<Schedule>> getAllSchedules(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));

    return _schedules.where((s) => s.userId == userId).toList();
  }

  // ==================== TASK OPERATIONS ====================

  Future<String> insertTask(Task task) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final newTask = Task(
      id: _taskIdCounter.toString(),
      userId: defaultUserId,
      title: task.title,
      description: task.description,
      subject: task.subject,
      dueDate: task.dueDate,
      isCompleted: task.isCompleted,
    );

    _tasks.add(newTask);
    _taskIdCounter++;

    return newTask.id!;
  }

  Future<int> updateTask(Task task) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      return 1;
    }
    return 0;
  }

  Future<int> deleteTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final initialLength = _tasks.length;
    _tasks.removeWhere((t) => t.id == id);
    return initialLength != _tasks.length ? 1 : 0;
  }

  Future<List<Task>> getTasksByUserId(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));

    return _tasks.where((t) => t.userId == userId).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  Future<List<Task>> getUpcomingTasks(String userId, {int days = 7}) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final now = DateTime.now();
    final future = now.add(Duration(days: days));

    return _tasks
        .where((t) =>
            t.userId == userId &&
            !t.isCompleted &&
            t.dueDate.isAfter(now) &&
            t.dueDate.isBefore(future))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate))
      ..take(5);
  }

  // ==================== HEALTH DATA OPERATIONS ====================

  Future<String> insertHealthData(HealthData healthData) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final newHealthData = HealthData(
      id: _healthIdCounter.toString(),
      userId: defaultUserId,
      weight: healthData.weight,
      height: healthData.height,
      age: healthData.age,
      sleepHours: healthData.sleepHours,
      fatigueNote: healthData.fatigueNote,
      createdAt: healthData.createdAt,
    );

    _healthData.add(newHealthData);
    _healthIdCounter++;

    return newHealthData.id!;
  }

  Future<HealthData?> getLatestHealthData(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final userHealthData = _healthData.where((h) => h.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return userHealthData.isNotEmpty ? userHealthData.first : null;
  }

  Future<List<HealthData>> getHealthDataHistory(String userId,
      {int days = 30}) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final startDate = DateTime.now().subtract(Duration(days: days));

    return _healthData
        .where((h) => h.userId == userId && h.createdAt.isAfter(startDate))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // ==================== UTILITY METHODS ====================

  // Clear all data (useful for testing)
  Future<void> clearAllData() async {
    _schedules.clear();
    _tasks.clear();
    _healthData.clear();
    _scheduleIdCounter = 1;
    _taskIdCounter = 1;
    _healthIdCounter = 1;
  }

  // Add sample data for development
  Future<void> addSampleData() async {
    // Sample Schedules
    await insertSchedule(Schedule(
      userId: defaultUserId,
      title: 'Algoritma & Pemrograman',
      instructor: 'Dr. Ahmad',
      room: 'Lab Komputer 1',
      dayOfWeek: DayOfWeek.monday,
      startTime: '08:00',
      endTime: '10:00',
      type: 'class',
    ));

    await insertSchedule(Schedule(
      userId: defaultUserId,
      title: 'Basis Data',
      instructor: 'Prof. Sarah',
      room: 'Ruang 301',
      dayOfWeek: DayOfWeek.tuesday,
      startTime: '10:00',
      endTime: '12:00',
      type: 'class',
    ));

    await insertSchedule(Schedule(
      userId: defaultUserId,
      title: 'Gym Session',
      room: 'Fitness Center',
      dayOfWeek: DayOfWeek.wednesday,
      startTime: '16:00',
      endTime: '18:00',
      type: 'gym',
    ));

    // Sample Tasks
    await insertTask(Task(
      userId: defaultUserId,
      title: 'Tugas Algoritma',
      description: 'Implementasi Binary Search',
      subject: 'Algoritma',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      isCompleted: false,
    ));

    await insertTask(Task(
      userId: defaultUserId,
      title: 'Laporan Basis Data',
      description: 'Normalisasi Database',
      subject: 'Basis Data',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      isCompleted: false,
    ));

    await insertTask(Task(
      userId: defaultUserId,
      title: 'Presentasi Pemrograman Web',
      description: 'Buat slide tentang Flutter',
      subject: 'Pemrograman Web',
      dueDate: DateTime.now().add(const Duration(days: 7)),
      isCompleted: false,
    ));

    // Sample Health Data
    await insertHealthData(HealthData(
      userId: defaultUserId,
      weight: 65.0,
      height: 170.0,
      age: 20,
      sleepHours: 7,
      bodyTemperature: 36.5,
      fatigueNote: 'Merasa segar dan sehat',
      createdAt: DateTime.now(),
    ));
  }
}
