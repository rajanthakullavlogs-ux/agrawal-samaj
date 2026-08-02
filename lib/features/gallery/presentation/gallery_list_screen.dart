import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../shared/widgets/widgets.dart';

enum _GalleryCategory { all, business, cultural, socialWork }

class _GalleryPhoto {
  final String id;
  final String url;
  final String title;
  final _GalleryCategory category;
  final String eventId;
  final String eventTitle;
  final String eventDate;
  final String venue;

  const _GalleryPhoto({
    required this.id,
    required this.url,
    required this.title,
    required this.category,
    required this.eventId,
    required this.eventTitle,
    required this.eventDate,
    required this.venue,
  });
}

class _GalleryAlbum {
  final String id;
  final String title;
  final String count;
  final IconData icon;
  final String imageUrl;
  final _GalleryCategory category;
  final String eventId;

  const _GalleryAlbum({
    required this.id,
    required this.title,
    required this.count,
    required this.icon,
    required this.imageUrl,
    required this.category,
    required this.eventId,
  });
}

/// Gallery Screen — Fully functional with live filtering, full-screen zoom, and event info integration
class GalleryListScreen extends ConsumerStatefulWidget {
  const GalleryListScreen({super.key});

  @override
  ConsumerState<GalleryListScreen> createState() => _GalleryListScreenState();
}

class _GalleryListScreenState extends ConsumerState<GalleryListScreen> {
  _GalleryCategory _category = _GalleryCategory.all;

  static const List<_GalleryPhoto> _allPhotos = [
    _GalleryPhoto(
      id: 'p1',
      url: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=800&q=80',
      title: 'Business Summit Keynote Presentation',
      category: _GalleryCategory.business,
      eventId: 'ev-2',
      eventTitle: 'Entrepreneurship & Trade Summit',
      eventDate: 'Oct 22, 2026',
      venue: 'Samaj Hall, Kamaladi',
    ),
    _GalleryPhoto(
      id: 'p2',
      url: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=800&q=80',
      title: 'Blood Donation Camp Volunteers',
      category: _GalleryCategory.socialWork,
      eventId: 'ev-4',
      eventTitle: 'Senior Wellness & Health Camp',
      eventDate: 'Oct 28, 2026',
      venue: 'Central Clinic Wing, Kathmandu',
    ),
    _GalleryPhoto(
      id: 'p3',
      url: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=800&q=80',
      title: 'Annual Heritage Gala Dance Performance',
      category: _GalleryCategory.cultural,
      eventId: 'ev-1',
      eventTitle: 'Annual Heritage Gala 2026',
      eventDate: 'Oct 15, 2026',
      venue: 'Hotel Yak & Yeti, Kathmandu',
    ),
    _GalleryPhoto(
      id: 'p4',
      url: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=800&q=80',
      title: 'Community Networking Dinner',
      category: _GalleryCategory.business,
      eventId: 'ev-2',
      eventTitle: 'Entrepreneurship & Trade Summit',
      eventDate: 'Oct 22, 2026',
      venue: 'Samaj Hall, Kamaladi',
    ),
    _GalleryPhoto(
      id: 'p5',
      url: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&w=800&q=80',
      title: 'Youth Cultural Fest Stage Program',
      category: _GalleryCategory.cultural,
      eventId: 'ev-3',
      eventTitle: 'Youth Cultural Fest 2026',
      eventDate: 'Nov 05, 2026',
      venue: 'National Stadium, Tripureshwor',
    ),
    _GalleryPhoto(
      id: 'p6',
      url: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=800&q=80',
      title: 'Teej Puja Ceremonies',
      category: _GalleryCategory.cultural,
      eventId: 'ev-1',
      eventTitle: 'Annual Heritage Gala 2026',
      eventDate: 'Oct 15, 2026',
      venue: 'Hotel Yak & Yeti, Kathmandu',
    ),
    _GalleryPhoto(
      id: 'p7',
      url: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=800&q=80',
      title: 'Agrawal Entrepreneurs Panel Discussion',
      category: _GalleryCategory.business,
      eventId: 'ev-2',
      eventTitle: 'Entrepreneurship & Trade Summit',
      eventDate: 'Oct 22, 2026',
      venue: 'Samaj Hall, Kamaladi',
    ),
    _GalleryPhoto(
      id: 'p8',
      url: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=800&q=80',
      title: 'Free Health Checkup Ward',
      category: _GalleryCategory.socialWork,
      eventId: 'ev-4',
      eventTitle: 'Senior Wellness & Health Camp',
      eventDate: 'Oct 28, 2026',
      venue: 'Central Clinic Wing, Kathmandu',
    ),
    _GalleryPhoto(
      id: 'p9',
      url: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=800&q=80',
      title: 'Youth Leadership Workshop',
      category: _GalleryCategory.cultural,
      eventId: 'ev-3',
      eventTitle: 'Youth Cultural Fest 2026',
      eventDate: 'Nov 05, 2026',
      venue: 'National Stadium, Tripureshwor',
    ),
  ];

  static const List<_GalleryAlbum> _allAlbums = [
    _GalleryAlbum(
      id: 'gal-1',
      title: 'Business Summit\n2026',
      count: '45 Photos',
      icon: Icons.work_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=400&q=80',
      category: _GalleryCategory.business,
      eventId: 'ev-2',
    ),
    _GalleryAlbum(
      id: 'gal-2',
      title: 'Heritage Gala\n2026',
      count: '68 Photos',
      icon: Icons.theater_comedy_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=400&q=80',
      category: _GalleryCategory.cultural,
      eventId: 'ev-1',
    ),
    _GalleryAlbum(
      id: 'gal-3',
      title: 'Health & Blood\nDrive',
      count: '32 Photos',
      icon: Icons.volunteer_activism_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=400&q=80',
      category: _GalleryCategory.socialWork,
      eventId: 'ev-4',
    ),
    _GalleryAlbum(
      id: 'gal-4',
      title: 'Youth Cultural\nFest',
      count: '56 Photos',
      icon: Icons.groups_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=400&q=80',
      category: _GalleryCategory.cultural,
      eventId: 'ev-3',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredPhotos = _category == _GalleryCategory.all
        ? _allPhotos
        : _allPhotos.where((p) => p.category == _category).toList();

    final filteredAlbums = _category == _GalleryCategory.all
        ? _allAlbums
        : _allAlbums.where((a) => a.category == _category).toList();

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
          _sectionHeader('Photo Highlights', count: filteredPhotos.length),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: filteredPhotos.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: const Text('No photos found for this category',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredPhotos.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, i) {
                      final photo = filteredPhotos[i];
                      return GestureDetector(
                        onTap: () => _showZoomableLightbox(context, photo),
                        child: _PhotoThumb(photo: photo),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 24),
          _sectionHeader('Recent Albums', count: filteredAlbums.length),
          const SizedBox(height: 12),
          SizedBox(
            height: 195,
            child: filteredAlbums.isEmpty
                ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: const Text('No albums found for this category',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  )
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredAlbums.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final album = filteredAlbums[i];
                      return GestureDetector(
                        onTap: () => context.push('/gallery/${album.id}'),
                        child: _AlbumCard(album: album),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const NASBottomNavBar(activeIndex: 3),
    );
  }

  Widget _sectionHeader(String title, {required int count}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$title ($count)', style: AppText.h2),
        ],
      ),
    );
  }

  void _showZoomableLightbox(BuildContext context, _GalleryPhoto photo) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Bar with Close button
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
                    onPressed: () => Navigator.pop(dialogContext),
                  ),
                ],
              ),
            ),

            // Zoomable Image View (Pinch to zoom / double tap)
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
                      child: CircularProgressIndicator(color: AppColors.accent),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image_rounded, size: 64, color: Colors.white54),
                  ),
                ),
              ),
            ),

            // Event Info Reference Card
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.event_note_rounded, color: AppColors.accent, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          photo.eventTitle,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, color: Colors.white54, size: 12),
                      const SizedBox(width: 4),
                      Text(photo.eventDate, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      const SizedBox(width: 12),
                      const Icon(Icons.location_on_rounded, color: Colors.white54, size: 12),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(photo.venue,
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            context.push('/events/${photo.eventId}');
                          },
                          icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                          label: const Text('View Event Details', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Opening website coverage for ${photo.eventTitle}...')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white38),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                        ),
                        child: const Icon(Icons.language_rounded, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
  final _GalleryPhoto photo;
  const _PhotoThumb({required this.photo});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: photo.url,
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
              child: const Icon(Icons.zoom_in_rounded, size: 12, color: Colors.white),
            ),
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
  final _GalleryAlbum album;
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
