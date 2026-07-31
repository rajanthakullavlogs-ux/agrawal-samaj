import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/nas_logo.dart';

/// B3 — Events Management Screen (Location Admin)
class EventsManagementScreen extends StatefulWidget {
  const EventsManagementScreen({super.key});

  @override
  State<EventsManagementScreen> createState() => _EventsManagementScreenState();
}

enum _EventFilter { all, upcoming, cultural, business, past }

class _EventsManagementScreenState extends State<EventsManagementScreen> {
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

            // Metrics Summary Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.6,
                children: const [
                  _MiniStat(
                    title: 'Total Events',
                    value: '12',
                    icon: Icons.event_note_rounded,
                    color: Color(0xFFE8622C),
                    bg: Color(0xFFFDF3ED),
                  ),
                  _MiniStat(
                    title: 'New RSVPs',
                    value: '+458',
                    icon: Icons.group_add_rounded,
                    color: Color(0xFF2E6FE0),
                    bg: Color(0xFFF3F8FE),
                  ),
                  _MiniStat(
                    title: 'Active Gatherings',
                    value: '3',
                    icon: Icons.celebration_rounded,
                    color: Color(0xFF3E7C4A),
                    bg: Color(0xFFF2FAF4),
                  ),
                  _MiniStat(
                    title: 'Revenue Generated',
                    value: 'NPR 45k',
                    icon: Icons.payments_rounded,
                    color: Color(0xFFC4901E),
                    bg: Color(0xFFFCF7EB),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Actions Strip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text('Quick Actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _QuickActionTile(
                    icon: Icons.add_box_rounded,
                    bg: const Color(0xFFFBE0D2),
                    color: const Color(0xFFE8622C),
                    label: 'Create New\nEvent',
                    onTap: () {},
                  ),
                  const SizedBox(width: 10),
                  _QuickActionTile(
                    icon: Icons.qr_code_scanner_rounded,
                    bg: const Color(0xFFE3EEFD),
                    color: const Color(0xFF2E6FE0),
                    label: 'Scan Ticket\nQR',
                    onTap: () {},
                  ),
                  const SizedBox(width: 10),
                  _QuickActionTile(
                    icon: Icons.download_rounded,
                    bg: const Color(0xFFE5F5E9),
                    color: const Color(0xFF3E7C4A),
                    label: 'Download\nReport',
                    onTap: () {},
                  ),
                  const SizedBox(width: 10),
                  _QuickActionTile(
                    icon: Icons.campaign_rounded,
                    bg: const Color(0xFFEFE7FB),
                    color: const Color(0xFF7B4FD6),
                    label: 'Broadcast\nNotice',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Filter Chips
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _filterChip('All Events', _EventFilter.all),
                  const SizedBox(width: 8),
                  _filterChip('Upcoming', _EventFilter.upcoming),
                  const SizedBox(width: 8),
                  _filterChip('Cultural', _EventFilter.cultural),
                  const SizedBox(width: 8),
                  _filterChip('Business', _EventFilter.business),
                  const SizedBox(width: 8),
                  _filterChip('Past Gatherings', _EventFilter.past),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Events List
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
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opening Create Event Wizard...')),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const _AdminBottomNavBar(activeIndex: 2),
    );
  }

  Widget _filterChip(String label, _EventFilter value) {
    final selected = _filter == value;
    return InkWell(
      onTap: () => setState(() => _filter = value),
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
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
            onTap: () => context.go(AppConstants.home),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.home_rounded, size: 22, color: AppColors.primary),
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
                Text(
                  'Events Command Center',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 11.5, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => context.go(AppConstants.home),
            borderRadius: BorderRadius.circular(100),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(100)),
              child: Row(
                children: const [
                  Text('Exit', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                  SizedBox(width: 2),
                  Icon(Icons.logout_rounded, size: 12, color: Colors.white),
                ],
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFCEEE4), Color(0xFFFBE3D3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Events Command Center 📅',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text('Schedule cultural festivals, business summits, and track real-time attendee registrations.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.35)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: const Icon(Icons.event_seat_rounded, color: AppColors.primary, size: 32),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MINI STAT
// ---------------------------------------------------------------------------
class _MiniStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color bg;

  const _MiniStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: color)),
                Text(title, style: TextStyle(fontSize: 10.5, color: Colors.grey.shade700), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// QUICK ACTION TILE
// ---------------------------------------------------------------------------
class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.bg,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        width: 84,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.lg)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ],
        ),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBE0D2),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(item.category,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFFE8622C))),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F5E9),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(item.status,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF3E7C4A))),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(item.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(item.venue,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700), overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.people_outline_rounded, size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text('${item.registered} Registered',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ],
              ),
              Text('${item.date} • ${item.time}',
                  style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  ),
                  child: const Text('Edit Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening attendee roster for ${item.title}...')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  ),
                  child: const Text('View Roster', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
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
