import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../shared/widgets/widgets.dart';

class _HighlightPhoto {
  final String id;
  final String url;
  final String title;
  final int photoCount;

  const _HighlightPhoto({
    required this.id,
    required this.url,
    required this.title,
    required this.photoCount,
  });
}

class _AlbumItem {
  final String id;
  final String title;
  final int photoCount;
  final int albumCount;
  final IconData icon;
  final String imageUrl;

  const _AlbumItem({
    required this.id,
    required this.title,
    required this.photoCount,
    required this.albumCount,
    required this.icon,
    required this.imageUrl,
  });
}

/// Refactored GalleryListScreen matching pixel-for-pixel the reference UI screenshot.
class GalleryListScreen extends ConsumerStatefulWidget {
  const GalleryListScreen({super.key});

  @override
  ConsumerState<GalleryListScreen> createState() => _GalleryListScreenState();
}

class _GalleryListScreenState extends ConsumerState<GalleryListScreen> {
  String _selectedCategory = 'All'; // 'All', 'Business Events', 'Cultural Events', 'Social Service', 'Youth Activities'

  static const _HighlightPhoto _tallLeftPhoto = _HighlightPhoto(
    id: 'p-1',
    url: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=800&q=80',
    title: 'Annual Business Summit Keynote Audience',
    photoCount: 24,
  );

  static const _HighlightPhoto _midTopPhoto = _HighlightPhoto(
    id: 'p-2',
    url: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80',
    title: 'Nepali Traditional Harmonium Performance',
    photoCount: 18,
  );

  static const _HighlightPhoto _midBottomPhoto = _HighlightPhoto(
    id: 'p-3',
    url: 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?auto=format&fit=crop&w=800&q=80',
    title: 'Youth Tree Plantation Social Service',
    photoCount: 16,
  );

  static const _HighlightPhoto _rightTopPhoto = _HighlightPhoto(
    id: 'p-4',
    url: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=800&q=80',
    title: 'Teej Festival Temple Dance Group',
    photoCount: 32,
  );

  static const _HighlightPhoto _rightBottomPhoto = _HighlightPhoto(
    id: 'p-5',
    url: 'https://images.unsplash.com/photo-1615461066841-6116e61058f4?auto=format&fit=crop&w=800&q=80',
    title: 'Mega Blood Donation Drive Volunteers',
    photoCount: 20,
  );

  static const List<_AlbumItem> _albums = [
    _AlbumItem(
      id: 'alb-1',
      title: 'Business Events',
      photoCount: 15,
      albumCount: 2,
      icon: Icons.business_center_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=400&q=80',
    ),
    _AlbumItem(
      id: 'alb-2',
      title: 'Cultural Events',
      photoCount: 18,
      albumCount: 3,
      icon: Icons.theater_comedy_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=400&q=80',
    ),
    _AlbumItem(
      id: 'alb-3',
      title: 'Social Service',
      photoCount: 12,
      albumCount: 2,
      icon: Icons.volunteer_activism_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=400&q=80',
    ),
    _AlbumItem(
      id: 'alb-4',
      title: 'Youth Activities',
      photoCount: 14,
      albumCount: 2,
      icon: Icons.groups_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=400&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Navigation & Hero Banner Section
            _GalleryHeroSection(
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppConstants.home);
                }
              },
              onProfile: () => context.push(AppConstants.profile),
            ),
            const SizedBox(height: 16),

            // Horizontal Category Filter Pills Bar
            _GalleryCategoryPillsBar(
              selectedCategory: _selectedCategory,
              onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
            ),
            const SizedBox(height: 24),

            // Photo Highlights Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 18,
                          decoration: BoxDecoration(
                            color: const Color(0xFF700D15),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Flexible(
                          child: Text(
                            'Photo Highlights',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E1615),
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push(AppConstants.allPhotos),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF700D15).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF700D15),
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(Icons.arrow_forward_rounded, size: 12, color: Color(0xFF700D15)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Asymmetric Photo Grid (Left Tall + 2 Middle Stacked + 2 Right Stacked)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 240,
                child: Row(
                  children: [
                    // Left Column (Tall Photo)
                    Expanded(
                      flex: 3,
                      child: _PhotoGridCard(
                        photo: _tallLeftPhoto,
                        onTap: () => _showZoomableLightbox(context, _tallLeftPhoto),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Middle Column (2 Stacked Photos)
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Expanded(
                            child: _PhotoGridCard(
                              photo: _midTopPhoto,
                              onTap: () => _showZoomableLightbox(context, _midTopPhoto),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: _PhotoGridCard(
                              photo: _midBottomPhoto,
                              onTap: () => _showZoomableLightbox(context, _midBottomPhoto),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Right Column (2 Stacked Photos)
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Expanded(
                            child: _PhotoGridCard(
                              photo: _rightTopPhoto,
                              onTap: () => _showZoomableLightbox(context, _rightTopPhoto),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: _PhotoGridCard(
                              photo: _rightBottomPhoto,
                              onTap: () => _showZoomableLightbox(context, _rightBottomPhoto),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Carousel Indicator Dots Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 16,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF700D15),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                for (int i = 0; i < 4; i++)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(left: 5),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE5D5D5),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 28),

            // Recent Albums Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 18,
                          decoration: BoxDecoration(
                            color: const Color(0xFF700D15),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Flexible(
                          child: Text(
                            'Recent Albums',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E1615),
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push(AppConstants.allAlbums),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF700D15).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'View All Albums',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF700D15),
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(Icons.arrow_forward_rounded, size: 12, color: Color(0xFF700D15)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Horizontal Recent Albums Scroll
            SizedBox(
              height: 185,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _albums.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final album = _albums[i];
                  return GestureDetector(
                    onTap: () => context.push('/gallery/${album.id}'),
                    child: _RecentAlbumCard(album: album),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: const NASBottomNavBar(activeIndex: 3),
    );
  }

  void _showZoomableLightbox(BuildContext context, _HighlightPhoto photo) {
    showDialog(
      context: context,
      builder: (dialogCtx) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      photo.title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(dialogCtx),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 450),
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: CachedNetworkImage(
                    imageUrl: photo.url,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(color: Color(0xFF700D15)),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image_rounded, size: 64, color: Colors.white54),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. TOP HERO BANNER & NAVIGATION
// ---------------------------------------------------------------------------
class _GalleryHeroSection extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onProfile;

  const _GalleryHeroSection({
    required this.onBack,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF9F7F5),
      padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Bar Row: Back Button + Centered Title + Profile Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onBack,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0EAE8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF500913), size: 20),
                ),
              ),
              const Text(
                'Gallery',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF500913),
                  letterSpacing: -0.3,
                ),
              ),
              GestureDetector(
                onTap: onProfile,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0EAE8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_outline_rounded, color: Color(0xFF500913), size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Main Headline & Temple Pagoda Graphic Stack/Row
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Moments that define us',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF500913),
                        height: 1.2,
                        letterSpacing: -0.4,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Relive our events, celebrations and success stories.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              // Pagoda Illustration Graphic (Faded light red/pink right accent)
              Positioned(
                right: 0,
                bottom: -10,
                child: SizedBox(
                  width: 120,
                  height: 110,
                  child: ShaderMask(
                    shaderCallback: (rect) => LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.15),
                      ],
                    ).createShader(rect),
                    blendMode: BlendMode.dstIn,
                    child: CachedNetworkImage(
                      imageUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=400&q=80',
                      fit: BoxFit.contain,
                      errorWidget: (_, _, _) => const Icon(Icons.account_balance_rounded, size: 64, color: Color(0x33500913)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. HORIZONTAL CATEGORY FILTER PILLS BAR
// ---------------------------------------------------------------------------
class _GalleryCategoryPillsBar extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const _GalleryCategoryPillsBar({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'label': 'All', 'icon': Icons.grid_view_rounded},
      {'label': 'Business Events', 'icon': Icons.business_center_rounded},
      {'label': 'Cultural Events', 'icon': Icons.theater_comedy_rounded},
      {'label': 'Social Service', 'icon': Icons.volunteer_activism_rounded},
      {'label': 'Youth Activities', 'icon': Icons.groups_rounded},
    ];

    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, i) {
          final cat = categories[i];
          final label = cat['label'] as String;
          final icon = cat['icon'] as IconData;
          final isSelected = label == selectedCategory;

          return GestureDetector(
            onTap: () => onCategorySelected(label),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF500913) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFF500913) : const Color(0xFFE5D0D0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 14,
                    color: isSelected ? Colors.white : const Color(0xFF700D15),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : const Color(0xFF1E1615),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. PHOTO HIGHLIGHT CARD ITEM
// ---------------------------------------------------------------------------
class _PhotoGridCard extends StatelessWidget {
  final _HighlightPhoto photo;
  final VoidCallback onTap;

  const _PhotoGridCard({
    required this.photo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: photo.url,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(color: const Color(0xFFEFEBE8)),
              errorWidget: (_, _, _) => Container(
                color: const Color(0xFFE5D0D0),
                child: const Icon(Icons.image, color: Color(0xFF700D15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. RECENT ALBUM CARD ITEM
// ---------------------------------------------------------------------------
class _RecentAlbumCard extends StatelessWidget {
  final _AlbumItem album;

  const _RecentAlbumCard({required this.album});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5D0D0), width: 0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Cover Image Stack with Circular Icon Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: SizedBox(
                  height: 110,
                  width: 155,
                  child: CachedNetworkImage(
                    imageUrl: album.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 8,
                top: 8,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(album.icon, size: 14, color: const Color(0xFF700D15)),
                ),
              ),
            ],
          ),

          // Bottom Album Details Padding
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  album.title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1615),
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                const Text(
                  'Album Collection',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
