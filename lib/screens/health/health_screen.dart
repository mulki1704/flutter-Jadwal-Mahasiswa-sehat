import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/health_data.dart';
import '../../services/database_service.dart';
import '../../utils/constants.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({Key? key}) : super(key: key);

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  final _sleepHoursController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _fatigueNoteController = TextEditingController();

  HealthData? _currentHealthData;
  List<HealthData> _healthHistory = [];
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadHealthData();
  }

  Future<void> _loadHealthData() async {
    try {
      final userId = DatabaseService.defaultUserId;
      final current = await DatabaseService().getLatestHealthData(userId);
      final history = await DatabaseService().getHealthDataHistory(userId);
      setState(() {
        _currentHealthData = current;
        _healthHistory = history;
        _isLoading = false;

        if (current != null) {
          _heightController.text = current.height.toString();
          _weightController.text = current.weight.toString();
          _ageController.text = current.age.toString();
          _sleepHoursController.text = current.sleepHours.toString();
          _temperatureController.text = current.bodyTemperature?.toString() ?? '';
          _fatigueNoteController.text = current.fatigueNote ?? '';
        }
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSave() async {
    if (_heightController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _sleepHoursController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua field yang wajib')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final userId = DatabaseService.defaultUserId;
      final healthData = HealthData(
        userId: userId,
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        age: int.parse(_ageController.text),
        sleepHours: int.parse(_sleepHoursController.text),
        bodyTemperature: _temperatureController.text.isEmpty 
            ? null 
            : double.parse(_temperatureController.text),
        fatigueNote: _fatigueNoteController.text.isEmpty
            ? null
            : _fatigueNoteController.text,
      );

      await DatabaseService().insertHealthData(healthData);
      _loadHealthData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data kesehatan berhasil disimpan')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _sleepHoursController.dispose();
    _temperatureController.dispose();
    _fatigueNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Kesehatan')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kesehatan'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Health Summary
              if (_currentHealthData != null) ...[
                _buildHealthSummary(),
                const SizedBox(height: AppSpacing.xl),
              ],

              // Input Form
              const Text(
                'Update Data Kesehatan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _heightController,
                      decoration: const InputDecoration(
                        labelText: 'Tinggi Badan (cm) *',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextField(
                      controller: _weightController,
                      decoration: const InputDecoration(
                        labelText: 'Berat Badan (kg) *',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelText: 'Usia (tahun) *',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextField(
                      controller: _sleepHoursController,
                      decoration: const InputDecoration(
                        labelText: 'Jam Tidur *',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Suhu Tubuh Field
              TextField(
                controller: _temperatureController,
                decoration: InputDecoration(
                  labelText: '🌡️ Suhu Tubuh (°C)',
                  hintText: 'Misal: 36.5',
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.thermostat, color: Colors.red),
                  helperText: 'Normal: 36.1°C - 37.2°C',
                  helperStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: AppSpacing.md),

              TextField(
                controller: _fatigueNoteController,
                decoration: const InputDecoration(
                  labelText: 'Catatan Kelelahan',
                  hintText: 'Bagaimana kondisi Anda?',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.xl),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Simpan Data',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Health History
              if (_healthHistory.isNotEmpty) ...[
                const Text(
                  'Riwayat Kesehatan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _healthHistory.length,
                  itemBuilder: (context, index) {
                    final data = _healthHistory[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('dd MMMM yyyy, HH:mm', 'id_ID')
                                  .format(data.createdAt),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMedium,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildHealthStat(
                                    'BMI', data.getBMI().toStringAsFixed(1)),
                                _buildHealthStat('${data.weight} kg', 'Berat'),
                                _buildHealthStat(
                                    '${data.sleepHours}h', 'Tidur'),
                              ],
                            ),
                            if (data.fatigueNote != null) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Catatan: ${data.fatigueNote}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMedium,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthSummary() {
    final data = _currentHealthData!;
    final bmi = data.getBMI();
    final bmiCategory = data.getBMICategory();
    final bmiColor = data.getBMIColor() == 'success'
        ? AppColors.success
        : data.getBMIColor() == 'warning'
            ? AppColors.warning
            : AppColors.danger;

    return Container(
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
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Status Kesehatan Saat Ini',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // BMI Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHealthMetric(
                  icon: Icons.straighten,
                  value: bmi.toStringAsFixed(1),
                  label: 'BMI',
                  color: bmiColor,
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade300),
                _buildHealthMetric(
                  icon: Icons.monitor_weight,
                  value: '${data.weight}',
                  label: 'kg',
                  color: AppColors.primary,
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade300),
                _buildHealthMetric(
                  icon: Icons.bedtime,
                  value: '${data.sleepHours}',
                  label: 'jam',
                  color: Colors.indigo,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Temperature Card (if available)
          if (data.bodyTemperature != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getTemperatureColor(data.bodyTemperature!).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(
                      Icons.thermostat,
                      color: _getTemperatureColor(data.bodyTemperature!),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${data.bodyTemperature!.toStringAsFixed(1)}°C',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _getTemperatureColor(data.bodyTemperature!),
                          ),
                        ),
                        Text(
                          data.getTemperatureStatus(),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _getTemperatureIcon(data.bodyTemperature!),
                    color: _getTemperatureColor(data.bodyTemperature!),
                    size: 32,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          
          // BMI Category Badge
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
                Icon(Icons.info_outline, size: 16, color: bmiColor),
                const SizedBox(width: 8),
                Text(
                  bmiCategory,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: bmiColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildHealthMetric({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Color _getTemperatureColor(double temp) {
    if (temp < 36.1) return Colors.blue;
    if (temp <= 37.2) return Colors.green;
    if (temp <= 38.0) return Colors.orange;
    return Colors.red;
  }

  IconData _getTemperatureIcon(double temp) {
    if (temp < 36.1) return Icons.ac_unit;
    if (temp <= 37.2) return Icons.check_circle;
    if (temp <= 38.0) return Icons.warning;
    return Icons.local_fire_department;
  }
}
