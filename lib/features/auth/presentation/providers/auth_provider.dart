import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/supabase_client.dart';
import '../../../../shared/models/profile.dart';

// ── Storage Keys ────────────────────────────────────────────────
const _kLoggedInKey = 'nas_logged_in';
const _kProfileJsonKey = 'nas_profile_json';

// ── Pre-seeded Demo Profiles ────────────────────────────────────
final Profile demoMemberProfile = Profile(
  id: 'demo-member-001',
  fullName: 'Rajan Thakulla',
  email: 'rajan@agrawalsamaj.org',
  phone: '+977 9841234567',
  address: 'Sinamangal, Kathmandu',
  dateOfBirth: DateTime(1995, 3, 15),
  gender: 'Male',
  role: 'member',
  locationId: 'loc-ktm',
  membershipType: 'normal',
  membershipStatus: 'active',
  avatarUrl: 'assets/images/pagoda_header_bg.png',
  createdAt: DateTime(2024, 1, 15),
);

final Profile demoLocationAdminProfile = Profile(
  id: 'demo-admin-001',
  fullName: 'Suresh Agrawal',
  email: 'suresh.admin@agrawalsamaj.org',
  phone: '+977 9851098765',
  address: 'New Road, Kathmandu',
  dateOfBirth: DateTime(1988, 7, 22),
  gender: 'Male',
  role: 'location_admin',
  locationId: 'loc-ktm',
  membershipType: 'business',
  membershipStatus: 'active',
  avatarUrl: 'assets/images/pagoda_header_bg.png',
  createdAt: DateTime(2023, 6, 1),
);

final Profile demoSuperAdminProfile = Profile(
  id: 'demo-super-001',
  fullName: 'Ramesh Kumar Agrawal',
  email: 'ramesh.ceo@agrawalsamaj.org',
  phone: '+977 9801000001',
  address: 'Durbar Marg, Kathmandu',
  dateOfBirth: DateTime(1975, 11, 5),
  gender: 'Male',
  role: 'super_admin',
  locationId: 'loc-ktm',
  membershipType: 'business',
  membershipStatus: 'active',
  avatarUrl: 'assets/images/pagoda_header_bg.png',
  createdAt: DateTime(2022, 1, 1),
);

Profile? demoProfileForEmail(String email) {
  final e = email.trim().toLowerCase();
  if (e.contains('suresh') || e.contains('admin@') || e.contains('branch')) {
    return demoLocationAdminProfile;
  }
  if (e.contains('ramesh') || e.contains('super') || e.contains('ceo')) {
    return demoSuperAdminProfile;
  }
  return demoMemberProfile;
}

String membershipIdFor(Profile p) {
  if (p.isSuperAdmin) return 'NAS-HQ-2024-0001';
  if (p.isLocationAdmin) return 'NAS-ADM-KTM-001';
  return 'NAS-KTM-2024-00125';
}

String roleBadgeFor(Profile p) {
  if (p.isSuperAdmin) return 'Super Admin';
  if (p.isLocationAdmin) return 'Branch Admin';
  if (p.membershipStatus == 'active') return 'Premium Member';
  return 'Member';
}

// ── Supabase Auth Stream Provider ───────────────────────────────
final authStateProvider = StreamProvider<AuthState>((ref) {
  return SupabaseConfig.client.auth.onAuthStateChange;
});

final currentUserProvider = Provider<User?>((ref) {
  return SupabaseConfig.client.auth.currentUser;
});

// ── Session-Persisted Profile Provider ──────────────────────────
final currentProfileProvider =
    AsyncNotifierProvider<CurrentProfileNotifier, Profile?>(
  CurrentProfileNotifier.new,
);

class CurrentProfileNotifier extends AsyncNotifier<Profile?> {
  @override
  Future<Profile?> build() async {
    // 1. Try Supabase auth first
    final user = SupabaseConfig.client.auth.currentUser;
    if (user != null) {
      try {
        final data = await SupabaseConfig.client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();
        if (data != null) return Profile.fromJson(data);
      } catch (_) {}
    }

    // 2. Fall back to persisted local session
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_kLoggedInKey) ?? false;
    if (!isLoggedIn) return null;

    final jsonStr = prefs.getString(_kProfileJsonKey);
    if (jsonStr != null) {
      try {
        return Profile.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
      } catch (_) {}
    }
    return null;
  }

  /// Login with a profile — persists to SharedPreferences.
  Future<void> login(Profile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedInKey, true);
    await prefs.setString(_kProfileJsonKey, jsonEncode(profile.toJson()));
    state = AsyncData(profile);
  }

  /// Logout — clears persisted session.
  Future<void> logout() async {
    try {
      await SupabaseConfig.client.auth.signOut();
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kLoggedInKey);
    await prefs.remove(_kProfileJsonKey);
    state = const AsyncData(null);
  }

  /// Update the profile in state and storage (e.g. after editing info).
  Future<void> updateProfile(Profile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kProfileJsonKey, jsonEncode(profile.toJson()));
    state = AsyncData(profile);
  }
}

/// Convenience: is any user currently logged in?
final isLoggedInProvider = Provider<bool>((ref) {
  final profile = ref.watch(currentProfileProvider).valueOrNull;
  return profile != null;
});

// ── Auth Repository (Supabase) ──────────────────────────────────
class AuthRepository {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String? locationId,
    String membershipType = 'normal',
  }) async {
    final response = await _client.auth.signUp(email: email, password: password);
    if (response.user != null) {
      try {
        await _client.from('profiles').insert({
          'id': response.user!.id,
          'full_name': fullName,
          'email': email,
          'phone': phone,
          'location_id': locationId,
          'membership_type': membershipType,
          'membership_status': 'pending',
          'role': 'member',
        });
      } catch (_) {}
    }
    return response;
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (_) {}
  }
}

final authRepositoryProvider = Provider<AuthRepository>((_) => AuthRepository());
