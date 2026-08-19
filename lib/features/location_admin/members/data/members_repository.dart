import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/supabase_client.dart';

class MemberItem {
  final String id;
  final String name;
  final String status; // ACTIVE, PENDING, INACTIVE
  final String memberType; // Lifetime Member, Standard Member, Trustee Member
  final String location;
  final String phone;
  final String email;
  final Color avatarBg;
  final Color avatarColor;

  const MemberItem({
    required this.id,
    required this.name,
    required this.status,
    required this.memberType,
    required this.location,
    required this.phone,
    required this.email,
    required this.avatarBg,
    required this.avatarColor,
  });

  MemberItem copyWith({
    String? id,
    String? name,
    String? status,
    String? memberType,
    String? location,
    String? phone,
    String? email,
    Color? avatarBg,
    Color? avatarColor,
  }) {
    return MemberItem(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      memberType: memberType ?? this.memberType,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarBg: avatarBg ?? this.avatarBg,
      avatarColor: avatarColor ?? this.avatarColor,
    );
  }

  factory MemberItem.fromJson(Map<String, dynamic> json) {
    final status = (json['membership_status'] ?? 'pending').toString().toUpperCase();
    final type = (json['membership_type'] ?? 'normal').toString() == 'business' ? 'Trustee Member' : 'Lifetime Member';
    return MemberItem(
      id: json['id']?.toString().substring(0, 8) ?? 'NAS-${json['hashCode']}',
      name: json['full_name'] ?? 'Agrawal Member',
      status: status,
      memberType: type,
      location: json['address'] ?? 'Kathmandu',
      phone: json['phone'] ?? '+977-98510XXXXX',
      email: json['email'] ?? 'member@agrawal.org',
      avatarBg: status == 'PENDING' ? const Color(0xFFFCEAE0) : const Color(0xFFE3EEFD),
      avatarColor: status == 'PENDING' ? const Color(0xFFE8622C) : const Color(0xFF2E6FE0),
    );
  }
}

class MembersNotifier extends StateNotifier<List<MemberItem>> {
  MembersNotifier() : super(_initialMembers) {
    fetchMembersFromSupabase();
  }

  static const List<MemberItem> _initialMembers = [
    MemberItem(
      id: 'NAS-4492',
      name: 'Rahul Agrawal',
      status: 'ACTIVE',
      memberType: 'Lifetime Member',
      location: 'Kathmandu',
      phone: '+977-98510XXXXX',
      email: 'rahul@agrawal.org',
      avatarBg: Color(0xFFE3EEFD),
      avatarColor: Color(0xFF2E6FE0),
    ),
    MemberItem(
      id: 'NAS-9021',
      name: 'Sneha Mittal',
      status: 'PENDING',
      memberType: 'Standard Member',
      location: 'Kathmandu',
      phone: '+977-98412XXXXX',
      email: 'sneha.m@gmail.com',
      avatarBg: Color(0xFFFCEAE0),
      avatarColor: Color(0xFFE8622C),
    ),
    MemberItem(
      id: 'NAS-1205',
      name: 'Deepak Goyal',
      status: 'ACTIVE',
      memberType: 'Trustee Member',
      location: 'Kathmandu',
      phone: '+977-98011XXXXX',
      email: 'deepak.goyal@nabil.com',
      avatarBg: Color(0xFFE5F5E9),
      avatarColor: Color(0xFF3E7C4A),
    ),
    MemberItem(
      id: 'NAS-5510',
      name: 'Vikram Bansal',
      status: 'INACTIVE',
      memberType: 'Standard Member',
      location: 'Kathmandu',
      phone: '+977-98600XXXXX',
      email: 'vikram.bansal@gmail.com',
      avatarBg: Color(0xFFEFE7FB),
      avatarColor: Color(0xFF7B4FD6),
    ),
    MemberItem(
      id: 'NAS-3301',
      name: 'Pooja Agrawal',
      status: 'PENDING',
      memberType: 'Lifetime Member',
      location: 'Kathmandu',
      phone: '+977-98130XXXXX',
      email: 'pooja.a@agrawal.org',
      avatarBg: Color(0xFFFCEAE0),
      avatarColor: Color(0xFFE8622C),
    ),
  ];

  Future<void> fetchMembersFromSupabase() async {
    try {
      final response = await SupabaseConfig.client.from('profiles').select().order('created_at', ascending: false);
      if ((response as List).isNotEmpty) {
        final list = (response as List).map((j) => MemberItem.fromJson(j)).toList();
        state = list;
      }
    } catch (_) {
      // Retain reactive initial members if Supabase is offline/unseeded
    }
  }

  void approveMember(String memberId) {
    state = [
      for (final m in state)
        if (m.id == memberId)
          m.copyWith(
            status: 'ACTIVE',
            avatarBg: const Color(0xFFE5F5E9),
            avatarColor: const Color(0xFF3E7C4A),
          )
        else
          m,
    ];
  }

  void rejectMember(String memberId) {
    state = state.where((m) => m.id != memberId).toList();
  }

  void addMember(MemberItem newMember) {
    state = [newMember, ...state];
  }
}

final membersNotifierProvider = StateNotifierProvider<MembersNotifier, List<MemberItem>>((ref) {
  return MembersNotifier();
});
