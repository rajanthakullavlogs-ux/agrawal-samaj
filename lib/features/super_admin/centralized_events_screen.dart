import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/design_tokens.dart';
import '../../shared/widgets/nas_logo.dart';

class CentralizedEventsScreen extends StatelessWidget {
  const CentralizedEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: const [
            _SuperAdminTopBar(),
            SizedBox(height: 14),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _HeroBanner(),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _OverviewSection(),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _TopEventsChart(),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _UpcomingEventsSection(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _SuperAdminBottomNavBar(activeIndex: 3),
    );
  }
}

// ---------------------------------------------------------------------------
// TOP BAR
// ---------------------------------------------------------------------------
class _SuperAdminTopBar extends StatelessWidget {
  const _SuperAdminTopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const NasLogo(size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Nepal Agrawal Samaj',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Super Admin Panel',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w600),
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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Events Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Monitor and oversee all events\norganized across branches.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -16,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: const Icon(Icons.event_note_rounded, color: AppColors.primary, size: 22),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// OVERVIEW SECTION
// ---------------------------------------------------------------------------
class _OverviewSection extends StatelessWidget {
  const _OverviewSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _OverviewCard(
            icon: Icons.event_note_rounded,
            value: '156',
            label: 'Total Events',
            trend: '↑ 12 this month',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _OverviewCard(
            icon: Icons.check_circle_rounded,
            value: '68',
            label: 'Upcoming Events',
            trend: '↑ 9 this month',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _OverviewCard(
            icon: Icons.groups_rounded,
            value: '32',
            label: 'Events Completed',
            trend: '↑ 3 this month',
          ),
        ),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final String trend;

  const _OverviewCard({required this.icon, required this.value, required this.label, required this.trend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: Colors.grey.shade800, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Text(trend, style: const TextStyle(fontSize: 9, color: AppColors.primary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TOP EVENTS CHART
// ---------------------------------------------------------------------------
class _TopEventsChart extends StatelessWidget {
  const _TopEventsChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'Top Events by Branch (This Month)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.primary),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _BranchBar(name: 'Kathmandu Branch', value: 56, maxValue: 60),
          const SizedBox(height: 16),
          const _BranchBar(name: 'Pokhara Branch', value: 48, maxValue: 60),
          const SizedBox(height: 16),
          const _BranchBar(name: 'Chitwan Branch', value: 41, maxValue: 60),
          const SizedBox(height: 16),
          const _BranchBar(name: 'Butwal Branch', value: 38, maxValue: 60),
          const SizedBox(height: 16),
          const _BranchBar(name: 'Biratnagar Branch', value: 34, maxValue: 60),
          const SizedBox(height: 16),
          
          // X-Axis labels
          Row(
            children: [
              const SizedBox(width: 100), // Match label width
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                    Text('20', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                    Text('40', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                    Text('60', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(width: 40), // Match trailing value width
            ],
          ),
        ],
      ),
    );
  }
}

class _BranchBar extends StatelessWidget {
  final String name;
  final int value;
  final int maxValue;

  const _BranchBar({required this.name, required this.value, required this.maxValue});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(name, style: TextStyle(fontSize: 11, color: Colors.grey.shade800, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double percent = value / maxValue;
              return Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    height: 8,
                    width: constraints.maxWidth * percent,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 28,
          child: Text(value.toString(), style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w800), textAlign: TextAlign.right),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// UPCOMING EVENTS SECTION
// ---------------------------------------------------------------------------
class _UpcomingEventsSection extends StatelessWidget {
  const _UpcomingEventsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upcoming Events', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
        const SizedBox(height: 12),
        // Filters Row
        Row(
          children: [
            Expanded(
              flex: 4,
              child: _FilterDropdown(icon: Icons.location_on_rounded, text: 'All Locations'),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 4,
              child: _FilterDropdown(icon: Icons.dashboard_customize_rounded, text: 'All Categories'),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 5,
              child: _FilterDropdown(icon: Icons.calendar_today_rounded, text: '17 May - 17 Aug 2025'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Event List
        const _EventTile(
          icon: Icons.event_note_rounded,
          title: 'Women Leadership Workshop',
          subtitle1: 'Kathmandu Branch • Workshop',
          subtitle2: '24 May 2025, Sat • 10:00 AM',
          registered: '128',
        ),
        const _EventTile(
          icon: Icons.groups_rounded,
          title: 'Blood Donation Camp',
          subtitle1: 'Pokhara Branch • Social Service',
          subtitle2: '20 Jun 2025, Fri • 9:00 AM',
          registered: '95',
        ),
        const _EventTile(
          icon: Icons.festival_rounded,
          title: 'Teej Festival Celebration',
          subtitle1: 'Chitwan Branch • Cultural',
          subtitle2: '05 Jul 2025, Sat • 5:00 PM',
          registered: '210',
        ),
        const _EventTile(
          icon: Icons.school_rounded,
          title: 'Entrepreneurship Seminar',
          subtitle1: 'Butwal Branch • Seminar',
          subtitle2: '18 Jul 2025, Fri • 11:00 AM',
          registered: '76',
        ),
        const _EventTile(
          icon: Icons.group_add_rounded,
          title: 'General Meeting',
          subtitle1: 'Biratnagar Branch • Meeting',
          subtitle2: '02 Aug 2025, Sat • 10:00 AM',
          registered: '64',
        ),
      ],
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FilterDropdown({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: Colors.grey.shade700),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle1;
  final String subtitle2;
  final String registered;

  const _EventTile({
    required this.icon,
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
    required this.registered,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(subtitle1, style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 10, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(subtitle2, style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.people_alt_rounded, color: AppColors.primary, size: 16),
              const SizedBox(height: 4),
              Text(registered, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              Text('Registered', style: TextStyle(fontSize: 8, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 18),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SUPER ADMIN BOTTOM NAV
// ---------------------------------------------------------------------------
class _SuperAdminBottomNavBar extends StatelessWidget {
  final int activeIndex;
  const _SuperAdminBottomNavBar({required this.activeIndex});

  static const _items = [
    (icon: Icons.dashboard_rounded, label: 'Dashboard', route: AppConstants.superAdminDashboard),
    (icon: Icons.people_rounded, label: 'Members', route: AppConstants.superAdminAnalytics),
    (icon: Icons.location_city_rounded, label: 'Locations', route: AppConstants.superAdminLocations),
    (icon: Icons.event_note_rounded, label: 'Events', route: AppConstants.superAdminEvents),
    (icon: Icons.settings_rounded, label: 'Settings', route: AppConstants.superAdminSettings),
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
