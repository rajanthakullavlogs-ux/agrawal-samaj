import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/design_tokens.dart';
import '../../../shared/models/profile.dart';
import '../../../shared/widgets/widgets.dart';
import 'providers/auth_provider.dart';

/// Login Screen — with 3 demo account cards and real Supabase fallback.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginAsDemo(Profile profile) async {
    setState(() => _isLoading = true);
    await ref.read(currentProfileProvider.notifier).login(profile);
    setState(() => _isLoading = false);

    if (!mounted) return;
    NASToast.success(context, 'Signed in as ${profile.fullName}');

    if (profile.isSuperAdmin) {
      context.go(AppConstants.superAdminDashboard);
    } else if (profile.isLocationAdmin) {
      context.go(AppConstants.adminDashboard);
    } else {
      context.go(AppConstants.home);
    }
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final email = _emailController.text.trim();

    // Try Supabase first, fall back to demo profiles
    try {
      final repo = ref.read(authRepositoryProvider);
      final response = await repo.signInWithEmail(
        email: email,
        password: _passwordController.text,
      );
      if (response.user != null) {
        // Supabase login succeeded — profile notifier will fetch from DB
        await ref.read(currentProfileProvider.notifier).login(
              demoProfileForEmail(email) ?? demoMemberProfile,
            );
      }
    } catch (_) {
      // Supabase not available — use demo profile based on email
      final profile = demoProfileForEmail(email) ?? demoMemberProfile;
      await ref.read(currentProfileProvider.notifier).login(profile);
    }

    setState(() => _isLoading = false);
    if (!mounted) return;

    final profile = ref.read(currentProfileProvider).valueOrNull;
    if (profile == null) return;

    NASToast.success(context, 'Signed in as ${profile.fullName}');

    if (profile.isSuperAdmin) {
      context.go(AppConstants.superAdminDashboard);
    } else if (profile.isLocationAdmin) {
      context.go(AppConstants.adminDashboard);
    } else {
      context.go(AppConstants.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const NASAppBar(
        title: 'Login',
        showBackButton: true,
        actions: [SizedBox.shrink()],
      ),
      body: Stack(
        children: [
          // Mountain silhouette backdrop
          Positioned(
            left: 0, right: 0, bottom: 0, height: 120,
            child: Opacity(
              opacity: 0.08,
              child: Icon(Icons.landscape_rounded, size: 280, color: AppColors.primary),
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      fontFamily: NASTypography.headlineFont,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Login to continue your journey',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // ── Quick Demo Login Cards ──────────────────
                  Text('Quick Login',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey.shade500)),
                  const SizedBox(height: 8),
                  _DemoAccountCard(
                    name: 'Rajan Thakulla',
                    role: 'Member',
                    email: 'rajan@agrawalsamaj.org',
                    avatarUrl: demoMemberProfile.avatarUrl!,
                    color: const Color(0xFF2E7D32),
                    onTap: () => _loginAsDemo(demoMemberProfile),
                  ),
                  const SizedBox(height: 8),
                  _DemoAccountCard(
                    name: 'Suresh Agrawal',
                    role: 'Branch Admin',
                    email: 'suresh.admin@agrawalsamaj.org',
                    avatarUrl: demoLocationAdminProfile.avatarUrl!,
                    color: const Color(0xFFE65100),
                    onTap: () => _loginAsDemo(demoLocationAdminProfile),
                  ),
                  const SizedBox(height: 8),
                  _DemoAccountCard(
                    name: 'Ramesh Kumar Agrawal',
                    role: 'Super Admin',
                    email: 'ramesh.ceo@agrawalsamaj.org',
                    avatarUrl: demoSuperAdminProfile.avatarUrl!,
                    color: AppColors.primary,
                    onTap: () => _loginAsDemo(demoSuperAdminProfile),
                  ),
                  const SizedBox(height: 20),

                  // ── Divider ─────────────────────────────────
                  Row(children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('or login with email',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ]),
                  const SizedBox(height: 16),

                  // ── Email Field ─────────────────────────────
                  _FieldLabel('Email / Phone Number'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecor('Enter your email or phone', Icons.email_outlined),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),

                  // ── Password Field ──────────────────────────
                  _FieldLabel('Password'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: _inputDecor(
                      'Enter your password',
                      Icons.lock_outline_rounded,
                      suffix: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: 18, color: Colors.grey.shade500,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 10),

                  // Remember me & Forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        SizedBox(
                          width: 22, height: 22,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (v) => setState(() => _rememberMe = v ?? false),
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text('Remember me', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                      ]),
                      GestureDetector(
                        onTap: () => context.push(AppConstants.forgotPassword),
                        child: const Text('Forgot Password?',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Login Button ────────────────────────────
                  SizedBox(
                    height: 48,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _onLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                        ),
                        child: _isLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      GestureDetector(
                        onTap: () => context.push(AppConstants.signup),
                        child: const Text('Sign Up',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecor(String hint, IconData prefix, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 12.5, color: Colors.grey.shade400),
      prefixIcon: Icon(prefix, size: 18, color: Colors.grey.shade500),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.textPrimary));
  }
}

/// A compact demo-account login card.
class _DemoAccountCard extends StatelessWidget {
  final String name;
  final String role;
  final String email;
  final String avatarUrl;
  final Color color;
  final VoidCallback onTap;

  const _DemoAccountCard({
    required this.name,
    required this.role,
    required this.email,
    required this.avatarUrl,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadow.card,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 1),
                  Text(email, style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(role, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: color)),
            ),
          ],
        ),
      ),
    );
  }
}
