import 'package:flutter/material.dart';
import '../../models/sensor_model.dart';

/// Small directional arrow icon indicating reading trend.
///
/// Up   → green arrow (rising value)
/// Down → red/maroon arrow (falling value)
/// Stable → grey dash
class TrendIcon extends StatelessWidget {
  final TrendDirection trend;
  final double size;

  const TrendIcon({super.key, required this.trend, this.size = 16});

  @override
  Widget build(BuildContext context) {
    switch (trend) {
      case TrendDirection.up:
        return Icon(Icons.trending_up, size: size, color: const Color(0xFF15803D));
      case TrendDirection.down:
        return Icon(Icons.trending_down, size: size, color: const Color(0xFFBE123C));
      case TrendDirection.stable:
        return Icon(Icons.trending_flat, size: size, color: const Color(0xFF6B7280));
    }
  }
}


