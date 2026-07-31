import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/design_tokens.dart';
import '../../../shared/widgets/widgets.dart';

/// A9 — Membership Selector Screen (Public Site)
class MembershipSelectorScreen extends StatelessWidget {
  const MembershipSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NASAppBar(title: 'Membership Options', showBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    'Choose Your Membership',
                    style: AppText.h1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Join our thriving community and preserve the heritage of Agrawals in Nepal. Select the path that best suits your identity or enterprise.',
                    style: AppText.body,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Individual Card
                  _MembershipTypeCard(
                    icon: Icons.person_rounded,
                    title: 'Individual Membership',
                    subtitle: 'PERSONAL & FAMILY',
                    iconColor: AppColors.primary,
                    buttonColor: AppColors.primary,
                    features: const [
                      'Full access to community directory and member portal.',
                      'Exclusive invitations to cultural and networking events.',
                      'Eligibility for internal leadership and community roles.',
                      'Digital membership ID and certificate.',
                    ],
                    buttonText: 'Register as Individual',
                    onTap: () => context.go(AppConstants.normalRegistration),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Business Card
                  _MembershipTypeCard(
                    icon: Icons.storefront_rounded,
                    title: 'Business Membership',
                    subtitle: 'CORPORATE & ENTERPRISE',
                    iconColor: AppColors.accent,
                    buttonColor: AppColors.accent,
                    features: const [
                      'Premium listing in the Business Directory with logo.',
                      'Direct marketing opportunities to community members.',
                      'B2B networking sessions and trade opportunities.',
                      'Priority sponsorship for major community festivals.',
                    ],
                    buttonText: 'Register as Business',
                    onTap: () => context.go(AppConstants.businessRegistration),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _MembershipTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color buttonColor;
  final List<String> features;
  final String buttonText;
  final VoidCallback onTap;

  const _MembershipTypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.buttonColor,
    required this.features,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadow.card,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: buttonColor.withValues(alpha: 0.12),
                child: Icon(icon, color: buttonColor, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.h2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: buttonColor,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 12),
          for (final f in features) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_rounded, size: 16, color: buttonColor),
                const SizedBox(width: 8),
                Expanded(child: Text(f, style: AppText.bodySmall)),
              ],
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
              child: Text(buttonText, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}
