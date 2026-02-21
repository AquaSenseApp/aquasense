import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/sensor_provider.dart';
import '../../widgets/home/ai_assistant_banner.dart';
import '../../widgets/home/search_bar_widget.dart';
import '../../widgets/sensors/sensor_card.dart';

/// Home tab — welcome greeting, AI banner, search, recent sensors.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<SensorProvider>(
          builder: (context, provider, _) {
            return RefreshIndicator(
              color: AppColors.teal,
              onRefresh: provider.loadSensors,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Welcome row ─────────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Text(
                                'Welcome Meggie 👋',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                              // Notification bell with red badge
                              Stack(
                                children: [
                                  const Icon(Icons.notifications_outlined,
                                      size: 26, color: AppColors.textDark),
                                  Positioned(
                                    top: 0, right: 0,
                                    child: Container(
                                      width: 9, height: 9,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // ── Search bar ───────────────────────────────
                          SearchBarWidget(
                            onChanged: provider.setSearchQuery,
                          ),
                          const SizedBox(height: 16),

                          // ── AI banner ─────────────────────────────────
                           AiAssistantBanner(),
                          const SizedBox(height: 24),

                          // ── Recent Sensors header ─────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Recent Sensors',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Switch to Sensors tab (index 1)
                                  // Handled via MainShell IndexedStack
                                },
                                child: const Text(
                                  'See all',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.teal,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),

                  // ── Sensor list ─────────────────────────────────────
                  if (provider.isLoading)
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.teal),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            final sensors = provider.recentSensors(count: 3);
                            if (i >= sensors.length) return null;
                            return SensorCard(sensor: sensors[i]);
                          },
                          childCount: provider.recentSensors(count: 3).length,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}