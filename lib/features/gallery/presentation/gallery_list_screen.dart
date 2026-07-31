import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_tokens.dart';
import '../../../shared/widgets/widgets.dart';

enum _GalleryCategory { all, business, cultural, socialWork }

/// Gallery Screen — Matches the exact uploaded design screenshot
class GalleryListScreen extends ConsumerStatefulWidget {
  const GalleryListScreen({super.key});

  @override
  ConsumerState<GalleryListScreen> createState() => _GalleryListScreenState();
}

class _GalleryListScreenState extends ConsumerState<GalleryListScreen> {
  _GalleryCategory _category = _GalleryCategory.all;

  static const _highlightPhotos = [
    'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=400&q=80',
  ];

  static const _albums = [
    (
      title: 'Business Summit\n2026',
      count: '45 Photos',
      icon: Icons.work_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=400&q=80',
    ),
    (
      title: 'Teej Celebration\n2081',
      count: '68 Photos',
      icon: Icons.theater_comedy_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=400&q=80',
    ),
    (
      title: 'Blood Donation\nDrive',
      count: '32 Photos',
      icon: Icons.volunteer_activism_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=400&q=80',
    ),
    (
      title: 'Community\nGathering',
      count: '56 Photos',
      icon: Icons.groups_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=400&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const NASAppBar(title: 'Gallery', showBackButton: true),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text(
                  'Gallery',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    fontFamily: NASTypography.headlineFont,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Moments that define us',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          _CategoryRow(
            category: _category,
            onChanged: (c) => setState(() => _category = c),
          ),
          const SizedBox(height: 20),
          _sectionHeader('Photo Highlights'),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _highlightPhotos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, i) => _PhotoThumb(url: _highlightPhotos[i]),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _EventAlbumsBanner(),
          ),
          const SizedBox(height: 20),
          _sectionHeader('Recent Albums'),
          const SizedBox(height: 12),
          SizedBox(
            height: 195,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _albums.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, i) => _AlbumCard(album: _albums[i]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NASBottomNavBar(activeIndex: 3),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppText.h2),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(foregroundColor: AppColors.primary, padding: EdgeInsets.zero),
            child: const Text('View All', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CATEGORY FILTER ROW
// ---------------------------------------------------------------------------
class _CategoryRow extends StatelessWidget {
  final _GalleryCategory category;
  final ValueChanged<_GalleryCategory> onChanged;
  const _CategoryRow({required this.category, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _chip(Icons.grid_view_rounded, 'All', _GalleryCategory.all),
          const SizedBox(width: 8),
          _chip(Icons.work_rounded, 'Business Events', _GalleryCategory.business),
          const SizedBox(width: 8),
          _chip(Icons.theater_comedy_rounded, 'Cultural Events', _GalleryCategory.cultural),
          const SizedBox(width: 8),
          _chip(Icons.volunteer_activism_rounded, 'Social Work', _GalleryCategory.socialWork),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label, _GalleryCategory value) {
    final selected = category == value;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: selected ? Colors.white : AppColors.accent),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PHOTO THUMBNAIL
// ---------------------------------------------------------------------------
class _PhotoThumb extends StatelessWidget {
  final String url;
  const _PhotoThumb({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: AppColors.subtleCard),
          ),
          Positioned(
            left: 6,
            bottom: 6,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.60),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.photo_camera_rounded, size: 11, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// EVENT ALBUMS BANNER
// ---------------------------------------------------------------------------
class _EventAlbumsBanner extends StatelessWidget {
  const _EventAlbumsBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Event Albums',
                  style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w800, fontSize: 14),
                ),
                SizedBox(height: 2),
                Text(
                  'Explore photos from our past events',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ALBUM CARD
// ---------------------------------------------------------------------------
class _AlbumCard extends StatelessWidget {
  final ({String title, String count, IconData icon, String imageUrl}) album;
  const _AlbumCard({required this.album});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: SizedBox(
                  height: 110,
                  width: 130,
                  child: CachedNetworkImage(
                    imageUrl: album.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 6,
                top: 6,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.90),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(album.icon, size: 13, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            album.title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, height: 1.25),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(album.count, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
