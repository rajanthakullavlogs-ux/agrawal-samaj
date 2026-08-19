import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/nas_logo.dart';

class LocationsManagementScreen extends StatelessWidget {
  const LocationsManagementScreen({super.key});

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
              child: _BranchesUpdateOverview(),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _BranchActivitySummary(),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _BranchesNeedingAttention(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _SuperAdminBottomNavBar(activeIndex: 2),
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
                  'Locations Management',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              const Icon(Icons.notifications_none_rounded, size: 28, color: Colors.black87),
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text('8', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
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
                  'Locations Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Monitor and oversee all branches\nacross Nepal.',
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
              child: const Icon(Icons.location_city_rounded, color: AppColors.primary, size: 22),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Overview', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
        const SizedBox(height: 12),
        Row(
          children: const [
            Expanded(
              child: _OverviewCard(
                icon: Icons.account_balance_rounded,
                value: '24',
                label: 'Total Branches',
                trend: '↑ 2 this month',
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _OverviewCard(
                icon: Icons.location_on_rounded,
                value: '77',
                label: 'Districts Covered',
                trend: '↑ 5 this month',
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _OverviewCard(
                icon: Icons.groups_rounded,
                value: '18',
                label: 'Provinces Covered',
                trend: '↑ 1 this month',
              ),
            ),
          ],
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade800, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Text(trend, style: const TextStyle(fontSize: 9, color: AppColors.primary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// BRANCHES UPDATE OVERVIEW
// ---------------------------------------------------------------------------
class _BranchesUpdateOverview extends StatelessWidget {
  const _BranchesUpdateOverview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Branches Update Overview', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 36,
                          sections: [
                            PieChartSectionData(color: AppColors.primary, value: 42, title: '', radius: 24),
                            PieChartSectionData(color: AppColors.primary.withValues(alpha: 0.5), value: 33, title: '', radius: 24),
                            PieChartSectionData(color: AppColors.primary.withValues(alpha: 0.2), value: 25, title: '', radius: 24),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('24', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
                          Text('Total Branches', style: TextStyle(fontSize: 8, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 6,
                child: Column(
                  children: const [
                    _UpdateLegendItem(
                      color: AppColors.primary,
                      title: 'Updated This Month',
                      subtitle: '10 branches (42%)',
                      pillText: '↑ 42%',
                      pillColor: Color(0xFFE8F5E9),
                      pillTextColor: Color(0xFF2E7D32),
                    ),
                    SizedBox(height: 12),
                    _UpdateLegendItem(
                      color: Color(0xFFB37373), // approximate AppColors.primary with 0.5 opacity
                      title: 'No Update This Month',
                      subtitle: '8 branches (33%)',
                      pillText: '↓ 33%',
                      pillColor: Color(0xFFFFF3E0),
                      pillTextColor: Color(0xFFE65100),
                    ),
                    SizedBox(height: 12),
                    _UpdateLegendItem(
                      color: Color(0xFFE6D0D0), // approximate AppColors.primary with 0.2 opacity
                      title: 'Not Updated for 2+ Months',
                      subtitle: '6 branches (25%)',
                      pillText: '↑ 25%',
                      pillColor: Color(0xFFFFEBEE),
                      pillTextColor: Color(0xFFC62828),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UpdateLegendItem extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final String pillText;
  final Color pillColor;
  final Color pillTextColor;

  const _UpdateLegendItem({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.pillText,
    required this.pillColor,
    required this.pillTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 9, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: pillColor, borderRadius: BorderRadius.circular(100)),
          child: Text(pillText, style: TextStyle(fontSize: 9, color: pillTextColor, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// BRANCH ACTIVITY SUMMARY
// ---------------------------------------------------------------------------
class _BranchActivitySummary extends StatelessWidget {
  const _BranchActivitySummary();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Branch Activity Summary', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: const [
              Expanded(child: _ActivityStat(icon: Icons.event_note_rounded, value: '156', label: 'Events Organized\n(This Month)')),
              _VerticalDivider(),
              Expanded(child: _ActivityStat(icon: Icons.photo_library_rounded, value: '2.4K', label: 'Photos Shared\n(This Month)')),
              _VerticalDivider(),
              Expanded(child: _ActivityStat(icon: Icons.campaign_rounded, value: '32', label: 'Notices Broadcast\n(This Month)')),
              _VerticalDivider(),
              Expanded(child: _ActivityStat(icon: Icons.person_add_alt_1_rounded, value: '325', label: 'New Members Added\n(This Month)')),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActivityStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _ActivityStat({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), shape: BoxShape.circle),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(height: 12),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
        const SizedBox(height: 4),
        Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 8, color: Colors.grey.shade700, fontWeight: FontWeight.w500, height: 1.3)),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 60,
      color: Colors.grey.shade200,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

// ---------------------------------------------------------------------------
// BRANCHES NEEDING ATTENTION
// ---------------------------------------------------------------------------
class _BranchesNeedingAttention extends StatelessWidget {
  const _BranchesNeedingAttention();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Branches Needing Attention', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
            Row(
              children: const [
                Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.primary),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _AttentionTile(title: 'Dolakha Branch', subtitle: 'No update for 65 days'),
        const _AttentionTile(title: 'Rukum Branch', subtitle: 'No update for 48 days'),
        const _AttentionTile(title: 'Bajhang Branch', subtitle: 'No update for 40 days'),
      ],
    );
  }
}

class _AttentionTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const _AttentionTile({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), shape: BoxShape.circle),
            child: const Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(100)),
            child: const Text('No Update', style: TextStyle(fontSize: 9, color: Color(0xFFC62828), fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 16),
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
    (icon: Icons.analytics_rounded, label: 'Analytics', route: AppConstants.superAdminAnalytics),
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
