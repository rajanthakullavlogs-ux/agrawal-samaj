import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants.dart';
import '../../../shared/widgets/widgets.dart';

class _EventItem {
  final String id;
  final String month;
  final String day;
  final String year;
  final String title;
  final String subtitle;
  final String time;
  final String location;
  final String organizer;
  final String desc;
  final String imageUrl;
  final bool isFeatured;
  final bool isBookmarked;
  final String status; // 'upcoming', 'past'
  final String category; // 'Business', 'Cultural', 'Social', 'Health', 'Youth'
  final String province; // 'Bagmati', 'Gandaki', 'Koshi', 'Madhesh', 'Lumbini'
  final List<String> tags;
  final String tagType; // 'business', 'cultural', 'health', 'youth'

  const _EventItem({
    required this.id,
    required this.month,
    required this.day,
    required this.year,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.location,
    required this.organizer,
    required this.desc,
    required this.imageUrl,
    this.isFeatured = false,
    this.isBookmarked = false,
    required this.status,
    required this.category,
    required this.province,
    required this.tags,
    required this.tagType,
  });

  DateTime get eventDate {
    const monthMap = {
      'JAN': 1, 'FEB': 2, 'MAR': 3, 'APR': 4, 'MAY': 5, 'JUN': 6,
      'JUL': 7, 'AUG': 8, 'SEP': 9, 'OCT': 10, 'NOV': 11, 'DEC': 12,
    };
    final m = monthMap[month.toUpperCase()] ?? 1;
    final d = int.tryParse(day) ?? 1;
    final y = int.tryParse(year) ?? 2026;
    return DateTime(y, m, d);
  }

  _EventItem copyWith({bool? isBookmarked}) {
    return _EventItem(
      id: id,
      month: month,
      day: day,
      year: year,
      title: title,
      subtitle: subtitle,
      time: time,
      location: location,
      organizer: organizer,
      desc: desc,
      imageUrl: imageUrl,
      isFeatured: isFeatured,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      status: status,
      category: category,
      province: province,
      tags: tags,
      tagType: tagType,
    );
  }
}

/// Refactored EventsListScreen matching pixel-for-pixel the reference UI screenshot.
class EventsListScreen extends ConsumerStatefulWidget {
  const EventsListScreen({super.key});

  @override
  ConsumerState<EventsListScreen> createState() => _EventsListScreenState();
}

class _EventsListScreenState extends ConsumerState<EventsListScreen> {
  String _selectedStatusFilter = 'Upcoming'; // 'Upcoming', 'Past', 'All'
  String? _selectedProvince; // null = All Provinces
  String? _selectedCategory; // null = All Categories
  DateTimeRange? _selectedDateRange; // null = All Dates
  String? _selectedDateRangeLabel;

  late List<_EventItem> _events;

  @override
  void initState() {
    super.initState();
    _events = [
      const _EventItem(
        id: 'ev-2',
        month: 'NOV',
        day: '15',
        year: '2026',
        title: 'Agrawal Business & Trade Summit 2026',
        subtitle: 'Connect • Collaborate • Grow',
        time: '10:00 AM – 4:30 PM',
        location: 'Hotel Yak & Yeti, Kathmandu',
        organizer: 'Business Wing',
        desc: 'A premier gathering of business leaders, entrepreneurs and professionals to exchange ideas.',
        imageUrl: 'assets/images/event_trade_summit_banner.png',
        isFeatured: true,
        isBookmarked: false,
        status: 'upcoming',
        category: 'Business',
        province: 'Bagmati',
        tags: ['Business', 'Networking', 'Growth'],
        tagType: 'business',
      ),
      const _EventItem(
        id: 'ev-1',
        month: 'OCT',
        day: '24',
        year: '2026',
        title: 'Maharaja Agrasen Jayanti 2026',
        subtitle: 'Grand cultural celebration & bhajans',
        time: '05:00 PM – 9:00 PM',
        location: 'Samaj Bhawan, Kamaladi, Kathmandu',
        organizer: 'Central Executive Committee',
        desc: 'Join us for a grand cultural celebration, bhajans, prasad distribution, and honoring community elders.',
        imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=800&q=80',
        isFeatured: false,
        isBookmarked: false,
        status: 'upcoming',
        category: 'Cultural',
        province: 'Bagmati',
        tags: ['Culture', 'Tradition', 'Community'],
        tagType: 'cultural',
      ),
      const _EventItem(
        id: 'ev-youth',
        month: 'APR',
        day: '20',
        year: '2026',
        title: 'Youth Leadership Workshop',
        subtitle: 'Mentorship & skill building for youth',
        time: '10:00 AM – 2:00 PM',
        location: 'National Youth Center, Kathmandu',
        organizer: 'Central Youth Wing',
        desc: 'Interactive mentorship session for young Agrawal professionals.',
        imageUrl: 'https://images.unsplash.com/photo-1523580494863-6f3031224c94?auto=format&fit=crop&w=800&q=80',
        isFeatured: false,
        isBookmarked: false,
        status: 'upcoming',
        category: 'Youth',
        province: 'Bagmati',
        tags: ['Youth', 'Leadership', 'Mentorship'],
        tagType: 'youth',
      ),
      const _EventItem(
        id: 'ev-women',
        month: 'MAR',
        day: '15',
        year: '2026',
        title: 'Women Empowerment Session',
        subtitle: 'Empowering women leaders & community tools',
        time: '11:00 AM – 3:00 PM',
        location: 'Agrawal Bhawan Auditorium, Kathmandu',
        organizer: 'Women Wing',
        desc: 'Empowering women leaders with financial literacy and community leadership tools.',
        imageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=800&q=80',
        isFeatured: false,
        isBookmarked: false,
        status: 'upcoming',
        category: 'Social',
        province: 'Bagmati',
        tags: ['Women', 'Empowerment', 'Leadership'],
        tagType: 'health',
      ),
      const _EventItem(
        id: 'ev-business',
        month: 'FEB',
        day: '25',
        year: '2026',
        title: 'Business Networking Meet',
        subtitle: 'Networking & trade collaboration',
        time: '06:00 PM – 9:00 PM',
        location: 'Hotel Radisson, Kathmandu',
        organizer: 'Business Wing',
        desc: 'Exclusive networking evening for business owners and startup founders.',
        imageUrl: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&w=800&q=80',
        isFeatured: false,
        isBookmarked: false,
        status: 'upcoming',
        category: 'Business',
        province: 'Bagmati',
        tags: ['Networking', 'Business', 'Trade'],
        tagType: 'business',
      ),
      const _EventItem(
        id: 'ev-3',
        month: 'DEC',
        day: '05',
        year: '2026',
        title: 'Free Health & Blood Donation Camp',
        subtitle: 'Donate blood, save lives',
        time: '08:00 AM – 1:00 PM',
        location: 'Birgunj Chapter Office Grounds',
        organizer: 'Youth & Health Wing',
        desc: 'Comprehensive health check-ups, eye tests, and blood donation drive.',
        imageUrl: 'https://images.unsplash.com/photo-1615461066841-6116e61058f4?auto=format&fit=crop&w=800&q=80',
        isFeatured: false,
        isBookmarked: false,
        status: 'upcoming',
        category: 'Health',
        province: 'Madhesh',
        tags: ['Health', 'Service', 'Humanity'],
        tagType: 'health',
      ),
      const _EventItem(
        id: 'ev-4',
        month: 'MAR',
        day: '25',
        year: '2026',
        title: 'Holi Milan & Cultural Evening 2026',
        subtitle: 'Festive celebration of colors & music',
        time: '03:00 PM – 7:00 PM',
        location: 'Biratnagar Community Garden',
        organizer: 'Koshi Regional Chapter',
        desc: 'Festive celebration of colors with traditional snacks, thandai, and music.',
        imageUrl: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=800&q=80',
        isFeatured: false,
        isBookmarked: false,
        status: 'past',
        category: 'Cultural',
        province: 'Koshi',
        tags: ['Culture', 'Festival', 'Music'],
        tagType: 'cultural',
      ),
    ];
  }

  void _toggleBookmark(String id) {
    setState(() {
      _events = _events.map((e) => e.id == id ? e.copyWith(isBookmarked: !e.isBookmarked) : e).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter logic
    final filteredEvents = _events.where((e) {
      if (_selectedStatusFilter == 'Upcoming' && e.status != 'upcoming') return false;
      if (_selectedStatusFilter == 'Past' && e.status != 'past') return false;
      if (_selectedProvince != null && e.province != _selectedProvince) return false;
      if (_selectedCategory != null && e.category != _selectedCategory) return false;
      if (_selectedDateRange != null) {
        final start = DateTime(_selectedDateRange!.start.year, _selectedDateRange!.start.month, _selectedDateRange!.start.day);
        final end = DateTime(_selectedDateRange!.end.year, _selectedDateRange!.end.month, _selectedDateRange!.end.day, 23, 59, 59);
        if (e.eventDate.isBefore(start) || e.eventDate.isAfter(end)) return false;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Deep Burgundy Header Section
            _EventsHeaderSection(
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppConstants.home);
                }
              },
              onProfile: () => context.push(AppConstants.profile),
            ),

            // Main Content Area inside Top Rounded Container
            Transform.translate(
              offset: const Offset(0, -16),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF9F7F5),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // Horizontal Filter Pills Bar
                    _FilterPillsBar(
                      selectedStatus: _selectedStatusFilter,
                      selectedProvince: _selectedProvince,
                      selectedCategory: _selectedCategory,
                      onStatusSelected: (st) => setState(() => _selectedStatusFilter = st),
                      onProvinceSelected: (pr) => setState(() => _selectedProvince = pr),
                      onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
                    ),
                    const SizedBox(height: 12),

                    // Section Title Row (Managed Heading + Styled Count Badge + Date Range Selector Button)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF700D15),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    '$_selectedStatusFilter Events',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF1E1615),
                                      letterSpacing: -0.3,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF700D15).withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFF700D15).withValues(alpha: 0.15)),
                                  ),
                                  child: Text(
                                    '${filteredEvents.length}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF700D15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Redesigned Interactive Date Range Selector Pill
                          GestureDetector(
                            onTap: () => _showDateRangeModalSheet(context),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: _selectedDateRange != null
                                    ? const Color(0xFF700D15)
                                    : const Color(0xFF700D15).withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _selectedDateRange != null
                                      ? const Color(0xFF700D15)
                                      : const Color(0xFF700D15).withValues(alpha: 0.15),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.calendar_month_rounded,
                                    size: 13,
                                    color: _selectedDateRange != null ? Colors.white : const Color(0xFF700D15),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    _selectedDateRangeLabel ?? 'Date Range',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w800,
                                      color: _selectedDateRange != null ? Colors.white : const Color(0xFF700D15),
                                    ),
                                  ),
                                  if (_selectedDateRange != null) ...[
                                    const SizedBox(width: 6),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedDateRange = null;
                                          _selectedDateRangeLabel = null;
                                        });
                                      },
                                      child: const Icon(Icons.cancel_rounded, size: 14, color: Colors.white),
                                    ),
                                  ] else ...[
                                    const SizedBox(width: 3),
                                    const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: Color(0xFF700D15)),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Event Cards List
                    if (filteredEvents.isEmpty)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        padding: const EdgeInsets.all(24),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5D5D5)),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.event_busy_rounded, size: 44, color: Color(0xFF8C7A75)),
                            const SizedBox(height: 10),
                            const Text(
                              'No events match your selected filters',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF1E1615)),
                            ),
                            const SizedBox(height: 6),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedStatusFilter = 'Upcoming';
                                  _selectedProvince = null;
                                  _selectedCategory = null;
                                  _selectedDateRange = null;
                                  _selectedDateRangeLabel = null;
                                });
                              },
                              child: const Text('Reset All Filters', style: TextStyle(color: Color(0xFF700D15), fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredEvents.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 16),
                          itemBuilder: (context, i) {
                            final event = filteredEvents[i];
                            return _EventCardItem(
                              event: event,
                              onBookmarkTap: () => _toggleBookmark(event.id),
                              onRegisterTap: () => _showEventRegistrationDialog(context, event),
                              onLearnMoreTap: () => context.push('/events/${event.id}'),
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 80), // Bottom padding for FAB & BottomNavBar
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),

      bottomNavigationBar: const NASBottomNavBar(activeIndex: 1),
    );
  }

  void _showEventRegistrationDialog(BuildContext context, _EventItem event) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.event_available_rounded, color: Color(0xFF700D15)),
            SizedBox(width: 8),
            Text('Register for Event', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Event: ${event.title}',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: Color(0xFF700D15)),
              ),
              Text('${event.time} • ${event.location}', style: const TextStyle(fontSize: 11, color: Color(0xFF757575))),
              const SizedBox(height: 14),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Attendee Full Name',
                  hintText: 'e.g. Ramesh Agrawal',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: '+977 9801XXXXXX',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('RSVP Confirmed for ${nameCtrl.text} at ${event.title}!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF500913), foregroundColor: Colors.white),
            child: const Text('Confirm Registration', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showDateRangeModalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final isRangeActive = _selectedDateRange != null;

          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFAFAFA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  // Drag Handle Bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4.5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6C7C2),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Premium Top Burgundy Header Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6B0E1B), Color(0xFF45060E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6B0E1B).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE5C158).withValues(alpha: 0.5), width: 1.2),
                          ),
                          child: const Icon(Icons.date_range_rounded, color: Color(0xFFE5C158), size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Filter by Date Range',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isRangeActive
                                    ? 'Active: ${_selectedDateRangeLabel ?? "Custom Range"}'
                                    : 'Select a quick range or custom start & end date',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isRangeActive ? FontWeight.w700 : FontWeight.w400,
                                  color: isRangeActive ? const Color(0xFFE5C158) : Colors.white70,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (isRangeActive)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDateRange = null;
                                _selectedDateRangeLabel = null;
                              });
                              Navigator.pop(ctx);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.white30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.refresh_rounded, color: Colors.white, size: 13),
                                  SizedBox(width: 4),
                                  Text(
                                    'Reset',
                                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),

                          // Presets Section Heading
                          Row(
                            children: const [
                              Icon(Icons.bolt_rounded, size: 16, color: Color(0xFF700D15)),
                              SizedBox(width: 6),
                              Text(
                                'QUICK RANGE PRESETS',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF700D15),
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // 2-Column Grid of Presets Cards
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 2.6,
                            children: [
                              _buildPresetCard(
                                title: 'All Dates',
                                subtitle: 'Show all events',
                                icon: Icons.all_inclusive_rounded,
                                isSelected: _selectedDateRange == null,
                                onTap: () {
                                  setState(() {
                                    _selectedDateRange = null;
                                    _selectedDateRangeLabel = null;
                                  });
                                  Navigator.pop(ctx);
                                },
                              ),
                              _buildPresetCard(
                                title: 'This Month',
                                subtitle: 'Current month',
                                icon: Icons.calendar_today_rounded,
                                isSelected: _selectedDateRangeLabel == 'This Month',
                                onTap: () {
                                  final now = DateTime(2026, 10, 1);
                                  final start = DateTime(now.year, now.month, 1);
                                  final end = DateTime(now.year, now.month + 1, 0);
                                  setState(() {
                                    _selectedDateRange = DateTimeRange(start: start, end: end);
                                    _selectedDateRangeLabel = 'This Month';
                                  });
                                  Navigator.pop(ctx);
                                },
                              ),
                              _buildPresetCard(
                                title: 'Next 30 Days',
                                subtitle: 'Upcoming month',
                                icon: Icons.date_range_outlined,
                                isSelected: _selectedDateRangeLabel == 'Next 30 Days',
                                onTap: () {
                                  final now = DateTime(2026, 10, 1);
                                  final end = now.add(const Duration(days: 30));
                                  setState(() {
                                    _selectedDateRange = DateTimeRange(start: now, end: end);
                                    _selectedDateRangeLabel = 'Next 30 Days';
                                  });
                                  Navigator.pop(ctx);
                                },
                              ),
                              _buildPresetCard(
                                title: 'Next 3 Months',
                                subtitle: 'Quarterly view',
                                icon: Icons.update_rounded,
                                isSelected: _selectedDateRangeLabel == 'Next 3 Months',
                                onTap: () {
                                  final now = DateTime(2026, 10, 1);
                                  final end = now.add(const Duration(days: 90));
                                  setState(() {
                                    _selectedDateRange = DateTimeRange(start: now, end: end);
                                    _selectedDateRangeLabel = 'Next 3 Months';
                                  });
                                  Navigator.pop(ctx);
                                },
                              ),
                              _buildPresetCard(
                                title: 'Year 2026',
                                subtitle: 'Full 2026 calendar',
                                icon: Icons.event_available_rounded,
                                isSelected: _selectedDateRangeLabel == 'Year 2026',
                                onTap: () {
                                  setState(() {
                                    _selectedDateRange = DateTimeRange(
                                      start: DateTime(2026, 1, 1),
                                      end: DateTime(2026, 12, 31),
                                    );
                                    _selectedDateRangeLabel = 'Year 2026';
                                  });
                                  Navigator.pop(ctx);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // Custom Date Range Section Heading
                          Row(
                            children: const [
                              Icon(Icons.edit_calendar_rounded, size: 16, color: Color(0xFF700D15)),
                              SizedBox(width: 6),
                              Text(
                                'CUSTOM DATE RANGE',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF700D15),
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Custom Date Range Interactive Selector Box
                          InkWell(
                            onTap: () async {
                              final picked = await showDateRangePicker(
                                context: context,
                                initialDateRange: _selectedDateRange ??
                                    DateTimeRange(
                                      start: DateTime(2026, 10, 1),
                                      end: DateTime(2026, 12, 31),
                                    ),
                                firstDate: DateTime(2024, 1, 1),
                                lastDate: DateTime(2030, 12, 31),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Color(0xFF700D15),
                                        onPrimary: Colors.white,
                                        surface: Colors.white,
                                        onSurface: Color(0xFF1E1615),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                final shortStart = DateFormat('MMM d').format(picked.start);
                                final shortEnd = DateFormat('MMM d').format(picked.end);
                                setState(() {
                                  _selectedDateRange = picked;
                                  _selectedDateRangeLabel = '$shortStart – $shortEnd';
                                });
                                if (context.mounted) Navigator.pop(ctx);
                              }
                            },
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isRangeActive
                                    ? const Color(0xFF700D15).withValues(alpha: 0.06)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isRangeActive
                                      ? const Color(0xFF700D15)
                                      : const Color(0xFFE2D6D3),
                                  width: isRangeActive ? 1.5 : 1.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Start Date Box
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xFFE2D6D3)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'FROM DATE',
                                            style: TextStyle(
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xFF8C7A75),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            _selectedDateRange != null
                                                ? DateFormat('MMM d, yyyy').format(_selectedDateRange!.start)
                                                : 'Select Start',
                                            style: TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w800,
                                              color: _selectedDateRange != null
                                                  ? const Color(0xFF700D15)
                                                  : const Color(0xFF1E1615),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Icon(Icons.arrow_forward_rounded, size: 16, color: Color(0xFF700D15)),
                                  ),
                                  // End Date Box
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xFFE2D6D3)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'TO DATE',
                                            style: TextStyle(
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xFF8C7A75),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            _selectedDateRange != null
                                                ? DateFormat('MMM d, yyyy').format(_selectedDateRange!.end)
                                                : 'Select End',
                                            style: TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w800,
                                              color: _selectedDateRange != null
                                                  ? const Color(0xFF700D15)
                                                  : const Color(0xFF1E1615),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),

                          // Done/Apply Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(ctx),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF500913),
                                foregroundColor: Colors.white,
                                elevation: 3,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Apply Date Filter',
                                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14.5),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.check_circle_outline_rounded, size: 18),
                                ],
                              ),
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
        },
      ),
    );
  }

  Widget _buildPresetCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF700D15) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF700D15) : const Color(0xFFE2D6D3),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF700D15).withValues(alpha: 0.25)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withValues(alpha: 0.2) : const Color(0xFF700D15).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 15,
                color: isSelected ? Colors.white : const Color(0xFF700D15),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? Colors.white : const Color(0xFF1E1615),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white70 : const Color(0xFF8C7A75),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_rounded, size: 14, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. TOP DEEP BURGUNDY HEADER SECTION
// ---------------------------------------------------------------------------
class _EventsHeaderSection extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onProfile;

  const _EventsHeaderSection({
    required this.onBack,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF6B0E1B),
            Color(0xFF3F050C),
          ],
        ),
      ),
      padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Action Row (Back Arrow + Profile Circle)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onBack,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0x33FFFFFF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                ),
              ),
              InkWell(
                onTap: onProfile,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_outline_rounded, color: Color(0xFF500913), size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Main Header Title + Subtitle
          const Text(
            'Events',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Join our events and be part of our community',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. HORIZONTAL FILTER PILLS ROW
// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// 2. HORIZONTAL FILTER PILLS ROW WITH TOP CURVE FOLLOWING ANIMATION
// ---------------------------------------------------------------------------
class _FilterPillsBar extends StatefulWidget {
  final String selectedStatus;
  final String? selectedProvince;
  final String? selectedCategory;
  final ValueChanged<String> onStatusSelected;
  final ValueChanged<String?> onProvinceSelected;
  final ValueChanged<String?> onCategorySelected;

  const _FilterPillsBar({
    required this.selectedStatus,
    required this.selectedProvince,
    required this.selectedCategory,
    required this.onStatusSelected,
    required this.onProvinceSelected,
    required this.onCategorySelected,
  });

  @override
  State<_FilterPillsBar> createState() => _FilterPillsBarState();
}

class _FilterPillsBarState extends State<_FilterPillsBar> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 42,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          setState(() {});
          return false;
        },
        child: ListView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            // Upcoming Pill
            _buildCurvedItem(
              screenWidth: screenWidth,
              child: _buildPill(
                icon: Icons.calendar_today_outlined,
                label: 'Upcoming',
                isSelected: widget.selectedStatus == 'Upcoming',
                onTap: () => widget.onStatusSelected('Upcoming'),
              ),
            ),
            const SizedBox(width: 8),

            // Past Pill
            _buildCurvedItem(
              screenWidth: screenWidth,
              child: _buildPill(
                icon: Icons.history_rounded,
                label: 'Past',
                isSelected: widget.selectedStatus == 'Past',
                onTap: () => widget.onStatusSelected('Past'),
              ),
            ),
            const SizedBox(width: 8),

            // All Pill
            _buildCurvedItem(
              screenWidth: screenWidth,
              child: _buildPill(
                icon: Icons.grid_view_rounded,
                label: 'All',
                isSelected: widget.selectedStatus == 'All',
                onTap: () => widget.onStatusSelected('All'),
              ),
            ),
            const SizedBox(width: 8),

            // Province Dropdown Pill
            _buildCurvedItem(
              screenWidth: screenWidth,
              child: PopupMenuButton<String>(
                initialValue: widget.selectedProvince ?? 'ALL',
                tooltip: 'Select Province',
                onSelected: (val) {
                  widget.onProvinceSelected(val == 'ALL' ? null : val);
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                color: Colors.white,
                elevation: 6,
                itemBuilder: (context) => [
                  'ALL',
                  'Bagmati',
                  'Gandaki',
                  'Koshi',
                  'Madhesh',
                  'Lumbini',
                ].map((pr) {
                  final isSel = (widget.selectedProvince == null && pr == 'ALL') || (widget.selectedProvince == pr);
                  final labelText = pr == 'ALL' ? 'All Provinces' : '$pr Province';
                  return PopupMenuItem<String>(
                    value: pr,
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: isSel ? const Color(0xFF700D15) : const Color(0xFF666666),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          labelText,
                          style: TextStyle(
                            fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                            color: isSel ? const Color(0xFF700D15) : const Color(0xFF1E1615),
                            fontSize: 13,
                          ),
                        ),
                        if (isSel) ...[
                          const Spacer(),
                          const Icon(Icons.check_rounded, size: 16, color: Color(0xFF700D15)),
                        ],
                      ],
                    ),
                  );
                }).toList(),
                child: _buildDropdownPill(
                  icon: Icons.location_on_outlined,
                  label: widget.selectedProvince ?? 'Province',
                  isSelected: widget.selectedProvince != null,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Category Dropdown Pill
            _buildCurvedItem(
              screenWidth: screenWidth,
              child: PopupMenuButton<String>(
                initialValue: widget.selectedCategory ?? 'ALL',
                tooltip: 'Select Category',
                onSelected: (val) {
                  widget.onCategorySelected(val == 'ALL' ? null : val);
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                color: Colors.white,
                elevation: 6,
                itemBuilder: (context) => [
                  'ALL',
                  'Business',
                  'Cultural',
                  'Health',
                  'Youth',
                  'Social',
                ].map((cat) {
                  final isSel = (widget.selectedCategory == null && cat == 'ALL') || (widget.selectedCategory == cat);
                  final labelText = cat == 'ALL' ? 'All Categories' : cat;
                  return PopupMenuItem<String>(
                    value: cat,
                    child: Row(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 14,
                          color: isSel ? const Color(0xFF700D15) : const Color(0xFF666666),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          labelText,
                          style: TextStyle(
                            fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                            color: isSel ? const Color(0xFF700D15) : const Color(0xFF1E1615),
                            fontSize: 13,
                          ),
                        ),
                        if (isSel) ...[
                          const Spacer(),
                          const Icon(Icons.check_rounded, size: 16, color: Color(0xFF700D15)),
                        ],
                      ],
                    ),
                  );
                }).toList(),
                child: _buildDropdownPill(
                  icon: Icons.category_outlined,
                  label: widget.selectedCategory ?? 'Category',
                  isSelected: widget.selectedCategory != null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurvedItem({
    required double screenWidth,
    required Widget child,
  }) {
    return Builder(
      builder: (context) {
        double offsetY = 0.0;
        double opacity = 1.0;
        double scale = 1.0;

        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.hasSize) {
          final position = renderBox.localToGlobal(Offset.zero);
          final pillWidth = renderBox.size.width;
          final pillCenterX = position.dx + (pillWidth / 2);

          const curveZone = 55.0;
          const maxOffsetY = 7.0;

          // Left Curve Border Zone
          if (pillCenterX < curveZone) {
            final t = ((curveZone - pillCenterX) / curveZone).clamp(0.0, 1.0);
            offsetY = t * t * maxOffsetY;
            opacity = 1.0 - (t * 0.35);
            scale = 1.0 - (t * 0.05);
          }
          // Right Curve Border Zone
          else if (pillCenterX > screenWidth - curveZone) {
            final t = ((pillCenterX - (screenWidth - curveZone)) / curveZone).clamp(0.0, 1.0);
            offsetY = t * t * maxOffsetY;
            opacity = 1.0 - (t * 0.35);
            scale = 1.0 - (t * 0.05);
          }
        }

        return Transform.translate(
          offset: Offset(0, offsetY),
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: child,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPill({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF500913) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF500913) : const Color(0xFFD0C4C0),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : const Color(0xFF700D15),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : const Color(0xFF1E1615),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownPill({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF500913).withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? const Color(0xFF500913) : const Color(0xFFD0C4C0),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF700D15)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
              color: const Color(0xFF1E1615),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: Color(0xFF700D15)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. ANIMATED SAVE / BOOKMARK BUTTON WITH SPRING SCALE EFFECT
// ---------------------------------------------------------------------------
class _AnimatedSaveButton extends StatefulWidget {
  final bool isSaved;
  final VoidCallback onTap;
  final String eventTitle;

  const _AnimatedSaveButton({
    required this.isSaved,
    required this.onTap,
    required this.eventTitle,
  });

  @override
  State<_AnimatedSaveButton> createState() => _AnimatedSaveButtonState();
}

class _AnimatedSaveButtonState extends State<_AnimatedSaveButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.48)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.48, end: 0.88)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.88, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(_controller);

    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -0.15)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.15, end: 0.15)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.15, end: 0.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0.0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.isSaved ? 'Remove from saved' : 'Save Event',
      child: GestureDetector(
        onTap: _handleTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: RotationTransition(
            turns: _rotationAnimation,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: widget.isSaved
                    ? const Color(0xFF700D15)
                    : const Color(0xFFFDF5F2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.isSaved
                      ? const Color(0xFFE5C158)
                      : const Color(0xFFE8D5D0),
                  width: widget.isSaved ? 1.5 : 1.2,
                ),
                boxShadow: widget.isSaved
                    ? [
                        BoxShadow(
                          color: const Color(0xFFE5C158).withValues(alpha: 0.35),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                        BoxShadow(
                          color: const Color(0xFF700D15).withValues(alpha: 0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Icon(
                widget.isSaved
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_outline_rounded,
                size: 18,
                color: widget.isSaved
                    ? const Color(0xFFE5C158)
                    : const Color(0xFF700D15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. EVENT CARD ITEM (SPLIT IMAGE & DETAILS CONTAINER)
// ---------------------------------------------------------------------------
class _EventCardItem extends StatelessWidget {
  final _EventItem event;
  final VoidCallback onBookmarkTap;
  final VoidCallback onRegisterTap;
  final VoidCallback onLearnMoreTap;

  const _EventCardItem({
    required this.event,
    required this.onBookmarkTap,
    required this.onRegisterTap,
    required this.onLearnMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onLearnMoreTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Banner Image Column (~38% width)
            SizedBox(
              width: 135,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: event.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: const Color(0xFFF0F0F0)),
                    errorWidget: (context, url, error) => Container(
                      color: const Color(0xFFE5D5D5),
                      child: const Icon(Icons.event, color: Color(0xFF700D15)),
                    ),
                  ),
                  if (event.isFeatured)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53935),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.star, size: 9, color: Colors.white),
                            SizedBox(width: 2),
                            Text(
                              'FEATURED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // Right Content Details Column
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Row: Date Badge + Title/Subtitle + Animated Save Button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date Badge Box
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF241B1D),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              event.month,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 8.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                            Text(
                              event.day,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                height: 1.05,
                              ),
                            ),
                            Text(
                              event.year,
                              style: const TextStyle(
                                color: Color(0xFFE5C158),
                                fontSize: 7.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),

                      // Title & Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E1615),
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (event.subtitle.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                event.subtitle,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFA67C1E),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),

                      // Animated Save Button (Scales up on click)
                      _AnimatedSaveButton(
                        isSaved: event.isBookmarked,
                        onTap: onBookmarkTap,
                        eventTitle: event.title,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Info Metadata Rows
                  _buildInfoRow(Icons.access_time_outlined, event.time),
                  const SizedBox(height: 2),
                  _buildInfoRow(Icons.location_on_outlined, event.location),
                  const SizedBox(height: 2),
                  _buildInfoRow(Icons.account_circle_outlined, 'Organized by: ${event.organizer}'),
                  const SizedBox(height: 6),

                  // Tags Row
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: event.tags.map((tag) {
                      final tagBg = _getTagBg(event.tagType);
                      final tagTxt = _getTagText(event.tagType);
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: tagBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: tagTxt,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),

                  // Action Buttons Row (Register Now + Learn More)
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: onRegisterTap,
                          child: Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF500913),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Register Now',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: 3),
                                    Icon(Icons.arrow_forward_rounded, size: 11, color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: GestureDetector(
                          onTap: onLearnMoreTap,
                          child: Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: const Color(0xFFD6C9C5)),
                            ),
                            child: const Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Learn More',
                                  style: TextStyle(
                                    color: Color(0xFF500913),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);
}

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 11, color: const Color(0xFF8C7A75)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getTagBg(String type) {
    switch (type) {
      case 'business':
        return const Color(0xFFF9F0E0);
      case 'cultural':
        return const Color(0xFFFDF0F0);
      case 'health':
        return const Color(0xFFEEF7F2);
      case 'youth':
      default:
        return const Color(0xFFF3E8FF);
    }
  }

  Color _getTagText(String type) {
    switch (type) {
      case 'business':
        return const Color(0xFFA67C1E);
      case 'cultural':
        return const Color(0xFF700D15);
      case 'health':
        return const Color(0xFF2E7D32);
      case 'youth':
      default:
        return const Color(0xFF7B4FD6);
    }
  }
}
