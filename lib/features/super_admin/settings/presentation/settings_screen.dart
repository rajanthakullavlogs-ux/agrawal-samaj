import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/widgets.dart';

/// C7 — Super Admin Settings Screen
/// Matches design c7._settings_super_admin/screen.png:
/// - Header "Super Admin Settings" + subtext
/// - Module 1: Admin Management ("COMING SOON" badge, subtext, placeholder controls)
/// - Module 2: Roles & Permissions ("Q4 2024" badge, subtext)
/// - Bottom Nav
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NASAppBar(title: 'Super Admin Settings'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NASContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: NASSpacing.md),
                  Text(
                    'Super Admin Settings',
                    style: NASTypography.headlineMd.copyWith(
                      color: NASColors.primary,
                      fontFamily: NASTypography.headlineFont,
                    ),
                  ),
                  const SizedBox(height: NASSpacing.xs),
                  Text(
                    'Configure the core parameters of the Nepal Agrawal Samaj portal. Manage administrative hierarchy, platform defaults, and system notifications.',
                    style: NASTypography.bodyMd.copyWith(
                      color: NASColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  // Module 1 Card: Admin Management
                  NASCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.admin_panel_settings_outlined,
                                size: 28, color: NASColors.primary),
                            NASBadge.business(label: 'Coming Soon'),
                          ],
                        ),
                        const SizedBox(height: NASSpacing.sm),
                        Text(
                          'Admin Management',
                          style: NASTypography.titleLg.copyWith(
                            color: NASColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Control who has access to the control panel. Add or remove administrators and monitor their activity logs for security auditing.',
                          style: NASTypography.bodyMd.copyWith(
                            color: NASColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: NASSpacing.md),

                  // Module 2 Card: Roles & Permissions
                  NASCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.security_outlined,
                                size: 28, color: NASColors.secondary),
                            NASBadge.pending(label: 'Q4 2024'),
                          ],
                        ),
                        const SizedBox(height: NASSpacing.sm),
                        Text(
                          'Roles & Permissions',
                          style: NASTypography.titleLg.copyWith(
                            color: NASColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Define granular permission sets for different community roles like super admin, location admin, and regional moderators.',
                          style: NASTypography.bodyMd.copyWith(
                            color: NASColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: NASSpacing.xl),
            const NASFooter(),
          ],
        ),
      ),
      bottomNavigationBar: NASBottomNav(
        selectedIndex: 3,
        onItemTap: (index) {
          switch (index) {
            case 0:
              context.go(AppConstants.superAdminDashboard);
            case 1:
              context.go(AppConstants.superAdminAnalytics);
            case 2:
              context.go(AppConstants.superAdminLocations);
            case 3:
              break;
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
