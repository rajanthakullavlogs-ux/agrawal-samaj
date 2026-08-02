import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/design_tokens.dart';
import '../../../shared/widgets/widgets.dart';

class _EventItem {
  final String id;
  final String month;
  final String day;
  final String title;
  final String posterTitle;
  final String time;
  final String place;
  final String organizer;
  final String desc;
  final String imageUrl;
  final String status; // 'upcoming', 'past'
  final String category; // 'Business', 'Cultural', 'Social', 'Health'
  final String province; // 'Bagmati', 'Gandaki', 'Koshi', 'Madhesh', 'Lumbini'

  const _EventItem({
    required this.id,
    required this.month,
    required this.day,
    required this.title,
    required this.posterTitle,
    required this.time,
    required this.place,
    required this.organizer,
    required this.desc,
    required this.imageUrl,
    required this.status,
    required this.category,
    required this.province,
  });
}

/// Events Screen — Fully functional with live filtering by status, province, and category
class EventsListScreen extends ConsumerStatefulWidget {
  const EventsListScreen({super.key});

  @override
  ConsumerState<EventsListScreen> createState() => _EventsListScreenState();
}

class _EventsListScreenState extends ConsumerState<EventsListScreen> {
  String _selectedStatusFilter = 'Upcoming'; // 'Upcoming', 'Past', 'All'
  String? _selectedProvince; // null = All Provinces
  String? _selectedCategory; // null = All Categories

  static const List<_EventItem> _allEvents = [
    _EventItem(
      id: 'ev-2',
      month: 'AUG',
      day: '20',
      title: 'Annual Business Summit 2026',
      posterTitle: 'ANNUAL\nBUSINESS\nSUMMIT\n2026',
      time: '10:00 AM - 4:00 PM',
      place: 'Kathmandu, Bagmati Province',
      organizer: 'Organized by: Central Committee',
      desc: 'A flagship event bringing together entrepreneurs, leaders and professionals.',
      imageUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=800&q=80',
      status: 'upcoming',
      category: 'Business',
      province: 'Bagmati',
    ),
    _EventItem(
      id: 'ev-1',
      month: 'SEP',
      day: '05',
      title: 'Teej Cultural Celebration',
      posterTitle: 'TEEJ\nCELEBRATION\n2081',
      time: '11:00 AM - 3:00 PM',
      place: 'Pokhara, Gandaki Province',
      organizer: 'Organized by: Pokhara Branch',
      desc: 'Celebrate tradition, culture and the spirit of togetherness.',
      imageUrl: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=800&q=80',
      status: 'upcoming',
      category: 'Cultural',
      province: 'Gandaki',
    ),
    _EventItem(
      id: 'ev-4',
      month: 'SEP',
      day: '18',
      title: 'Mega Blood Donation Drive',
      posterTitle: 'MEGA BLOOD\nDONATION DRIVE\n2081',
      time: '9:00 AM - 1:00 PM',
      place: 'Biratnagar, Koshi Province',
      organizer: 'Organized by: Biratnagar Branch',
      desc: 'Join us in saving lives. Your blood can bring hope to someone in need.',
      imageUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=800&q=80',
      status: 'upcoming',
      category: 'Health',
      province: 'Koshi',
    ),
    _EventItem(
      id: 'ev-3',
      month: 'OCT',
      day: '12',
      title: 'Youth Leadership & Career Expo',
      posterTitle: 'YOUTH\nLEADERSHIP\nEXPO 2026',
      time: '01:00 PM - 5:00 PM',
      place: 'Birgunj, Madhesh Province',
      organizer: 'Organized by: Birgunj Youth Wing',
      desc: 'Empowering Agrawal youth through career guidance & mentorship.',
      imageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=800&q=80',
      status: 'upcoming',
      category: 'Youth',
      province: 'Madhesh',
    ),
    _EventItem(
      id: 'ev-5',
      month: 'JAN',
      day: '15',
      title: 'Winter Health & Senior Wellness Camp',
      posterTitle: 'SENIOR\nWELLNESS\nCAMP 2026',
      time: '08:00 AM - 2:00 PM',
      place: 'Butwal, Lumbini Province',
      organizer: 'Organized by: Butwal Chapter',
      desc: 'Free medical consultations, health checkups and wellness kits for senior members.',
      imageUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=800&q=80',
      status: 'past',
      category: 'Social',
      province: 'Lumbini',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Compute filtered events
    final filteredEvents = _allEvents.where((e) {
      // Status filter
      if (_selectedStatusFilter == 'Upcoming' && e.status != 'upcoming') return false;
      if (_selectedStatusFilter == 'Past' && e.status != 'past') return false;

      // Province filter
      if (_selectedProvince != null && e.province != _selectedProvince) return false;

      // Category filter
      if (_selectedCategory != null && e.category != _selectedCategory) return false;

      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const NASAppBar(title: 'Events', showBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    'Events',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      fontFamily: NASTypography.headlineFont,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Join our events and be part of our community',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Horizontal Filter Pills Row
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _filterPill(Icons.calendar_today_rounded, 'Upcoming', _selectedStatusFilter == 'Upcoming',
                      onTap: () => setState(() => _selectedStatusFilter = 'Upcoming')),
                  const SizedBox(width: 8),
                  _filterPill(Icons.history_rounded, 'Past', _selectedStatusFilter == 'Past',
                      onTap: () => setState(() => _selectedStatusFilter = 'Past')),
                  const SizedBox(width: 8),
                  _filterPill(Icons.grid_view_rounded, 'All', _selectedStatusFilter == 'All',
                      onTap: () => setState(() => _selectedStatusFilter = 'All')),
                  const SizedBox(width: 8),

                  // Province Selector Dropdown Pill
                  PopupMenuButton<String?>(
                    initialValue: _selectedProvince,
                    tooltip: 'Select Province',
                    onSelected: (province) => setState(() => _selectedProvince = province),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: null, child: Text('All Provinces')),
                      const PopupMenuItem(value: 'Bagmati', child: Text('Bagmati Province')),
                      const PopupMenuItem(value: 'Gandaki', child: Text('Gandaki Province')),
                      const PopupMenuItem(value: 'Koshi', child: Text('Koshi Province')),
                      const PopupMenuItem(value: 'Madhesh', child: Text('Madhesh Province')),
                      const PopupMenuItem(value: 'Lumbini', child: Text('Lumbini Province')),
                    ],
                    child: _dropdownPill(
                      Icons.location_on_rounded,
                      _selectedProvince == null ? 'Province' : _selectedProvince!,
                      isSelected: _selectedProvince != null,
                      onClear: _selectedProvince != null
                          ? () => setState(() => _selectedProvince = null)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Category Selector Dropdown Pill
                  PopupMenuButton<String?>(
                    initialValue: _selectedCategory,
                    tooltip: 'Select Category',
                    onSelected: (category) => setState(() => _selectedCategory = category),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: null, child: Text('All Categories')),
                      const PopupMenuItem(value: 'Cultural', child: Text('Cultural')),
                      const PopupMenuItem(value: 'Business', child: Text('Business')),
                      const PopupMenuItem(value: 'Youth', child: Text('Youth')),
                      const PopupMenuItem(value: 'Health', child: Text('Health')),
                      const PopupMenuItem(value: 'Social', child: Text('Social')),
                    ],
                    child: _dropdownPill(
                      Icons.category_rounded,
                      _selectedCategory == null ? 'Category' : _selectedCategory!,
                      isSelected: _selectedCategory != null,
                      onClear: _selectedCategory != null
                          ? () => setState(() => _selectedCategory = null)
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Clean Section Header (without unnecessary View All)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedStatusFilter == 'Upcoming'
                        ? 'Upcoming Events (${filteredEvents.length})'
                        : _selectedStatusFilter == 'Past'
                            ? 'Past Gatherings (${filteredEvents.length})'
                            : 'All Events (${filteredEvents.length})',
                    style: AppText.h2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Events List Cards
            filteredEvents.isEmpty
                ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.event_busy_rounded, size: 48, color: AppColors.textSecondary),
                        const SizedBox(height: 10),
                        const Text(
                          'No events match your selected filters',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedStatusFilter = 'All';
                              _selectedProvince = null;
                              _selectedCategory = null;
                            });
                          },
                          child: const Text('Reset All Filters'),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredEvents.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, i) {
                      final e = filteredEvents[i];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          boxShadow: AppShadow.card,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Poster Image with Text Overlay
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(AppRadius.lg),
                                bottomLeft: Radius.circular(AppRadius.lg),
                              ),
                              child: SizedBox(
                                width: 115,
                                height: 215,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: e.imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black.withValues(alpha: 0.65),
                                            Colors.black.withValues(alpha: 0.80),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.posterTitle,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 11,
                                              height: 1.15,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Right Content Details
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Date Badge Box
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                e.month,
                                                style: const TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                              Text(
                                                e.day,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w900,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            e.title,
                                            style: AppText.h3.copyWith(fontSize: 13),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    _iconRow(Icons.access_time_rounded, e.time),
                                    const SizedBox(height: 3),
                                    _iconRow(Icons.location_on_rounded, e.place),
                                    const SizedBox(height: 3),
                                    _iconRow(Icons.account_circle_outlined, e.organizer),
                                    const SizedBox(height: 6),
                                    Text(
                                      e.desc,
                                      style: AppText.bodySmall,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 32,
                                            child: ElevatedButton(
                                              onPressed: () => _showEventRegistrationDialog(context, e),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.primary,
                                                foregroundColor: Colors.white,
                                                elevation: 0,
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                                ),
                                              ),
                                              child: const Text('Register Now',
                                                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700)),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: SizedBox(
                                            height: 32,
                                            child: OutlinedButton(
                                              onPressed: () => context.push('/events/${e.id}'),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: AppColors.primary,
                                                side: const BorderSide(color: AppColors.border),
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                                ),
                                              ),
                                              child: const Text('Learn More',
                                                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700)),
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
                      );
                    },
                  ),
            const SizedBox(height: 20),

            // "Have an Event to Share?" Orange Banner (Clean layout without confusing dots)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.event_available_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Have an Event to Share?',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Organize events and bring our community together.',
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => context.go(AppConstants.contact),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.accent,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Submit Event', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800)),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded, size: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: Row(
          children: const [
            Icon(Icons.event_available_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Event RSVP Registration', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Event: ${event.title}',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.primary),
              ),
              Text('${event.time} • ${event.place}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              const SizedBox(height: 14),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Attendee Full Name',
                  hintText: 'e.g. Ramesh Agrawal',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: '+977 9801XXXXXX',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
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
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Confirm Registration', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _filterPill(IconData icon, String label, bool isSelected, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isSelected ? Colors.white : AppColors.accent),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdownPill(IconData icon, String label, {bool isSelected = false, VoidCallback? onClear}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: isSelected ? AppColors.primary : AppColors.accent),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 4),
          if (isSelected && onClear != null)
            GestureDetector(
              onTap: onClear,
              child: const Icon(Icons.close_rounded, size: 14, color: AppColors.primary),
            )
          else
            const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _iconRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.accent),
        const SizedBox(width: 4),
        Expanded(
          child: Text(text, style: AppText.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
