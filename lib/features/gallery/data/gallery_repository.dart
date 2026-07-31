import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase_client.dart';
import '../../../shared/models/gallery.dart';

final galleryRepositoryProvider = Provider<GalleryRepository>((ref) {
  return GalleryRepository();
});

final galleriesProvider = FutureProvider<List<Gallery>>((ref) async {
  return ref.watch(galleryRepositoryProvider).getGalleries();
});

final galleryPhotosProvider =
    FutureProvider.family<List<GalleryPhoto>, String>((ref, galleryId) async {
  return ref.watch(galleryRepositoryProvider).getGalleryPhotos(galleryId);
});

class GalleryRepository {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<List<Gallery>> getGalleries({String? locationId}) async {
    try {
      var query = _client.from('galleries').select();
      if (locationId != null && locationId.isNotEmpty) {
        query = query.eq('location_id', locationId);
      }

      final data = await query.order('created_at', ascending: false);
      return (data as List).map((json) => Gallery.fromJson(json)).toList();
    } catch (_) {
      return _sampleGalleries;
    }
  }

  Future<List<GalleryPhoto>> getGalleryPhotos(String galleryId) async {
    try {
      final data = await _client
          .from('gallery_photos')
          .select()
          .eq('gallery_id', galleryId)
          .order('sort_order', ascending: true);

      return (data as List).map((json) => GalleryPhoto.fromJson(json)).toList();
    } catch (_) {
      return _samplePhotos.where((p) => p.galleryId == galleryId).toList();
    }
  }

  static final List<Gallery> _sampleGalleries = [
    Gallery(
      id: 'gal-1',
      title: 'Holi Milan Samaroh 2024',
      category: 'Cultural',
      description: 'Photos from the vibrant Holi celebrations in Kathmandu.',
      photoCount: 12,
      createdAt: DateTime.now(),
    ),
    Gallery(
      id: 'gal-2',
      title: 'Business Summit 2023',
      category: 'Business',
      description: 'Highlights from the annual business leadership forum.',
      photoCount: 8,
      createdAt: DateTime.now(),
    ),
    Gallery(
      id: 'gal-3',
      title: 'Youth Sports Meet',
      category: 'Sports',
      description: 'Cricket and badminton tournament highlights.',
      photoCount: 15,
      createdAt: DateTime.now(),
    ),
  ];

  static final List<GalleryPhoto> _samplePhotos = [
    const GalleryPhoto(
      id: 'p-1',
      galleryId: 'gal-1',
      photoUrl: 'https://picsum.photos/800/600?random=1',
      caption: 'Opening Cultural Program',
      sortOrder: 1,
    ),
    const GalleryPhoto(
      id: 'p-2',
      galleryId: 'gal-1',
      photoUrl: 'https://picsum.photos/800/600?random=2',
      caption: 'Community Gathering',
      sortOrder: 2,
    ),
    const GalleryPhoto(
      id: 'p-3',
      galleryId: 'gal-1',
      photoUrl: 'https://picsum.photos/800/600?random=3',
      caption: 'Felicitation Ceremony',
      sortOrder: 3,
    ),
  ];
}
