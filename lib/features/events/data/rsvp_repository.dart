import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventRsvp {
  final String id;
  final String eventId;
  final String eventName;
  final String? locationId;
  final String userName;
  final String phone;
  final String? email;
  final String userType; // 'Member' or 'Guest'
  final String? avatarUrl;
  final DateTime registeredAt;
  final String eventStatus; // 'ongoing', 'upcoming', 'past'
  final String eventCategory;
  final String eventDateStr;

  const EventRsvp({
    required this.id,
    required this.eventId,
    required this.eventName,
    this.locationId,
    required this.userName,
    required this.phone,
    this.email,
    this.userType = 'Member',
    this.avatarUrl,
    required this.registeredAt,
    this.eventStatus = 'upcoming',
    this.eventCategory = 'General',
    this.eventDateStr = 'Oct 15, 2026',
  });
}

class RsvpNotifier extends StateNotifier<List<EventRsvp>> {
  RsvpNotifier() : super(_initialRsvps);

  void addRsvp(EventRsvp rsvp) {
    state = [rsvp, ...state];
  }
}

final eventRsvpsProvider =
    StateNotifierProvider<RsvpNotifier, List<EventRsvp>>((ref) {
  return RsvpNotifier();
});

final List<EventRsvp> _initialRsvps = [
  EventRsvp(
    id: 'rsvp-1',
    eventId: 'ev-guru',
    eventName: 'Annual Heritage Gala 2026',
    userName: 'Rohit Agrawal',
    phone: '+977 9841234567',
    userType: 'Member',
    avatarUrl: 'https://i.pravatar.cc/150?img=11',
    registeredAt: DateTime.now().subtract(const Duration(hours: 2)),
    eventStatus: 'ongoing',
    eventCategory: 'CULTURAL',
    eventDateStr: 'Oct 15, 2026 • 05:00 PM',
  ),
  EventRsvp(
    id: 'rsvp-2',
    eventId: 'ev-2',
    eventName: 'Entrepreneurship & Trade Summit 2026',
    userName: 'Pooja Agrawal',
    phone: '+977 9808765432',
    userType: 'Guest',
    avatarUrl: 'https://i.pravatar.cc/150?img=5',
    registeredAt: DateTime.now().subtract(const Duration(hours: 5)),
    eventStatus: 'ongoing',
    eventCategory: 'BUSINESS',
    eventDateStr: 'Oct 22, 2026 • 10:00 AM',
  ),
  EventRsvp(
    id: 'rsvp-3',
    eventId: 'ev-1',
    eventName: 'Maharaja Agrasen Jayanti 2026',
    userName: 'Kartik Agrawal',
    phone: '+977 9851122334',
    userType: 'Member',
    avatarUrl: 'https://i.pravatar.cc/150?img=8',
    registeredAt: DateTime.now().subtract(const Duration(days: 1)),
    eventStatus: 'upcoming',
    eventCategory: 'CULTURAL',
    eventDateStr: 'Oct 24, 2026 • 05:00 PM',
  ),
  EventRsvp(
    id: 'rsvp-4',
    eventId: 'ev-youth',
    eventName: 'Youth Cultural Fest 2026',
    userName: 'Sneh Lata Agrawal',
    phone: '+977 9813456789',
    userType: 'Guest',
    avatarUrl: 'https://i.pravatar.cc/150?img=20',
    registeredAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
    eventStatus: 'upcoming',
    eventCategory: 'YOUTH',
    eventDateStr: 'Nov 05, 2026 • 04:00 PM',
  ),
  EventRsvp(
    id: 'rsvp-5',
    eventId: 'ev-guru',
    eventName: 'Annual Heritage Gala 2026',
    userName: 'Sunil Agrawal',
    phone: '+977 9801122445',
    userType: 'Member',
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
    registeredAt: DateTime.now().subtract(const Duration(days: 2)),
    eventStatus: 'ongoing',
    eventCategory: 'CULTURAL',
    eventDateStr: 'Oct 15, 2026 • 05:00 PM',
  ),
  EventRsvp(
    id: 'rsvp-6',
    eventId: 'ev-health',
    eventName: 'Senior Wellness & Health Camp',
    userName: 'Aarti Garg',
    phone: '+977 9841998877',
    userType: 'Guest',
    avatarUrl: 'https://i.pravatar.cc/150?img=25',
    registeredAt: DateTime.now().subtract(const Duration(days: 2, hours: 8)),
    eventStatus: 'upcoming',
    eventCategory: 'HEALTH',
    eventDateStr: 'Oct 28, 2026 • 08:00 AM',
  ),
];
