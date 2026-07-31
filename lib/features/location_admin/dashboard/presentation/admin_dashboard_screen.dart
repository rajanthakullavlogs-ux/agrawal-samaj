import 'package:flutter/material.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/nas_logo.dart';

/// Location Admin Dashboard — /admin/dashboard
/// Matches the uploaded design: top bar with branch switcher + notification
/// bell + avatar, greeting hero banner, 2x2 metric grid with sparklines,
/// Quick Actions row, filterable Recent Activities feed, and the
/// "Pending Approvals" banner.
///
/// Data is hardcoded per the design — wire each section to Supabase
/// (`profiles`, `events`, `activity_log`, `donations`) as noted inline.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

enum _ActivityFilter { all, registrations, events, donations, announcements }

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  _ActivityFilter _filter = _ActivityFilter.all;

  // ---- Sample data — replace with Supabase queries ----
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const _GreetingHero(),
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
                childAspectRatio: 1.35,
                children: const [
                  _MetricCard(
                    icon: Icons.people_alt_rounded,
                    iconBg: Color(0xFFDCEBFD),
                    iconColor: Color(0xFF2E6FE0),
                    cardBg: Color(0xFFF3F8FE),
                    title: 'Total Members',
                    value: '1,248',
                    trend: '12.5% from last month',
                    trendColor: Color(0xFF2E6FE0),
                    sparkColor: Color(0xFF2E6FE0),
                    sparkPoints: [2, 4, 3, 5, 4, 6, 8],
                  ),
                  _MetricCard(
                    icon: Icons.check_circle_rounded,
                    iconBg: Color(0xFFD8F0DE),
                    iconColor: Color(0xFF3E7C4A),
                    cardBg: Color(0xFFF2FAF4),
                    title: 'Active Members',
                    value: '856',
                    trend: '8.3% from last month',
                    trendColor: Color(0xFF3E7C4A),
                    sparkColor: Color(0xFF3E7C4A),
                    sparkPoints: [3, 3, 5, 4, 6, 5, 7],
                  ),
                  _MetricCard(
                    icon: Icons.event_note_rounded,
                    iconBg: Color(0xFFFBE0D2),
                    iconColor: Color(0xFFE8622C),
                    cardBg: Color(0xFFFDF3ED),
                    title: 'Upcoming Events',
                    value: '12',
                    trend: '3 new this week',
                    trendColor: Color(0xFFE8622C),
                    sparkColor: Color(0xFFE8622C),
                    sparkPoints: [4, 3, 5, 3, 6, 5, 8],
                  ),
                  _MetricCard(
                    icon: Icons.history_rounded,
                    iconBg: Color(0xFFFAE9C6),
                    iconColor: Color(0xFFC4901E),
                    cardBg: Color(0xFFFCF7EB),
                    title: 'Past Events',
                    value: '342',
                    trend: '18 this month',
                    trendColor: Color(0xFFC4901E),
                    sparkColor: Color(0xFFC4901E),
                    sparkPoints: [5, 4, 5, 6, 5, 7, 8],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            _sectionHeader('Quick Actions'),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: const [
                  _ActionTile(
                    icon: Icons.person_add_alt_1_rounded,
                    bg: Color(0xFFE3EEFD),
                    iconColor: Color(0xFF2E6FE0),
                    label: 'Approve\nMembers',
                  ),
                  SizedBox(width: 10),
                  _ActionTile(
                    icon: Icons.add_box_rounded,
                    bg: Color(0xFFFBE0D2),
                    iconColor: Color(0xFFE8622C),
                    label: 'Create\nEvent',
                  ),
                  SizedBox(width: 10),
                  _ActionTile(
                    icon: Icons.campaign_rounded,
                    bg: Color(0xFFEFE7FB),
                    iconColor: Color(0xFF7B4FD6),
                    label: 'Send\nAnnouncement',
                  ),
                  SizedBox(width: 10),
                  _ActionTile(
                    icon: Icons.volunteer_activism_rounded,
                    bg: Color(0xFFD8F0DE),
                    iconColor: Color(0xFF3E7C4A),
                    label: 'Record\nDonation',
                  ),
                  SizedBox(width: 10),
                  _ActionTile(
                    icon: Icons.bar_chart_rounded,
                    bg: Color(0xFFFBE3E3),
                    iconColor: Color(0xFFD64545),
                    label: 'View\nReports',
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const _PendingApprovalsBanner(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _AdminBottomNavBar(activeIndex: 2),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          Row(
            children: const [
              Text('View All', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
              Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.primary),
            ],
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
// TOP BAR: hamburger • logo + branch title + dropdown • bell w/ badge • avatar
// ---------------------------------------------------------------------------
class _AdminTopBar extends StatelessWidget {
  const _AdminTopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              final scaffoldState = Scaffold.maybeOf(context);
              if (scaffoldState?.hasDrawer ?? false) {
                scaffoldState?.openDrawer();
              }
            },
            child: const Icon(Icons.menu_rounded, size: 26, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 12),
          const NasLogo(size: 46),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Nepal Agrawal Samaj',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 16)),
                Row(
                  children: [
                    Text('Kathmandu Branch Admin',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5, fontWeight: FontWeight.w500)),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Colors.grey.shade600),
                  ],
                ),
              ],
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade100),
                child: const Icon(Icons.notifications_none_rounded, size: 20, color: AppColors.textPrimary),
              ),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Color(0xFFD64545), shape: BoxShape.circle),
                  child: const Text('5', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          const CircleAvatar(radius: 20, backgroundColor: Color(0xFFDDD7CE)),
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
        height: 165,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFCEEE4), Color(0xFFFBE3D3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Background temple/mountain art — swap for the real photo asset.
            Positioned(
              right: -10,
              bottom: -10,
              child: Opacity(
                opacity: 0.9,
                child: Icon(Icons.temple_hindu_rounded, size: 150, color: AppColors.primary.withValues(alpha: 0.35)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text('Namaste, Administrator',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      SizedBox(width: 6),
                      Text('🙏', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 230,
                    child: Text(
                      "Manage the Kathmandu chapter's activities, members and events "
                      'from your command center.',
                      style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700, height: 1.4),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, size: 17, color: iconColor),
              ),
              SizedBox(width: 46, height: 24, child: CustomPaint(painter: _SparklinePainter(sparkPoints, sparkColor))),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.arrow_upward_rounded, size: 11, color: trendColor),
              const SizedBox(width: 2),
              Expanded(
                child: Text(trend,
                    style: TextStyle(fontSize: 10, color: trendColor, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis),
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
  const _ActionTile({required this.icon, required this.bg, required this.iconColor, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        width: 84,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.lg)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: iconColor),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.2),
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
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: activity.iconBg, shape: BoxShape.circle),
            child: Icon(activity.icon, size: 18, color: activity.iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 2),
                Text(activity.subtitle,
                    style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(activity.time, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              Text(activity.date, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            ],
          ),
          const SizedBox(width: 6),
          Container(width: 7, height: 7, decoration: BoxDecoration(color: activity.dotColor, shape: BoxShape.circle)),
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
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.groups_2_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pending Approvals', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                SizedBox(height: 2),
                Text('8 members awaiting approval', style: TextStyle(color: Colors.white70, fontSize: 11.5)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Review Now', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
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

// ---------------------------------------------------------------------------
// ADMIN BOTTOM NAV: Home • Events • Dashboard • Members • More
// ---------------------------------------------------------------------------
class _AdminBottomNavBar extends StatelessWidget {
  final int activeIndex;
  const _AdminBottomNavBar({required this.activeIndex});

  static const _items = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.event_rounded, label: 'Events'),
    (icon: Icons.grid_view_rounded, label: 'Dashboard'),
    (icon: Icons.people_alt_rounded, label: 'Members'),
    (icon: Icons.more_horiz_rounded, label: 'More'),
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
                  onTap: () {},
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: i == activeIndex
                            ? BoxDecoration(
                                border: Border.all(color: AppColors.border),
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
                          fontWeight: i == activeIndex ? FontWeight.w700 : FontWeight.w400,
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
