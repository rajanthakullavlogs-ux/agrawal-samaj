import 'package:flutter/material.dart';

import '../../../core/design_tokens.dart';
import '../../../shared/widgets/widgets.dart';

/// Screen 6 — Forgot Password Screen
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendReset() {
    if (!_formKey.currentState!.validate()) return;
    NASToast.success(context, 'Reset link sent to ${_emailController.text.trim()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const NASAppBar(title: 'Forgot Password', showBackButton: true, actions: [SizedBox.shrink()]),
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
                  const SizedBox(height: 16),
                  const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      fontFamily: NASTypography.headlineFont,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Don\'t worry! It happens. Please enter your email address and we\'ll send you a link to reset your password.',
                    style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),

                  // Email Address
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email Address',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter your registered email',
                          hintStyle: TextStyle(fontSize: 12.5, color: Colors.grey.shade400),
                          prefixIcon: Icon(Icons.email_outlined, size: 18, color: Colors.grey.shade500),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Please enter email' : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

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
                        onPressed: _onSendReset,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                        ),
                        child: const Text('Send Reset Link', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Keyhole Envelope Illustration
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: AppColors.accentLight,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Icon(Icons.mark_email_read_rounded, size: 72, color: AppColors.accent),
                    ),
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
}
