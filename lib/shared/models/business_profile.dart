import 'package:flutter/foundation.dart';

@immutable
class BusinessProfile {
  final String profileId;
  final String businessName;
  final String? businessType;
  final String? businessAddress;
  final String? registrationNumber;
  final String? businessPhone;
  final String? businessEmail;

  const BusinessProfile({
    required this.profileId,
    required this.businessName,
    this.businessType,
    this.businessAddress,
    this.registrationNumber,
    this.businessPhone,
    this.businessEmail,
  });

  factory BusinessProfile.fromJson(Map<String, dynamic> json) {
    return BusinessProfile(
      profileId: json['profile_id'] as String,
      businessName: json['business_name'] as String,
      businessType: json['business_type'] as String?,
      businessAddress: json['business_address'] as String?,
      registrationNumber: json['registration_number'] as String?,
      businessPhone: json['business_phone'] as String?,
      businessEmail: json['business_email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile_id': profileId,
      'business_name': businessName,
      'business_type': businessType,
      'business_address': businessAddress,
      'registration_number': registrationNumber,
      'business_phone': businessPhone,
      'business_email': businessEmail,
    };
  }
}
