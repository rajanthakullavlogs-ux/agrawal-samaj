import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/widgets.dart';

/// B4 — Gallery Management Screen (Location Admin)
/// Matches design b4._gallery_location_admin/screen.png:
/// - Header "Gallery Management" + subtext
/// - Action buttons: "Upload Photos" + "+ Create Album"
/// - 4 Stat cards: TOTAL ALBUMS (42), TOTAL PHOTOS (1,284), STORAGE USED (84%), SHARED VIEWS (15.2k)
/// - "Recent Albums" grid list (Cover photo, count badge overlay, title, date, triple dot menu)
/// - Bottom Nav
class GalleryManagementScreen extends StatelessWidget {
  const GalleryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NASAppBar(title: 'Gallery Management'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NASContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: NASSpacing.md),
                  Text(
                    'Gallery Management',
                    style: NASTypography.headlineMd.copyWith(
                      color: NASColors.primary,
                      fontFamily: NASTypography.headlineFont,
                    ),
                  ),
                  const SizedBox(height: NASSpacing.xs),
                  Text(
                    'Manage community event albums, preserve cultural heritage through photography, and organize archives.',
                    style: NASTypography.bodyMd.copyWith(
                      color: NASColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: NASSpacing.md),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: NASSecondaryButton(
                          label: 'Upload Photos',
                          icon: Icons.cloud_upload_outlined,
                          onPressed: () {
                            NASToast.success(context, 'Select photos to upload...');
                          },
                        ),
                      ),
                      const SizedBox(width: NASSpacing.sm),
                      Expanded(
                        child: NASPrimaryButton(
                          label: 'Create Album',
                          icon: Icons.add,
                          onPressed: () {
                            NASToast.success(context, 'New Album Dialog');
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
                        value: '42',
                      ),
                      NASStatCard(
                        icon: Icons.image_outlined,
                        label: 'TOTAL PHOTOS',
                        value: '1,284',
                      ),
                      NASStatCard(
                        icon: Icons.sd_card_outlined,
                        label: 'STORAGE USED',
                        value: '84%',
                        iconColor: NASColors.primaryContainer,
                      ),
                      NASStatCard(
                        icon: Icons.visibility_outlined,
                        label: 'SHARED VIEWS',
                        value: '15.2k',
                      ),
                    ],
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  // Recent Albums header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Albums',
                        style: NASTypography.titleLg.copyWith(
                          color: NASColors.primary,
                        ),
                      ),
                      DropdownButton<String>(
                        value: 'Date',
                        items: const [
                          DropdownMenuItem(value: 'Date', child: Text('Sort by: Date')),
                          DropdownMenuItem(value: 'Views', child: Text('Sort by: Views')),
                        ],
                        onChanged: (_) {},
                        underline: const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  const SizedBox(height: NASSpacing.xs),

                  // Albums list
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _recentAlbums.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: NASSpacing.sm),
                    itemBuilder: (context, index) {
                      final album = _recentAlbums[index];
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
                                    child: Icon(Icons.photo_album_outlined,
                                        size: 40, color: NASColors.outline),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.7),
                                        borderRadius: NASRadius.fullBorderRadius,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.photo,
                                              size: 12, color: Colors.white),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${album.count}',
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 12),
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
                                      style: NASTypography.titleLg.copyWith(
                                        color: NASColors.primary,
                                      ),
                                    ),
                                    Text(
                                      '${album.date} • ${album.category}',
                                      style: NASTypography.labelSm.copyWith(
                                        color: NASColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () {},
                                ),
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
              context.go(AppConstants.adminDashboard);
            case 1:
              context.go(AppConstants.adminMembers);
            case 2:
              context.go(AppConstants.adminEvents);
            case 3:
              context.go(AppConstants.adminSettings);
          }
        },
        items: const [
          NASNavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard'),
          NASNavItem(icon: Icons.people_outlined, activeIcon: Icons.people, label: 'Members'),
          NASNavItem(icon: Icons.event_outlined, activeIcon: Icons.event, label: 'Events'),
          NASNavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'Settings'),
        ],
      ),
    );
  }
}

class _AlbumAdminItem {
  final String title;
  final String date;
  final String category;
  final int count;
  const _AlbumAdminItem({
    required this.title,
    required this.date,
    required this.category,
    required this.count,
  });
}

const _recentAlbums = [
  _AlbumAdminItem(
    title: 'Maha Shivaratri 2024',
    date: 'Feb 15, 2024',
    category: 'Cultural',
    count: 124,
  ),
  _AlbumAdminItem(
    title: 'Executive Committee Meet',
    date: 'Jan 22, 2024',
    category: 'Admin',
    count: 45,
  ),
  _AlbumAdminItem(
    title: 'Vasant Panchami Celebration',
    date: 'Feb 02, 2024',
    category: 'Community',
    count: 210,
  ),
];
