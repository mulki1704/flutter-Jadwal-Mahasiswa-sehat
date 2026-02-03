class HealthData {
  final String? id;
  final String userId;
  final double height; // cm
  final double weight; // kg
  final int age;
  final int sleepHours;
  final double? bodyTemperature; // celsius
  final String? fatigueNote;
  final DateTime createdAt;

  HealthData({
    this.id,
    required this.userId,
    required this.height,
    required this.weight,
    required this.age,
    required this.sleepHours,
    this.bodyTemperature,
    this.fatigueNote,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Hitung BMI: weight (kg) / (height (m) ^ 2)
  double getBMI() {
    double heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  // Kategori BMI
  String getBMICategory() {
    double bmi = getBMI();
    if (bmi < 18.5) return 'Kurang Berat Badan';
    if (bmi < 25.0) return 'Berat Badan Normal';
    if (bmi < 30.0) return 'Kelebihan Berat Badan';
    return 'Obesitas';
  }

  // Warna BMI
  String getBMIColor() {
    double bmi = getBMI();
    if (bmi < 18.5) return 'warning';
    if (bmi < 25.0) return 'success';
    if (bmi < 30.0) return 'warning';
    return 'danger';
  }

  // Kategori Suhu Tubuh
  String getTemperatureStatus() {
    if (bodyTemperature == null) return 'Tidak ada data';
    if (bodyTemperature! < 36.1) return 'Rendah';
    if (bodyTemperature! <= 37.2) return 'Normal';
    if (bodyTemperature! <= 38.0) return 'Subfebris';
    return 'Demam';
  }

  // Warna Suhu
  String getTemperatureColor() {
    if (bodyTemperature == null) return 'grey';
    if (bodyTemperature! < 36.1) return 'info';
    if (bodyTemperature! <= 37.2) return 'success';
    if (bodyTemperature! <= 38.0) return 'warning';
    return 'danger';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'height': height,
      'weight': weight,
      'age': age,
      'sleepHours': sleepHours,
      'bodyTemperature': bodyTemperature,
      'fatigueNote': fatigueNote,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory HealthData.fromMap(Map<String, dynamic> map) {
    return HealthData(
      id: map['id'],
      userId: map['userId'],
      height: map['height'],
      weight: map['weight'],
      age: map['age'],
      sleepHours: map['sleepHours'],
      bodyTemperature: map['bodyTemperature'],
      fatigueNote: map['fatigueNote'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  HealthData copyWith({
    String? id,
    String? userId,
    double? height,
    double? weight,
    int? age,
    int? sleepHours,
    double? bodyTemperature,
    String? fatigueNote,
    DateTime? createdAt,
  }) {
    return HealthData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      sleepHours: sleepHours ?? this.sleepHours,
      bodyTemperature: bodyTemperature ?? this.bodyTemperature,
      fatigueNote: fatigueNote ?? this.fatigueNote,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
