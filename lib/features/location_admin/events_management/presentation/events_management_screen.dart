import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/widgets.dart';

/// B3 — Events Management Screen (Location Admin)
/// Matches design b3._events_location_admin/screen.png:
/// - Title "Events Management" + subtext
/// - Segmented toggle: Upcoming / Past / Cancelled
/// - Top Event Card with "ACTIVE" & "CULTURAL" badges, 1,240 Registered count, "Edit Details" & "View Roster" buttons
/// - Quick Summary card (Total Events: 12, New RSVPs: +458, Revenue: NPR 45,000, "Download Report" CTA)
/// - Event list cards with venue, RSVPs, and dates
/// - Floating Action Button "+" to create new event
/// - Bottom Nav
class EventsManagementScreen extends StatefulWidget {
  const EventsManagementScreen({super.key});

  @override
  State<EventsManagementScreen> createState() => _EventsManagementScreenState();
}

class _EventsManagementScreenState extends State<EventsManagementScreen> {
  int _selectedFilter = 0; // 0: Upcoming, 1: Past, 2: Cancelled

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NASAppBar(title: 'Events Management'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NASContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: NASSpacing.md),
                  Text(
                    'Events Management',
                    style: NASTypography.headlineMd.copyWith(
                      color: NASColors.primary,
                      fontFamily: NASTypography.headlineFont,
                    ),
                  ),
                  const SizedBox(height: NASSpacing.xs),
                  Text(
                    'Oversee and organize community gatherings for your chapter.',
                    style: NASTypography.bodyMd.copyWith(
                      color: NASColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: NASSpacing.md),

                  // Segmented toggle (Upcoming / Past / Cancelled)
                  Container(
                    decoration: BoxDecoration(
                      color: NASColors.surfaceContainerHigh,
                      borderRadius: NASRadius.fullBorderRadius,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: ['Upcoming', 'Past', 'Cancelled']
                          .asMap()
                          .entries
                          .map((e) {
                        final isSelected = e.key == _selectedFilter;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedFilter = e.key),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? NASColors.surfaceContainerLowest
                                    : Colors.transparent,
                                borderRadius: NASRadius.fullBorderRadius,
                              ),
                              child: Text(
                                e.value,
                                textAlign: TextAlign.center,
                                style: NASTypography.labelMd.copyWith(
                                  color: isSelected
                                      ? NASColors.primary
                                      : NASColors.onSurfaceVariant,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  // Featured Active Event Card
                  NASCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            NASBadge.cultural(label: 'Cultural'),
                            NASBadge.active(label: 'Active'),
                          ],
                        ),
                        const SizedBox(height: NASSpacing.xs),
                        Text(
                          'Annual Heritage Gala 2024',
                          style: NASTypography.titleLg.copyWith(
                            color: NASColors.primary,
                          ),
                        ),
                        const SizedBox(height: NASSpacing.sm),
                        Row(
                          children: const [
                            Icon(Icons.people_outline, size: 16, color: NASColors.secondary),
                            SizedBox(width: 4),
                            Text('1,240 Registered'),
                            SizedBox(width: 16),
                            Icon(Icons.calendar_today, size: 16, color: NASColors.secondary),
                            SizedBox(width: 4),
                            Text('Oct 15, 2024'),
                          ],
                        ),
                        const SizedBox(height: NASSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: NASSecondaryButton(
                                label: 'Edit Details',
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(width: NASSpacing.sm),
                            Expanded(
                              child: NASPrimaryButton(
                                label: 'View Roster',
                                onPressed: () {
                                  NASToast.success(context, 'Opening registration roster...');
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  // Quick Summary Dark Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(NASSpacing.md),
                    decoration: BoxDecoration(
                      color: NASColors.primary,
                      borderRadius: NASRadius.lgBorderRadius,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Summary',
                          style: NASTypography.titleLg.copyWith(
                            color: NASColors.onPrimary,
                          ),
                        ),
                        Text(
                          'Current month\'s performance',
                          style: NASTypography.labelSm.copyWith(
                            color: NASColors.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: NASSpacing.md),

                        const _SummaryRow(label: 'Total Events', value: '12'),
                        const Divider(color: NASColors.outline),
                        const _SummaryRow(label: 'New RSVPs', value: '+458'),
                        const Divider(color: NASColors.outline),
                        const _SummaryRow(label: 'Revenue', value: 'NPR 45,000'),
                        const SizedBox(height: NASSpacing.md),

                        NASSecondaryButton(
                          label: 'Download Report',
                          fullWidth: true,
                          onPressed: () {
                            NASToast.success(context, 'Downloading event performance report...');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  // Additional events list
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _adminEvents.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: NASSpacing.sm),
                    itemBuilder: (context, index) {
                      final item = _adminEvents[index];
                      return NASCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NASBadge.business(label: item.category),
                            const SizedBox(height: 4),
                            Text(
                              item.title,
                              style: NASTypography.titleLg.copyWith(
                                color: NASColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 14, color: NASColors.outline),
                                const SizedBox(width: 4),
                                Text(item.venue),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${item.count} Booked',
                                    style: NASTypography.labelSm),
                                Text(item.date, style: NASTypography.labelSm),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NASToast.success(context, 'Create New Event dialog');
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NASBottomNav(
        selectedIndex: 2,
        onItemTap: (index) {
          switch (index) {
            case 0:
              context.go(AppConstants.adminDashboard);
            case 1:
              context.go(AppConstants.adminMembers);
            case 2:
              break;
            case 3:
              context.go(AppConstants.adminSettings);
          }
        },
        items: const [
          NASNavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard'),
          NASNavItem(icon: Icons.people_outlined, activeIcon: Icons.people, label: 'Members'),
          NASNavItem(icon: Icons.event_outlined, activeIcon: Icons.event, label: 'Events'),
          NASNavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'Settings'),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: NASTypography.bodyMd.copyWith(color: NASColors.onPrimary)),
          Text(value,
              style: NASTypography.titleLg.copyWith(
                  color: NASColors.secondaryContainer, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _AdminEventItem {
  final String title;
  final String category;
  final String venue;
  final int count;
  final String date;
  const _AdminEventItem({
    required this.title,
    required this.category,
    required this.venue,
    required this.count,
    required this.date,
  });
}

const _adminEvents = [
  _AdminEventItem(
    title: 'Entrepreneurship Summit',
    category: 'BUSINESS',
    venue: 'Samaj Hall, Kathmandu',
    count: 84,
    date: 'Oct 22, 10:00 AM',
  ),
  _AdminEventItem(
    title: 'Youth Cultural Fest',
    category: 'YOUTH',
    venue: 'National Stadium',
    count: 312,
    date: 'Nov 05, 04:00 PM',
  ),
  _AdminEventItem(
    title: 'Senior Wellness Day',
    category: 'HEALTH',
    venue: 'Central Clinic Wing',
    count: 45,
    date: 'Oct 28, 08:00 AM',
  ),
];
