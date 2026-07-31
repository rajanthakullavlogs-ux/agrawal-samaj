import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/design_tokens.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/locations_repository.dart';

/// A8 — Location Profile Screen (Public Site)
/// Matches design a8._location_profile_public_site/screen.png:
/// - Chapter Banner (Title, province badge, member count chip)
/// - Chapter Intro & Achievements
/// - Chapter Leader Profile card
/// - Office Address & Contact details
/// - Local Chapter Events list
/// - Footer + Bottom nav
class LocationProfileScreen extends ConsumerWidget {
  final String locationId;

  const LocationProfileScreen({super.key, required this.locationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(locationDetailProvider(locationId));

    return Scaffold(
      appBar: const NASAppBar(title: 'Chapter Profile', showBackButton: true),
      body: locationAsync.when(
        data: (location) {
          if (location == null) {
            return const NASEmptyState(title: 'Chapter not found');
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header Banner
                Container(
                  width: double.infinity,
                  color: NASColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: NASSpacing.marginMobile,
                    vertical: NASSpacing.lg,
                  ),
                  child: NASContentWidth(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NASBadge.cultural(label: location.province),
                        const SizedBox(height: NASSpacing.xs),
                        Text(
                          location.name,
                          style: NASTypography.headlineMdMobile.copyWith(
                            color: NASColors.onPrimary,
                            fontFamily: NASTypography.headlineFont,
                          ),
                        ),
                        const SizedBox(height: NASSpacing.xs),
                        Row(
                          children: [
                            const Icon(Icons.people, size: 16, color: NASColors.secondaryContainer),
                            const SizedBox(width: 4),
                            Text(
                              '${location.totalMembers} Active Members',
                              style: NASTypography.labelSm.copyWith(
                                color: NASColors.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                NASContentWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: NASSpacing.md),

                      // Intro section
                      Text(
                        'About Chapter',
                        style: NASTypography.titleLg.copyWith(color: NASColors.primary),
                      ),
                      const SizedBox(height: NASSpacing.xs),
                      Text(
                        location.intro ??
                            'Serving the local Agrawal community through regular cultural programs, economic empowerment, and member support.',
                        style: NASTypography.bodyMd.copyWith(color: NASColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: NASSpacing.lg),

                      // Contact & Office details card
                      NASCard(
                        hasGoldAccent: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Contact & Location',
                              style: NASTypography.titleLg.copyWith(color: NASColors.primary),
                            ),
                            const SizedBox(height: NASSpacing.sm),
                            Row(
                              children: [
                                const Icon(Icons.business_outlined, color: NASColors.secondary),
                                const SizedBox(width: NASSpacing.xs),
                                Expanded(
                                  child: Text(
                                    location.officeAddress ?? 'Chapter Office Address',
                                    style: NASTypography.bodyMd.copyWith(color: NASColors.onSurface),
                                  ),
                                ),
                              ],
                            ),
                            if (location.contactPhone != null) ...[
                              const SizedBox(height: NASSpacing.xs),
                              Row(
                                children: [
                                  const Icon(Icons.phone_outlined, color: NASColors.secondary),
                                  const SizedBox(width: NASSpacing.xs),
                                  Text(
                                    location.contactPhone!,
                                    style: NASTypography.bodyMd.copyWith(color: NASColors.onSurface),
                                  ),
                                ],
                              ),
                            ],
                            if (location.contactEmail != null) ...[
                              const SizedBox(height: NASSpacing.xs),
                              Row(
                                children: [
                                  const Icon(Icons.email_outlined, color: NASColors.secondary),
                                  const SizedBox(width: NASSpacing.xs),
                                  Text(
                                    location.contactEmail!,
                                    style: NASTypography.bodyMd.copyWith(color: NASColors.onSurface),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: NASSpacing.lg),

                      // Chapter Leadership
                      Text(
                        'Chapter Leadership',
                        style: NASTypography.titleLg.copyWith(color: NASColors.primary),
                      ),
                      const SizedBox(height: NASSpacing.xs),
                      NASMemberCard(
                        name: 'Rajesh Agrawal',
                        subtitle: 'Chapter President',
                        memberType: 'Lifetime Member',
                        locationName: location.name,
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
        error: (_, _) => const NASEmptyState(title: 'Failed to load chapter profile'),
      ),
      bottomNavigationBar: NASBottomNav(
        selectedIndex: 1,
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
