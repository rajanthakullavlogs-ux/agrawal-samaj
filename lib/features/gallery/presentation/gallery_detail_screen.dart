import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/gallery_repository.dart';

/// A6 — Gallery Detail Screen (Public Site)
/// Matches design a6._gallery_detail_public_site/screen.png:
/// - Header with album title & photo count
/// - Photo grid (responsive thumbnails)
/// - Tap to view high-res photo modal / lightbox
/// - Footer
class GalleryDetailScreen extends ConsumerWidget {
  final String galleryId;

  const GalleryDetailScreen({super.key, required this.galleryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photosAsync = ref.watch(galleryPhotosProvider(galleryId));

    return Scaffold(
      appBar: const NASAppBar(title: 'Album View', showBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NASContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: NASSpacing.md),
                  Text(
                    'Holi Milan Samaroh 2024',
                    style: NASTypography.headlineMd.copyWith(
                      color: NASColors.primary,
                      fontFamily: NASTypography.headlineFont,
                    ),
                  ),
                  const SizedBox(height: NASSpacing.xs),
                  Text(
                    'Photos from the vibrant Holi celebrations in Kathmandu.',
                    style: NASTypography.bodyMd.copyWith(
                      color: NASColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  // Photos Grid
                  photosAsync.when(
                    data: (photos) {
                      if (photos.isEmpty) {
                        return const NASEmptyState(
                          icon: Icons.photo_outlined,
                          title: 'No photos in this album',
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: NASSpacing.xs,
                          crossAxisSpacing: NASSpacing.xs,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: photos.length,
                        itemBuilder: (context, index) {
                          final photo = photos[index];
                          return GestureDetector(
                            onTap: () => _showLightbox(context, photo.photoUrl, photo.caption),
                            child: ClipRRect(
                              borderRadius: NASRadius.defaultBorderRadius,
                              child: Container(
                                color: NASColors.surfaceVariant,
                                child: CachedNetworkImage(
                                  imageUrl: photo.photoUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(strokeWidth: 2, color: NASColors.primary),
                                  ),
                                  errorWidget: (context, url, error) => const Center(
                                    child: Icon(Icons.image, color: NASColors.outline),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => NASLoadingSkeleton.grid(count: 6),
                    error: (_, _) => const NASEmptyState(title: 'Failed to load photos'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: NASSpacing.xl),
            const NASFooter(),
          ],
        ),
      ),
    );
  }

  void _showLightbox(BuildContext context, String url, String? caption) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(NASSpacing.sm),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(NASRadius.md)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(dialogContext),
              ),
            ),
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 450),
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image, size: 64, color: Colors.white54),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(NASRadius.md),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    caption ?? 'Holi Milan Samaroh 2024 Celebration',
                    style: NASTypography.bodyMd.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            context.push('/events/ev-1');
                          },
                          icon: const Icon(Icons.event_note_rounded, size: 16),
                          label: const Text('View Related Event', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: NASColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Opening event web coverage...')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white38),
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
