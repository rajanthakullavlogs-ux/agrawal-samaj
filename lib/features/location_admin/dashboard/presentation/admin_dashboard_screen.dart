import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/models/event.dart';
import '../../../../shared/widgets/nas_logo.dart';
import '../../../events/data/events_repository.dart';
import '../../members/data/members_repository.dart';
import '../../shared/branch_admin_nav_bar.dart';

/// Location Admin Dashboard — /admin/dashboard
class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

enum _ActivityFilter { all, registrations, events, donations, announcements }

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  _ActivityFilter _filter = _ActivityFilter.all;
  final ScrollController _quickActionsScrollController = ScrollController();
  bool _showSwipeHint = true;

  @override
  void initState() {
    super.initState();
    _quickActionsScrollController.addListener(_onQuickActionsScroll);
  }

  void _onQuickActionsScroll() {
    if (!_quickActionsScrollController.hasClients) return;
    final maxScroll = _quickActionsScrollController.position.maxScrollExtent;
    final currentScroll = _quickActionsScrollController.offset;
    final atEnd = currentScroll >= (maxScroll - 15);
    if (atEnd && _showSwipeHint) {
      setState(() => _showSwipeHint = false);
    } else if (!atEnd && !_showSwipeHint) {
      setState(() => _showSwipeHint = true);
    }
  }

  @override
  void dispose() {
    _quickActionsScrollController.removeListener(_onQuickActionsScroll);
    _quickActionsScrollController.dispose();
    super.dispose();
  }

  static const _activities = [
    (
      icon: Icons.person_add_alt_1_rounded,
      iconBg: Color(0xFFE3EEFD),
      iconColor: Color(0xFF2E6FE0),
      title: 'New Member Registration',
      subtitle: 'Rajesh Agrawal has registered as a new member',
      time: '10:30 AM',
      date: 'Today',
      dotColor: Color(0xFF2E6FE0),
      category: _ActivityFilter.registrations,
    ),
    (
      icon: Icons.edit_calendar_rounded,
      iconBg: Color(0xFFFCEAE0),
      iconColor: Color(0xFFE8622C),
      title: 'Event RSVP Update',
      subtitle: '15 members confirmed for Teej Festival 2026',
      time: '09:15 AM',
      date: 'Today',
      dotColor: Color(0xFFE8622C),
      category: _ActivityFilter.events,
    ),
    (
      icon: Icons.volunteer_activism_rounded,
      iconBg: Color(0xFFE5F5E9),
      iconColor: Color(0xFF3E7C4A),
      title: 'New Donation Received',
      subtitle: 'NPR 5,000 donation received from Suresh Agrawal',
      time: '07:45 PM',
      date: 'Yesterday',
      dotColor: Color(0xFF3E7C4A),
      category: _ActivityFilter.donations,
    ),
    (
      icon: Icons.campaign_rounded,
      iconBg: Color(0xFFEFE7FB),
      iconColor: Color(0xFF7B4FD6),
      title: 'Announcement Published',
      subtitle: 'Dashain Celebration 2026 announcement sent',
      time: '03:20 PM',
      date: 'Yesterday',
      dotColor: Color(0xFF7B4FD6),
      category: _ActivityFilter.announcements,
    ),
    (
      icon: Icons.groups_rounded,
      iconBg: Color(0xFFFCEEDD),
      iconColor: Color(0xFFB5732E),
      title: 'Member Profile Updated',
      subtitle: 'Meena Agrawal updated their profile information',
      time: '11:10 AM',
      date: '22 Aug 2025',
      dotColor: Color(0xFFE8622C),
      category: _ActivityFilter.registrations,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersNotifierProvider);
    final events = ref.watch(eventsNotifierProvider);

    final totalMembers = members.where((m) => m.status != 'PENDING').length;
    final activeMembers = members.where((m) => m.status == 'ACTIVE').length;
    final upcomingEventsCount = events.where((e) => e.isUpcoming).length;
    final pastEventsCount = events.where((e) => !e.isUpcoming).length;

    final filtered = _filter == _ActivityFilter.all
        ? _activities
        : _activities.where((a) => a.category == _filter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F6),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            const _AdminTopBar(),
            const SizedBox(height: 14),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _GreetingHero(),
            ),
            const SizedBox(height: 22),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Overview',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _MetricCard(
                          icon: Icons.people_alt_rounded,
                          iconBg: const Color(0xFFDCEBFD),
                          iconColor: const Color(0xFF2E6FE0),
                          cardBg: const Color(0xFFF3F8FE),
                          title: 'Total Members',
                          value: '$totalMembers',
                          onTap: () => context.go('${AppConstants.adminMembers}?filter=ALL'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MetricCard(
                          icon: Icons.check_circle_rounded,
                          iconBg: const Color(0xFFD8F0DE),
                          iconColor: const Color(0xFF3E7C4A),
                          cardBg: const Color(0xFFF2FAF4),
                          title: 'Active Members',
                          value: '$activeMembers',
                          onTap: () => context.go('${AppConstants.adminMembers}?filter=ACTIVE'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _MetricCard(
                          icon: Icons.event_note_rounded,
                          iconBg: const Color(0xFFFBE0D2),
                          iconColor: const Color(0xFFE8622C),
                          cardBg: const Color(0xFFFDF3ED),
                          title: 'Upcoming Events',
                          value: '$upcomingEventsCount',
                          onTap: () => context.go('${AppConstants.adminEvents}?filter=UPCOMING'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MetricCard(
                          icon: Icons.history_rounded,
                          iconBg: const Color(0xFFFAE9C6),
                          iconColor: const Color(0xFFC4901E),
                          cardBg: const Color(0xFFFCF7EB),
                          title: 'Past Events',
                          value: '$pastEventsCount',
                          onTap: () => context.go('${AppConstants.adminEvents}?filter=PAST'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            _sectionHeader(
              'Quick Actions',
              rightWidget: AnimatedOpacity(
                duration: const Duration(milliseconds: 220),
                opacity: _showSwipeHint ? 1.0 : 0.0,
                child: _showSwipeHint
                    ? GestureDetector(
                        onTap: () {
                          if (_quickActionsScrollController.hasClients) {
                            _quickActionsScrollController.animateTo(
                              _quickActionsScrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeOutCubic,
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF500913).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('Swipe', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF500913))),
                              SizedBox(width: 3),
                              Icon(Icons.arrow_forward_rounded, size: 11, color: Color(0xFF500913)),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 95,
              child: ListView(
                controller: _quickActionsScrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _ActionTile(
                    icon: Icons.person_add_alt_1_rounded,
                    bg: const Color(0xFFFDEEEF),
                    iconColor: const Color(0xFF500913),
                    label: 'Approve\nMembers',
                    onTap: () => context.go(AppConstants.adminMembers),
                  ),
                  const SizedBox(width: 10),
                  _ActionTile(
                    icon: Icons.add_box_rounded,
                    bg: const Color(0xFFFDF0E1),
                    iconColor: const Color(0xFF9E5606),
                    label: 'Create\nEvent',
                    onTap: () => _showCreateEventDialog(context, ref),
                  ),
                  const SizedBox(width: 10),
                  _ActionTile(
                    icon: Icons.photo_library_rounded,
                    bg: const Color(0xFFEAF4EC),
                    iconColor: const Color(0xFF2E5E35),
                    label: 'Manage\nGallery',
                    onTap: () => context.go(AppConstants.adminGallery),
                  ),
                  const SizedBox(width: 10),
                  _ActionTile(
                    icon: Icons.settings_rounded,
                    bg: const Color(0xFFFDEEEF),
                    iconColor: const Color(0xFF500913),
                    label: 'Branch\nSettings',
                    onTap: () => context.go(AppConstants.adminSettings),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            _sectionHeader(
              'Recent Activities',
              rightWidget: PopupMenuButton<_ActivityFilter>(
                initialValue: _filter,
                onSelected: (val) => setState(() => _filter = val),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
                elevation: 6,
                itemBuilder: (context) => [
                  _buildActivityMenuItem(_ActivityFilter.all, 'All Activities', Icons.grid_view_rounded, Colors.grey.shade700),
                  _buildActivityMenuItem(_ActivityFilter.registrations, 'Registrations', Icons.person_add_alt_1_rounded, const Color(0xFF2E6FE0)),
                  _buildActivityMenuItem(_ActivityFilter.events, 'Event RSVPs', Icons.edit_calendar_rounded, const Color(0xFFE8622C)),
                  _buildActivityMenuItem(_ActivityFilter.donations, 'Donations', Icons.volunteer_activism_rounded, const Color(0xFF3E7C4A)),
                  _buildActivityMenuItem(_ActivityFilter.announcements, 'Announcements', Icons.campaign_rounded, const Color(0xFF7B4FD6)),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF500913).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF500913).withValues(alpha: 0.15)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.filter_list_rounded, size: 13, color: Color(0xFF500913)),
                      const SizedBox(width: 5),
                      Text(
                        _activityFilterName(_filter),
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF500913)),
                      ),
                      const SizedBox(width: 3),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 15, color: Color(0xFF500913)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < filtered.length; i++) ...[
                      _ActivityItem(activity: filtered[i]),
                      if (i != filtered.length - 1) Divider(height: 1, color: Colors.grey.shade100),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _PendingApprovalsBanner(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, {VoidCallback? onViewAll, Widget? rightWidget}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          if (rightWidget != null)
            rightWidget
          else if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: Row(
                children: const [
                  Text('View All', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.primary),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _activityFilterName(_ActivityFilter f) {
    switch (f) {
      case _ActivityFilter.all:
        return 'All Activities';
      case _ActivityFilter.registrations:
        return 'Registrations';
      case _ActivityFilter.events:
        return 'Event RSVPs';
      case _ActivityFilter.donations:
        return 'Donations';
      case _ActivityFilter.announcements:
        return 'Announcements';
    }
  }

  PopupMenuItem<_ActivityFilter> _buildActivityMenuItem(_ActivityFilter val, String label, IconData icon, Color color) {
    final isSelected = _filter == val;
    return PopupMenuItem<_ActivityFilter>(
      value: val,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? const Color(0xFF500913) : AppColors.textPrimary,
              ),
            ),
          ),
          if (isSelected) const Icon(Icons.check_rounded, size: 16, color: Color(0xFF500913)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TOP BAR: Exit Home • Logo • Branch title • Notification • Avatar
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
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'Kathmandu Branch',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          // Notifications Bell
          InkWell(
            onTap: () => context.push(AppConstants.notifications),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_none_rounded, size: 28, color: AppColors.textPrimary),
                  Positioned(
                    top: 0,
                    right: 2,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD64545),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFFCF9F6), width: 1.5),
                      ),
                      child: const Text('5', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w700, height: 1)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Exit Admin Panel Button
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
// GREETING HERO BANNER
// ---------------------------------------------------------------------------
class _GreetingHero extends StatelessWidget {
  const _GreetingHero();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF500913), Color(0xFF3F050C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF500913).withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -15,
              bottom: -20,
              child: Opacity(
                opacity: 0.12,
                child: const Icon(Icons.temple_hindu_rounded, size: 150, color: Colors.white),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.circle, size: 8, color: Color(0xFF4CE688)),
                          SizedBox(width: 6),
                          Text(
                            'Kathmandu Branch — Live Session',
                            style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Text(
                      'Namaste, Administrator',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.3),
                    ),
                    SizedBox(width: 6),
                    Text('🙏', style: TextStyle(fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 6),
                const SizedBox(
                  width: 260,
                  child: Text(
                    "Manage your branch members, host events, publish media, and update executive committee settings.",
                    style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.35),
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

// ---------------------------------------------------------------------------
// METRIC CARD with mini sparkline
// ---------------------------------------------------------------------------
class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color cardBg;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _MetricCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.cardBg,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        width: double.infinity,
        height: 98,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: const Color(0xFFF1E3DF)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: AppColors.primary, height: 1.0),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF500913), fontWeight: FontWeight.w700, height: 1.1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

// ---------------------------------------------------------------------------
// QUICK ACTION TILE
// ---------------------------------------------------------------------------
class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.bg,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        width: 105,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.lg)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24, color: iconColor),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.2),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, size: 16, color: iconColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ACTIVITY ITEM ROW
// ---------------------------------------------------------------------------
class _ActivityItem extends StatelessWidget {
  final ({
    IconData icon,
    Color iconBg,
    Color iconColor,
    String title,
    String subtitle,
    String time,
    String date,
    Color dotColor,
    _ActivityFilter category,
  }) activity;

  const _ActivityItem({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: activity.iconBg, shape: BoxShape.circle),
            child: Icon(activity.icon, size: 17, color: activity.iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                const SizedBox(height: 2),
                Text(
                  activity.subtitle,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(activity.time, style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500)),
                  const SizedBox(width: 8),
                  Container(width: 6, height: 6, decoration: BoxDecoration(color: activity.dotColor, shape: BoxShape.circle)),
                ],
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Text(activity.date, style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PENDING APPROVALS BANNER
// ---------------------------------------------------------------------------
class _PendingApprovalsBanner extends ConsumerWidget {
  const _PendingApprovalsBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(membersNotifierProvider);
    final pendingCount = members.where((m) => m.status == 'PENDING').length;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: AppColors.maroonGradient,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.groups_2_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pending Approvals', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13.5)),
                const SizedBox(height: 2),
                Text(
                  '$pendingCount ${pendingCount == 1 ? 'member' : 'members'} awaiting approval',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => context.go('${AppConstants.adminMembers}?filter=PENDING'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Review Approvals', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, size: 14),
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

  String category = 'Cultural';
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
                                'Fill in all details to publish live into Events section',
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

                          // 1. Event Category Selector
                          const Text('Event Category *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E1615))),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: ['Cultural', 'Business', 'Youth', 'Social', 'Health'].map((cat) {
                              final isSel = category == cat;
                              return GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    category = cat;
                                    posterUrlController.text = presetPosters[cat] ?? posterUrlController.text;
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
                            }).toList(),
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

                          // 7. Poster Image URL Input
                          TextField(
                            controller: posterUrlController,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              labelText: 'Banner / Poster Image URL',
                              hintText: 'https://...',
                              prefixIcon: const Icon(Icons.image_rounded, color: Color(0xFF500913), size: 20),
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

                                // Direct user to Events section
                                context.go(AppConstants.events);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('🎉 Event "${newEvent.title}" published live! Directing to Events page...'),
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
