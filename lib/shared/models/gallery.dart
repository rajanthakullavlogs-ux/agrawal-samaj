import 'package:flutter/foundation.dart';

@immutable
class Gallery {
  final String id;
  final String? locationId;
  final String? eventId;
  final String? title;
  final String? category;
  final String? description;
  final String? coverPhotoUrl;
  final int photoCount;
  final DateTime createdAt;

  const Gallery({
    required this.id,
    this.locationId,
    this.eventId,
    this.title,
    this.category,
    this.description,
    this.coverPhotoUrl,
    this.photoCount = 0,
    required this.createdAt,
  });

  factory Gallery.fromJson(Map<String, dynamic> json) {
    return Gallery(
      id: json['id'] as String,
      locationId: json['location_id'] as String?,
      eventId: json['event_id'] as String?,
      title: json['title'] as String?,
      category: json['category'] as String?,
      description: json['description'] as String?,
      coverPhotoUrl: json['cover_photo_url'] as String?,
      photoCount: json['photo_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location_id': locationId,
      'event_id': eventId,
      'title': title,
      'category': category,
      'description': description,
      'cover_photo_url': coverPhotoUrl,
      'photo_count': photoCount,
    };
  }
}

@immutable
class GalleryPhoto {
  final String id;
  final String galleryId;
  final String photoUrl;
  final String? caption;
  final int sortOrder;

  const GalleryPhoto({
    required this.id,
    required this.galleryId,
    required this.photoUrl,
    this.caption,
    this.sortOrder = 0,
  });

  factory GalleryPhoto.fromJson(Map<String, dynamic> json) {
    return GalleryPhoto(
      id: json['id'] as String,
      galleryId: json['gallery_id'] as String,
      photoUrl: json['photo_url'] as String,
      caption: json['caption'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gallery_id': galleryId,
      'photo_url': photoUrl,
      'caption': caption,
      'sort_order': sortOrder,
    };
  }
}
