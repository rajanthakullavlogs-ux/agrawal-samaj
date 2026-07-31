import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/design_tokens.dart';
import '../../../shared/models/profile.dart';
import '../../../shared/widgets/widgets.dart';
import 'providers/auth_provider.dart';

/// Screen 5 — Create Account Sign Up Screen
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSignUp() async {
    if (!_formKey.currentState!.validate() || !_agreeTerms) {
      if (!_agreeTerms) {
        NASToast.error(context, 'Please agree to Terms & Conditions');
      }
      return;
    }
    final newProfile = Profile(
      id: 'usr-new-${DateTime.now().millisecondsSinceEpoch}',
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      role: 'member',
      membershipType: 'normal',
      membershipStatus: 'pending',
      createdAt: DateTime.now(),
    );
    await ref.read(currentProfileProvider.notifier).login(newProfile);
    if (mounted) {
      NASToast.success(context, 'Account created successfully!');
      context.go(AppConstants.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const NASAppBar(title: 'Create Account', showBackButton: true, actions: [SizedBox.shrink()]),
      body: Stack(
        children: [
          // Mountain silhouette backdrop at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 120,
            child: Opacity(
              opacity: 0.12,
              child: Icon(Icons.landscape_rounded, size: 280, color: AppColors.primary),
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      fontFamily: NASTypography.headlineFont,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Join Nepal Agrawal Samaj family',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Full Name
                  _inputField('Full Name', _nameController, 'Enter your full name', Icons.person_outline_rounded),
                  const SizedBox(height: 14),

                  // Email Address
                  _inputField('Email Address', _emailController, 'Enter your email', Icons.email_outlined),
                  const SizedBox(height: 14),

                  // Phone Number
                  _inputField('Phone Number', _phoneController, 'Enter your phone number', Icons.call_outlined),
                  const SizedBox(height: 14),

                  // Password
                  _inputField(
                    'Password',
                    _passwordController,
                    'Create a password',
                    Icons.lock_outline_rounded,
                    obscure: _obscurePassword,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 18,
                        color: Colors.grey.shade500,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Confirm Password
                  _inputField(
                    'Confirm Password',
                    _confirmPasswordController,
                    'Confirm your password',
                    Icons.lock_outline_rounded,
                    obscure: _obscureConfirmPassword,
                    suffix: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 18,
                        color: Colors.grey.shade500,
                      ),
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Checkbox Terms
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _agreeTerms,
                          onChanged: (v) => setState(() => _agreeTerms = v ?? false),
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: 'I agree to the ',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                            children: const [
                              TextSpan(text: 'Terms & Conditions', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
                              TextSpan(text: ' and '),
                              TextSpan(text: 'Privacy Policy', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Full-Width Orange Gradient Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: ElevatedButton(
                        onPressed: _onSignUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                        ),
                        child: const Text('Sign Up', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Footer Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account? ', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: const Text('Login', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary)),
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

  Widget _inputField(
    String label,
    TextEditingController controller,
    String hint,
    IconData prefix, {
    bool obscure = false,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
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
          ),
        ),
      ],
    );
  }
}
