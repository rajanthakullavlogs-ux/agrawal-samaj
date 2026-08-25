import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../shared/models/event.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/events_repository.dart';
import '../data/rsvp_repository.dart';

/// Event Detail Screen — Redesigned matching exact UI spec dynamically populated by Event ID
class EventDetailScreen extends ConsumerStatefulWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  bool _isBookmarked = false;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventDetailProvider(widget.eventId));

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: InkWell(
              onTap: () {
                if (GoRouter.of(context).canPop()) {
                  context.pop();
                } else {
                  context.go(AppConstants.events);
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFFDF0F0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: Color(0xFF5C1414),
                  size: 22,
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          'Event Details',
          style: TextStyle(
            color: Color(0xFF5C1414),
            fontWeight: FontWeight.w700,
            fontSize: 19,
          ),
        ),
        actions: [
          // Notification Bell with Badge
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF5C1414), size: 24),
                onPressed: () => context.push(AppConstants.notifications),
              ),
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD93025),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(Icons.account_circle_outlined, color: Color(0xFF5C1414), size: 24),
              onPressed: () => context.push(AppConstants.profile),
            ),
          ),
        ],
      ),
      body: eventAsync.when(
        data: (event) => _buildEventContent(context, event),
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF5C1414))),
        error: (_, __) => _buildEventContent(context, null),
      ),
      bottomNavigationBar: const NASBottomNavBar(activeIndex: 1),
    );
  }

  Widget _buildEventContent(BuildContext context, Event? event) {
    final title = event?.title ?? 'Agrawal Business & Trade Summit 2026';
    final category = event?.category?.toUpperCase() ?? 'BUSINESS';
    final dateStr = event != null
        ? '${event.eventDate.day} ${_monthName(event.eventDate.month)} ${event.eventDate.year}'
        : '15 November 2026';
    final timeStr = event?.eventTime ?? '10:00 AM – 4:30 PM';
    final venueStr = event?.venue ?? 'Hotel Yak & Yeti, Kathmandu';
    final organizedBy = event?.organizedBy ?? 'Business Wing';
    final description = event?.description ??
        'A premier gathering of business leaders, entrepreneurs and professionals to exchange ideas, explore opportunities and drive growth together.';
    final posterUrl = event?.posterUrl;

    return ListView(
      padding: const EdgeInsets.only(bottom: 100),
      children: [
        const SizedBox(height: 8),

        // Hero Banner Card with Carousel Dots
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 210,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Event cover photo
                Positioned.fill(
                  child: posterUrl != null && posterUrl.startsWith('assets/')
                      ? Image.asset(posterUrl, fit: BoxFit.cover)
                      : CachedNetworkImage(
                          imageUrl: posterUrl ?? 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=800&q=80',
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Container(color: const Color(0xFF5C1414)),
                        ),
                ),

                // Top-Left Category Tag
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5C1414),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                // Top-Right Floating Share & Bookmark Buttons
                Positioned(
                  top: 14,
                  right: 14,
                  child: Row(
                    children: [
                      // Share Button
                      GestureDetector(
                        onTap: () => _shareEvent(context, title),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.share_outlined, size: 18, color: Color(0xFF1F2937)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Bookmark Button
                      GestureDetector(
                        onTap: () => setState(() => _isBookmarked = !_isBookmarked),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                            size: 18,
                            color: _isBookmarked ? const Color(0xFF5C1414) : const Color(0xFF1F2937),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Pagination Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 14,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF5C1414),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 4),
            for (int i = 0; i < 3; i++) ...[
              Container(
                width: 6,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0DCD8),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              if (i < 2) const SizedBox(width: 4),
            ],
          ],
        ),
        const SizedBox(height: 16),

        // Event Title & Subtitle Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF5C1414),
                  height: 1.25,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Connect • Collaborate • Grow',
                style: TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF6E645D),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Event Information Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEAE4E0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Row 1: Date + Add to Calendar Pill
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.calendar_today_outlined, color: Color(0xFF8F6910), size: 20),
                    const SizedBox(width: 12),
                    const Text(
                      'Date',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6E645D),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            dateStr,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Added "$title" to Calendar!')),
                              );
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDF0F0),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.calendar_today_outlined, size: 12, color: Color(0xFF5C1414)),
                                  SizedBox(width: 4),
                                  Text(
                                    'Add to Calendar',
                                    style: TextStyle(
                                      color: Color(0xFF5C1414),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1, color: Color(0xFFF3ECE7)),
                ),

                // Row 2: Time
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.access_time_outlined, color: Color(0xFF8F6910), size: 20),
                    const SizedBox(width: 12),
                    const Text(
                      'Time',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6E645D),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            timeStr,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '(Nepal Time)',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6E645D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1, color: Color(0xFFF3ECE7)),
                ),

                // Row 3: Venue + View on Map Pill
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined, color: Color(0xFF8F6910), size: 20),
                    const SizedBox(width: 12),
                    const Text(
                      'Venue',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6E645D),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            venueStr,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1F2937),
                            ),
                            textAlign: TextAlign.end,
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Durbar Marg, Kathmandu 44600',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF6E645D),
                            ),
                            textAlign: TextAlign.end,
                          ),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () => context.push(AppConstants.locations),
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDF0F0),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF5C1414)),
                                  SizedBox(width: 4),
                                  Text(
                                    'View on Map',
                                    style: TextStyle(
                                      color: Color(0xFF5C1414),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1, color: Color(0xFFF3ECE7)),
                ),

                // Row 4: Organized By
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.people_outline_rounded, color: Color(0xFF8F6910), size: 20),
                    const SizedBox(width: 12),
                    const Text(
                      'Organized By',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6E645D),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            organizedBy,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Nepal Agrawal Samaj',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF6E645D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // About This Event Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFDF0F0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.description_outlined, color: Color(0xFF5C1414), size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'About This Event',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF5C1414),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6E645D),
                  height: 1.45,
                ),
                maxLines: _isExpanded ? null : 3,
                overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isExpanded ? 'See less' : 'See more',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5C1414),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: const Color(0xFF5C1414),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Action Buttons (Register Now & Share Event)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // Register Now Button
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => _registerForEvent(context, title, dateStr, venueStr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5C1414),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.person_add_alt_1_rounded, size: 16, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'Register Now',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Share Event Button
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => _shareEvent(context, title),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFDF0F0),
                      foregroundColor: const Color(0xFF5C1414),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.share_outlined, size: 16, color: Color(0xFF5C1414)),
                        SizedBox(width: 6),
                        Text(
                          'Share Event',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF5C1414),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[(month - 1) % 12];
  }

  void _shareEvent(BuildContext context, String eventTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing "$eventTitle"...')),
    );
  }

  void _registerForEvent(BuildContext context, String title, String date, String venue) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.event_available_rounded, color: Color(0xFF5C1414)),
            SizedBox(width: 8),
            Text('Register for Event', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF5C1414)),
            ),
            const SizedBox(height: 4),
            Text('$date • $venue', style: const TextStyle(fontSize: 12, color: Color(0xFF6E645D))),
            const SizedBox(height: 12),
            const Text('Registration is free for all members.', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              ref.read(eventRsvpsProvider.notifier).addRsvp(
                EventRsvp(
                  id: 'rsvp-${DateTime.now().millisecondsSinceEpoch}',
                  eventId: widget.eventId,
                  eventName: title,
                  userName: 'Verified Member',
                  phone: '+977 9841990000',
                  userType: 'Member',
                  registeredAt: DateTime.now(),
                  eventStatus: 'upcoming',
                  eventCategory: 'Cultural',
                  eventDateStr: '$date • $venue',
                ),
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Successfully registered for "$title"!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5C1414), foregroundColor: Colors.white),
            child: const Text('Confirm RSVP', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
