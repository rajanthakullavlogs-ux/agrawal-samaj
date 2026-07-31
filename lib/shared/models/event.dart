import 'package:flutter/foundation.dart';

@immutable
class Event {
  final String id;
  final String? locationId;
  final String title;
  final String? description;
  final String? category;
  final DateTime eventDate;
  final String? eventTime;
  final String? venue;
  final String? organizedBy;
  final String? posterUrl;
  final String status;
  final String? createdBy;
  final DateTime createdAt;

  const Event({
    required this.id,
    this.locationId,
    required this.title,
    this.description,
    this.category,
    required this.eventDate,
    this.eventTime,
    this.venue,
    this.organizedBy,
    this.posterUrl,
    this.status = 'upcoming',
    this.createdBy,
    required this.createdAt,
  });

  bool get isUpcoming => status == 'upcoming';
  bool get isPast => status == 'past';
  bool get isCancelled => status == 'cancelled';

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      locationId: json['location_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
      eventDate: DateTime.parse(json['event_date'] as String),
      eventTime: json['event_time'] as String?,
      venue: json['venue'] as String?,
      organizedBy: json['organized_by'] as String?,
      posterUrl: json['poster_url'] as String?,
      status: json['status'] as String? ?? 'upcoming',
      createdBy: json['created_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location_id': locationId,
      'title': title,
      'description': description,
      'category': category,
      'event_date': eventDate.toIso8601String().split('T').first,
      'event_time': eventTime,
      'venue': venue,
      'organized_by': organizedBy,
      'poster_url': posterUrl,
      'status': status,
      'created_by': createdBy,
    };
  }
}

@immutable
class EventRegistration {
  final String id;
  final String eventId;
  final String? profileId;
  final DateTime registeredAt;
  final String status;

  const EventRegistration({
    required this.id,
    required this.eventId,
    this.profileId,
    required this.registeredAt,
    this.status = 'confirmed',
  });

  factory EventRegistration.fromJson(Map<String, dynamic> json) {
    return EventRegistration(
      id: json['id'] as String,
      eventId: json['event_id'] as String,
      profileId: json['profile_id'] as String?,
      registeredAt: DateTime.parse(json['registered_at'] as String),
      status: json['status'] as String? ?? 'confirmed',
    );
  }
}
