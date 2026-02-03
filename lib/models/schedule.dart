enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  String get name {
    return [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ][index];
  }
}

class Schedule {
  final String? id;
  final String userId;
  final String title;
  final String? instructor;
  final String? room;
  final DayOfWeek dayOfWeek;
  final String startTime;
  final String endTime;
  final String type; // 'class', 'work', 'gym'
  final DateTime createdAt;

  Schedule({
    this.id,
    required this.userId,
    required this.title,
    this.instructor,
    this.room,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.type,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'instructor': instructor,
      'room': room,
      'dayOfWeek': dayOfWeek.index,
      'startTime': startTime,
      'endTime': endTime,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      instructor: map['instructor'],
      room: map['room'],
      dayOfWeek: DayOfWeek.values[map['dayOfWeek']],
      startTime: map['startTime'],
      endTime: map['endTime'],
      type: map['type'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Schedule copyWith({
    String? id,
    String? userId,
    String? title,
    String? instructor,
    String? room,
    DayOfWeek? dayOfWeek,
    String? startTime,
    String? endTime,
    String? type,
    DateTime? createdAt,
  }) {
    return Schedule(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      instructor: instructor ?? this.instructor,
      room: room ?? this.room,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
