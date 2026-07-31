import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/widgets.dart';

/// C1 — Super Admin Strategic Dashboard Screen
class SuperAdminDashboardScreen extends StatelessWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NASAppBar(title: 'Super Admin Portal'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    'ADMINISTRATOR PORTAL',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.gold, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 4),
                  const Text('Strategic Dashboard', style: AppText.h1),
                  const SizedBox(height: AppSpacing.md),

                  // Top Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: ElevatedButton.icon(
                            onPressed: () => NASToast.success(context, 'Creating Central Event...'),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('Create Event', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: OutlinedButton.icon(
                            onPressed: () => NASToast.success(context, 'Exporting organization reports...'),
                            icon: const Icon(Icons.download_rounded, size: 18, color: AppColors.primary),
                            label: const Text('Export Reports', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.primary)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Nationwide Metric Cards
                  const _SuperMetricTile(
                    icon: Icons.location_on_rounded,
                    value: '18',
                    label: 'Total Active Chapters',
                    trend: '↗ 2 added this month',
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 12),
                  const _SuperMetricTile(
                    icon: Icons.groups_rounded,
                    value: '5,200+',
                    label: 'Total Registered Members',
                    trend: '↗ +12% growth in 2026',
                    color: AppColors.accent,
                  ),
                  const SizedBox(height: 12),
                  const _SuperMetricTile(
                    icon: Icons.event_rounded,
                    value: '130+',
                    label: 'Total Events Organized',
                    trend: '↗ 24 upcoming across Nepal',
                    color: AppColors.gold,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Management Modules
                  const Text('Management Modules', style: AppText.h2),
                  const SizedBox(height: AppSpacing.md),

                  _moduleTile(
                    context: context,
                    icon: Icons.analytics_rounded,
                    title: 'Member Analytics',
                    subtitle: 'View demographics & growth trends',
                    route: AppConstants.superAdminAnalytics,
                  ),
                  const SizedBox(height: 10),
                  _moduleTile(
                    context: context,
                    icon: Icons.place_rounded,
                    title: 'Locations Management',
                    subtitle: 'Manage 18 regional chapters',
                    route: AppConstants.superAdminLocations,
                  ),
                  const SizedBox(height: 10),
                  _moduleTile(
                    context: context,
                    icon: Icons.event_note_rounded,
                    title: 'Centralized Events',
                    subtitle: 'Oversee nationwide event calendar',
                    route: AppConstants.superAdminEvents,
                  ),
                  const SizedBox(height: 10),
                  _moduleTile(
                    context: context,
                    icon: Icons.photo_library_rounded,
                    title: 'Centralized Gallery',
                    subtitle: 'Approve & categorize album media',
                    route: AppConstants.superAdminGallery,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _moduleTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: AppShadow.card,
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.accentLight,
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.h3),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppText.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _SuperMetricTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final String trend;
  final Color color;

  const _SuperMetricTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.trend,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadow.card,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
                Text(label, style: AppText.h3),
                const SizedBox(height: 2),
                Text(trend, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.green)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
