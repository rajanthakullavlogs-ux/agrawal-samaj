import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/nas_logo.dart';

/// B2 — Members Management Screen (Location Admin)
class MembersManagementScreen extends ConsumerStatefulWidget {
  const MembersManagementScreen({super.key});

  @override
  ConsumerState<MembersManagementScreen> createState() => _MembersManagementScreenState();
}

enum _MemberFilter { all, active, pending, inactive, lifetime }

class _MembersManagementScreenState extends ConsumerState<MembersManagementScreen> {
  _MemberFilter _filter = _MemberFilter.all;
  String _searchQuery = '';

  static const _membersList = [
    (
      id: 'NAS-4492',
      name: 'Rahul Agrawal',
      status: 'ACTIVE',
      memberType: 'Lifetime Member',
      location: 'Kathmandu',
      phone: '+977-98510XXXXX',
      email: 'rahul@agrawal.org',
      avatarBg: Color(0xFFE3EEFD),
      avatarColor: Color(0xFF2E6FE0),
    ),
    (
      id: 'NAS-9021',
      name: 'Sneha Mittal',
      status: 'PENDING',
      memberType: 'Standard Member',
      location: 'Kathmandu',
      phone: '+977-98412XXXXX',
      email: 'sneha.m@gmail.com',
      avatarBg: Color(0xFFFCEAE0),
      avatarColor: Color(0xFFE8622C),
    ),
    (
      id: 'NAS-1205',
      name: 'Deepak Goyal',
      status: 'ACTIVE',
      memberType: 'Trustee Member',
      location: 'Kathmandu',
      phone: '+977-98011XXXXX',
      email: 'deepak.goyal@nabil.com',
      avatarBg: Color(0xFFE5F5E9),
      avatarColor: Color(0xFF3E7C4A),
    ),
    (
      id: 'NAS-5510',
      name: 'Vikram Bansal',
      status: 'INACTIVE',
      memberType: 'Standard Member',
      location: 'Kathmandu',
      phone: '+977-98600XXXXX',
      email: 'vikram.bansal@gmail.com',
      avatarBg: Color(0xFFEFE7FB),
      avatarColor: Color(0xFF7B4FD6),
    ),
    (
      id: 'NAS-3301',
      name: 'Pooja Agrawal',
      status: 'PENDING',
      memberType: 'Lifetime Member',
      location: 'Kathmandu',
      phone: '+977-98130XXXXX',
      email: 'pooja.a@agrawal.org',
      avatarBg: Color(0xFFFCEAE0),
      avatarColor: Color(0xFFE8622C),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _membersList.where((m) {
      final matchesQuery = _searchQuery.isEmpty ||
          m.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.id.toLowerCase().contains(_searchQuery.toLowerCase());

      if (!matchesQuery) return false;

      switch (_filter) {
        case _MemberFilter.all:
          return true;
        case _MemberFilter.active:
          return m.status == 'ACTIVE';
        case _MemberFilter.pending:
          return m.status == 'PENDING';
        case _MemberFilter.inactive:
          return m.status == 'INACTIVE';
        case _MemberFilter.lifetime:
          return m.memberType.contains('Lifetime');
      }
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            const _AdminTopBar(),
            const SizedBox(height: 14),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _HeroBanner(),
            ),
            const SizedBox(height: 20),

            // Summary metrics grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.6,
                children: const [
                  _MiniStat(
                    title: 'Total Members',
                    value: '1,248',
                    icon: Icons.people_alt_rounded,
                    color: Color(0xFF2E6FE0),
                    bg: Color(0xFFF3F8FE),
                  ),
                  _MiniStat(
                    title: 'Active Members',
                    value: '856',
                    icon: Icons.check_circle_rounded,
                    color: Color(0xFF3E7C4A),
                    bg: Color(0xFFF2FAF4),
                  ),
                  _MiniStat(
                    title: 'Pending Review',
                    value: '12',
                    icon: Icons.pending_actions_rounded,
                    color: Color(0xFFE8622C),
                    bg: Color(0xFFFDF3ED),
                  ),
                  _MiniStat(
                    title: 'Trustees',
                    value: '42',
                    icon: Icons.workspace_premium_rounded,
                    color: Color(0xFFC4901E),
                    bg: Color(0xFFFCF7EB),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Actions Strip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text('Quick Actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _QuickActionTile(
                    icon: Icons.person_add_alt_1_rounded,
                    bg: const Color(0xFFE3EEFD),
                    color: const Color(0xFF2E6FE0),
                    label: 'Add New\nMember',
                    onTap: () => _showAddMemberModal(context),
                  ),
                  const SizedBox(width: 10),
                  _QuickActionTile(
                    icon: Icons.how_to_reg_rounded,
                    bg: const Color(0xFFFCEAE0),
                    color: const Color(0xFFE8622C),
                    label: 'Pending\nApplications',
                    onTap: () => setState(() => _filter = _MemberFilter.pending),
                  ),
                  const SizedBox(width: 10),
                  _QuickActionTile(
                    icon: Icons.file_download_rounded,
                    bg: const Color(0xFFE5F5E9),
                    color: const Color(0xFF3E7C4A),
                    label: 'Export\nDirectory',
                    onTap: () {},
                  ),
                  const SizedBox(width: 10),
                  _QuickActionTile(
                    icon: Icons.mark_email_read_rounded,
                    bg: const Color(0xFFEFE7FB),
                    color: const Color(0xFF7B4FD6),
                    label: 'Send Bulk\nNotice',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Search member by name, ID or email...',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Filter Chips
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _filterChip('All Members', _MemberFilter.all),
                  const SizedBox(width: 8),
                  _filterChip('Active', _MemberFilter.active),
                  const SizedBox(width: 8),
                  _filterChip('Pending (2)', _MemberFilter.pending),
                  const SizedBox(width: 8),
                  _filterChip('Inactive', _MemberFilter.inactive),
                  const SizedBox(width: 8),
                  _filterChip('Lifetime', _MemberFilter.lifetime),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Members List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  for (final member in filtered) ...[
                    _MemberCard(
                      member: member,
                      onTap: () => _showMemberDetailsDrawer(context, member),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (filtered.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(30),
                      alignment: Alignment.center,
                      child: Text('No members found matching your search',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _AdminBottomNavBar(activeIndex: 1),
    );
  }

  Widget _filterChip(String label, _MemberFilter value) {
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

  void _showAddMemberModal(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening New Member Application Form...')),
    );
  }

  void _showMemberDetailsDrawer(BuildContext context, dynamic m) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: m.avatarBg,
                  child: Icon(Icons.person_rounded, color: m.avatarColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                      Text('${m.id} • ${m.memberType}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _infoRow(Icons.phone_rounded, m.phone),
            const SizedBox(height: 6),
            _infoRow(Icons.email_rounded, m.email),
            const SizedBox(height: 6),
            _infoRow(Icons.location_on_rounded, 'Branch: ${m.location} Chapter'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${m.name} status updated successfully!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    ),
                    child: const Text('Approve / Edit Status', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  ),
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// TOP BAR WITH EXIT BUTTON
// ---------------------------------------------------------------------------
class _AdminTopBar extends StatelessWidget {
  const _AdminTopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => context.go(AppConstants.home),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.home_rounded, size: 22, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 8),
          const NasLogo(size: 38),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Nepal Agrawal Samaj',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Members Directory',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 11.5, fontWeight: FontWeight.w600),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFCEEE4), Color(0xFFFBE3D3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Members Directory 👥',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text('Manage chapter registrations, review pending credentials, and support community members.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.35)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: const Icon(Icons.badge_rounded, color: AppColors.primary, size: 32),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MINI STAT
// ---------------------------------------------------------------------------
class _MiniStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color bg;

  const _MiniStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: color)),
                Text(title, style: TextStyle(fontSize: 10.5, color: Colors.grey.shade700), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// QUICK ACTION TILE
// ---------------------------------------------------------------------------
class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.bg,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        width: 84,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.lg)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MEMBER CARD
// ---------------------------------------------------------------------------
class _MemberCard extends StatelessWidget {
  final dynamic member;
  final VoidCallback onTap;

  const _MemberCard({required this.member, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isPending = member.status == 'PENDING';
    final isInactive = member.status == 'INACTIVE';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: member.avatarBg,
          child: Icon(Icons.person_rounded, color: member.avatarColor, size: 20),
        ),
        title: Text(member.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        subtitle: Text('ID: ${member.id} • ${member.memberType}',
            style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isPending
                ? const Color(0xFFFFF3E0)
                : isInactive
                    ? const Color(0xFFF5F5F5)
                    : const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            member.status,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: isPending
                  ? const Color(0xFFE8622C)
                  : isInactive
                      ? Colors.grey.shade600
                      : const Color(0xFF3E7C4A),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ADMIN BOTTOM NAV
// ---------------------------------------------------------------------------
class _AdminBottomNavBar extends StatelessWidget {
  final int activeIndex;
  const _AdminBottomNavBar({required this.activeIndex});

  static const _items = [
    (icon: Icons.dashboard_rounded, label: 'Dashboard', route: AppConstants.adminDashboard),
    (icon: Icons.people_alt_rounded, label: 'Members', route: AppConstants.adminMembers),
    (icon: Icons.event_rounded, label: 'Events', route: AppConstants.adminEvents),
    (icon: Icons.photo_library_rounded, label: 'Gallery', route: AppConstants.adminGallery),
    (icon: Icons.settings_rounded, label: 'Settings', route: AppConstants.adminSettings),
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
