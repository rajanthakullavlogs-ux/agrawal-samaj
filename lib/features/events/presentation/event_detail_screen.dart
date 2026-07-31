import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/design_tokens.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/events_repository.dart';

/// A4 — Event Detail Screen (Public Site)
/// Matches design a4._event_detail_public_site/screen.png:
/// - Event poster banner
/// - Category badge (Cultural, Business, Social)
/// - Title, date, time, venue, organizer
/// - Description text
/// - "Register for Event" CTA card with registration button
/// - Footer + Bottom nav
class EventDetailScreen extends ConsumerWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventDetailProvider(eventId));

    return Scaffold(
      appBar: const NASAppBar(title: 'Event Details', showBackButton: true),
      body: eventAsync.when(
        data: (event) {
          if (event == null) {
            return const NASEmptyState(title: 'Event not found');
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                // Event Poster Banner
                Container(
                  height: 240,
                  width: double.infinity,
                  color: NASColors.surfaceVariant,
                  child: event.posterUrl != null
                      ? Image.network(event.posterUrl!, fit: BoxFit.cover)
                      : const Center(
                          child: Icon(Icons.event, size: 64, color: NASColors.outline),
                        ),
                ),

                NASContentWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: NASSpacing.md),
                      // Category badge
                      if (event.category != null)
                        NASBadge.cultural(label: event.category!),
                      const SizedBox(height: NASSpacing.xs),

                      // Title
                      Text(
                        event.title,
                        style: NASTypography.headlineMd.copyWith(
                          color: NASColors.primary,
                          fontFamily: NASTypography.headlineFont,
                        ),
                      ),
                      const SizedBox(height: NASSpacing.md),

                      // Details grid (Date, Time, Venue, Organized By)
                      NASCard(
                        child: Column(
                          children: [
                            _DetailRow(
                              icon: Icons.calendar_today_outlined,
                              label: 'Date',
                              value: '${event.eventDate.day}/${event.eventDate.month}/${event.eventDate.year}',
                            ),
                            const Divider(height: NASSpacing.md),
                            _DetailRow(
                              icon: Icons.access_time_outlined,
                              label: 'Time',
                              value: event.eventTime ?? 'TBD',
                            ),
                            const Divider(height: NASSpacing.md),
                            _DetailRow(
                              icon: Icons.location_on_outlined,
                              label: 'Venue',
                              value: event.venue ?? 'TBD',
                            ),
                            if (event.organizedBy != null) ...[
                              const Divider(height: NASSpacing.md),
                              _DetailRow(
                                icon: Icons.group_outlined,
                                label: 'Organized By',
                                value: event.organizedBy!,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: NASSpacing.lg),

                      // Description
                      Text(
                        'About This Event',
                        style: NASTypography.titleLg.copyWith(
                          color: NASColors.primary,
                        ),
                      ),
                      const SizedBox(height: NASSpacing.xs),
                      Text(
                        event.description ??
                            'Join us for this community event. All members and families are warmly welcome to attend.',
                        style: NASTypography.bodyMd.copyWith(
                          color: NASColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: NASSpacing.xl),

                      // Register CTA
                      NASCard(
                        hasGoldAccent: true,
                        child: Column(
                          children: [
                            Text(
                              'Reserve Your Spot',
                              style: NASTypography.titleLg.copyWith(
                                color: NASColors.primary,
                              ),
                            ),
                            const SizedBox(height: NASSpacing.xs),
                            Text(
                              'Registration is free for all registered members.',
                              style: NASTypography.bodyMd.copyWith(
                                color: NASColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: NASSpacing.md),
                            NASPrimaryButton(
                              label: 'Register Now',
                              fullWidth: true,
                              onPressed: () {
                                NASToast.success(context, 'Successfully registered for event!');
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: NASSpacing.xl),
                const NASFooter(),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const NASEmptyState(title: 'Error loading event'),
      ),
      bottomNavigationBar: NASBottomNav(
        selectedIndex: 2,
        onItemTap: (index) {
          switch (index) {
            case 0:
              context.go(AppConstants.home);
            case 1:
              context.go(AppConstants.locations);
            case 2:
              context.go(AppConstants.events);
            case 3:
              context.go(AppConstants.login);
          }
        },
        items: const [
          NASNavItem(icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view, label: 'Overview'),
          NASNavItem(icon: Icons.people_outlined, activeIcon: Icons.people, label: 'Members'),
          NASNavItem(icon: Icons.event_outlined, activeIcon: Icons.event, label: 'Events'),
          NASNavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'Settings'),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: NASColors.secondary),
        const SizedBox(width: NASSpacing.sm),
        Text(
          label,
          style: NASTypography.labelMd.copyWith(color: NASColors.onSurfaceVariant),
        ),
        const Spacer(),
        Text(
          value,
          style: NASTypography.labelMd.copyWith(
            color: NASColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
