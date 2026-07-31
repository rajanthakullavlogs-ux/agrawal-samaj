import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/supabase_client.dart';
import '../../shared/models/event.dart';

final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  return EventsRepository();
});

class EventsRepository {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<List<Event>> fetchEvents({String? category}) async {
    try {
      var query = _client.from('events').select();
      if (category != null && category != 'All' && category.isNotEmpty) {
        query = query.eq('category', category);
      }
      final response = await query.order('event_date', ascending: true);
      final list = (response as List).map((e) => Event.fromJson(e)).toList();
      if (list.isNotEmpty) return list;
    } catch (_) {}

    final mockEvents = [
      Event(
        id: 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11',
        title: 'Maharaja Agrasen Jayanti 2024',
        description: 'Join us for a grand cultural celebration featuring bhajans, traditional lamps, prasad distribution, and honoring community elders.',
        category: 'Cultural',
        eventDate: DateTime(2024, 10, 24),
        eventTime: '4:00 PM',
        venue: 'Hotel Annapurna, Kathmandu',
        posterUrl: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=800&q=80',
        organizedBy: 'Central Executive Committee',
        status: 'upcoming',
        createdAt: DateTime(2024, 1, 1),
      ),
      Event(
        id: 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b12',
        title: 'Business Networking Mixer',
        description: 'Empowering Agrawal entrepreneurs across Nepal with strategic business partnerships, mentorship talks, and investment discussions.',
        category: 'Social',
        eventDate: DateTime(2024, 11, 12),
        eventTime: '6:00 PM',
        venue: 'Samaj Bhawan, Birgunj',
        posterUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=800&q=80',
        organizedBy: 'Birgunj Branch Committee',
        status: 'upcoming',
        createdAt: DateTime(2024, 1, 1),
      ),
      Event(
        id: 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b13',
        title: 'Annual Free Health Camp',
        description: 'Free medical checkups, blood donation drive, and health counseling provided by expert doctors for community families and public.',
        category: 'Social',
        eventDate: DateTime(2024, 12, 5),
        eventTime: '9:00 AM',
        venue: 'Civil Hospital, Kathmandu',
        posterUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=800&q=80',
        organizedBy: 'Youth Wing & Health Cell',
        status: 'upcoming',
        createdAt: DateTime(2024, 1, 1),
      ),
    ];

    if (category != null && category != 'All' && category.isNotEmpty) {
      return mockEvents.where((e) => e.category?.toLowerCase() == category.toLowerCase()).toList();
    }

    return mockEvents;
  }

  Future<Event?> fetchEventById(String id) async {
    final list = await fetchEvents();
    try {
      return list.firstWhere((e) => e.id == id);
    } catch (_) {
      return list.first;
    }
  }
}
