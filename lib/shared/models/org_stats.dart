import 'package:flutter/foundation.dart';

@immutable
class OrgStats {
  final int activeMembers;
  final int activeLocations;
  final int upcomingEvents;
  final int galleryCount;

  const OrgStats({
    this.activeMembers = 0,
    this.activeLocations = 0,
    this.upcomingEvents = 0,
    this.galleryCount = 0,
  });

  factory OrgStats.fromJson(Map<String, dynamic> json) {
    return OrgStats(
      activeMembers: json['active_members'] as int? ?? 0,
      activeLocations: json['active_locations'] as int? ?? 0,
      upcomingEvents: json['upcoming_events'] as int? ?? 0,
      galleryCount: json['gallery_count'] as int? ?? 0,
    );
  }
}
