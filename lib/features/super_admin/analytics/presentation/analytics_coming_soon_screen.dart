import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/widgets.dart';

/// C6 — Analytics Dashboard Coming Soon Screen (Super Admin)
/// Matches design c6._analytics_coming_soon_super_admin/screen.png:
/// - "Under Construction" blurred chart illustration
/// - Headline "Analytics Dashboard Coming Soon"
/// - Description "We are building a powerful community intelligence engine..."
/// - "Growth Metrics" pill chip
/// - Bottom Nav
class AnalyticsComingSoonScreen extends StatelessWidget {
  const AnalyticsComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NASAppBar(title: 'Analytics Engine'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NASContentWidth(
              child: Column(
                children: [
                  const SizedBox(height: NASSpacing.lg),
                  // Graphic placeholder
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: NASColors.surfaceContainerHigh,
                      borderRadius: NASRadius.lgBorderRadius,
                      border: Border.all(color: NASColors.outlineVariant),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: NASSpacing.md,
                          vertical: NASSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: NASRadius.defaultBorderRadius,
                          boxShadow: NASShadows.sm,
                        ),
                        child: Text(
                          'Under Construction',
                          style: NASTypography.titleLg.copyWith(
                            color: NASColors.primary,
                            fontFamily: NASTypography.headlineFont,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: NASSpacing.xl),

                  Text(
                    'Analytics Dashboard\nComing Soon',
                    style: NASTypography.headlineMd.copyWith(
                      color: NASColors.primary,
                      fontFamily: NASTypography.headlineFont,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: NASSpacing.md),
                  Text(
                    'We are building a powerful community intelligence engine. Soon, you will be able to visualize growth, track member engagement, and understand Samaj demographics in real-time.',
                    style: NASTypography.bodyMd.copyWith(
                      color: NASColors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  NASBadge.business(label: 'Growth Metrics Q4 2024'),
                ],
              ),
            ),
            const SizedBox(height: NASSpacing.xl),
            const NASFooter(),
          ],
        ),
      ),
      bottomNavigationBar: NASBottomNav(
        selectedIndex: 1,
        onItemTap: (index) {
          switch (index) {
            case 0:
              context.go(AppConstants.superAdminDashboard);
            case 1:
              break;
            case 2:
              context.go(AppConstants.superAdminLocations);
            case 3:
              context.go(AppConstants.superAdminSettings);
          }
        },
        items: const [
          NASNavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard'),
          NASNavItem(icon: Icons.analytics_outlined, activeIcon: Icons.analytics, label: 'Analytics'),
          NASNavItem(icon: Icons.location_city_outlined, activeIcon: Icons.location_city, label: 'Locations'),
          NASNavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'Settings'),
        ],
      ),
    );
  }
}
