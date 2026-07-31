import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/widgets.dart';

/// C3 — Locations Management Screen (Super Admin)
/// Matches design c3._locations_super_admin/screen.png:
/// - Title "Manage Locations" + "+ Add Location" CTA button
/// - Search input + Region filter chips (All Regions, Province 1, Bagmati, Lumbini)
/// - Branch location cards (Kathmandu Central ONLINE, Biratnagar Branch ONLINE, Butwal Unit SUSPENDED)
/// - Location Details side drawer (Metrics, Leader info, Status toggle, Save Changes)
/// - Bottom Nav
class LocationsManagementScreen extends StatefulWidget {
  const LocationsManagementScreen({super.key});

  @override
  State<LocationsManagementScreen> createState() =>
      _LocationsManagementScreenState();
}

class _LocationsManagementScreenState
    extends State<LocationsManagementScreen> {
  String _selectedRegion = 'All Regions';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NASAppBar(title: 'Locations Management'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NASContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: NASSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SUPER ADMIN DASHBOARD',
                            style: NASTypography.labelSm.copyWith(
                              color: NASColors.secondary,
                            ),
                          ),
                          Text(
                            'Manage Locations',
                            style: NASTypography.headlineMd.copyWith(
                              color: NASColors.primary,
                              fontFamily: NASTypography.headlineFont,
                            ),
                          ),
                        ],
                      ),
                      NASPrimaryButton(
                        label: 'Add Location',
                        icon: Icons.add_location_alt_outlined,
                        onPressed: () {
                          NASToast.success(context, 'Add Location Dialog');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: NASSpacing.md),

                  // Search + Region Filter Chips
                  const NASInputField(
                    label: '',
                    hint: 'Search by branch name, leader...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  const SizedBox(height: NASSpacing.xs),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All Regions', 'Province 1', 'Bagmati', 'Lumbini']
                          .map((region) {
                        final isSelected = _selectedRegion == region;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: isSelected,
                            label: Text(region),
                            onSelected: (_) =>
                                setState(() => _selectedRegion = region),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  // Location Branch Cards List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _sampleBranches.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: NASSpacing.sm),
                    itemBuilder: (context, index) {
                      final b = _sampleBranches[index];
                      return NASCard(
                        hasGoldAccent: true,
                        onTap: () => _showLocationDrawer(context, b),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: NASColors.secondaryContainer
                                    .withValues(alpha: 0.3),
                                borderRadius: NASRadius.defaultBorderRadius,
                              ),
                              child: const Icon(Icons.location_city,
                                  color: NASColors.secondary),
                            ),
                            const SizedBox(width: NASSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    b.name,
                                    style: NASTypography.titleLg.copyWith(
                                      color: NASColors.primary,
                                    ),
                                  ),
                                  Text(
                                    'Leader: ${b.leader}',
                                    style: NASTypography.labelSm.copyWith(
                                      color: NASColors.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${b.members} Members • ${b.events} Events',
                                    style: NASTypography.bodyMd.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            NASBadge.fromStatus(b.status),
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
        selectedIndex: 2,
        onItemTap: (index) {
          switch (index) {
            case 0:
              context.go(AppConstants.superAdminDashboard);
            case 1:
              context.go(AppConstants.superAdminAnalytics);
            case 2:
              break;
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

  void _showLocationDrawer(BuildContext context, _BranchItem b) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(NASRadius.lg)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(NASSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(b.name, style: NASTypography.headlineMdMobile),
            Text('Province: ${b.province}', style: NASTypography.labelSm),
            const SizedBox(height: NASSpacing.md),

            NASCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Members'),
                      Text('${b.members}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Branch Leader'),
                      Text(b.leader, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: NASSpacing.md),

            Row(
              children: [
                Expanded(
                  child: NASPrimaryButton(
                    label: 'Reassign Leader',
                    onPressed: () {
                      Navigator.pop(context);
                      NASToast.success(context, 'Leader reassignment initiated.');
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: NASSecondaryButton(
                    label: 'Close',
                    onPressed: () => Navigator.pop(context),
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

class _BranchItem {
  final String name;
  final String province;
  final String leader;
  final int members;
  final int events;
  final String status;
  const _BranchItem({
    required this.name,
    required this.province,
    required this.leader,
    required this.members,
    required this.events,
    required this.status,
  });
}

const _sampleBranches = [
  _BranchItem(
    name: 'Kathmandu Central',
    province: 'Bagmati Province',
    leader: 'Shri Rajesh Agrawal',
    members: 1240,
    events: 42,
    status: 'Active',
  ),
  _BranchItem(
    name: 'Biratnagar Branch',
    province: 'Province 1',
    leader: 'Smt. Sarita Agrawal',
    members: 856,
    events: 18,
    status: 'Active',
  ),
  _BranchItem(
    name: 'Butwal Unit',
    province: 'Lumbini Province',
    leader: 'Shri Pawan Gupta',
    members: 230,
    events: 0,
    status: 'Inactive',
  ),
];
