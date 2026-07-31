import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(NASSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 64, color: Colors.white54),
              ),
            ),
            if (caption != null) ...[
              const SizedBox(height: NASSpacing.sm),
              Padding(
                padding: const EdgeInsets.all(NASSpacing.sm),
                child: Text(
                  caption,
                  style: NASTypography.bodyMd.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
