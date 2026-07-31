import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/nas_logo.dart';

/// C1 — Super Admin Strategic Dashboard Screen
class SuperAdminDashboardScreen extends StatelessWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            const _SuperAdminTopBar(),
            const SizedBox(height: 14),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _HeroBanner(),
            ),
            const SizedBox(height: 20),

            // Nationwide Metric Cards Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.15,
                children: const [
                  _MetricCard(
                    icon: Icons.location_city_rounded,
                    iconBg: Color(0xFFDCEBFD),
                    iconColor: Color(0xFF2E6FE0),
                    cardBg: Color(0xFFF3F8FE),
                    title: 'Active Chapters',
                    value: '18',
                    trend: '↗ 2 added this month',
                    trendColor: Color(0xFF2E6FE0),
                  ),
                  _MetricCard(
                    icon: Icons.groups_rounded,
                    iconBg: Color(0xFFD8F0DE),
                    iconColor: Color(0xFF3E7C4A),
                    cardBg: Color(0xFFF2FAF4),
                    title: 'Total Members',
                    value: '5,200+',
                    trend: '↗ +12% growth in 2026',
                    trendColor: Color(0xFF3E7C4A),
                  ),
                  _MetricCard(
                    icon: Icons.event_note_rounded,
                    iconBg: Color(0xFFFBE0D2),
                    iconColor: Color(0xFFE8622C),
                    cardBg: Color(0xFFFDF3ED),
                    title: 'Total Events',
                    value: '130+',
                    trend: '↗ 24 upcoming',
                    trendColor: Color(0xFFE8622C),
                  ),
                  _MetricCard(
                    icon: Icons.photo_library_rounded,
                    iconBg: Color(0xFFFAE9C6),
                    iconColor: Color(0xFFC4901E),
                    cardBg: Color(0xFFFCF7EB),
                    title: 'Media Vault',
                    value: '12.8k',
                    trend: '↗ 1.2 TB archived',
                    trendColor: Color(0xFFC4901E),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Quick Actions Strip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text('Quick Actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _QuickActionTile(
                    icon: Icons.add_location_alt_rounded,
                    bg: const Color(0xFFE3EEFD),
                    color: const Color(0xFF2E6FE0),
                    label: 'Add New\nChapter',
                    onTap: () => context.go(AppConstants.superAdminLocations),
                  ),
                  const SizedBox(width: 10),
                  _QuickActionTile(
                    icon: Icons.event_available_rounded,
                    bg: const Color(0xFFFBE0D2),
                    color: const Color(0xFFE8622C),
                    label: 'Create National\nEvent',
                    onTap: () => context.go(AppConstants.superAdminEvents),
                  ),
                  const SizedBox(width: 10),
                  _QuickActionTile(
                    icon: Icons.analytics_rounded,
                    bg: const Color(0xFFE5F5E9),
                    color: const Color(0xFF3E7C4A),
                    label: 'Member\nAnalytics',
                    onTap: () => context.go(AppConstants.superAdminAnalytics),
                  ),
                  const SizedBox(width: 10),
                  _QuickActionTile(
                    icon: Icons.admin_panel_settings_rounded,
                    bg: const Color(0xFFEFE7FB),
                    color: const Color(0xFF7B4FD6),
                    label: 'System\nSettings',
                    onTap: () => context.go(AppConstants.superAdminSettings),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Management Modules Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text('Executive Management Modules',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _moduleTile(
                    context: context,
                    icon: Icons.analytics_rounded,
                    iconBg: const Color(0xFFE3EEFD),
                    iconColor: const Color(0xFF2E6FE0),
                    title: 'Member Analytics',
                    subtitle: 'Demographic insights & growth trends across Nepal',
                    route: AppConstants.superAdminAnalytics,
                  ),
                  const SizedBox(height: 10),
                  _moduleTile(
                    context: context,
                    icon: Icons.location_city_rounded,
                    iconBg: const Color(0xFFE5F5E9),
                    iconColor: const Color(0xFF3E7C4A),
                    title: 'Locations Management',
                    subtitle: 'Manage 18 regional branch chapters & leaders',
                    route: AppConstants.superAdminLocations,
                  ),
                  const SizedBox(height: 10),
                  _moduleTile(
                    context: context,
                    icon: Icons.event_note_rounded,
                    iconBg: const Color(0xFFFBE0D2),
                    iconColor: const Color(0xFFE8622C),
                    title: 'Centralized Events Overview',
                    subtitle: 'Coordinate 130+ nationwide chapter events',
                    route: AppConstants.superAdminEvents,
                  ),
                  const SizedBox(height: 10),
                  _moduleTile(
                    context: context,
                    icon: Icons.photo_library_rounded,
                    iconBg: const Color(0xFFEFE7FB),
                    iconColor: const Color(0xFF7B4FD6),
                    title: 'Centralized Media Vault',
                    subtitle: 'National archive of cultural photos & media',
                    route: AppConstants.superAdminGallery,
                  ),
                  const SizedBox(height: 10),
                  _moduleTile(
                    context: context,
                    icon: Icons.settings_applications_rounded,
                    iconBg: const Color(0xFFFAE9C6),
                    iconColor: const Color(0xFFC4901E),
                    title: 'Global System Settings',
                    subtitle: 'Configure RBAC roles, security & admin permissions',
                    route: AppConstants.superAdminSettings,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _SuperAdminBottomNavBar(activeIndex: 0),
    );
  }

  Widget _moduleTile({
    required BuildContext context,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String route,
  }) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600)),
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

// ---------------------------------------------------------------------------
// TOP BAR WITH EXIT BUTTON
// ---------------------------------------------------------------------------
class _SuperAdminTopBar extends StatelessWidget {
  const _SuperAdminTopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => context.go(AppConstants.home),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.home_rounded, size: 22, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 8),
          const NasLogo(size: 38),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Nepal Agrawal Samaj',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Super Admin Board',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 11.5, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => context.go(AppConstants.home),
            borderRadius: BorderRadius.circular(100),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(100)),
              child: Row(
                children: const [
                  Text('Exit', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                  SizedBox(width: 2),
                  Icon(Icons.logout_rounded, size: 12, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// HERO BANNER
// ---------------------------------------------------------------------------
class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFCEEE4), Color(0xFFFBE3D3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Super Admin Portal 👑',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text('Strategic national command center overseeing 18 chapters and 5,200+ members across Nepal.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.35)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: const Icon(Icons.workspace_premium_rounded, color: AppColors.primary, size: 32),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// METRIC CARD
// ---------------------------------------------------------------------------
class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color cardBg;
  final String title;
  final String value;
  final String trend;
  final Color trendColor;

  const _MetricCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.cardBg,
    required this.title,
    required this.value,
    required this.trend,
    required this.trendColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 15, color: iconColor),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            ],
          ),
          Text(
            trend,
            style: TextStyle(fontSize: 9.5, color: trendColor, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// QUICK ACTION TILE
// ---------------------------------------------------------------------------
class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.bg,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        width: 84,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.lg)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SUPER ADMIN BOTTOM NAV: Dashboard • Analytics • Locations • Events • Settings
// ---------------------------------------------------------------------------
class _SuperAdminBottomNavBar extends StatelessWidget {
  final int activeIndex;
  const _SuperAdminBottomNavBar({required this.activeIndex});

  static const _items = [
    (icon: Icons.dashboard_rounded, label: 'Dashboard', route: AppConstants.superAdminDashboard),
    (icon: Icons.analytics_rounded, label: 'Analytics', route: AppConstants.superAdminAnalytics),
    (icon: Icons.location_city_rounded, label: 'Locations', route: AppConstants.superAdminLocations),
    (icon: Icons.event_note_rounded, label: 'Events', route: AppConstants.superAdminEvents),
    (icon: Icons.settings_rounded, label: 'Settings', route: AppConstants.superAdminSettings),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (int i = 0; i < _items.length; i++)
              Expanded(
                child: InkWell(
                  onTap: () => context.go(_items[i].route),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: i == activeIndex
                            ? BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              )
                            : null,
                        child: Icon(
                          _items[i].icon,
                          size: 20,
                          color: i == activeIndex ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _items[i].label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: i == activeIndex ? FontWeight.w700 : FontWeight.w500,
                          color: i == activeIndex ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
