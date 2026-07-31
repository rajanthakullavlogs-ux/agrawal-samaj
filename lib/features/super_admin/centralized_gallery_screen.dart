import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/design_tokens.dart';
import '../../shared/widgets/widgets.dart';

/// C5 — Centralized Gallery Screen (Super Admin)
/// Matches design c5._centralized_gallery_super_admin:
/// - Header "Centralized Photo Archive" + subtext
/// - Action Buttons: "Moderation Queue" + "Archive Media"
/// - Stat grid: Total Photos (12,800+), Total Albums (240+), Storage (1.2 TB), Views (120k)
/// - National Albums list with chapter badge, cover stack, and photo count
/// - Bottom Nav
class CentralizedGalleryScreen extends StatelessWidget {
  const CentralizedGalleryScreen({super.key});

  static const _centralAlbums = [
    (
      title: 'Maha Shivaratri 2026 Celebrations',
      chapter: 'Kathmandu Central',
      photos: 340,
      date: 'Feb 15, 2026',
      category: 'CULTURAL',
    ),
    (
      title: 'Koshi Business Summit Highlights',
      chapter: 'Biratnagar Chapter',
      photos: 185,
      date: 'Jan 28, 2026',
      category: 'BUSINESS',
    ),
    (
      title: 'Agrawal Heritage & Youth Festival',
      chapter: 'Pokhara Branch',
      photos: 512,
      date: 'Dec 12, 2025',
      category: 'HERITAGE',
    ),
    (
      title: 'National General Assembly Assembly',
      chapter: 'National Executive Board',
      photos: 820,
      date: 'Nov 05, 2025',
      category: 'GOVERNANCE',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NASAppBar(title: 'Centralized Gallery'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NASContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: NASSpacing.md),
                  Text(
                    'SUPER ADMIN PORTAL',
                    style: NASTypography.labelSm.copyWith(color: NASColors.secondary),
                  ),
                  Text(
                    'National Photo Archive',
                    style: NASTypography.headlineMd.copyWith(
                      color: NASColors.primary,
                      fontFamily: NASTypography.headlineFont,
                    ),
                  ),
                  const SizedBox(height: NASSpacing.xs),
                  Text(
                    'National vault of cultural photos, event galleries, and historical heritage documents across Nepal.',
                    style: NASTypography.bodyMd.copyWith(color: NASColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: NASSpacing.md),

                  // Actions Row
                  Row(
                    children: [
                      Expanded(
                        child: NASSecondaryButton(
                          label: 'Moderation Queue',
                          icon: Icons.verified_user_outlined,
                          onPressed: () {
                            NASToast.success(context, 'Opening photo moderation queue...');
                          },
                        ),
                      ),
                      const SizedBox(width: NASSpacing.sm),
                      Expanded(
                        child: NASPrimaryButton(
                          label: 'Archive Media',
                          icon: Icons.cloud_upload_outlined,
                          onPressed: () {
                            NASToast.success(context, 'Media Uploader Opened');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  // Stat Cards Grid (4 items)
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: NASSpacing.sm,
                    crossAxisSpacing: NASSpacing.sm,
                    childAspectRatio: 1.4,
                    children: const [
                      NASStatCard(
                        icon: Icons.photo_library_outlined,
                        label: 'TOTAL ALBUMS',
                        value: '240+',
                      ),
                      NASStatCard(
                        icon: Icons.image_outlined,
                        label: 'TOTAL PHOTOS',
                        value: '12,800+',
                      ),
                      NASStatCard(
                        icon: Icons.sd_card_outlined,
                        label: 'STORAGE USED',
                        value: '1.2 TB',
                        iconColor: NASColors.primaryContainer,
                      ),
                      NASStatCard(
                        icon: Icons.visibility_outlined,
                        label: 'TOTAL VIEWS',
                        value: '120k',
                      ),
                    ],
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  Text(
                    'National Media Albums',
                    style: NASTypography.titleLg.copyWith(color: NASColors.primary),
                  ),
                  const SizedBox(height: NASSpacing.xs),

                  // Albums List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _centralAlbums.length,
                    separatorBuilder: (_, _) => const SizedBox(height: NASSpacing.sm),
                    itemBuilder: (context, index) {
                      final album = _centralAlbums[index];
                      return NASCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 140,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: NASColors.surfaceVariant,
                                borderRadius: NASRadius.defaultBorderRadius,
                              ),
                              child: Stack(
                                children: [
                                  const Center(
                                    child: Icon(Icons.collections_outlined, size: 44, color: NASColors.outline),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.7),
                                        borderRadius: NASRadius.fullBorderRadius,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.photo, size: 12, color: Colors.white),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${album.photos}',
                                            style: const TextStyle(color: Colors.white, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: NASSpacing.xs),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      album.title,
                                      style: NASTypography.titleLg.copyWith(color: NASColors.primary),
                                    ),
                                    Text(
                                      '${album.chapter} • ${album.date}',
                                      style: NASTypography.labelSm.copyWith(color: NASColors.onSurfaceVariant),
                                    ),
                                  ],
                                ),
                                NASBadge.business(label: album.category),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
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
        selectedIndex: 0,
        onItemTap: (index) {
          switch (index) {
            case 0:
              context.go(AppConstants.superAdminDashboard);
            case 1:
              context.go(AppConstants.superAdminAnalytics);
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
