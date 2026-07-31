import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/nas_logo.dart';
import '../../../events/data/events_repository.dart';
import '../../members/data/members_repository.dart';

/// Location Admin Dashboard — /admin/dashboard
class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

enum _ActivityFilter { all, registrations, events, donations, announcements }

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  _ActivityFilter _filter = _ActivityFilter.all;

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

    final totalMembers = members.length;
    final activeMembers = members.where((m) => m.status == 'ACTIVE').length;
    final upcomingEventsCount = events.where((e) => e.isUpcoming).length;
    final pastEventsCount = events.where((e) => !e.isUpcoming).length;

    final filtered = _filter == _ActivityFilter.all
        ? _activities
        : _activities.where((a) => a.category == _filter).toList();

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
              child: _GreetingHero(),
            ),
            const SizedBox(height: 22),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Overview',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  Row(
                    children: [
                      Text('This Month', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.textSecondary),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.15,
                children: [
                  _MetricCard(
                    icon: Icons.people_alt_rounded,
                    iconBg: const Color(0xFFDCEBFD),
                    iconColor: const Color(0xFF2E6FE0),
                    cardBg: const Color(0xFFF3F8FE),
                    title: 'Total Members',
                    value: '$totalMembers',
                    trend: '12.5% from last month',
                    trendColor: const Color(0xFF2E6FE0),
                    sparkColor: const Color(0xFF2E6FE0),
                    sparkPoints: const [2, 4, 3, 5, 4, 6, 8],
                  ),
                  _MetricCard(
                    icon: Icons.check_circle_rounded,
                    iconBg: const Color(0xFFD8F0DE),
                    iconColor: const Color(0xFF3E7C4A),
                    cardBg: const Color(0xFFF2FAF4),
                    title: 'Active Members',
                    value: '$activeMembers',
                    trend: '8.3% from last month',
                    trendColor: const Color(0xFF3E7C4A),
                    sparkColor: const Color(0xFF3E7C4A),
                    sparkPoints: const [3, 3, 5, 4, 6, 5, 7],
                  ),
                  _MetricCard(
                    icon: Icons.event_note_rounded,
                    iconBg: const Color(0xFFFBE0D2),
                    iconColor: const Color(0xFFE8622C),
                    cardBg: const Color(0xFFFDF3ED),
                    title: 'Upcoming Events',
                    value: '$upcomingEventsCount',
                    trend: '3 new this week',
                    trendColor: const Color(0xFFE8622C),
                    sparkColor: const Color(0xFFE8622C),
                    sparkPoints: const [4, 3, 5, 3, 6, 5, 8],
                  ),
                  _MetricCard(
                    icon: Icons.history_rounded,
                    iconBg: const Color(0xFFFAE9C6),
                    iconColor: const Color(0xFFC4901E),
                    cardBg: const Color(0xFFFCF7EB),
                    title: 'Past Events',
                    value: '$pastEventsCount',
                    trend: '18 this month',
                    trendColor: const Color(0xFFC4901E),
                    sparkColor: const Color(0xFFC4901E),
                    sparkPoints: const [5, 4, 5, 6, 5, 7, 8],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            _sectionHeader('Quick Actions', onViewAll: () => context.go(AppConstants.adminEvents)),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _ActionTile(
                    icon: Icons.person_add_alt_1_rounded,
                    bg: const Color(0xFFE3EEFD),
                    iconColor: const Color(0xFF2E6FE0),
                    label: 'Approve\nMembers',
                    onTap: () => context.go(AppConstants.adminMembers),
                  ),
                  const SizedBox(width: 10),
                  _ActionTile(
                    icon: Icons.add_box_rounded,
                    bg: const Color(0xFFFBE0D2),
                    iconColor: const Color(0xFFE8622C),
                    label: 'Create\nEvent',
                    onTap: () => context.go(AppConstants.adminEvents),
                  ),
                  const SizedBox(width: 10),
                  _ActionTile(
                    icon: Icons.photo_library_rounded,
                    bg: const Color(0xFFEFE7FB),
                    iconColor: const Color(0xFF7B4FD6),
                    label: 'Manage\nGallery',
                    onTap: () => context.go(AppConstants.adminGallery),
                  ),
                  const SizedBox(width: 10),
                  _ActionTile(
                    icon: Icons.settings_rounded,
                    bg: const Color(0xFFD8F0DE),
                    iconColor: const Color(0xFF3E7C4A),
                    label: 'Branch\nSettings',
                    onTap: () => context.go(AppConstants.adminSettings),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            _sectionHeader('Recent Activities'),
            const SizedBox(height: 10),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _filterChip('All', _ActivityFilter.all),
                  const SizedBox(width: 8),
                  _filterChip('Registrations', _ActivityFilter.registrations),
                  const SizedBox(width: 8),
                  _filterChip('Events', _ActivityFilter.events),
                  const SizedBox(width: 8),
                  _filterChip('Donations', _ActivityFilter.donations),
                  const SizedBox(width: 8),
                  _filterChip('Announcements', _ActivityFilter.announcements),
                ],
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
      bottomNavigationBar: const _AdminBottomNavBar(activeIndex: 0),
    );
  }

  Widget _sectionHeader(String title, {VoidCallback? onViewAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
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

  Widget _filterChip(String label, _ActivityFilter value) {
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
          // Button to Exit Admin & Return to Home Screen
          InkWell(
            onTap: () => context.go(AppConstants.home),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.home_rounded,
                size: 22,
                color: AppColors.primary,
              ),
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
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade100),
                child: const Icon(Icons.notifications_none_rounded, size: 18, color: AppColors.textPrimary),
              ),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(color: Color(0xFFD64545), shape: BoxShape.circle),
                  child: const Text('5', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
          // Exit Admin Button Label Chip
          InkWell(
            onTap: () => context.go(AppConstants.home),
            borderRadius: BorderRadius.circular(100),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Exit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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
        height: 150,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFCEEE4), Color(0xFFFBE3D3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              bottom: -10,
              child: Opacity(
                opacity: 0.9,
                child: Icon(Icons.temple_hindu_rounded, size: 140, color: AppColors.primary.withValues(alpha: 0.35)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text('Namaste, Administrator',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      SizedBox(width: 6),
                      Text('🙏', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 220,
                    child: Text(
                      "Manage the Kathmandu chapter's activities, members and events from your command center.",
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.35),
                    ),
                  ),
                ],
              ),
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
  final String trend;
  final Color trendColor;
  final Color sparkColor;
  final List<double> sparkPoints;

  const _MetricCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.cardBg,
    required this.title,
    required this.value,
    required this.trend,
    required this.trendColor,
    required this.sparkColor,
    required this.sparkPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, size: 15, color: iconColor),
              ),
              SizedBox(width: 44, height: 20, child: CustomPaint(painter: _SparklinePainter(sparkPoints, sparkColor))),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            ],
          ),
          Row(
            children: [
              Icon(Icons.arrow_upward_rounded, size: 10, color: trendColor),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  trend,
                  style: TextStyle(fontSize: 9.5, color: trendColor, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> points;
  final Color color;
  _SparklinePainter(this.points, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final maxVal = points.reduce((a, b) => a > b ? a : b);
    final minVal = points.reduce((a, b) => a < b ? a : b);
    final range = (maxVal - minVal) == 0 ? 1 : (maxVal - minVal);
    final dx = size.width / (points.length - 1);

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = dx * i;
      final y = size.height - ((points[i] - minVal) / range) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
        width: 84,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.lg)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: iconColor),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.2),
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
              Text(activity.time, style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500)),
              Text(activity.date, style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500)),
            ],
          ),
          const SizedBox(width: 6),
          Container(width: 6, height: 6, decoration: BoxDecoration(color: activity.dotColor, shape: BoxShape.circle)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PENDING APPROVALS BANNER
// ---------------------------------------------------------------------------
class _PendingApprovalsBanner extends StatelessWidget {
  const _PendingApprovalsBanner();

  @override
  Widget build(BuildContext context) {
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
              children: const [
                Text('Pending Approvals', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13.5)),
                SizedBox(height: 2),
                Text('8 members awaiting approval', style: TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => context.go(AppConstants.adminMembers),
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
                Text('Review', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                SizedBox(width: 2),
                Icon(Icons.arrow_forward_rounded, size: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ADMIN BOTTOM NAV: Dashboard • Members • Events • Gallery • Settings
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
