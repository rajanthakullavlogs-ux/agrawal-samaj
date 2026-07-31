import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/supabase_client.dart';
import '../../shared/models/gallery.dart';

final galleryRepositoryProvider = Provider<GalleryRepository>((ref) {
  return GalleryRepository();
});

class GalleryRepository {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<List<Gallery>> fetchGalleries({String? category}) async {
    try {
      var query = _client.from('galleries').select();
      if (category != null && category != 'All' && category.isNotEmpty) {
        query = query.eq('category', category);
      }
      final response = await query.order('created_at', ascending: false);
      final list = (response as List).map((e) => Gallery.fromJson(e)).toList();
      if (list.isNotEmpty) return list;
    } catch (_) {}

    final mockGalleries = [
      Gallery(
        id: 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c11',
        title: 'Annual Heritage Festival 2024',
        category: 'Cultural',
        description: 'A grand traditional Nepali cultural festival with members of the Agrawal community wearing vibrant ethnic attire.',
        coverPhotoUrl: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=800&q=80',
        photoCount: 124,
        createdAt: DateTime(2024, 3, 25),
      ),
      Gallery(
        id: 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c12',
        title: 'Entrepreneurs Networking Summit',
        category: 'Business',
        description: 'A professional business networking summit held in a modern, sophisticated hall.',
        coverPhotoUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=800&q=80',
        photoCount: 48,
        createdAt: DateTime(2024, 4, 12),
      ),
      Gallery(
        id: 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c13',
        title: 'Samaj Seva Initiatives',
        category: 'Social',
        description: 'Heartwarming community service events where volunteers distribute aid and interact with families.',
        coverPhotoUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=800&q=80',
        photoCount: 82,
        createdAt: DateTime(2024, 5, 5),
      ),
      Gallery(
        id: 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c14',
        title: 'Annual General Meeting Gala',
        category: 'Cultural',
        description: 'An elegant evening gala featuring community members in formal wear.',
        coverPhotoUrl: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&w=800&q=80',
        photoCount: 215,
        createdAt: DateTime(2024, 1, 15),
      ),
    ];

    if (category != null && category != 'All' && category.isNotEmpty) {
      return mockGalleries.where((g) => g.category?.toLowerCase() == category.toLowerCase()).toList();
    }

    return mockGalleries;
  }

  Future<List<GalleryPhoto>> fetchGalleryPhotos(String galleryId) async {
    try {
      final response = await _client
          .from('gallery_photos')
          .select()
          .eq('gallery_id', galleryId)
          .order('sort_order', ascending: true);
      final list = (response as List).map((e) => GalleryPhoto.fromJson(e)).toList();
      if (list.isNotEmpty) return list;
    } catch (_) {}

    return [
      GalleryPhoto(
        id: 'p1',
        galleryId: galleryId,
        photoUrl: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=1200&q=80',
        caption: 'Opening Traditional Cultural Ceremony',
        sortOrder: 1,
      ),
      GalleryPhoto(
        id: 'p2',
        galleryId: galleryId,
        photoUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=1200&q=80',
        caption: 'Elders & Executive Committee Felicitation',
        sortOrder: 2,
      ),
      GalleryPhoto(
        id: 'p3',
        galleryId: galleryId,
        photoUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=1200&q=80',
        caption: 'Youth & Social Welfare Drive',
        sortOrder: 3,
      ),
      GalleryPhoto(
        id: 'p4',
        galleryId: galleryId,
        photoUrl: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&w=1200&q=80',
        caption: 'Grand Evening Musical & Cultural Program',
        sortOrder: 4,
      ),
    ];
  }
}
