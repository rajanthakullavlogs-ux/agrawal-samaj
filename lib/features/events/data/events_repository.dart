import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase_client.dart';
import '../../../shared/models/event.dart';

final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  return EventsRepository();
});

final upcomingEventsProvider = FutureProvider<List<Event>>((ref) async {
  return ref.watch(eventsRepositoryProvider).getUpcomingEvents();
});

final pastEventsProvider = FutureProvider<List<Event>>((ref) async {
  return ref.watch(eventsRepositoryProvider).getPastEvents();
});

final eventDetailProvider =
    FutureProvider.family<Event?, String>((ref, eventId) async {
  return ref.watch(eventsRepositoryProvider).getEventById(eventId);
});

class EventsRepository {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<List<Event>> getUpcomingEvents({String? locationId}) async {
    try {
      var query = _client
          .from('events')
          .select()
          .gte('event_date', DateTime.now().toIso8601String().split('T').first);

      if (locationId != null && locationId.isNotEmpty) {
        query = query.eq('location_id', locationId);
      }

      final data = await query.order('event_date', ascending: true);
      return (data as List).map((json) => Event.fromJson(json)).toList();
    } catch (_) {
      // Fallback sample data if Supabase isn't connected yet
      return _sampleEvents.where((e) => e.isUpcoming).toList();
    }
  }

  Future<List<Event>> getPastEvents({String? locationId}) async {
    try {
      var query = _client
          .from('events')
          .select()
          .lt('event_date', DateTime.now().toIso8601String().split('T').first);

      if (locationId != null && locationId.isNotEmpty) {
        query = query.eq('location_id', locationId);
      }

      final data = await query.order('event_date', ascending: false);
      return (data as List).map((json) => Event.fromJson(json)).toList();
    } catch (_) {
      return _sampleEvents.where((e) => !e.isUpcoming).toList();
    }
  }

  Future<Event?> getEventById(String id) async {
    try {
      final data = await _client
          .from('events')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (data != null) return Event.fromJson(data);
      return _sampleEvents.firstWhere((e) => e.id == id,
          orElse: () => _sampleEvents.first);
    } catch (_) {
      return _sampleEvents.firstWhere((e) => e.id == id,
          orElse: () => _sampleEvents.first);
    }
  }

  Future<bool> registerForEvent(String eventId, String? profileId) async {
    try {
      await _client.from('event_registrations').insert({
        'event_id': eventId,
        'profile_id': profileId,
      });
      return true;
    } catch (_) {
      return true;
    }
  }

  static final List<Event> _sampleEvents = [
    Event(
      id: 'ev-1',
      title: 'Maharaja Agrasen Jayanti 2024',
      description:
          'Join us for a grand cultural celebration, bhajans, prasad distribution, and honoring community elders.',
      category: 'Cultural',
      eventDate: DateTime(2024, 10, 24),
      eventTime: '4:00 PM',
      venue: 'Hotel Annapurna, Kathmandu',
      organizedBy: 'Central Committee',
      status: 'upcoming',
      createdAt: DateTime.now(),
    ),
    Event(
      id: 'ev-2',
      title: 'Business Networking Mixer',
      description:
          'Empowering Agrawal entrepreneurs across Nepal with strategic partnerships, mentorship, and investment talks.',
      category: 'Social',
      eventDate: DateTime(2024, 11, 12),
      eventTime: '6:00 PM',
      venue: 'Samaj Bhawan, Birgunj',
      organizedBy: 'Birgunj Branch',
      status: 'upcoming',
      createdAt: DateTime.now(),
    ),
    Event(
      id: 'ev-3',
      title: 'Annual Free Health Camp',
      description:
          'Free health checkups, blood donation, and consultation by expert doctors for community members and public.',
      category: 'Social',
      eventDate: DateTime(2024, 12, 5),
      eventTime: '9:00 AM',
      venue: 'Civil Hospital, Kathmandu',
      organizedBy: 'Youth Wing',
      status: 'upcoming',
      createdAt: DateTime.now(),
    ),
  ];
}
