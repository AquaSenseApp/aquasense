import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/sensor_provider.dart';
import '../../widgets/sensors/add_sensor_sheet.dart';
import 'home_screen.dart';
import '../sensors/sensors_screen.dart';

/// Root shell that owns the bottom navigation bar and FAB.
/// Wraps [HomeScreen] and [SensorsScreen] — add Alerts/Settings here.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _pages = [
    HomeScreen(),
    SensorsScreen(),
    _PlaceholderScreen(label: 'Alerts',   icon: Icons.notifications_outlined),
    _PlaceholderScreen(label: 'Settings', icon: Icons.settings_outlined),
  ];

  @override
  void initState() {
    super.initState();
    // Load sensors once when the shell mounts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SensorProvider>().loadSensors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // Floating AI assistant button (centre FAB)
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddSensorSheet(context),
        backgroundColor: AppColors.aiFab, // purple matching design
        shape: const CircleBorder(),
        child: const Icon(Icons.auto_awesome, color: AppColors.white, size: 22),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: AppColors.white,
        elevation: 8,
        child: Row(
          children: [
            _NavItem(icon: Icons.home_outlined,           label: 'Home',     index: 0, current: _currentIndex, onTap: _setIndex),
            _NavItem(icon: Icons.sensors,                 label: 'Sensor',   index: 1, current: _currentIndex, onTap: _setIndex),
            const SizedBox(width: 60), // FAB notch spacer
            _NavItem(icon: Icons.notifications_outlined,  label: 'Alerts',   index: 2, current: _currentIndex, onTap: _setIndex),
            _NavItem(icon: Icons.settings_outlined,       label: 'Settings', index: 3, current: _currentIndex, onTap: _setIndex),
          ],
        ),
      ),
    );
  }

  void _setIndex(int i) => setState(() => _currentIndex = i);
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon, required this.label, required this.index,
    required this.current, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22,
                color: isActive ? AppColors.teal : AppColors.textGrey),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppColors.teal : AppColors.textGrey,
                )),
          ],
        ),
      ),
    );
  }
}

/// Generic placeholder for tabs not yet implemented.
class _PlaceholderScreen extends StatelessWidget {
  final String label;
  final IconData icon;
  const _PlaceholderScreen({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 52, color: AppColors.teal),
            const SizedBox(height: 12),
            Text(label,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 8),
            const Text('Coming soon', style: TextStyle(color: AppColors.textGrey)),
          ],
        ),
      ),
    );
  }
}
