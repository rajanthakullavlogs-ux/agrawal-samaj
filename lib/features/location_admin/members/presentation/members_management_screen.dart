import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/widgets.dart';

/// B2 — Members Management Screen (Location Admin)
/// Matches design b2._members_location_admin/screen.png:
/// - Search bar + Status dropdown + "+ Add Member" CTA button
/// - Pending Applications banner card ("12 New Applications pending review for Birgunj branch")
/// - Members list cards (Rahul Agrawal ACTIVE Lifetime Member, Sneha Mittal PENDING, Deepak Goyal ACTIVE Trustee, Vikram Bansal INACTIVE)
/// - Bottom Nav
class MembersManagementScreen extends ConsumerStatefulWidget {
  const MembersManagementScreen({super.key});

  @override
  ConsumerState<MembersManagementScreen> createState() =>
      _MembersManagementScreenState();
}

class _MembersManagementScreenState
    extends ConsumerState<MembersManagementScreen> {
  String _selectedStatus = 'All Status';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NASAppBar(title: 'Members Management'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NASContentWidth(
              child: Column(
                children: [
                  const SizedBox(height: NASSpacing.md),
                  // Search bar
                  NASInputField(
                    label: '',
                    hint: 'Search members by name or ID...',
                    prefixIcon: const Icon(Icons.search),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                  const SizedBox(height: NASSpacing.xs),

                  Row(
                    children: [
                      Expanded(
                        child: NASSelectField<String>(
                          label: '',
                          value: _selectedStatus,
                          items: const [
                            DropdownMenuItem(
                                value: 'All Status', child: Text('All Status')),
                            DropdownMenuItem(
                                value: 'Active', child: Text('Active')),
                            DropdownMenuItem(
                                value: 'Pending', child: Text('Pending')),
                            DropdownMenuItem(
                                value: 'Inactive', child: Text('Inactive')),
                          ],
                          onChanged: (v) =>
                              setState(() => _selectedStatus = v ?? 'All Status'),
                        ),
                      ),
                      const SizedBox(width: NASSpacing.sm),
                      NASPrimaryButton(
                        label: 'Add Member',
                        icon: Icons.person_add,
                        onPressed: () {
                          NASToast.success(context, 'Add Member Form Opened');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  // Pending Banner Card
                  NASCard(
                    hasGoldAccent: true,
                    child: Container(
                      padding: const EdgeInsets.all(NASSpacing.sm),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.assignment_ind_outlined,
                            size: 36,
                            color: NASColors.secondary,
                          ),
                          const SizedBox(height: NASSpacing.xs),
                          Text(
                            '12 New Applications',
                            style: NASTypography.titleLg.copyWith(
                              color: NASColors.primary,
                            ),
                          ),
                          Text(
                            'Pending review for Kathmandu chapter',
                            style: NASTypography.bodyMd.copyWith(
                              color: NASColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: NASSpacing.sm),
                          NASSecondaryButton(
                            label: 'View List',
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  // Members List Cards
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _sampleMembers.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: NASSpacing.sm),
                    itemBuilder: (context, index) {
                      final m = _sampleMembers[index];
                      if (_selectedStatus != 'All Status' &&
                          m.status.toLowerCase() !=
                              _selectedStatus.toLowerCase()) {
                        return const SizedBox.shrink();
                      }
                      if (_searchQuery.isNotEmpty &&
                          !m.name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
                          !m.id.toLowerCase().contains(_searchQuery.toLowerCase())) {
                        return const SizedBox.shrink();
                      }

                      return NASMemberCard(
                        name: m.name,
                        subtitle: 'ID: ${m.id}',
                        status: m.status,
                        memberType: m.memberType,
                        locationName: m.location,
                        onTap: () => _showMemberDrawer(context, m),
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
        selectedIndex: 1,
        onItemTap: (index) {
          switch (index) {
            case 0:
              context.go(AppConstants.adminDashboard);
            case 1:
              break;
            case 2:
              context.go(AppConstants.adminEvents);
            case 3:
              context.go(AppConstants.adminGallery);
            case 4:
              context.go(AppConstants.adminSettings);
          }
        },
        items: const [
          NASNavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard'),
          NASNavItem(icon: Icons.people_outlined, activeIcon: Icons.people, label: 'Members'),
          NASNavItem(icon: Icons.event_outlined, activeIcon: Icons.event, label: 'Events'),
          NASNavItem(icon: Icons.photo_library_outlined, activeIcon: Icons.photo_library, label: 'Gallery'),
          NASNavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'Settings'),
        ],
      ),
    );
  }

  void _showMemberDrawer(BuildContext context, _MemberItem m) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(NASRadius.lg)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(NASSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(m.name, style: NASTypography.headlineMdMobile),
            Text('ID: ${m.id} • ${m.memberType}', style: NASTypography.labelSm),
            const SizedBox(height: NASSpacing.md),
            Row(
              children: [
                Expanded(
                  child: NASPrimaryButton(
                    label: 'Approve / Edit',
                    onPressed: () {
                      Navigator.pop(context);
                      NASToast.success(context, 'Member status updated.');
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

class _MemberItem {
  final String id;
  final String name;
  final String status;
  final String memberType;
  final String location;
  const _MemberItem({
    required this.id,
    required this.name,
    required this.status,
    required this.memberType,
    required this.location,
  });
}

const _sampleMembers = [
  _MemberItem(
    id: 'NAS-4492',
    name: 'Rahul Agrawal',
    status: 'ACTIVE',
    memberType: 'Lifetime Member',
    location: 'Kathmandu',
  ),
  _MemberItem(
    id: 'NAS-9021',
    name: 'Sneha Mittal',
    status: 'PENDING',
    memberType: 'Standard Member',
    location: 'Lalitpur',
  ),
  _MemberItem(
    id: 'NAS-1205',
    name: 'Deepak Goyal',
    status: 'ACTIVE',
    memberType: 'Trustee',
    location: 'Bhaktapur',
  ),
  _MemberItem(
    id: 'NAS-5510',
    name: 'Vikram Bansal',
    status: 'INACTIVE',
    memberType: 'Standard Member',
    location: 'Pokhara',
  ),
];
