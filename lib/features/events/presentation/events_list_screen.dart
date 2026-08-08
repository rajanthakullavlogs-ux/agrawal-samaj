import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

  late List<_EventItem> _events;

  @override
  void initState() {
    super.initState();
    _events = [
      const _EventItem(
        id: 'ev-1',
        month: 'AUG',
        day: '20',
        year: '2026',
        title: 'Annual Business Summit',
        subtitle: 'A flagship event for leaders & entrepreneurs',
        time: '10:00 AM – 4:00 PM',
        location: 'Kathmandu, Bagmati Province',
        organizer: 'Central Committee',
        desc: 'A flagship event bringing together entrepreneurs, leaders and professionals.',
        imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=800&q=80',
        isFeatured: true,
        isBookmarked: false,
        status: 'upcoming',
        category: 'Business',
        province: 'Bagmati',
        tags: ['Business', 'Networking', 'Leadership'],
        tagType: 'business',
      ),
      const _EventItem(
        id: 'ev-2',
        month: 'SEP',
        day: '05',
        year: '2026',
        title: 'Teej Cultural Celebration',
        subtitle: 'Celebrate tradition, culture & togetherness',
        time: '11:00 AM – 3:00 PM',
        location: 'Pokhara, Gandaki Province',
        organizer: 'Pokhara Branch',
        desc: 'Celebrate tradition, culture and the spirit of togetherness.',
        imageUrl: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=800&q=80',
        isFeatured: false,
        isBookmarked: false,
        status: 'upcoming',
        category: 'Cultural',
        province: 'Gandaki',
        tags: ['Culture', 'Tradition', 'Community'],
        tagType: 'cultural',
      ),
      const _EventItem(
        id: 'ev-3',
        month: 'SEP',
        day: '18',
        year: '2026',
        title: 'Blood Donation Drive',
        subtitle: 'Donate blood, save lives',
        time: '9:00 AM – 1:00 PM',
        location: 'Biratnagar, Koshi Province',
        organizer: 'Biratnagar Branch',
        desc: 'Join us in saving lives. Your blood can bring hope to someone in need.',
        imageUrl: 'https://images.unsplash.com/photo-1615461066841-6116e61058f4?auto=format&fit=crop&w=800&q=80',
        isFeatured: false,
        isBookmarked: false,
        status: 'upcoming',
        category: 'Health',
        province: 'Koshi',
        tags: ['Health', 'Service', 'Humanity'],
        tagType: 'health',
      ),
      const _EventItem(
        id: 'ev-4',
        month: 'OCT',
        day: '02',
        year: '2026',
        title: 'Youth Empowerment Workshop',
        subtitle: 'Learn. Grow. Lead.',
        time: '10:00 AM – 2:00 PM',
        location: 'Lalitpur, Bagmati Province',
        organizer: 'Central Youth Wing',
        desc: 'Empowering Agrawal youth through career guidance & mentorship.',
        imageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=800&q=80',
        isFeatured: false,
        isBookmarked: false,
        status: 'upcoming',
        category: 'Youth',
        province: 'Bagmati',
        tags: ['Youth', 'Skill', 'Career'],
        tagType: 'youth',
      ),
      const _EventItem(
        id: 'ev-5',
        month: 'JAN',
        day: '15',
        year: '2026',
        title: 'Winter Health & Senior Camp',
        subtitle: 'Free consultations & checkups for elders',
        time: '08:00 AM – 2:00 PM',
        location: 'Butwal, Lumbini Province',
        organizer: 'Butwal Chapter',
        desc: 'Free medical consultations, health checkups and wellness kits for senior members.',
        imageUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=800&q=80',
        isFeatured: false,
        isBookmarked: false,
        status: 'past',
        category: 'Social',
        province: 'Lumbini',
        tags: ['Health', 'Elders', 'Wellness'],
        tagType: 'health',
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
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF9F7F5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Horizontal Filter Pills Bar
                    _FilterPillsBar(
                      selectedStatus: _selectedStatusFilter,
                      selectedProvince: _selectedProvince,
                      selectedCategory: _selectedCategory,
                      onStatusSelected: (st) => setState(() => _selectedStatusFilter = st),
                      onProvinceSelected: (pr) => setState(() => _selectedProvince = pr),
                      onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
                    ),
                    const SizedBox(height: 20),

                    // Section Title Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFDF0F0),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF700D15)),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$_selectedStatusFilter Events (${filteredEvents.length})',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E1615),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Calendar view opened')),
                              );
                            },
                            child: Row(
                              children: const [
                                Text(
                                  'View Calendar',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF700D15),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.calendar_month_outlined, size: 14, color: Color(0xFF700D15)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

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
          ],
        ),
      ),

      // Floating Action Button with Red Badge Counter
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () => _showFilterModalSheet(context),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF6B0E1B),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6B0E1B).withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.filter_alt_outlined, color: Colors.white, size: 24),
              ),
            ),
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.8),
                ),
                child: const Center(
                  child: Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                    ),
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

  void _showFilterModalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.filter_alt_rounded, color: Color(0xFF700D15)),
                  const SizedBox(width: 8),
                  const Text('Filter Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedProvince = null;
                        _selectedCategory = null;
                      });
                      Navigator.pop(ctx);
                    },
                    child: const Text('Reset All', style: TextStyle(color: Color(0xFF700D15), fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Select Province', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E1615))),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Bagmati', 'Gandaki', 'Koshi', 'Madhesh', 'Lumbini'].map((pr) {
                  final sel = _selectedProvince == pr;
                  return ChoiceChip(
                    label: Text(pr),
                    selected: sel,
                    selectedColor: const Color(0xFF700D15),
                    labelStyle: TextStyle(color: sel ? Colors.white : const Color(0xFF1E1615), fontWeight: FontWeight.w600, fontSize: 12),
                    onSelected: (val) {
                      setState(() => _selectedProvince = val ? pr : null);
                      setModalState(() {});
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Select Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E1615))),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Business', 'Cultural', 'Health', 'Youth', 'Social'].map((cat) {
                  final sel = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: sel,
                    selectedColor: const Color(0xFF700D15),
                    labelStyle: TextStyle(color: sel ? Colors.white : const Color(0xFF1E1615), fontWeight: FontWeight.w600, fontSize: 12),
                    onSelected: (val) {
                      setState(() => _selectedCategory = val ? cat : null);
                      setModalState(() {});
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF500913),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  ),
                  child: const Text('Apply Filters', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
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
              GestureDetector(
                onTap: onProfile,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0x33FFFFFF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 20),
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
class _FilterPillsBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Upcoming Pill
          _buildPill(
            icon: Icons.calendar_today_outlined,
            label: 'Upcoming',
            isSelected: selectedStatus == 'Upcoming',
            onTap: () => onStatusSelected('Upcoming'),
          ),
          const SizedBox(width: 8),

          // Past Pill
          _buildPill(
            icon: Icons.history_rounded,
            label: 'Past',
            isSelected: selectedStatus == 'Past',
            onTap: () => onStatusSelected('Past'),
          ),
          const SizedBox(width: 8),

          // All Pill
          _buildPill(
            icon: Icons.grid_view_rounded,
            label: 'All',
            isSelected: selectedStatus == 'All',
            onTap: () => onStatusSelected('All'),
          ),
          const SizedBox(width: 8),

          // Province Dropdown Pill
          PopupMenuButton<String?>(
            initialValue: selectedProvince,
            tooltip: 'Select Province',
            onSelected: onProvinceSelected,
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('All Provinces')),
              const PopupMenuItem(value: 'Bagmati', child: Text('Bagmati Province')),
              const PopupMenuItem(value: 'Gandaki', child: Text('Gandaki Province')),
              const PopupMenuItem(value: 'Koshi', child: Text('Koshi Province')),
              const PopupMenuItem(value: 'Madhesh', child: Text('Madhesh Province')),
              const PopupMenuItem(value: 'Lumbini', child: Text('Lumbini Province')),
            ],
            child: _buildDropdownPill(
              icon: Icons.location_on_outlined,
              label: selectedProvince ?? 'Province',
              isSelected: selectedProvince != null,
            ),
          ),
        ],
      ),
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
// 3. EVENT CARD ITEM (SPLIT IMAGE & DETAILS CONTAINER)
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
    return Container(
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
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                    child: CachedNetworkImage(
                      imageUrl: event.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: const Color(0xFFF0F0F0)),
                      errorWidget: (context, url, error) => Container(
                        color: const Color(0xFFE5D5D5),
                        child: const Icon(Icons.event, color: Color(0xFF700D15)),
                      ),
                    ),
                  ),

                  // Featured Badge Tag (Top-Left)
                  if (event.isFeatured)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53935),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.star, size: 10, color: Colors.white),
                            SizedBox(width: 3),
                            Text(
                              'FEATURED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
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
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Date Badge + Title/Subtitle + Bookmark Button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date Badge Box
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
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
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              Text(
                                event.day,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  height: 1.05,
                                ),
                              ),
                              Text(
                                event.year,
                                style: const TextStyle(
                                  color: Color(0xFFE5C158),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Title & Subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: const TextStyle(
                                  fontSize: 14.5,
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
                                    fontSize: 10.5,
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

                        // Bookmark Circle Icon
                        GestureDetector(
                          onTap: onBookmarkTap,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFDF5F2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              event.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                              size: 16,
                              color: const Color(0xFF700D15),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Info Metadata Rows
                    _buildInfoRow(Icons.access_time_outlined, event.time),
                    const SizedBox(height: 3),
                    _buildInfoRow(Icons.location_on_outlined, event.location),
                    const SizedBox(height: 3),
                    _buildInfoRow(Icons.account_circle_outlined, 'Organized by: ${event.organizer}'),
                    const SizedBox(height: 8),

                    // Tags Row
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: event.tags.map((tag) {
                        final tagBg = _getTagBg(event.tagType);
                        final tagTxt = _getTagText(event.tagType);
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: tagBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: tagTxt,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),

                    // Action Buttons Row (Register Now + Learn More)
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: onRegisterTap,
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF500913),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Register Now',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: onLearnMoreTap,
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFD6C9C5)),
                              ),
                              child: const Center(
                                child: Text(
                                  'Learn More',
                                  style: TextStyle(
                                    color: Color(0xFF500913),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
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
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: const Color(0xFF8C7A75)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 10.5,
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
