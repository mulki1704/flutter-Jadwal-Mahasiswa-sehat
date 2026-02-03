import 'package:flutter/material.dart';
import '../../../models/schedule.dart';
import '../../../utils/constants.dart';

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;

  const ScheduleCard({
    Key? key,
    required this.schedule,
  }) : super(key: key);

  Color _getTypeColor() {
    switch (schedule.type) {
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

  String _getTypeLabel() {
    switch (schedule.type) {
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

  IconData _getTypeIcon() {
    switch (schedule.type) {
      case 'class':
        return Icons.school;
      case 'work':
        return Icons.work;
      case 'gym':
        return Icons.fitness_center;
      default:
        return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor();
    final typeLabel = _getTypeLabel();
    final typeIcon = _getTypeIcon();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
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
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(typeIcon, color: typeColor, size: 30),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${schedule.startTime} - ${schedule.endTime}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMedium,
                  ),
                ),
                if (schedule.room != null && schedule.room!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: Text(
                      'Ruang: ${schedule.room}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMedium,
                      ),
                    ),
                  ),
              ],
            ),
          ),
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
    );
  }
}
