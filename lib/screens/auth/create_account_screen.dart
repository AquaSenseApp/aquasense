import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/auth/auth_footer_link.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/field_label.dart';
import '../../widgets/auth/google_sign_in_button.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

/// Create Account screen.
///
/// Layout (top → bottom):
///   • [AuthHeader]           — back button, logo, title, subtitle
///   • Email / Password fields with [FieldLabel]s
///   • [_TermsCheckbox]       — "I agree to terms of service and privacy policy"
///   • "Create Account" primary button
///   • [GoogleSignInButton]   — "Sign up with Google"
///   • [AuthFooterLink]       — "Already have an account? Sign in"
class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreedToTerms = false;

  /// Primary CTA enabled only when fields filled + terms accepted.
  bool get _canSubmit =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _agreedToTerms;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _submit(AuthProvider auth) async {
    if (!_canSubmit) return;
    final success = await auth.createAccount(
      email:    _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (success && mounted) {
      Navigator.of(context).pushNamed(AppRoutes.emailVerification);
    }
  }

  /// Placeholder — wire up google_sign_in package when ready.
  void _signUpWithGoogle() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google sign-up coming soon')),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),

                  // ── Logo + title block ───────────────────────────────
                  AuthHeader(
                    title: 'Create Account',
                    subtitle: 'Sign up to get started on the platform',
                    onBack: () {
                           if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          } else {
                            // If someone arrived here directly (e.g., deep link),
                            // send them to onboarding instead of a black screen.
                            Navigator.of(
                              context,
                            ).pushReplacementNamed(AppRoutes.onboarding);
                          }
                        },
                  ),
                  const SizedBox(height: 28),

                  // ── Email ────────────────────────────────────────────
                  const FieldLabel('Email'),
                  const SizedBox(height: 8),
                  AppTextField(
                    hint: 'Enter your email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 18),

                  // ── Password ─────────────────────────────────────────
                  const FieldLabel('Password'),
                  const SizedBox(height: 8),
                  AppTextField(
                    hint: '••••••••',
                    controller: _passwordController,
                    isPassword: true,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),

                  // ── Terms checkbox ───────────────────────────────────
                  _TermsCheckbox(
                    value: _agreedToTerms,
                    onChanged: (val) => setState(() => _agreedToTerms = val),
                  ),
                  const SizedBox(height: 24),

                  // ── Primary CTA ──────────────────────────────────────
                  AppButton(
                    label: 'Create Account',
                    enabled: _canSubmit,
                    isLoading: auth.status == AuthStatus.loading,
                    onPressed: () => _submit(auth),
                  ),
                  const SizedBox(height: 14),

                  // ── Google sign-up ───────────────────────────────────
                  GoogleSignInButton(
                    label: 'Sign up with Google',
                    onTap: _signUpWithGoogle,
                  ),
                  const SizedBox(height: 24),

                  // ── Sign-in link ─────────────────────────────────────
                  AuthFooterLink(
                    prefixText: 'Already have an account?  ',
                    linkText: 'Sign in',
                   onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.signIn,
                      ModalRoute.withName(
                        AppRoutes.onboarding,
                      ), // Keep onboarding, remove signup
                    ),   
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

/// "I agree to the terms of service and privacy policy" checkbox row.
/// Only used on Create Account so kept private to this file.
class _TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _TermsCheckbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Custom teal checkbox
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: value
                  ? AppColors.teal.withValues(alpha: 0.12)
                  : AppColors.white,
              border: Border.all(
                color: value ? AppColors.teal : AppColors.borderColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: value
                ? const Icon(Icons.check, size: 12, color: AppColors.teal)
                : null,
          ),
          const SizedBox(width: 10),

          // "I agree to the terms of service and privacy policy"
          Text.rich(
            TextSpan(
              text: 'I agree to the ',
              style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
              children: [
                TextSpan(
                  text: 'terms of service',
                  style: const TextStyle(
                    color: AppColors.teal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'privacy policy',
                  style: const TextStyle(
                    color: AppColors.teal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
