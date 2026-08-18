import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/models/event.dart';
import '../../../../shared/widgets/nas_logo.dart';
import '../../../events/data/events_repository.dart';

/// B3 — Events Management Screen (Location Admin)
class EventsManagementScreen extends ConsumerStatefulWidget {
  const EventsManagementScreen({super.key});

  @override
  ConsumerState<EventsManagementScreen> createState() => _EventsManagementScreenState();
}

enum _EventFilter { all, upcoming, cultural, business, past }

class _EventsManagementScreenState extends ConsumerState<EventsManagementScreen> {
  _EventFilter _filter = _EventFilter.all;

  static const _eventsList = [
    (
      title: 'Annual Heritage Gala 2026',
      category: 'CULTURAL',
      venue: 'Hotel Yak & Yeti, Kathmandu',
      registered: 1240,
      date: 'Oct 15, 2026',
      time: '05:00 PM',
      isFeatured: true,
      status: 'ACTIVE',
    ),
    (
      title: 'Entrepreneurship & Trade Summit',
      category: 'BUSINESS',
      venue: 'Samaj Hall, Kamaladi',
      registered: 84,
      date: 'Oct 22, 2026',
      time: '10:00 AM',
      isFeatured: false,
      status: 'UPCOMING',
    ),
    (
      title: 'Youth Cultural Fest 2026',
      category: 'YOUTH',
      venue: 'National Stadium, Tripureshwor',
      registered: 312,
      date: 'Nov 05, 2026',
      time: '04:00 PM',
      isFeatured: false,
      status: 'UPCOMING',
    ),
    (
      title: 'Senior Wellness & Health Camp',
      category: 'HEALTH',
      venue: 'Central Clinic Wing, Kathmandu',
      registered: 45,
      date: 'Oct 28, 2026',
      time: '08:00 AM',
      isFeatured: false,
      status: 'UPCOMING',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(eventsNotifierProvider);
    final totalEvents = events.length;
    final activeEvents = events.where((e) => e.isUpcoming).length;

    final filtered = _eventsList.where((e) {
      switch (_filter) {
        case _EventFilter.all:
          return true;
        case _EventFilter.upcoming:
          return e.status == 'UPCOMING' || e.status == 'ACTIVE';
        case _EventFilter.cultural:
          return e.category == 'CULTURAL';
        case _EventFilter.business:
          return e.category == 'BUSINESS';
        case _EventFilter.past:
          return e.status == 'PAST';
      }
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            const _AdminTopBar(),
            const SizedBox(height: 14),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _HeroBanner(),
            ),
            const SizedBox(height: 20),

            // At a Glance Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('At a Glance',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Row(
                      children: [
                        Text('This Month', style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                        const SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: Colors.grey.shade700),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Metrics Summary Row
            SizedBox(
              height: 125,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _MetricCard(
                    title: 'Total Events',
                    value: '24', // Use static matching screenshot or '$totalEvents'
                    trend: '↑ 4 this month',
                    trendColor: const Color(0xFF3E7C4A),
                    icon: Icons.people_alt_rounded,
                    iconColor: const Color(0xFFC7555D),
                    iconBg: const Color(0xFFFAEAEC),
                  ),
                  const SizedBox(width: 10),
                  const _MetricCard(
                    title: 'New RSVPs',
                    value: '36',
                    trend: '↑ 6 this week',
                    trendColor: Color(0xFFE8622C),
                    icon: Icons.person_add_alt_1_rounded,
                    iconColor: Color(0xFFE8622C),
                    iconBg: Color(0xFFFDF3ED),
                  ),
                  const SizedBox(width: 10),
                  const _MetricCard(
                    title: 'Total RSVPs',
                    value: '248',
                    trend: '↑ 18 this month',
                    trendColor: Color(0xFF3E7C4A),
                    icon: Icons.local_activity_rounded,
                    iconColor: Color(0xFF3E7C4A),
                    iconBg: Color(0xFFE5F5E9),
                  ),
                  const SizedBox(width: 10),
                  const _MetricCard(
                    title: 'Ongoing Events',
                    value: '2',
                    trend: 'In progress',
                    trendColor: Color(0xFF757575), // Grey
                    icon: Icons.event_available_rounded,
                    iconColor: Color(0xFFC4901E),
                    iconBg: Color(0xFFFCF7EB),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Search & Filter Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search events by title, category or location...',
                          hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                          filled: true,
                          fillColor: const Color(0xFFFDFDFD),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: const Icon(Icons.filter_alt_outlined, color: AppColors.textPrimary, size: 20),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 18),
                        SizedBox(width: 6),
                        Text('Calendar View', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // New RSVPs Section
            _sectionHeader('New RSVPs', onViewAll: () {}),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Column(
                  children: [
                    const _RsvpTile(
                      name: 'Rohit Agrawal',
                      eventName: 'Teej Festival 2026',
                      time: 'Today, 10:30 AM',
                      tickets: 2,
                      avatarUrl: 'https://i.pravatar.cc/150?img=11',
                    ),
                    const Divider(height: 1, color: AppColors.border),
                    const _RsvpTile(
                      name: 'Pooja Agrawal',
                      eventName: 'Youth Leadership Summit 2026',
                      time: 'Today, 09:15 AM',
                      tickets: 1,
                      avatarUrl: 'https://i.pravatar.cc/150?img=5',
                    ),
                    const Divider(height: 1, color: AppColors.border),
                    const _RsvpTile(
                      name: 'Kartik Agrawal',
                      eventName: 'Blood Donation Camp',
                      time: 'Yesterday, 07:45 PM',
                      tickets: 1,
                      avatarUrl: 'https://i.pravatar.cc/150?img=8',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Upcoming Events Section
            _sectionHeader('Upcoming Events', onViewAll: () {}),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  for (final item in filtered) ...[
                    _EventCard(item: item),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateEventDialog(context, ref),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const _AdminBottomNavBar(activeIndex: 2),
    );
  }

  Widget _sectionHeader(String title, {required VoidCallback onViewAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          InkWell(
            onTap: onViewAll,
            child: Row(
              children: const [
                Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TOP BAR WITH EXIT BUTTON
// ---------------------------------------------------------------------------
class _AdminTopBar extends StatelessWidget {
  const _AdminTopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(100),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF81161B),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.menu_rounded, size: 22, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          const NasLogo(size: 38),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Nepal Agrawal Samaj',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Text(
                      'Kathmandu Branch',
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 11.5, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 2),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: Colors.grey.shade700),
                  ],
                ),
              ],
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_none_rounded, size: 26, color: AppColors.textPrimary),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Text('5', style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Container(
            height: 38,
            width: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage('https://i.pravatar.cc/150?img=11'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// HERO BANNER
// ---------------------------------------------------------------------------
class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Events Management',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: 8),
            Text('Create, manage and promote events\nto bring our community together.',
                style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.35)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _HeroActionButton(
                    icon: Icons.edit_calendar_rounded,
                    title: 'Create Event',
                    subtitle: 'Host a new event',
                    color: Colors.white.withOpacity(0.15),
                    iconColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _HeroActionButton(
                    icon: Icons.campaign_rounded,
                    title: 'Broadcast Notice',
                    subtitle: 'Send announcement',
                    color: Colors.white.withOpacity(0.15),
                    iconColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _HeroActionButton(
                    icon: Icons.insert_chart_outlined_rounded,
                    title: 'Download Report',
                    subtitle: 'Export event data',
                    color: Colors.white.withOpacity(0.15),
                    iconColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color iconColor;

  const _HeroActionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(title,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 8, color: Colors.white70)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// METRIC CARD
// ---------------------------------------------------------------------------
class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String trend;
  final Color trendColor;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.trend,
    required this.trendColor,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 115,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const Spacer(),
          Text(title, style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const Spacer(),
          Text(trend, style: TextStyle(fontSize: 10, color: trendColor, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// RSVP TILE
// ---------------------------------------------------------------------------
class _RsvpTile extends StatelessWidget {
  final String name;
  final String eventName;
  final String time;
  final int tickets;
  final String avatarUrl;

  const _RsvpTile({
    required this.name,
    required this.eventName,
    required this.time,
    required this.tickets,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: NetworkImage(avatarUrl), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 10, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(eventName, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 10, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE5F5E9),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              '$tickets Ticket${tickets > 1 ? 's' : ''}',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF3E7C4A)),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// EVENT CARD
// ---------------------------------------------------------------------------
class _EventCard extends StatelessWidget {
  final dynamic item;

  const _EventCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              gradient: LinearGradient(
                colors: item.category == 'CULTURAL'
                    ? [const Color(0xFF5A080D), const Color(0xFF81161B)]
                    : [const Color(0xFFE8CAAB), const Color(0xFFDEAA7B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  item.title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: item.category == 'CULTURAL' ? Colors.white : const Color(0xFF5A080D),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(item.title,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBE0D2).withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(item.status == 'UPCOMING' ? 'Upcoming' : 'Active',
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFFE8622C))),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.more_vert_rounded, size: 16, color: AppColors.textSecondary),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBE0D2).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(item.category == 'CULTURAL' ? 'Cultural' : 'Seminar',
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF5A080D))),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text('${item.date} • ', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                    const Icon(Icons.access_time_rounded, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(item.time, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(item.venue,
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade600), overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.people_alt_outlined, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text('${item.registered} registered',
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ADMIN BOTTOM NAV
// ---------------------------------------------------------------------------
class _AdminBottomNavBar extends StatelessWidget {
  final int activeIndex;
  const _AdminBottomNavBar({required this.activeIndex});

  static const _items = [
    (icon: Icons.dashboard_rounded, label: 'Dashboard', route: AppConstants.adminDashboard),
    (icon: Icons.people_alt_rounded, label: 'Members', route: AppConstants.adminMembers),
    (icon: Icons.event_rounded, label: 'Events', route: AppConstants.adminEvents),
    (icon: Icons.photo_library_rounded, label: 'Gallery', route: AppConstants.adminGallery),
    (icon: Icons.settings_rounded, label: 'Settings', route: AppConstants.adminSettings),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (int i = 0; i < _items.length; i++)
              Expanded(
                child: InkWell(
                  onTap: () => context.go(_items[i].route),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: i == activeIndex
                            ? BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              )
                            : null,
                        child: Icon(
                          _items[i].icon,
                          size: 20,
                          color: i == activeIndex ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _items[i].label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: i == activeIndex ? FontWeight.w700 : FontWeight.w500,
                          color: i == activeIndex ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void _showCreateEventDialog(BuildContext context, WidgetRef ref) {
  final titleController = TextEditingController();
  final venueController = TextEditingController();
  String category = 'Cultural';

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      title: Row(
        children: const [
          Icon(Icons.add_box_rounded, color: AppColors.primary),
          SizedBox(width: 8),
          Text('Create New Event', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Event Title',
                hintText: 'e.g. Dashain Cultural Gala 2026',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: venueController,
              decoration: InputDecoration(
                labelText: 'Venue Address',
                hintText: 'e.g. Samaj Bhawan Hall',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (titleController.text.isNotEmpty) {
              final newEvent = Event(
                id: 'ev-${DateTime.now().millisecondsSinceEpoch}',
                title: titleController.text,
                description: 'Organized by Location Admin',
                category: category,
                eventDate: DateTime.now().add(const Duration(days: 10)),
                eventTime: '05:00 PM',
                venue: venueController.text.isNotEmpty ? venueController.text : 'Kathmandu Samaj Hall',
                organizedBy: 'Kathmandu Chapter',
                status: 'upcoming',
                createdAt: DateTime.now(),
              );
              ref.read(eventsNotifierProvider.notifier).addEvent(newEvent);
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Event "${newEvent.title}" published successfully!')),
              );
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          child: const Text('Publish Event', style: TextStyle(fontWeight: FontWeight.w700)),
        ),
      ],
    ),
  );
}

void _showQrScannerModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg))),
    builder: (ctx) => Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.qr_code_scanner_rounded, size: 64, color: AppColors.primary),
          const SizedBox(height: 12),
          const Text('Scan Attendee Ticket QR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('Point camera at member\'s event pass QR code for instant check-in verification.',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ Ticket Verified: Rahul Agrawal (Kathmandu Chapter)')),
              );
            },
            icon: const Icon(Icons.camera_alt_rounded),
            label: const Text('Simulate Scan Verification', style: TextStyle(fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          ),
        ],
      ),
    ),
  );
}

void _showBroadcastModal(BuildContext context) {
  final messageController = TextEditingController();
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      title: Row(
        children: const [
          Icon(Icons.campaign_rounded, color: AppColors.primary),
          SizedBox(width: 8),
          Text('Broadcast Event Notice', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        ],
      ),
      content: TextField(
        controller: messageController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Type announcement message to send to all registered attendees...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Announcement broadcasted to 1,240 attendees via SMS & App Notification!')),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          child: const Text('Send Broadcast'),
        ),
      ],
    ),
  );
}
