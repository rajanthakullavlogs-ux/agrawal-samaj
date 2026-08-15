import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/nas_logo.dart';
import '../data/members_repository.dart';

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

  @override
  Widget build(BuildContext context) {
    final membersList = ref.watch(membersNotifierProvider);

    final filtered = membersList.where((m) {
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

    final activeCount = membersList.where((m) => m.status == 'ACTIVE').length;
    final pendingCount = membersList.where((m) => m.status == 'PENDING').length;
    final trusteeCount = membersList.where((m) => m.memberType.contains('Trustee')).length;

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
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _MetricCard(
                          icon: Icons.people_alt_rounded,
                          iconBg: const Color(0xFFDCEBFD),
                          iconColor: const Color(0xFF2E6FE0),
                          cardBg: const Color(0xFFF3F8FE),
                          title: 'Total Members',
                          value: '1,248',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MetricCard(
                          icon: Icons.person_rounded,
                          iconBg: const Color(0xFFFBE0D2),
                          iconColor: const Color(0xFFE8622C),
                          cardBg: const Color(0xFFFDF3ED),
                          title: 'Women Leaders',
                          value: '152',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _MetricCard(
                          icon: Icons.female_rounded,
                          iconBg: const Color(0xFFFBECEE),
                          iconColor: const Color(0xFF9E4348),
                          cardBg: const Color(0xFFFDF3F4),
                          title: 'Young Female Members',
                          value: '316',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MetricCard(
                          icon: Icons.person_add_alt_1_rounded,
                          iconBg: const Color(0xFFD8F0DE),
                          iconColor: const Color(0xFF3E7C4A),
                          cardBg: const Color(0xFFF2FAF4),
                          title: 'New Requests',
                          value: '24',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Search and Review Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: TextField(
                        onChanged: (v) => setState(() => _searchQuery = v),
                        decoration: InputDecoration(
                          hintText: 'Search by name, phone or member ID...',
                          hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 44,
                    width: 44,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF81161B),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Badge(
                        label: Text('24', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 10)),
                        backgroundColor: Color(0xFFFACC15), // bright yellow pop
                        textColor: Color(0xFF81161B),
                        offset: Offset(8, -8),
                        child: Icon(Icons.person_add_alt_1_rounded, size: 22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Secondary Filters Row
            SizedBox(
              height: 32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _filterDropdown('All Categories'),
                  const SizedBox(width: 8),
                  _filterDropdown('All Age Groups'),
                  const SizedBox(width: 8),
                  _filterDropdown('All Status'),
                  const SizedBox(width: 8),
                  _filterDropdown('Sort: Newest'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Members Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Members ',
                      style: const TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4A1215),
                      ),
                      children: [
                        TextSpan(
                          text: '(1,248)',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: const [
                        Icon(Icons.download_rounded, size: 16, color: Color(0xFF81161B)),
                        SizedBox(width: 4),
                        Text('Export Members', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF81161B))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

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
            // Pagination Footer
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Showing 1-10 of 1248', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(4)),
                        child: const Icon(Icons.chevron_left_rounded, size: 16, color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFF81161B), borderRadius: BorderRadius.circular(4)),
                        child: const Text('1', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      const Text('2', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      const Text('3', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      const Text('...', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(4)),
                        child: const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF4A1215)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: const _AdminBottomNavBar(activeIndex: 1),
    );
  }

  Widget _filterDropdown(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF7F5),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: const Color(0xFFF1E3DF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF81161B),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: Color(0xFF81161B)),
        ],
      ),
    );
  }

  void _showAddMemberModal(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    String memberType = 'Standard Member';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: Row(
          children: const [
            Icon(Icons.person_add_alt_1_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Add New Member', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'e.g. Anand Agrawal',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+977-98XXXXXXXX',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'anand@agrawal.org',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final newMember = MemberItem(
                  id: 'NAS-${1000 + DateTime.now().millisecond}',
                  name: nameController.text,
                  status: 'PENDING',
                  memberType: memberType,
                  location: 'Kathmandu',
                  phone: phoneController.text.isNotEmpty ? phoneController.text : '+977-9851XXXXXX',
                  email: emailController.text.isNotEmpty ? emailController.text : 'newmember@agrawal.org',
                  avatarBg: const Color(0xFFFCEAE0),
                  avatarColor: const Color(0xFFE8622C),
                );
                ref.read(membersNotifierProvider.notifier).addMember(newMember);
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Member "${newMember.name}" registered and added to directory!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Save Member', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
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
                      ref.read(membersNotifierProvider.notifier).approveMember(m.id);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${m.name} status updated to ACTIVE!')),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.primary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Members Management',
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay', 
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 220,
                child: Text(
                  'Oversee your branch members,\napprove new requests and\nstrengthen our community.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MINI STAT
// ---------------------------------------------------------------------------
class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color cardBg;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.cardBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, size: 15, color: iconColor),
              ),
              const SizedBox(width: 8),
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary, height: 1.0)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500, height: 1.1),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}


// ---------------------------------------------------------------------------
// MEMBER CARD
class _MemberCard extends StatelessWidget {
  final dynamic member;
  final VoidCallback onTap;

  const _MemberCard({required this.member, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: const Color(0xFFF1E3DF)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/profile_banner.jpg'), // Using dummy image for now
              // If you have real avatars, use NetworkImage(member.avatarUrl)
            ),
            const SizedBox(width: 16),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Active Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        member.name,
                        style: const TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4A1215),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF5EF),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Text(
                              'Active',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF3E7C4A)),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.more_vert_rounded, size: 18, color: Color(0xFF81161B)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Role Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCEEE4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      member.memberType,
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFB5704D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Phone and ID
                  Row(
                    children: [
                      const Icon(Icons.phone_rounded, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${member.phone}   •   ${member.id}',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Joined Date
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Joined 12 Jan 2024',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
