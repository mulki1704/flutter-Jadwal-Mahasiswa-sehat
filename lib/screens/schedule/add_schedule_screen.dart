import 'package:flutter/material.dart';
import '../../models/schedule.dart';
import '../../services/database_service.dart';
import '../../utils/constants.dart';

class AddScheduleScreen extends StatefulWidget {
  const AddScheduleScreen({Key? key}) : super(key: key);

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _titleController = TextEditingController();
  final _instructorController = TextEditingController();
  final _roomController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  DayOfWeek _selectedDay = DayOfWeek.monday;
  String _selectedType = 'class';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _instructorController.dispose();
    _roomController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      final formattedTime =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      controller.text = formattedTime;
    }
  }

  Future<void> _handleSave() async {
    if (_titleController.text.isEmpty ||
        _startTimeController.text.isEmpty ||
        _endTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua field yang wajib')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId = DatabaseService.defaultUserId;
      final schedule = Schedule(
        userId: userId,
        title: _titleController.text,
        instructor: _instructorController.text.isEmpty
            ? null
            : _instructorController.text,
        room: _roomController.text.isEmpty ? null : _roomController.text,
        dayOfWeek: _selectedDay,
        startTime: _startTimeController.text,
        endTime: _endTimeController.text,
        type: _selectedType,
      );

      await DatabaseService().insertSchedule(schedule);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jadwal berhasil ditambahkan')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Jadwal'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Jenis Aktivitas',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  _buildTypeChip('class', 'Kuliah', Icons.school),
                  _buildTypeChip('work', 'Kerja', Icons.work),
                  _buildTypeChip('gym', 'Gym', Icons.fitness_center),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Hari',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<DayOfWeek>(
                value: _selectedDay,
                decoration: const InputDecoration(labelText: 'Pilih hari'),
                items: DayOfWeek.values
                    .map((day) => DropdownMenuItem(
                          value: day,
                          child: Text(day.name),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedDay = value!),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Nama Aktivitas *',
                  hintText: 'Contoh: Algoritma & Struktur Data',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _instructorController,
                decoration: const InputDecoration(
                  labelText: 'Dosen/Atasan',
                  hintText: 'Opsional',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _roomController,
                decoration: const InputDecoration(
                  labelText: 'Ruangan',
                  hintText: 'Opsional',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _startTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Jam Mulai *',
                        hintText: 'HH:MM',
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      readOnly: true,
                      onTap: () => _selectTime(_startTimeController),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextField(
                      controller: _endTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Jam Selesai *',
                        hintText: 'HH:MM',
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      readOnly: true,
                      onTap: () => _selectTime(_endTimeController),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: _isLoading
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
                          'Simpan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(String value, String label, IconData icon) {
    final isSelected = _selectedType == value;
    return FilterChip(
      selected: isSelected,
      onSelected: (selected) => setState(() => _selectedType = value),
      backgroundColor: Colors.transparent,
      selectedColor: AppColors.primary.withOpacity(0.2),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.border,
        width: isSelected ? 2 : 1,
      ),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: AppSpacing.xs),
          Text(label),
        ],
      ),
    );
  }
}
