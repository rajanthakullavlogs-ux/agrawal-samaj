import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase_client.dart';
import '../../../shared/models/location.dart';

final locationsRepositoryProvider = Provider<LocationsRepository>((ref) {
  return LocationsRepository();
});

final locationsProvider = FutureProvider<List<Location>>((ref) async {
  return ref.watch(locationsRepositoryProvider).getLocations();
});

final locationDetailProvider =
    FutureProvider.family<Location?, String>((ref, locationId) async {
  return ref.watch(locationsRepositoryProvider).getLocationById(locationId);
});

class LocationsRepository {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<List<Location>> getLocations() async {
    try {
      final data = await _client
          .from('locations')
          .select()
          .order('name', ascending: true);

      return (data as List).map((json) => Location.fromJson(json)).toList();
    } catch (_) {
      return _sampleLocations;
    }
  }

  Future<Location?> getLocationById(String id) async {
    try {
      final data = await _client
          .from('locations')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (data != null) return Location.fromJson(data);
      return _sampleLocations.firstWhere((l) => l.id == id,
          orElse: () => _sampleLocations.first);
    } catch (_) {
      return _sampleLocations.firstWhere((l) => l.id == id,
          orElse: () => _sampleLocations.first);
    }
  }

  static final List<Location> _sampleLocations = [
    Location(
      id: 'loc-1',
      name: 'Kathmandu Chapter',
      province: 'Bagmati Province',
      intro:
          'Central chapter overseeing national initiatives, Samaj Bhawan administration, and cultural festivals.',
      officeAddress: 'Kamaladi, Kathmandu',
      latitude: 27.7172,
      longitude: 85.3240,
      totalMembers: 2100,
      status: 'active',
      contactPhone: '+977 1 4220000',
      contactEmail: 'kathmandu@agrawalsamaj.org.np',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Location(
      id: 'loc-2',
      name: 'Birgunj Chapter',
      province: 'Madhesh Province',
      intro:
          'Leading industrial and trade hub chapter with active business networking and community welfare projects.',
      officeAddress: 'Main Road, Birgunj',
      latitude: 27.0126,
      longitude: 84.8770,
      totalMembers: 1450,
      status: 'active',
      contactPhone: '+977 51 520000',
      contactEmail: 'birgunj@agrawalsamaj.org.np',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Location(
      id: 'loc-3',
      name: 'Biratnagar Chapter',
      province: 'Koshi Province',
      intro:
          'Eastern zone chapter supporting local enterprise, educational scholarships, and healthcare camps.',
      officeAddress: 'Traffic Chowk, Biratnagar',
      latitude: 26.4525,
      longitude: 87.2718,
      totalMembers: 980,
      status: 'active',
      contactPhone: '+977 21 530000',
      contactEmail: 'biratnagar@agrawalsamaj.org.np',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Location(
      id: 'loc-4',
      name: 'Pokhara Chapter',
      province: 'Gandaki Province',
      intro:
          'Gandaki region chapter focused on tourism, youth activities, and preservation of Agrawal heritage.',
      officeAddress: 'New Road, Pokhara',
      latitude: 28.2096,
      longitude: 83.9856,
      totalMembers: 620,
      status: 'active',
      contactPhone: '+977 61 540000',
      contactEmail: 'pokhara@agrawalsamaj.org.np',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];
}
