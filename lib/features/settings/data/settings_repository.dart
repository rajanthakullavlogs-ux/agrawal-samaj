import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase_client.dart';

class BranchSettingsModel {
  final String branchName;
  final String mission;
  final String phone;
  final String email;
  final String website;
  final String address;
  final String leaderName;
  final String leaderBio;

  const BranchSettingsModel({
    required this.branchName,
    required this.mission,
    required this.phone,
    required this.email,
    required this.website,
    required this.address,
    required this.leaderName,
    required this.leaderBio,
  });

  BranchSettingsModel copyWith({
    String? branchName,
    String? mission,
    String? phone,
    String? email,
    String? website,
    String? address,
    String? leaderName,
    String? leaderBio,
  }) {
    return BranchSettingsModel(
      branchName: branchName ?? this.branchName,
      mission: mission ?? this.mission,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      address: address ?? this.address,
      leaderName: leaderName ?? this.leaderName,
      leaderBio: leaderBio ?? this.leaderBio,
    );
  }
}

class BranchSettingsNotifier extends StateNotifier<BranchSettingsModel> {
  BranchSettingsNotifier()
      : super(const BranchSettingsModel(
          branchName: 'Kathmandu Central Branch',
          mission:
              'Dedicated to preserving the Agrawal heritage in Nepal, providing unity, business networking, and social welfare.',
          phone: '+977-1-4423XXX',
          email: 'kathmandu@nepalagrawal.org',
          website: 'https://kathmandu.agrawalsamaj.org.np',
          address: 'Kamaladi, Kathmandu, Ward No. 28',
          leaderName: 'Shree Ram Agrawal',
          leaderBio:
              'Respected entrepreneur and community activist with 30+ years in trade and philanthropy.',
        ));

  void updateSettings(BranchSettingsModel newSettings) {
    state = newSettings;
    try {
      SupabaseConfig.client.from('locations').update({
        'name': newSettings.branchName,
        'intro': newSettings.mission,
        'contact_phone': newSettings.phone,
        'contact_email': newSettings.email,
        'office_address': newSettings.address,
      }).eq('id', '11111111-1111-1111-1111-111111111111');
    } catch (_) {}
  }
}

final branchSettingsNotifierProvider =
    StateNotifierProvider<BranchSettingsNotifier, BranchSettingsModel>((ref) {
  return BranchSettingsNotifier();
});
