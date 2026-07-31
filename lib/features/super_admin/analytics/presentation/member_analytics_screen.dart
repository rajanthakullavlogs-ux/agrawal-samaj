import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/widgets.dart';

/// C2 — Member Distribution Analytics Screen (Super Admin)
/// Matches design c2._member_analytics_super_admin/screen.png:
/// - Title "Member Distribution Analytics" + subtext
/// - Date Range Filter Card (01/01/2024 to 31/12/2024 + Apply button)
/// - Metric cards: TOTAL MEMBERS (12,842), NEW REGISTRATIONS (432), ACTIVE PROVINCES (7)
/// - Bar Chart / Pie Chart visualization using fl_chart
/// - Bottom Nav
class MemberAnalyticsScreen extends StatelessWidget {
  const MemberAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NASAppBar(title: 'Member Analytics'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NASContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: NASSpacing.md),
                  Text(
                    'Member Distribution Analytics',
                    style: NASTypography.headlineMd.copyWith(
                      color: NASColors.primary,
                      fontFamily: NASTypography.headlineFont,
                    ),
                  ),
                  const SizedBox(height: NASSpacing.xs),
                  Text(
                    'Comprehensive visualization of the community network and demographics.',
                    style: NASTypography.bodyMd.copyWith(
                      color: NASColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: NASSpacing.md),

                  // Date range picker card
                  NASCard(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.calendar_month, size: 18, color: NASColors.secondary),
                            SizedBox(width: 4),
                            Text('01/01/2024', style: TextStyle(fontWeight: FontWeight.bold)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('to'),
                            ),
                            Text('31/12/2024', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: NASSpacing.sm),
                        NASPrimaryButton(
                          label: 'Apply Filter',
                          onPressed: () {
                            NASToast.success(context, 'Date range applied.');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  // Metric Cards
                  NASStatCard(
                    icon: Icons.people_outlined,
                    label: 'TOTAL MEMBERS',
                    value: '12,842',
                    trend: '↗ +12% from last year',
                  ),
                  const SizedBox(height: NASSpacing.sm),
                  NASStatCard(
                    icon: Icons.person_add_alt_1_outlined,
                    label: 'NEW REGISTRATIONS',
                    value: '432',
                    trend: 'Current month',
                  ),
                  const SizedBox(height: NASSpacing.sm),
                  NASStatCard(
                    icon: Icons.map_outlined,
                    label: 'ACTIVE PROVINCES',
                    value: '7',
                    trend: 'Covering all Nepal',
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  // Chart Card (fl_chart)
                  Text(
                    'Province Member Distribution',
                    style: NASTypography.titleLg.copyWith(color: NASColors.primary),
                  ),
                  const SizedBox(height: NASSpacing.xs),
                  NASCard(
                    child: SizedBox(
                      height: 220,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 3000,
                          barTouchData: BarTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const titles = ['Bagmati', 'Madhesh', 'Koshi', 'Gandaki', 'Lumbini'];
                                  final index = value.toInt();
                                  if (index >= 0 && index < titles.length) {
                                    return Text(titles[index], style: const TextStyle(fontSize: 10));
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 2800, color: NASColors.primary)]),
                            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 2100, color: NASColors.secondary)]),
                            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 1600, color: NASColors.tertiaryContainer)]),
                            BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 1200, color: NASColors.primaryContainer)]),
                            BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 900, color: NASColors.outline)]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: NASSpacing.xl),
            const NASFooter(),
          ],
        ),
      ),
      bottomNavigationBar: NASBottomNav(
        selectedIndex: 1,
        onItemTap: (index) {
          switch (index) {
            case 0:
              context.go(AppConstants.superAdminDashboard);
            case 1:
              break;
            case 2:
              context.go(AppConstants.superAdminLocations);
            case 3:
              context.go(AppConstants.superAdminSettings);
          }
        },
        items: const [
          NASNavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard'),
          NASNavItem(icon: Icons.analytics_outlined, activeIcon: Icons.analytics, label: 'Analytics'),
          NASNavItem(icon: Icons.location_city_outlined, activeIcon: Icons.location_city, label: 'Locations'),
          NASNavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'Settings'),
        ],
      ),
    );
  }
}
