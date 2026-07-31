import 'package:flutter/foundation.dart';

@immutable
class Profile {
  final String id;
  final String fullName;
  final String? email;
  final String? phone;
  final String? address;
  final DateTime? dateOfBirth;
  final String? gender;
  final String role;
  final String? locationId;
  final String membershipType;
  final String membershipStatus;
  final String? avatarUrl;
  final DateTime createdAt;

  const Profile({
    required this.id,
    required this.fullName,
    this.email,
    this.phone,
    this.address,
    this.dateOfBirth,
    this.gender,
    this.role = 'member',
    this.locationId,
    this.membershipType = 'normal',
    this.membershipStatus = 'pending',
    this.avatarUrl,
    required this.createdAt,
  });

  bool get isMember => role == 'member';
  bool get isLocationAdmin => role == 'location_admin';
  bool get isSuperAdmin => role == 'super_admin';
  bool get isActive => membershipStatus == 'active';
  bool get isPending => membershipStatus == 'pending';
  bool get isBusiness => membershipType == 'business';

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      gender: json['gender'] as String?,
      role: json['role'] as String? ?? 'member',
      locationId: json['location_id'] as String?,
      membershipType: json['membership_type'] as String? ?? 'normal',
      membershipStatus: json['membership_status'] as String? ?? 'pending',
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'date_of_birth': dateOfBirth?.toIso8601String().split('T').first,
      'gender': gender,
      'role': role,
      'location_id': locationId,
      'membership_type': membershipType,
      'membership_status': membershipStatus,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Profile copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? address,
    DateTime? dateOfBirth,
    String? gender,
    String? role,
    String? locationId,
    String? membershipType,
    String? membershipStatus,
    String? avatarUrl,
  }) {
    return Profile(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      locationId: locationId ?? this.locationId,
      membershipType: membershipType ?? this.membershipType,
      membershipStatus: membershipStatus ?? this.membershipStatus,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt,
    );
  }
}
