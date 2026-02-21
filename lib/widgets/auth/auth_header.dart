import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../common/app_logo.dart';
import 'teal_back_button.dart';

/// Shared top section used on all auth screens:
///   • Teal back button (top-left)
///   • AquaSense logo   (centred)
///   • Title            (centred, bold)
///   • Subtitle         (centred, grey)
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onBack;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Teal back button ─────────────────────────────────────────
        Align(
          alignment: Alignment.centerLeft,
          child: TealBackButton(onTap: onBack),
        ),
        const SizedBox(height: 24),

        // ── Brand logo ───────────────────────────────────────────────
        const Center(child: AppLogo(size: 100)),
        const SizedBox(height: 22),

        // ── Title ────────────────────────────────────────────────────
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),

        // ── Subtitle ─────────────────────────────────────────────────
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textGrey,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
