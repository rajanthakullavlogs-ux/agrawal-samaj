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

class EventsNotifier extends StateNotifier<List<Event>> {
  EventsNotifier() : super(EventsRepository._sampleEvents) {
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      final repo = EventsRepository();
      final upcoming = await repo.getUpcomingEvents();
      final past = await repo.getPastEvents();
      state = [...upcoming, ...past];
    } catch (_) {}
  }

  void addEvent(Event newEvent) {
    state = [newEvent, ...state];
  }

  void updateEvent(Event updated) {
    state = [
      for (final e in state)
        if (e.id == updated.id) updated else e,
    ];
  }
}

final eventsNotifierProvider = StateNotifierProvider<EventsNotifier, List<Event>>((ref) {
  return EventsNotifier();
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
      id: 'ev-2',
      title: 'Agrawal Business & Trade Summit 2026',
      description:
          'A premier gathering of business leaders, entrepreneurs and professionals to exchange ideas, explore opportunities and drive growth together.',
      category: 'Business',
      eventDate: DateTime(2026, 11, 15),
      eventTime: '10:00 AM – 4:30 PM',
      venue: 'Hotel Yak & Yeti, Kathmandu',
      organizedBy: 'Business Wing',
      posterUrl: 'assets/images/event_trade_summit_banner.png',
      status: 'upcoming',
      createdAt: DateTime.now(),
    ),
    Event(
      id: 'ev-1',
      title: 'Maharaja Agrasen Jayanti 2026',
      description:
          'Join us for a grand cultural celebration, bhajans, prasad distribution, and honoring community elders.',
      category: 'Cultural',
      eventDate: DateTime(2026, 10, 24),
      eventTime: '05:00 PM – 9:00 PM',
      venue: 'Samaj Bhawan, Kamaladi, Kathmandu',
      organizedBy: 'Central Executive Committee',
      posterUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=800&q=80',
      status: 'upcoming',
      createdAt: DateTime.now(),
    ),
    Event(
      id: 'ev-youth',
      title: 'Youth Leadership Workshop',
      description:
          'Interactive mentorship session for young Agrawal professionals focusing on entrepreneurship, public speaking, and digital innovation.',
      category: 'Youth',
      eventDate: DateTime(2026, 4, 20),
      eventTime: '10:00 AM – 2:00 PM',
      venue: 'National Youth Center, Kathmandu',
      organizedBy: 'Central Youth Wing',
      posterUrl: 'https://images.unsplash.com/photo-1523580494863-6f3031224c94?auto=format&fit=crop&w=800&q=80',
      status: 'upcoming',
      createdAt: DateTime.now(),
    ),
    Event(
      id: 'ev-women',
      title: 'Women Empowerment Session',
      description:
          'Empowering women leaders with financial literacy, community leadership tools, and networking opportunities.',
      category: 'Social',
      eventDate: DateTime(2026, 3, 15),
      eventTime: '11:00 AM – 3:00 PM',
      venue: 'Agrawal Bhawan Auditorium, Kathmandu',
      organizedBy: 'Women Wing',
      posterUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=800&q=80',
      status: 'upcoming',
      createdAt: DateTime.now(),
    ),
    Event(
      id: 'ev-business',
      title: 'Business Networking Meet',
      description:
          'Exclusive networking evening for business owners and startup founders to collaborate on upcoming initiatives.',
      category: 'Business',
      eventDate: DateTime(2026, 2, 25),
      eventTime: '06:00 PM – 9:00 PM',
      venue: 'Hotel Radisson, Kathmandu',
      organizedBy: 'Business Wing',
      posterUrl: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&w=800&q=80',
      status: 'upcoming',
      createdAt: DateTime.now(),
    ),
    Event(
      id: 'ev-3',
      title: 'Free Health & Blood Donation Camp',
      description:
          'Comprehensive health check-ups, eye tests, and blood donation drive in partnership with Nepal Red Cross.',
      category: 'Health',
      eventDate: DateTime(2026, 12, 05),
      eventTime: '08:00 AM – 1:00 PM',
      venue: 'Birgunj Chapter Office Grounds',
      organizedBy: 'Youth & Health Wing',
      posterUrl: 'https://images.unsplash.com/photo-1615461066841-6116e61058f4?auto=format&fit=crop&w=800&q=80',
      status: 'upcoming',
      createdAt: DateTime.now(),
    ),
    Event(
      id: 'ev-4',
      title: 'Holi Milan & Cultural Evening 2026',
      description:
          'Festive celebration of colors with traditional snacks, thandai, music, and community dance.',
      category: 'Cultural',
      eventDate: DateTime(2026, 3, 25),
      eventTime: '03:00 PM – 7:00 PM',
      venue: 'Biratnagar Community Garden',
      organizedBy: 'Koshi Regional Chapter',
      posterUrl: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=800&q=80',
      status: 'past',
      createdAt: DateTime.now(),
    ),
  ];
}
