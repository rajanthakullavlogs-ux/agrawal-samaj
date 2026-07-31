import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/design_tokens.dart';
import '../../shared/widgets/widgets.dart';

/// C4 — Centralized Events Screen (Super Admin)
/// Matches design c4._centralized_events_super_admin:
/// - Title "Centralized Events Overview" + subtext
/// - Stats overview: Total Events (130+), Nationwide Registrations (24,500+), Active Chapters (18)
/// - Province Filter Chips & Search
/// - Cross-chapter events list with chapter origin badges, RSVP counters, venue info
/// - Bottom Nav
class CentralizedEventsScreen extends StatefulWidget {
  const CentralizedEventsScreen({super.key});

  @override
  State<CentralizedEventsScreen> createState() => _CentralizedEventsScreenState();
}

class _CentralizedEventsScreenState extends State<CentralizedEventsScreen> {
  String _selectedProvince = 'All Provinces';
  String _searchQuery = '';

  static const _allCentralEvents = [
    (
      title: 'National Agrawal Heritage Gala 2026',
      chapter: 'Kathmandu Central',
      province: 'Bagmati',
      date: 'Oct 15, 2026',
      venue: 'Hotel Yak & Yeti, Kathmandu',
      rsvps: 1240,
      category: 'CULTURAL',
      status: 'APPROVED',
    ),
    (
      title: 'Eastern Industrial & Business Trade Expo',
      chapter: 'Biratnagar Chapter',
      province: 'Koshi',
      date: 'Nov 02, 2026',
      venue: 'Trade Pavilion, Biratnagar',
      rsvps: 850,
      category: 'BUSINESS',
      status: 'UPCOMING',
    ),
    (
      title: 'Lumbini Youth Sports & Cultural Fest',
      chapter: 'Butwal Chapter',
      province: 'Lumbini',
      date: 'Nov 18, 2026',
      venue: 'Municipal Stadium, Butwal',
      rsvps: 420,
      category: 'YOUTH',
      status: 'UPCOMING',
    ),
    (
      title: 'Terai Community Medical Camp',
      chapter: 'Birgunj Unit',
      province: 'Madhesh',
      date: 'Dec 05, 2026',
      venue: 'Samaj Seva Health Center, Birgunj',
      rsvps: 610,
      category: 'HEALTH',
      status: 'SCHEDULED',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _allCentralEvents.where((e) {
      final matchesProvince = _selectedProvince == 'All Provinces' || e.province == _selectedProvince;
      final matchesQuery = _searchQuery.isEmpty ||
          e.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.chapter.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesProvince && matchesQuery;
    }).toList();

    return Scaffold(
      appBar: const NASAppBar(title: 'Centralized Events'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NASContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: NASSpacing.md),
                  Text(
                    'SUPER ADMIN PORTAL',
                    style: NASTypography.labelSm.copyWith(color: NASColors.secondary),
                  ),
                  Text(
                    'Centralized Events Calendar',
                    style: NASTypography.headlineMd.copyWith(
                      color: NASColors.primary,
                      fontFamily: NASTypography.headlineFont,
                    ),
                  ),
                  const SizedBox(height: NASSpacing.xs),
                  Text(
                    'Oversee, monitor, and coordinate events across all 18 chapters in Nepal.',
                    style: NASTypography.bodyMd.copyWith(color: NASColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: NASSpacing.md),

                  // Stat Cards 3-column
                  Row(
                    children: const [
                      Expanded(
                        child: NASStatCard(
                          icon: Icons.event_note_rounded,
                          label: 'TOTAL EVENTS',
                          value: '130+',
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: NASStatCard(
                          icon: Icons.groups_rounded,
                          label: 'TOTAL RSVPS',
                          value: '24.5k',
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: NASStatCard(
                          icon: Icons.place_rounded,
                          label: 'CHAPTERS',
                          value: '18',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  // Search + Province Filter Chips
                  NASInputField(
                    label: '',
                    hint: 'Search events or chapter name...',
                    prefixIcon: const Icon(Icons.search),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                  const SizedBox(height: NASSpacing.xs),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All Provinces', 'Bagmati', 'Koshi', 'Lumbini', 'Madhesh'].map((prov) {
                        final selected = _selectedProvince == prov;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: selected,
                            label: Text(prov),
                            onSelected: (_) => setState(() => _selectedProvince = prov),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  // Events List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: NASSpacing.sm),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return NASCard(
                        hasGoldAccent: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                NASBadge.business(label: item.chapter),
                                NASBadge.active(label: item.status),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.title,
                              style: NASTypography.titleLg.copyWith(color: NASColors.primary),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 14, color: NASColors.outline),
                                const SizedBox(width: 4),
                                Text(item.venue, style: NASTypography.bodyMd),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.people_outline, size: 14, color: NASColors.secondary),
                                    const SizedBox(width: 4),
                                    Text('${item.rsvps} Registered', style: NASTypography.labelSm),
                                  ],
                                ),
                                Text(item.date, style: NASTypography.labelSm.copyWith(color: NASColors.secondary)),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
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
        selectedIndex: 0,
        onItemTap: (index) {
          switch (index) {
            case 0:
              context.go(AppConstants.superAdminDashboard);
            case 1:
              context.go(AppConstants.superAdminAnalytics);
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
