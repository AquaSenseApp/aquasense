import 'package:flutter/material.dart';
import '../../models/sensor_model.dart';

/// Coloured pill badge displaying the sensor's [RiskLevel].
///
/// Colours:
///   - high   → pink/red background, dark red text
///   - medium → amber background, amber text
///   - low    → green background, green text
class RiskBadge extends StatelessWidget {
  final RiskLevel level;

  const RiskBadge({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final colors = _colorsFor(level);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        level.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colors.text,
        ),
      ),
    );
  }

  _BadgeColors _colorsFor(RiskLevel level) {
    switch (level) {
      case RiskLevel.high:
        return _BadgeColors(
          background: const Color(0xFFFFE4E6),
          text:       const Color(0xFFBE123C),
        );
      case RiskLevel.medium:
        return _BadgeColors(
          background: const Color(0xFFFEF9C3),
          text:       const Color(0xFFB45309),
        );
      case RiskLevel.low:
        return _BadgeColors(
          background: const Color(0xFFDCFCE7),
          text:       const Color(0xFF15803D),
        );
    }
  }
}

class _BadgeColors {
  final Color background;
  final Color text;
  const _BadgeColors({required this.background, required this.text});
}