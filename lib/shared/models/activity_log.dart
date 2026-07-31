import 'package:flutter/foundation.dart';

@immutable
class ActivityLog {
  final String id;
  final String? actorId;
  final String? locationId;
  final String action;
  final Map<String, dynamic>? details;
  final DateTime createdAt;

  const ActivityLog({
    required this.id,
    this.actorId,
    this.locationId,
    required this.action,
    this.details,
    required this.createdAt,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json['id'] as String,
      actorId: json['actor_id'] as String?,
      locationId: json['location_id'] as String?,
      action: json['action'] as String,
      details: json['details'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'actor_id': actorId,
      'location_id': locationId,
      'action': action,
      'details': details,
    };
  }
}
