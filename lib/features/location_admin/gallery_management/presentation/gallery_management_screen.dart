import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/nas_logo.dart';

/// B4 — Gallery Management Screen (Location Admin)
class GalleryManagementScreen extends StatefulWidget {
  const GalleryManagementScreen({super.key});

  @override
  State<GalleryManagementScreen> createState() => _GalleryManagementScreenState();
}

class _GalleryManagementScreenState extends State<GalleryManagementScreen> {
  static const _albumsList = [
    (
      title: 'Maha Shivaratri Festival 2026',
      date: 'Feb 15, 2026',
      category: 'Cultural',
      count: 124,
      views: '4.8k',
      color: Color(0xFFE3EEFD),
    ),
    (
      title: 'Executive Committee Meeting',
      date: 'Jan 22, 2026',
      category: 'Admin',
      count: 45,
      views: '1.2k',
      color: Color(0xFFFCEAE0),
    ),
    (
      title: 'Vasant Panchami Celebration',
      date: 'Feb 02, 2026',
      category: 'Community',
      count: 210,
      views: '6.5k',
      color: Color(0xFFE5F5E9),
    ),
    (
      title: 'Teej Cultural Program Archives',
      date: 'Sep 10, 2025',
      category: 'Heritage',
      count: 310,
      views: '12.4k',
      color: Color(0xFFEFE7FB),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            const _AdminTopBar(),
            const SizedBox(height: 14),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _HeroBanner(),
            ),
            const SizedBox(height: 20),

            // Stat Cards Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.6,
                children: const [
                  _MiniStat(
                    title: 'Total Albums',
                    value: '42',
                    icon: Icons.photo_library_rounded,
                    color: Color(0xFF2E6FE0),
                    bg: Color(0xFFF3F8FE),
                  ),
                  _MiniStat(
                    title: 'Total Photos',
                    value: '1,284',
                    icon: Icons.image_rounded,
                    color: Color(0xFF3E7C4A),
                    bg: Color(0xFFF2FAF4),
                  ),
                  _MiniStat(
                    title: 'Storage Used',
                    value: '84%',
                    icon: Icons.sd_card_rounded,
                    color: Color(0xFFE8622C),
                    bg: Color(0xFFFDF3ED),
                  ),
                  _MiniStat(
                    title: 'Shared Views',
                    value: '15.2k',
                    icon: Icons.visibility_rounded,
                    color: Color(0xFFC4901E),
                    bg: Color(0xFFFCF7EB),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

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
                    icon: Icons.cloud_upload_rounded,
                    bg: const Color(0xFFE3EEFD),
                    color: const Color(0xFF2E6FE0),
                    label: 'Upload\nPhotos',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening Photo Upload Manager...')),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  _QuickActionTile(
                    icon: Icons.create_new_folder_rounded,
                    bg: const Color(0xFFFBE0D2),
                    color: const Color(0xFFE8622C),
                    label: 'Create\nAlbum',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening New Album Dialog...')),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  _QuickActionTile(
                    icon: Icons.sd_card_rounded,
                    bg: const Color(0xFFE5F5E9),
                    color: const Color(0xFF3E7C4A),
                    label: 'Storage\nUsage',
                    onTap: () {},
                  ),
                  const SizedBox(width: 10),
                  _QuickActionTile(
                    icon: Icons.share_rounded,
                    bg: const Color(0xFFEFE7FB),
                    color: const Color(0xFF7B4FD6),
                    label: 'Share\nGallery',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Recent Albums Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent Albums',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  Row(
                    children: [
                      Text('Sort by: Date', style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600)),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.textSecondary),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Albums List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  for (final album in _albumsList) ...[
                    _AlbumCard(album: album),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _AdminBottomNavBar(activeIndex: 3),
    );
  }
}

// ---------------------------------------------------------------------------
// TOP BAR WITH EXIT BUTTON
// ---------------------------------------------------------------------------
class _AdminTopBar extends StatelessWidget {
  const _AdminTopBar();

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
                  'Gallery Management',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 11.5, fontWeight: FontWeight.w500),
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
                const Text('Gallery Vault 🖼️',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text('Manage community photo archives, preserve cultural heritage, and organize event memories.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.35)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: const Icon(Icons.photo_library_rounded, color: AppColors.primary, size: 32),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MINI STAT
// ---------------------------------------------------------------------------
class _MiniStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color bg;

  const _MiniStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: color)),
                Text(title, style: TextStyle(fontSize: 10.5, color: Colors.grey.shade700), overflow: TextOverflow.ellipsis),
              ],
            ),
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
// ALBUM CARD
// ---------------------------------------------------------------------------
class _AlbumCard extends StatelessWidget {
  final dynamic album;

  const _AlbumCard({required this.album});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: album.color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(Icons.photo_album_rounded, size: 48, color: AppColors.primary.withValues(alpha: 0.4)),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.photo_camera_rounded, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text('${album.count}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(album.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      const SizedBox(height: 2),
                      Text('${album.date} • ${album.category} • ${album.views} views',
                          style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert_rounded, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ADMIN BOTTOM NAV
// ---------------------------------------------------------------------------
class _AdminBottomNavBar extends StatelessWidget {
  final int activeIndex;
  const _AdminBottomNavBar({required this.activeIndex});

  static const _items = [
    (icon: Icons.dashboard_rounded, label: 'Dashboard', route: AppConstants.adminDashboard),
    (icon: Icons.people_alt_rounded, label: 'Members', route: AppConstants.adminMembers),
    (icon: Icons.event_rounded, label: 'Events', route: AppConstants.adminEvents),
    (icon: Icons.photo_library_rounded, label: 'Gallery', route: AppConstants.adminGallery),
    (icon: Icons.settings_rounded, label: 'Settings', route: AppConstants.adminSettings),
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
