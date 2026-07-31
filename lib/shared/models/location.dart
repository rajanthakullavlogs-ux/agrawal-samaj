import 'package:flutter/foundation.dart';

@immutable
class Location {
  final String id;
  final String name;
  final String province;
  final String? intro;
  final String? officeAddress;
  final double? latitude;
  final double? longitude;
  final String? leaderProfileId;
  final int totalMembers;
  final String status;
  final String? achievements;
  final String? contactPhone;
  final String? contactEmail;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Location({
    required this.id,
    required this.name,
    required this.province,
    this.intro,
    this.officeAddress,
    this.latitude,
    this.longitude,
    this.leaderProfileId,
    this.totalMembers = 0,
    this.status = 'active',
    this.achievements,
    this.contactPhone,
    this.contactEmail,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isActive => status == 'active';
  bool get hasCoordinates => latitude != null && longitude != null;

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as String,
      name: json['name'] as String,
      province: json['province'] as String,
      intro: json['intro'] as String?,
      officeAddress: json['office_address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      leaderProfileId: json['leader_profile_id'] as String?,
      totalMembers: json['total_members'] as int? ?? 0,
      status: json['status'] as String? ?? 'active',
      achievements: json['achievements'] as String?,
      contactPhone: json['contact_phone'] as String?,
      contactEmail: json['contact_email'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'province': province,
      'intro': intro,
      'office_address': officeAddress,
      'latitude': latitude,
      'longitude': longitude,
      'leader_profile_id': leaderProfileId,
      'total_members': totalMembers,
      'status': status,
      'achievements': achievements,
      'contact_phone': contactPhone,
      'contact_email': contactEmail,
    };
  }
}
