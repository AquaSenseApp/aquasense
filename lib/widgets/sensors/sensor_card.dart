import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/sensor_model.dart';
import 'risk_badge.dart';
import 'trend_icon.dart';

/// Card representing a single sensor in the list.
///
/// Shows: sensor ID, risk badge, edit icon, reading value + trend,
/// location, last update time, and AI insight snippet.
class SensorCard extends StatelessWidget {
  final SensorModel sensor;
  final VoidCallback? onEdit;

  const SensorCard({super.key, required this.sensor, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Row 1: ID  +  badge  +  edit icon ───────────────────────
          Row(
            children: [
              Text(
                sensor.id,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textGrey,
                ),
              ),
              const Spacer(),
              RiskBadge(level: sensor.riskLevel),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onEdit,
                child: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // ── Row 2: Reading value + trend arrow ───────────────────────
          Row(
            children: [
              Text(
                sensor.latestReading.displayValue,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(width: 6),
              TrendIcon(trend: sensor.latestReading.trend),
            ],
          ),
          const SizedBox(height: 4),

          // ── Location ─────────────────────────────────────────────────
          Text(
            sensor.location,
            style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
          ),
          const SizedBox(height: 2),

          // ── Last update timestamp ─────────────────────────────────────
          Text(
            _formatTimestamp(sensor.latestReading.timestamp),
            style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
          ),
          const SizedBox(height: 8),

          // ── AI insight snippet ────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 14,
                color: AppColors.teal,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  sensor.aiInsight,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Returns a human-friendly relative time string.
  String _formatTimestamp(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 60)  return 'Update just now';
    if (diff.inMinutes < 60)  return 'Update ${diff.inMinutes} min ago';
    if (diff.inHours < 24)    return 'Update ${diff.inHours}h ago';
    return 'Update ${diff.inDays}d ago';
  }
}