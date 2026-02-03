import 'package:flutter/material.dart';
import '../../../models/schedule.dart';
import '../../../utils/constants.dart';

class ScheduleListWidget extends StatelessWidget {
  final List<Schedule> schedules;
  final Function(String) onDelete;
  final Function(Schedule) onEdit;
  final Function() onRefresh;

  const ScheduleListWidget({
    Key? key,
    required this.schedules,
    required this.onDelete,
    required this.onEdit,
    required this.onRefresh,
  }) : super(key: key);

  Map<DayOfWeek, List<Schedule>> _groupByDay() {
    final grouped = <DayOfWeek, List<Schedule>>{};
    for (final day in DayOfWeek.values) {
      grouped[day] = [];
    }
    for (final schedule in schedules) {
      grouped[schedule.dayOfWeek]!.add(schedule);
    }
    return grouped;
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'class':
        return AppColors.primary;
      case 'work':
        return const Color(0xFF8B5CF6);
      case 'gym':
        return const Color(0xFFF59E0B);
      default:
        return AppColors.primary;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'class':
        return 'Kuliah';
      case 'work':
        return 'Kerja';
      case 'gym':
        return 'Gym';
      default:
        return 'Aktivitas';
    }
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByDay();

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: DayOfWeek.values.length,
      itemBuilder: (context, index) {
        final day = DayOfWeek.values[index];
        final daySchedules = grouped[day]!;

        if (daySchedules.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ...daySchedules.map((schedule) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _buildScheduleItem(context, schedule),
                )),
            const SizedBox(height: AppSpacing.lg),
          ],
        );
      },
    );
  }

  Widget _buildScheduleItem(BuildContext context, Schedule schedule) {
    final typeColor = _getTypeColor(schedule.type);
    final typeLabel = _getTypeLabel(schedule.type);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            typeLabel,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: typeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      schedule.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Edit'),
                    onTap: () => onEdit(schedule),
                  ),
                  PopupMenuItem(
                    child: const Text('Hapus',
                        style: TextStyle(color: AppColors.danger)),
                    onTap: () => onDelete(schedule.id!),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Icon(Icons.access_time,
                  size: 16, color: AppColors.textMedium),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${schedule.startTime} - ${schedule.endTime}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMedium,
                ),
              ),
            ],
          ),
          if (schedule.room != null && schedule.room!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(Icons.location_on,
                    size: 16, color: AppColors.textMedium),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Ruang: ${schedule.room}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
          ],
          if (schedule.instructor != null &&
              schedule.instructor!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: AppColors.textMedium),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  schedule.instructor!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
