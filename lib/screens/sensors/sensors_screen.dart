import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/sensor_provider.dart';
import '../../widgets/home/search_bar_widget.dart';
import '../../widgets/sensors/add_sensor_sheet.dart';
import '../../widgets/sensors/sensor_card.dart';
import '../../widgets/common/app_button.dart';

/// Sensors tab — full list with search, filter, add button, and empty state.
class SensorsScreen extends StatelessWidget {
  const SensorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<SensorProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                // ── Header ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    children: [
                      const Text(
                        'Sensors',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Search bar + add button row
                      Row(
                        children: [
                          Expanded(
                            child: SearchBarWidget(
                              onChanged: provider.setSearchQuery,
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Teal + button — only shown when list is non-empty
                          if (provider.sensors.isNotEmpty)
                            GestureDetector(
                              onTap: () => showAddSensorSheet(context),
                              child: Container(
                                width: 44, height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.teal,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: AppColors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ── Body — loading / empty / list ────────────────────────
                Expanded(
                  child: provider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: AppColors.teal))
                      : provider.sensors.isEmpty
                          ? _EmptyState(
                              onAddSensor: () => showAddSensorSheet(context))
                          : RefreshIndicator(
                              color: AppColors.teal,
                              onRefresh: provider.loadSensors,
                              child: ListView.builder(
                                padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                                itemCount: provider.filteredSensors.length,
                                itemBuilder: (context, i) {
                                  return SensorCard(
                                    sensor: provider.filteredSensors[i]);
                                },
                              ),
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Empty state shown when no sensors have been added yet.
class _EmptyState extends StatelessWidget {
  final VoidCallback onAddSensor;
  const _EmptyState({required this.onAddSensor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No Sensor Yet.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Add your first sensor',
            style: TextStyle(fontSize: 14, color: AppColors.textGrey),
          ),
          const SizedBox(height: 28),
          AppButton(
            label: 'Add New Sensor',
            onPressed: onAddSensor,
          ),
        ],
      ),
    );
  }
}
