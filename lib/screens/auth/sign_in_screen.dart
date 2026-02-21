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

/// Sign In screen.
///
/// Layout (top → bottom):
///   • [AuthHeader]          — back button, logo, title, subtitle
///   • Email / Password fields with labels
///   • Remember me + Forgot Password row
///   • "Login" primary button
///   • [GoogleSignInButton]  — "Sign in with Google"
///   • [AuthFooterLink]      — "Don't have an account? Create One"
///   • Inline error message (if auth fails)
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  /// Login button is enabled only when both fields have text.
  bool get _canSubmit =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _submit(AuthProvider auth) async {
    if (!_canSubmit) return;
    final success = await auth.signIn(
      email:    _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.emailVerified);
    }
  }

  /// Navigates to the Forgot Password screen.
  void _goToForgotPassword() {
    Navigator.of(context).pushNamed(AppRoutes.forgotPassword);
  }

  /// Placeholder — wire up google_sign_in package when ready.
  void _signInWithGoogle() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google sign-in coming soon')),
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
                    title: 'Welcome back',
                    subtitle: 'Log in to get started on the platform',
                    onBack: () => Navigator.of(context).pop(),
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
                  const SizedBox(height: 14),

                  // ── Remember me + Forgot Password ────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _RememberMeCheckbox(
                        value: _rememberMe,
                        onChanged: (v) => setState(() => _rememberMe = v),
                      ),
                      GestureDetector(
                        onTap: _goToForgotPassword,
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.teal,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Login CTA ────────────────────────────────────────
                  AppButton(
                    label: 'Login',
                    enabled: _canSubmit,
                    isLoading: auth.status == AuthStatus.loading,
                    onPressed: () => _submit(auth),
                  ),
                  const SizedBox(height: 14),

                  // ── Google sign-in ───────────────────────────────────
                  GoogleSignInButton(
                    label: 'Sign in with Google',
                    onTap: _signInWithGoogle,
                  ),
                  const SizedBox(height: 24),

                  // ── Create account link ──────────────────────────────
                  AuthFooterLink(
                    prefixText: "Don't have an account?  ",
                    linkText: 'Create One',
                    onTap: () => Navigator.of(context)
                        .pushReplacementNamed(AppRoutes.createAccount),
                  ),

                  // ── Inline error ─────────────────────────────────────
                  if (auth.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      auth.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ],
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

/// "Remember me" checkbox row — local to SignInScreen only.
class _RememberMeCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _RememberMeCheckbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
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
          const SizedBox(width: 8),
          const Text(
            'Remember me',
            style: TextStyle(fontSize: 13, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}
