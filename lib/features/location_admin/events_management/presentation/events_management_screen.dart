import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/models/event.dart';
import '../../../../shared/widgets/nas_logo.dart';
import '../../../events/data/events_repository.dart';
import '../../../events/data/rsvp_repository.dart';

/// B3 — Events Management Screen (Location Admin)
class EventsManagementScreen extends ConsumerStatefulWidget {
  final String? initialFilter;
  const EventsManagementScreen({super.key, this.initialFilter});

  @override
  ConsumerState<EventsManagementScreen> createState() => _EventsManagementScreenState();
}

enum _EventFilter { all, upcoming, cultural, business, past }

bool _isParticularBranchEvent(Event e) {
  final v = (e.venue ?? '').toLowerCase();
  final o = (e.organizedBy ?? '').toLowerCase();
  if (v.contains('birgunj') || v.contains('biratnagar') || o.contains('koshi') || o.contains('birgunj')) {
    return false;
  }
  return true;
}

class _EventsManagementScreenState extends ConsumerState<EventsManagementScreen> {
  late _EventFilter _filter;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.initialFilter == 'UPCOMING') {
      _filter = _EventFilter.upcoming;
    } else if (widget.initialFilter == 'PAST') {
      _filter = _EventFilter.past;
    } else {
      _filter = _EventFilter.all;
    }

    if (widget.initialFilter != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            220.0,
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOutCubic,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
    final rsvps = ref.watch(eventRsvpsProvider);

    final branchEvents = events.where(_isParticularBranchEvent).toList();
    final totalEvents = branchEvents.length;
    final ongoingEvents = branchEvents.where((e) => e.status.toLowerCase() == 'active' || e.status.toLowerCase() == 'ongoing').length;

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
          controller: _scrollController,
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            const _AdminTopBar(),
            const SizedBox(height: 14),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _HeroBanner(),
            ),
            const SizedBox(height: 20),

            // At a Glance Header (Filter button removed)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'At a Glance',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 12),

            // Metrics Summary Row (Total Events, Total RSVPs, Ongoing Events)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      title: 'Total Events',
                      value: '$totalEvents',
                      trend: '↑ $totalEvents total',
                      trendColor: const Color(0xFF3E7C4A),
                      icon: Icons.event_available_rounded,
                      iconColor: const Color(0xFFC7555D),
                      iconBg: const Color(0xFFFAEAEC),
                      onTap: () => _showBranchEventsModal(context, ref, initialTab: 'UPCOMING'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricCard(
                      title: 'Total RSVPs',
                      value: '${rsvps.length}',
                      trend: '↑ ${rsvps.length} active',
                      trendColor: const Color(0xFF3E7C4A),
                      icon: Icons.local_activity_rounded,
                      iconColor: const Color(0xFF3E7C4A),
                      iconBg: const Color(0xFFE5F5E9),
                      onTap: () => _showAllRsvpsModal(context, ref),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricCard(
                      title: 'Ongoing Events',
                      value: '$ongoingEvents',
                      trend: '$ongoingEvents active',
                      trendColor: const Color(0xFFC4901E),
                      icon: Icons.play_circle_filled_rounded,
                      iconColor: const Color(0xFFC4901E),
                      iconBg: const Color(0xFFFCF7EB),
                      onTap: () => _showBranchEventsModal(context, ref, initialTab: 'ONGOING'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // New RSVPs Section
            _sectionHeader(
              'New RSVPs (${rsvps.length})',
              onViewAll: () => _showAllRsvpsModal(context, ref),
            ),
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
                    for (int i = 0; i < rsvps.take(4).length; i++) ...[
                      if (i > 0) const Divider(height: 1, color: AppColors.border),
                      _RsvpTile(
                        rsvp: rsvps[i],
                        onTap: () => _showAllRsvpsModal(context, ref),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Upcoming Events Section
            _sectionHeader('Upcoming Events', onViewAll: () => _showBranchEventsModal(context, ref)),
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
          const SizedBox(width: 6),
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
// ---------------------------------------------------------------------------
// HERO BANNER (2 QUICK ACTIONS: BROADCAST & DOWNLOAD)
// ---------------------------------------------------------------------------
class _HeroBanner extends ConsumerWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF500913), Color(0xFF700D15)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF500913).withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Events Management',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Manage, promote & broadcast branch events.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFE5C8A6),
                          height: 1.3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _HeroActionButton(
                    icon: Icons.campaign_rounded,
                    title: 'Broadcast',
                    subtitle: 'Send member notice',
                    color: Colors.white.withValues(alpha: 0.12),
                    borderColor: Colors.white.withValues(alpha: 0.2),
                    iconColor: const Color(0xFF64B5F6),
                    iconBg: const Color(0xFF64B5F6).withValues(alpha: 0.2),
                    onTap: () => _showBroadcastDialog(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _HeroActionButton(
                    icon: Icons.file_download_rounded,
                    title: 'Download',
                    subtitle: 'Export event report',
                    color: Colors.white.withValues(alpha: 0.12),
                    borderColor: Colors.white.withValues(alpha: 0.2),
                    iconColor: const Color(0xFF81C784),
                    iconBg: const Color(0xFF81C784).withValues(alpha: 0.2),
                    onTap: () => _handleDownloadReport(context),
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
  final Color borderColor;
  final Color iconColor;
  final Color iconBg;
  final VoidCallback onTap;

  const _HeroActionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.borderColor,
    required this.iconColor,
    required this.iconBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7.5),
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.8),
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
    );
  }
}

void _showBroadcastDialog(BuildContext context) {
  final titleCtrl = TextEditingController(text: 'Notice: Upcoming Community Event');
  final msgCtrl = TextEditingController(text: 'Check program schedule and venue guidelines for the upcoming event.');
  String audience = 'All Members';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (modalCtx) => StatefulBuilder(
      builder: (bCtx, setModalState) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(modalCtx).viewInsets.bottom + 20,
          top: 16,
          left: 20,
          right: 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: const [
                Icon(Icons.campaign_rounded, color: Color(0xFF500913), size: 24),
                SizedBox(width: 10),
                Text(
                  'Broadcast Notice',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF1E1615)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Send push notification & message to branch members',
              style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleCtrl,
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                labelText: 'Notice Title',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: msgCtrl,
              maxLines: 3,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                labelText: 'Announcement Message',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 14),
            const Text('Recipient Audience', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: ['All Members', 'Registered RSVPs', 'Executive Board'].map((aud) {
                final isSel = audience == aud;
                return ChoiceChip(
                  label: Text(aud, style: TextStyle(fontSize: 11, color: isSel ? Colors.white : const Color(0xFF500913), fontWeight: FontWeight.w600)),
                  selected: isSel,
                  selectedColor: const Color(0xFF500913),
                  onSelected: (val) => setModalState(() => audience = aud),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(modalCtx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: const [
                          Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                          SizedBox(width: 10),
                          Text('Broadcast notice sent successfully!'),
                        ],
                      ),
                      backgroundColor: const Color(0xFF3E7C4A),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                icon: const Icon(Icons.send_rounded, size: 18),
                label: const Text('Send Broadcast Notice', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF500913),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _handleDownloadReport(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: const [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Generating Events Report (CSV/PDF)...',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF500913),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );

  Future.delayed(const Duration(seconds: 2), () {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.file_download_done_rounded, color: Colors.white, size: 18),
              SizedBox(width: 10),
              Text('Report saved to downloads!'),
            ],
          ),
          backgroundColor: const Color(0xFF3E7C4A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  });
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
  final VoidCallback? onTap;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.trend,
    required this.trendColor,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(5.5),
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 14),
              ),
              const SizedBox(width: 2),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: trendColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      trend,
                      style: TextStyle(fontSize: 8.5, color: trendColor, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(title, style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary, height: 1.1)),
        ],
      ),
    ),
    );
  }
}

// ---------------------------------------------------------------------------
// RSVP TILE (TICKETS REMOVED, GUEST / MEMBER SPECIFIED)
// ---------------------------------------------------------------------------
class _RsvpTile extends StatelessWidget {
  final EventRsvp rsvp;
  final VoidCallback? onTap;

  const _RsvpTile({
    required this.rsvp,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMember = rsvp.userType.toUpperCase() == 'MEMBER';
    final avatar = rsvp.avatarUrl ?? 'https://i.pravatar.cc/150?img=11';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: NetworkImage(avatar), fit: BoxFit.cover),
                border: Border.all(color: isMember ? const Color(0xFF500913) : const Color(0xFFE65100), width: 1.5),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          rsvp.userName,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isMember ? const Color(0xFFFAEAEC) : const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isMember ? const Color(0xFFE5B5B9) : const Color(0xFFFFCC80),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          rsvp.userType,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: isMember ? const Color(0xFF700D15) : const Color(0xFFE65100),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.event_note_rounded, size: 12, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          rsvp.eventName,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.phone_iphone_rounded, size: 11, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        rsvp.phone,
                        style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// VIEW ALL BRANCH EVENTS MODAL ("PAST EVENTS", "ONGOING EVENTS", "UPCOMING EVENTS")
// ---------------------------------------------------------------------------
void _showBranchEventsModal(BuildContext context, WidgetRef ref, {String initialTab = 'UPCOMING'}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _BranchEventsViewModal(initialTab: initialTab),
  );
}

class _BranchEventsViewModal extends ConsumerStatefulWidget {
  final String initialTab;
  const _BranchEventsViewModal({this.initialTab = 'UPCOMING'});

  @override
  ConsumerState<_BranchEventsViewModal> createState() => _BranchEventsViewModalState();
}

class _BranchEventsViewModalState extends ConsumerState<_BranchEventsViewModal> {
  late String _selectedTab;
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allEvents = ref.watch(eventsNotifierProvider);

    // Filter strictly events belonging to this particular branch (Kathmandu Branch)
    final branchEvents = allEvents.where(_isParticularBranchEvent).toList();

    final pastCount = branchEvents.where((e) => e.isPast || e.status.toUpperCase() == 'PAST').length;
    final ongoingCount = branchEvents.where((e) => e.status.toLowerCase() == 'active' || e.status.toLowerCase() == 'ongoing').length;
    final upcomingCount = branchEvents.where((e) => e.isUpcoming || e.status.toUpperCase() == 'UPCOMING').length;

    final filteredEvents = branchEvents.where((e) {
      final statusUpper = e.status.toUpperCase();
      if (_selectedTab == 'PAST') {
        return e.isPast || statusUpper == 'PAST';
      } else if (_selectedTab == 'ONGOING') {
        return statusUpper == 'ACTIVE' || statusUpper == 'ONGOING';
      } else if (_selectedTab == 'UPCOMING') {
        return e.isUpcoming || statusUpper == 'UPCOMING';
      }
      return true;
    }).where((e) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.trim().toLowerCase();
      return e.title.toLowerCase().contains(q) ||
          (e.category ?? '').toLowerCase().contains(q) ||
          (e.venue ?? '').toLowerCase().contains(q);
    }).toList();

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.90),
      decoration: const BoxDecoration(
        color: Color(0xFFF9F6F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 14, 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF500913), Color(0xFF700D15)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.event_note_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Kathmandu Branch Events',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Exclusively showing events for Kathmandu Branch',
                            style: TextStyle(fontSize: 11, color: Color(0xFFE5C8A6), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Search Field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFEFE8E5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (val) => setState(() => _searchQuery = val),
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search branch events by title, venue...',
                  hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400, fontWeight: FontWeight.w500),
                  prefixIcon: const Icon(Icons.search_rounded, size: 19, color: Color(0xFF500913)),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 16, color: Colors.grey),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // Filter Row strictly ("PAST EVENTS", "ONGOING EVENTS", "UPCOMING EVENTS")
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterPill('PAST', 'PAST EVENTS', '$pastCount', const Color(0xFF616161)),
                const SizedBox(width: 6),
                _buildFilterPill('ONGOING', 'ONGOING EVENTS', '$ongoingCount', const Color(0xFFC4901E)),
                const SizedBox(width: 6),
                _buildFilterPill('UPCOMING', 'UPCOMING EVENTS', '$upcomingCount', const Color(0xFF500913)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Events List
          Expanded(
            child: filteredEvents.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF3ECE7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.event_busy_rounded, size: 36, color: Color(0xFF500913)),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No $_selectedTab Branch Events Found',
                            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'No events match this filter for Kathmandu Branch',
                            style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      return _BranchEventCardDetail(event: event);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String key, String label, String count, Color activeColor) {
    final isSelected = _selectedTab == key;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = key),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 2),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? activeColor : const Color(0xFFEFE8E5)),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.2,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withValues(alpha: 0.25) : const Color(0xFFF3ECE7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BranchEventCardDetail extends StatelessWidget {
  final Event event;

  const _BranchEventCardDetail({required this.event});

  @override
  Widget build(BuildContext context) {
    final isPast = event.isPast || event.status.toUpperCase() == 'PAST';
    final isOngoing = event.status.toLowerCase() == 'active' || event.status.toLowerCase() == 'ongoing';
    
    final statusLabel = isOngoing ? 'ONGOING' : (isPast ? 'PAST' : 'UPCOMING');
    final statusColor = isOngoing ? const Color(0xFF2E7D32) : (isPast ? Colors.grey.shade700 : const Color(0xFF1565C0));
    final statusBg = isOngoing ? const Color(0xFFE5F5E9) : (isPast ? Colors.grey.shade200 : const Color(0xFFE3F2FD));
    final accentColor = isOngoing ? const Color(0xFFC4901E) : (isPast ? Colors.grey.shade600 : const Color(0xFF500913));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFE8E5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 5,
                color: accentColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              event.category?.toUpperCase() ?? 'EVENT',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                color: accentColor,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: statusColor,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  statusLabel,
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w900,
                                    color: statusColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 12, color: AppColors.textSecondary),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              '${event.eventTime ?? ''} • ${event.venue ?? ''}',
                              style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (event.organizedBy != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.business_rounded, size: 12, color: AppColors.textSecondary),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                'Organized by: ${event.organizedBy}',
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
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
}

// ---------------------------------------------------------------------------
// VIEW ALL RSVPS & ATTENDEES DIALOGS
// ---------------------------------------------------------------------------
void _showAllRsvpsModal(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const _AllRsvpsViewModal(),
  );
}

class _AllRsvpsViewModal extends ConsumerStatefulWidget {
  const _AllRsvpsViewModal();
  @override
  ConsumerState<_AllRsvpsViewModal> createState() => _AllRsvpsViewModalState();
}

class _AllRsvpsViewModalState extends ConsumerState<_AllRsvpsViewModal> {
  String _selectedTab = 'ONGOING'; // 'ONGOING', 'UPCOMING', 'ALL'
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allRsvps = ref.watch(eventRsvpsProvider);
    final allEvents = ref.watch(eventsNotifierProvider);
    final events = allEvents.where(_isParticularBranchEvent).toList();
    final ongoingCount = events.where((e) => e.status.toLowerCase() == 'active' || e.status.toLowerCase() == 'ongoing').length;
    final upcomingCount = events.where((e) => e.isUpcoming || e.status.toUpperCase() == 'UPCOMING').length;
    final totalCount = events.length;

    final filteredEvents = events.where((e) {
      if (_selectedTab == 'ONGOING') return e.status.toLowerCase() == 'active' || e.status.toLowerCase() == 'ongoing';
      if (_selectedTab == 'UPCOMING') return e.isUpcoming || e.status.toUpperCase() == 'UPCOMING';
      return true;
    }).where((e) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.trim().toLowerCase();
      return e.title.toLowerCase().contains(q) || (e.category ?? '').toLowerCase().contains(q) || (e.venue ?? '').toLowerCase().contains(q);
    }).toList();

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      decoration: const BoxDecoration(
        color: Color(0xFFF9F6F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 14, 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF500913), Color(0xFF700D15)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.event_available_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Branch Event RSVPs',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'View and manage registered members & guests by event',
                            style: TextStyle(fontSize: 11, color: Color(0xFFE5C8A6), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Search Field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFEFE8E5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (val) => setState(() => _searchQuery = val),
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search event title, category, venue...',
                  hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400, fontWeight: FontWeight.w500),
                  prefixIcon: const Icon(Icons.search_rounded, size: 19, color: Color(0xFF500913)),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 16, color: Colors.grey),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // Filter Row strictly ("ONGOING", "UPCOMING", "ALL")
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterPill('ONGOING', 'ONGOING', '$ongoingCount', const Color(0xFFC4901E)),
                const SizedBox(width: 8),
                _buildFilterPill('UPCOMING', 'UPCOMING', '$upcomingCount', const Color(0xFF500913)),
                const SizedBox(width: 8),
                _buildFilterPill('ALL', 'ALL', '$totalCount', const Color(0xFF374151)),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // List of events
          Expanded(
            child: filteredEvents.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF3ECE7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.event_busy_rounded, size: 36, color: Color(0xFF500913)),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No $_selectedTab Events Found',
                            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Try switching tabs or clearing search filter',
                            style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      final eventRsvpsList = allRsvps.where((r) =>
                        r.eventId == event.id ||
                        r.eventName.toLowerCase().contains(event.title.toLowerCase())
                      ).toList();

                      return _EventRsvpCard(
                        event: event,
                        rsvps: eventRsvpsList,
                        onTap: () => _showEventAttendeesModal(context, event.title, eventRsvpsList),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String key, String label, String count, Color activeColor) {
    final isSelected = _selectedTab == key;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = key),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? activeColor : const Color(0xFFEFE8E5)),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.3,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withValues(alpha: 0.25) : const Color(0xFFF3ECE7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventRsvpCard extends StatelessWidget {
  final dynamic event;
  final List<EventRsvp> rsvps;
  final VoidCallback onTap;

  const _EventRsvpCard({
    required this.event,
    required this.rsvps,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final memberCount = rsvps.where((r) => r.userType.toUpperCase() == 'MEMBER').length;
    final guestCount = rsvps.where((r) => r.userType.toUpperCase() == 'GUEST').length;

    final isOngoing = event.status.toLowerCase() == 'active' || event.status.toLowerCase() == 'ongoing';
    final accentColor = isOngoing ? const Color(0xFFC4901E) : const Color(0xFF500913);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFE8E5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left accent bar
                Container(
                  width: 5,
                  color: accentColor,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                event.category?.toUpperCase() ?? 'EVENT',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                  color: accentColor,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isOngoing ? const Color(0xFFE5F5E9) : const Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isOngoing ? const Color(0xFF2E7D32) : const Color(0xFF1565C0),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isOngoing ? 'ONGOING' : 'UPCOMING',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w900,
                                      color: isOngoing ? const Color(0xFF2E7D32) : const Color(0xFF1565C0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded, size: 12, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${event.eventTime ?? ''} • ${event.venue ?? ''}',
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1, color: Color(0xFFF3ECE7)),
                        const SizedBox(height: 10),

                        // Zero Overflow RSVP summary row using Wrap
                        Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3E5F5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${rsvps.length} RSVPs',
                                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF7B1FA2)),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFAEAEC),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '$memberCount Members',
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF700D15)),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF3E0),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '$guestCount Guests',
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFFE65100)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'View List',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF500913)),
                                ),
                                SizedBox(width: 2),
                                Icon(Icons.arrow_forward_ios_rounded, size: 11, color: Color(0xFF500913)),
                              ],
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
      ),
    );
  }
}

void _showEventAttendeesModal(BuildContext context, String eventTitle, List<EventRsvp> attendees) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _EventAttendeesModal(eventTitle: eventTitle, attendees: attendees),
  );
}

class _EventAttendeesModal extends StatefulWidget {
  final String eventTitle;
  final List<EventRsvp> attendees;

  const _EventAttendeesModal({required this.eventTitle, required this.attendees});

  @override
  State<_EventAttendeesModal> createState() => _EventAttendeesModalState();
}

class _EventAttendeesModalState extends State<_EventAttendeesModal> {
  String _search = '';
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.attendees.where((a) {
      if (_search.trim().isEmpty) return true;
      final q = _search.trim().toLowerCase();
      return a.userName.toLowerCase().contains(q) || a.phone.contains(q);
    }).toList();

    final membersCount = widget.attendees.where((a) => a.userType.toUpperCase() == 'MEMBER').length;
    final guestsCount = widget.attendees.where((a) => a.userType.toUpperCase() == 'GUEST').length;

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: const BoxDecoration(
        color: Color(0xFFF9F6F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 14, 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF500913), Color(0xFF700D15)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.35), borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.eventTitle,
                            style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w900, color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${widget.attendees.length} Attendees',
                                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$membersCount Members • $guestsCount Guests',
                                style: const TextStyle(fontSize: 11, color: Color(0xFFE5C8A6), fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle),
                        child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Search Field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEFE8E5)),
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (val) => setState(() => _search = val),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: 'Search attendee by name or phone...',
                  hintStyle: TextStyle(fontSize: 11.5, color: Colors.grey.shade400),
                  prefixIcon: const Icon(Icons.search_rounded, size: 18, color: Color(0xFF500913)),
                  suffixIcon: _search.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 16, color: Colors.grey),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _search = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // Attendees List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_search_rounded, size: 42, color: Colors.grey.shade400),
                          const SizedBox(height: 10),
                          Text(
                            'No Attendees Match Your Search',
                            style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w700, fontSize: 13.5),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, idx) {
                      final item = filtered[idx];
                      final isMember = item.userType.toUpperCase() == 'MEMBER';

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFEFE8E5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.025),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 21,
                              backgroundColor: isMember ? const Color(0xFFFAEAEC) : const Color(0xFFFFF3E0),
                              backgroundImage: NetworkImage(item.avatarUrl ?? 'https://i.pravatar.cc/150?img=11'),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          item.userName,
                                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: isMember ? const Color(0xFFFAEAEC) : const Color(0xFFFFF3E0),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                            color: isMember ? const Color(0xFFE5B5B9) : const Color(0xFFFFCC80),
                                            width: 0.8,
                                          ),
                                        ),
                                        child: Text(
                                          item.userType,
                                          style: TextStyle(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w900,
                                            color: isMember ? const Color(0xFF700D15) : const Color(0xFFE65100),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      const Icon(Icons.phone_iphone_rounded, size: 11, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          item.phone,
                                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Contacting ${item.userName} (${item.phone})...'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAEAEC),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.call_rounded, color: Color(0xFF500913), size: 18),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
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

String _formatTimeOfDay(TimeOfDay tod) {
  final hour = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
  final minute = tod.minute.toString().padLeft(2, '0');
  final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
  return '${hour.toString().padLeft(2, '0')}:$minute $period';
}

void _showCreateEventDialog(BuildContext context, WidgetRef ref) {
  final titleController = TextEditingController();
  final venueController = TextEditingController(text: 'Samaj Bhawan Hall, Kathmandu');
  final timeController = TextEditingController(text: '05:00 PM – 9:00 PM');
  final organizerController = TextEditingController(text: 'Kathmandu Chapter');
  final descController = TextEditingController();
  final posterUrlController = TextEditingController();
  final posterFocusNode = FocusNode();

  String category = 'Cultural';
  List<String> categoriesList = ['Cultural', 'Business', 'Youth', 'Social', 'Health'];
  DateTime selectedDate = DateTime.now().add(const Duration(days: 7));
  String status = 'upcoming';
  String? errorMsg;

  final presetPosters = {
    'Cultural': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=800&q=80',
    'Business': 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&w=800&q=80',
    'Health': 'https://images.unsplash.com/photo-1615461066841-6116e61058f4?auto=format&fit=crop&w=800&q=80',
    'Youth': 'https://images.unsplash.com/photo-1523580494863-6f3031224c94?auto=format&fit=crop&w=800&q=80',
    'Social': 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=800&q=80',
  };

  posterUrlController.text = presetPosters[category]!;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (modalContext) => StatefulBuilder(
      builder: (ctx, setModalState) {
        return Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.88),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Drag Handle
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Header Banner Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF500913), Color(0xFF3F050C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF500913).withValues(alpha: 0.25),
                          blurRadius: 10,
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
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.add_box_rounded, color: Color(0xFFE5C158), size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Publish New Event',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Fill in all details to display in the main Events section',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Form Fields List
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (errorMsg != null) ...[
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDE8E8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE53935)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline_rounded, color: Color(0xFFE53935), size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      errorMsg!,
                                      style: const TextStyle(color: Color(0xFFE53935), fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],

                          // 1. Event Category Selector (with + Custom Category option)
                          const Text('Event Category *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E1615))),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ...categoriesList.map((cat) {
                                final isSel = category == cat;
                                return GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      category = cat;
                                      if (presetPosters.containsKey(cat)) {
                                        posterUrlController.text = presetPosters[cat]!;
                                      }
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSel ? const Color(0xFF500913) : const Color(0xFFF7F5F4),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSel ? const Color(0xFF500913) : const Color(0xFFEBE5E1),
                                      ),
                                    ),
                                    child: Text(
                                      cat,
                                      style: TextStyle(
                                        color: isSel ? Colors.white : const Color(0xFF500913),
                                        fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                );
                              }),

                              // "+ Add Custom Category" Chip
                              GestureDetector(
                                onTap: () {
                                  final customCatController = TextEditingController();
                                  showDialog(
                                    context: ctx,
                                    builder: (dCtx) => AlertDialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                      title: Row(
                                        children: const [
                                          Icon(Icons.add_circle_outline_rounded, color: Color(0xFF500913)),
                                          SizedBox(width: 8),
                                          Text(
                                            'Add Custom Category',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E1615)),
                                          ),
                                        ],
                                      ),
                                      content: TextField(
                                        controller: customCatController,
                                        autofocus: true,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                        decoration: InputDecoration(
                                          hintText: 'e.g. Sports, Religious, Welfare...',
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(dCtx),
                                          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            final newCat = customCatController.text.trim();
                                            if (newCat.isNotEmpty) {
                                              setModalState(() {
                                                if (!categoriesList.contains(newCat)) {
                                                  categoriesList.add(newCat);
                                                }
                                                category = newCat;
                                              });
                                              Navigator.pop(dCtx);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF500913),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          ),
                                          child: const Text('Add Category', style: TextStyle(fontWeight: FontWeight.w700)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF5F5),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFF500913), width: 1.2),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.add_rounded, size: 16, color: Color(0xFF500913)),
                                      SizedBox(width: 4),
                                      Text(
                                        'Custom',
                                        style: TextStyle(
                                          color: Color(0xFF500913),
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // 2. Event Title Input
                          TextField(
                            controller: titleController,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              labelText: 'Event Title *',
                              hintText: 'e.g. Maharaja Agrasen Jayanti Gala 2026',
                              prefixIcon: const Icon(Icons.event_rounded, color: Color(0xFF500913), size: 20),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // 3. Date & Time Row
                          Row(
                            children: [
                              // Date Picker Box
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: ctx,
                                      initialDate: selectedDate,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 730)),
                                    );
                                    if (picked != null) {
                                      setModalState(() {
                                        selectedDate = picked;
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xFFC7BDB8)),
                                      borderRadius: BorderRadius.circular(14),
                                      color: const Color(0xFFFFFBF9),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.calendar_today_rounded, size: 18, color: Color(0xFF500913)),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E1615)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Time Picker Box
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    final startTime = await showTimePicker(
                                      context: ctx,
                                      initialTime: const TimeOfDay(hour: 17, minute: 0),
                                      helpText: 'SELECT START TIME',
                                    );
                                    if (startTime != null) {
                                      final startStr = _formatTimeOfDay(startTime);
                                      final endTime = await showTimePicker(
                                        context: ctx,
                                        initialTime: TimeOfDay(
                                          hour: (startTime.hour + 4) % 24,
                                          minute: startTime.minute,
                                        ),
                                        helpText: 'SELECT END TIME (OPTIONAL)',
                                      );
                                      if (endTime != null) {
                                        final endStr = _formatTimeOfDay(endTime);
                                        setModalState(() {
                                          timeController.text = '$startStr – $endStr';
                                        });
                                      } else {
                                        setModalState(() {
                                          timeController.text = startStr;
                                        });
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xFFC7BDB8)),
                                      borderRadius: BorderRadius.circular(14),
                                      color: const Color(0xFFFFFBF9),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.access_time_filled_rounded, size: 18, color: Color(0xFF500913)),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            timeController.text.isNotEmpty ? timeController.text : 'Select Time',
                                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF1E1615)),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 4. Venue Address Input
                          TextField(
                            controller: venueController,
                            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              labelText: 'Venue Address *',
                              hintText: 'e.g. Samaj Bhawan, Kamaladi, Kathmandu',
                              prefixIcon: const Icon(Icons.location_on_rounded, color: Color(0xFF500913), size: 20),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // 5. Organized By Chapter Input
                          TextField(
                            controller: organizerController,
                            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              labelText: 'Organized By',
                              hintText: 'e.g. Kathmandu Chapter',
                              prefixIcon: const Icon(Icons.business_rounded, color: Color(0xFF500913), size: 20),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // 6. Detailed Description Multiline Input
                          TextField(
                            controller: descController,
                            maxLines: 3,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              labelText: 'Event Description & Details *',
                              hintText: 'Provide event agenda, program highlights, entry guidelines...',
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                              contentPadding: const EdgeInsets.all(14),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // 7. Poster Image URL Input (Auto-select on tap & clear (X) suffix icon)
                          TextField(
                            controller: posterUrlController,
                            focusNode: posterFocusNode,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            onTap: () {
                              if (posterUrlController.text.isNotEmpty) {
                                posterUrlController.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: posterUrlController.text.length,
                                );
                              }
                            },
                            onChanged: (_) => setModalState(() {}),
                            decoration: InputDecoration(
                              labelText: 'Banner / Poster Image URL',
                              hintText: 'https://...',
                              prefixIcon: const Icon(Icons.image_rounded, color: Color(0xFF500913), size: 20),
                              suffixIcon: posterUrlController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.cancel_rounded, color: Color(0xFF700D15), size: 20),
                                      tooltip: 'Clear URL',
                                      onPressed: () {
                                        setModalState(() {
                                          posterUrlController.clear();
                                        });
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            ),
                          ),
                          const SizedBox(height: 20),


                          // Publish Action Button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                if (titleController.text.trim().isEmpty) {
                                  setModalState(() => errorMsg = 'Please enter an Event Title');
                                  return;
                                }
                                if (venueController.text.trim().isEmpty) {
                                  setModalState(() => errorMsg = 'Please enter the Venue Address');
                                  return;
                                }
                                if (descController.text.trim().isEmpty) {
                                  setModalState(() => errorMsg = 'Please enter Event Description & Details');
                                  return;
                                }

                                final newEvent = Event(
                                  id: 'ev-${DateTime.now().millisecondsSinceEpoch}',
                                  title: titleController.text.trim(),
                                  description: descController.text.trim(),
                                  category: category,
                                  eventDate: selectedDate,
                                  eventTime: timeController.text.trim().isNotEmpty ? timeController.text.trim() : '05:00 PM – 9:00 PM',
                                  venue: venueController.text.trim(),
                                  organizedBy: organizerController.text.trim().isNotEmpty ? organizerController.text.trim() : 'Kathmandu Chapter',
                                  posterUrl: posterUrlController.text.trim().isNotEmpty ? posterUrlController.text.trim() : presetPosters[category],
                                  status: status,
                                  createdAt: DateTime.now(),
                                );

                                ref.read(eventsNotifierProvider.notifier).addEvent(newEvent);
                                Navigator.pop(modalContext);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('🎉 Event "${newEvent.title}" published live to Events section!'),
                                    backgroundColor: const Color(0xFF500913),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF500913),
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shadowColor: const Color(0xFF500913).withValues(alpha: 0.3),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                              ),
                              child: const Text(
                                'Publish Event Live',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: messageController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Type announcement message to send to all registered attendees...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Announcement broadcasted to 1,240 attendees via SMS & App Notification!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                    child: const Text('Send'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
