import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/nas_logo.dart';
import '../data/members_repository.dart';
import '../../shared/branch_admin_nav_bar.dart';

/// B2 — Members Management Screen (Location Admin)
class MembersManagementScreen extends ConsumerStatefulWidget {
  final String? initialFilter;
  const MembersManagementScreen({super.key, this.initialFilter});

  @override
  ConsumerState<MembersManagementScreen> createState() => _MembersManagementScreenState();
}

enum _MemberFilter { all, active, pending, inactive, lifetime }

class _MembersManagementScreenState extends ConsumerState<MembersManagementScreen> {
  late _MemberFilter _filter;
  String _searchQuery = '';
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  static const int _itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    if (widget.initialFilter == 'ACTIVE') {
      _filter = _MemberFilter.active;
    } else if (widget.initialFilter == 'PENDING') {
      _filter = _MemberFilter.pending;
    } else if (widget.initialFilter == 'LIFETIME') {
      _filter = _MemberFilter.lifetime;
    } else {
      _filter = _MemberFilter.all;
    }

    if (widget.initialFilter != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            240.0,
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOutCubic,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
          return m.status != 'PENDING';
        case _MemberFilter.active:
          return m.status == 'ACTIVE';
        case _MemberFilter.pending:
          return m.status == 'PENDING';
        case _MemberFilter.inactive:
          return m.status == 'INACTIVE';
        case _MemberFilter.lifetime:
          return m.status != 'PENDING' && m.memberType.contains('Lifetime');
      }
    }).toList();

    final officialCount = membersList.where((m) => m.status != 'PENDING').length;
    final activeCount = membersList.where((m) => m.status == 'ACTIVE').length;
    final pendingCount = membersList.where((m) => m.status == 'PENDING').length;

    final totalItems = filtered.length;
    final totalPages = (totalItems / _itemsPerPage).ceil().clamp(1, 9999);
    final currentPage = _currentPage.clamp(1, totalPages);
    final startIndex = (currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, totalItems);
    final paginatedMembers = totalItems == 0 ? <MemberItem>[] : filtered.sublist(startIndex, endIndex);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          controller: _scrollController,
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
                          value: '$officialCount',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MetricCard(
                          icon: Icons.person_rounded,
                          iconBg: const Color(0xFFFBE0D2),
                          iconColor: const Color(0xFFE8622C),
                          cardBg: const Color(0xFFFDF3ED),
                          title: 'Active Members',
                          value: '$activeCount',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _MetricCard(
                          icon: Icons.workspace_premium_rounded,
                          iconBg: const Color(0xFFFBECEE),
                          iconColor: const Color(0xFF9E4348),
                          cardBg: const Color(0xFFFDF3F4),
                          title: 'Lifetime Members',
                          value: '${membersList.where((m) => m.status != 'PENDING' && (m.memberType.contains('Lifetime') || m.memberType.contains('Trustee'))).length}',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MetricCard(
                          icon: Icons.person_add_alt_1_rounded,
                          iconBg: const Color(0xFFD8F0DE),
                          iconColor: const Color(0xFF3E7C4A),
                          cardBg: const Color(0xFFF2FAF4),
                          title: 'Pending Requests',
                          value: '$pendingCount',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Search and Filter Dropdown Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: TextField(
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        onChanged: (v) => setState(() {
                          _searchQuery = v;
                          _currentPage = 1;
                        }),
                        decoration: InputDecoration(
                          hintText: 'Search by name, phone or ID...',
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
                  const SizedBox(width: 10),
                  PopupMenuButton<_MemberFilter>(
                    initialValue: _filter,
                    onSelected: (val) => setState(() {
                      _filter = val;
                      _currentPage = 1;
                    }),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    color: Colors.white,
                    elevation: 6,
                    itemBuilder: (context) => [
                      _buildMemberFilterMenuItem(_MemberFilter.all, 'All Members ($officialCount)', Icons.people_alt_rounded, AppColors.primary),
                      _buildMemberFilterMenuItem(_MemberFilter.pending, 'Pending Requests ($pendingCount)', Icons.how_to_reg_rounded, const Color(0xFFD97706)),
                      _buildMemberFilterMenuItem(_MemberFilter.active, 'Active Members ($activeCount)', Icons.check_circle_rounded, const Color(0xFF16A34A)),
                      _buildMemberFilterMenuItem(_MemberFilter.lifetime, 'Lifetime Members', Icons.workspace_premium_rounded, const Color(0xFF81161B)),
                    ],
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: _filter == _MemberFilter.pending ? const Color(0xFFFFF3DC) : Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: _filter == _MemberFilter.pending ? const Color(0xFFD97706) : AppColors.border,
                          width: _filter == _MemberFilter.pending ? 1.5 : 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.filter_list_rounded,
                            size: 18,
                            color: _filter == _MemberFilter.pending ? const Color(0xFFD97706) : AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _memberFilterLabel(_filter, pendingCount),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _filter == _MemberFilter.pending ? const Color(0xFFD97706) : AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 16,
                            color: _filter == _MemberFilter.pending ? const Color(0xFFD97706) : AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Members Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: _filter == _MemberFilter.pending ? 'Pending Applications ' : 'Members ',
                      style: const TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4A1215),
                      ),
                      children: [
                        TextSpan(
                          text: '(${filtered.length})',
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
                    onTap: () => _showExportModal(context, filtered, membersList),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Row(
                        children: const [
                          Icon(Icons.download_rounded, size: 16, color: Color(0xFF81161B)),
                          SizedBox(width: 4),
                          Text('Export List', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF81161B))),
                        ],
                      ),
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
                  for (final member in paginatedMembers) ...[
                    _MemberCard(
                      member: member,
                      onTap: () => _showMemberDetailsDrawer(context, member),
                      onApprove: () {
                        ref.read(membersNotifierProvider.notifier).approveMember(member.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('🎉 Approved member "${member.name}"! Status updated to ACTIVE.'),
                            backgroundColor: const Color(0xFF16A34A),
                          ),
                        );
                      },
                      onReject: () {
                        ref.read(membersNotifierProvider.notifier).rejectMember(member.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Application rejected for "${member.name}".'),
                            backgroundColor: const Color(0xFFDC2626),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (paginatedMembers.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(30),
                      alignment: Alignment.center,
                      child: Text(
                        _filter == _MemberFilter.pending
                            ? 'No pending membership applications at this time.'
                            : 'No members found matching your search',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                ],
              ),
            ),
            // Dynamic Interactive Pagination Footer
            if (totalItems > 0) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFF1E3DF)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Showing ${totalItems == 0 ? 0 : startIndex + 1}-$endIndex of $totalItems',
                        style: TextStyle(fontSize: 11.5, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: currentPage > 1 ? () => setState(() => _currentPage--) : null,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: currentPage > 1 ? const Color(0xFFF5EBE8) : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.chevron_left_rounded,
                                size: 18,
                                color: currentPage > 1 ? const Color(0xFF500913) : Colors.grey.shade400,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          for (int p = 1; p <= totalPages; p++) ...[
                            InkWell(
                              onTap: () => setState(() => _currentPage = p),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: currentPage == p ? const Color(0xFF500913) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '$p',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: currentPage == p ? FontWeight.w800 : FontWeight.w600,
                                    color: currentPage == p ? Colors.white : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ),
                            if (p != totalPages) const SizedBox(width: 4),
                          ],
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: currentPage < totalPages ? () => setState(() => _currentPage++) : null,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: currentPage < totalPages ? const Color(0xFFF5EBE8) : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.chevron_right_rounded,
                                size: 18,
                                color: currentPage < totalPages ? const Color(0xFF500913) : Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  String _memberFilterLabel(_MemberFilter f, int pendingCount) {
    switch (f) {
      case _MemberFilter.all:
        return 'All';
      case _MemberFilter.pending:
        return 'Pending ($pendingCount)';
      case _MemberFilter.active:
        return 'Active';
      case _MemberFilter.inactive:
        return 'Inactive';
      case _MemberFilter.lifetime:
        return 'Lifetime';
    }
  }

  PopupMenuItem<_MemberFilter> _buildMemberFilterMenuItem(_MemberFilter val, String label, IconData icon, Color color) {
    final isSelected = _filter == val;
    return PopupMenuItem<_MemberFilter>(
      value: val,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? const Color(0xFF500913) : AppColors.textPrimary,
              ),
            ),
          ),
          if (isSelected) const Icon(Icons.check_rounded, size: 16, color: Color(0xFF500913)),
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

  void _showExportModal(BuildContext context, List<MemberItem> filteredMembers, List<MemberItem> allMembers) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            String selectedFormat = 'CSV';
            bool exportFilteredOnly = true;

            final targetList = exportFilteredOnly ? filteredMembers : allMembers;

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF500913).withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.file_download_rounded, color: Color(0xFF500913), size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Export Members Directory',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                            ),
                            Text(
                              'Download official list format or copy data',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(modalContext),
                        icon: const Icon(Icons.close_rounded, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  const Text('Export Format', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _formatOptionChip(
                        label: 'CSV File',
                        icon: Icons.table_chart_rounded,
                        isSelected: selectedFormat == 'CSV',
                        onTap: () => setModalState(() => selectedFormat = 'CSV'),
                      ),
                      const SizedBox(width: 8),
                      _formatOptionChip(
                        label: 'PDF Doc',
                        icon: Icons.picture_as_pdf_rounded,
                        isSelected: selectedFormat == 'PDF',
                        onTap: () => setModalState(() => selectedFormat = 'PDF'),
                      ),
                      const SizedBox(width: 8),
                      _formatOptionChip(
                        label: 'Clipboard',
                        icon: Icons.copy_rounded,
                        isSelected: selectedFormat == 'COPY',
                        onTap: () => setModalState(() => selectedFormat = 'COPY'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Text('List Scope', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setModalState(() => exportFilteredOnly = true),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              color: exportFilteredOnly ? const Color(0xFF500913).withValues(alpha: 0.08) : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: exportFilteredOnly ? const Color(0xFF500913) : Colors.grey.shade300,
                                width: exportFilteredOnly ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  exportFilteredOnly ? Icons.radio_button_checked : Icons.radio_button_off,
                                  size: 16,
                                  color: exportFilteredOnly ? const Color(0xFF500913) : Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Filtered (${filteredMembers.length})',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: exportFilteredOnly ? FontWeight.w700 : FontWeight.w500,
                                      color: exportFilteredOnly ? const Color(0xFF500913) : AppColors.textPrimary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () => setModalState(() => exportFilteredOnly = false),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              color: !exportFilteredOnly ? const Color(0xFF500913).withValues(alpha: 0.08) : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: !exportFilteredOnly ? const Color(0xFF500913) : Colors.grey.shade300,
                                width: !exportFilteredOnly ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  !exportFilteredOnly ? Icons.radio_button_checked : Icons.radio_button_off,
                                  size: 16,
                                  color: !exportFilteredOnly ? const Color(0xFF500913) : Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'All Records (${allMembers.length})',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: !exportFilteredOnly ? FontWeight.w700 : FontWeight.w500,
                                      color: !exportFilteredOnly ? const Color(0xFF500913) : AppColors.textPrimary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Live Table Preview (${targetList.length} Items)',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: const [
                            Icon(Icons.check_circle_outline, size: 12, color: Color(0xFF16A34A)),
                            SizedBox(width: 3),
                            Text('Ready', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF16A34A))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF500913).withValues(alpha: 0.05),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                          ),
                          child: Row(
                            children: const [
                              Expanded(flex: 3, child: Text('NAME / ID', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF500913)))),
                              Expanded(flex: 3, child: Text('TYPE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF500913)))),
                              Expanded(flex: 3, child: Text('PHONE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF500913)))),
                              Expanded(flex: 2, child: Text('STATUS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF500913)), textAlign: TextAlign.right)),
                            ],
                          ),
                        ),
                        for (int i = 0; i < targetList.take(4).length; i++) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: i % 2 == 0 ? Colors.white : Colors.grey.shade50,
                              border: Border(top: BorderSide(color: Colors.grey.shade200, width: 0.5)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(targetList[i].name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis),
                                      Text(targetList[i].id, style: TextStyle(fontSize: 9.5, color: Colors.grey.shade500)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(targetList[i].memberType, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(targetList[i].phone, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: targetList[i].status == 'ACTIVE'
                                            ? const Color(0xFFDCFCE7)
                                            : (targetList[i].status == 'PENDING' ? const Color(0xFFFEF3C7) : Colors.grey.shade200),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        targetList[i].status,
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          color: targetList[i].status == 'ACTIVE'
                                              ? const Color(0xFF16A34A)
                                              : (targetList[i].status == 'PENDING' ? const Color(0xFFD97706) : Colors.grey.shade700),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (targetList.length > 4)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(
                              '+ ${targetList.length - 4} more members included in export',
                              style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey.shade600),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(modalContext);
                        
                        final fileName = 'Nepal_Agrawal_Samaj_Members_${DateTime.now().millisecondsSinceEpoch}.$selectedFormat'.toLowerCase();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.verified_rounded, color: Colors.white, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Export Complete (${targetList.length} Members)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                      Text('Saved as $fileName', style: const TextStyle(fontSize: 11, color: Colors.white70)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: const Color(0xFF500913),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            duration: const Duration(seconds: 4),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF500913),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 2,
                      ),
                      icon: const Icon(Icons.file_download_rounded, size: 20),
                      label: Text(
                        'Download $selectedFormat Export (${targetList.length} Records)',
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _formatOptionChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF500913) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.grey.shade700),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : Colors.grey.shade800,
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
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: const Color(0xFFF1E3DF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 15, color: iconColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary, height: 1.0),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: TextStyle(fontSize: 10.5, color: Colors.grey.shade700, fontWeight: FontWeight.w600, height: 1.1),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
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
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const _MemberCard({
    required this.member,
    required this.onTap,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = member.status == 'PENDING';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isPending ? const Color(0xFFFED7AA) : const Color(0xFFF1E3DF),
            width: isPending ? 1.5 : 1.0,
          ),
          boxShadow: isPending
              ? [
                  BoxShadow(
                    color: const Color(0xFFEA580C).withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar Tile
                CircleAvatar(
                  radius: 26,
                  backgroundColor: member.avatarBg,
                  child: Text(
                    member.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: member.avatarColor),
                  ),
                ),
                const SizedBox(width: 14),
                // Details Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Status Badge Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              member.name,
                              style: const TextStyle(
                                fontFamily: 'PlayfairDisplay',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF4A1215),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                            decoration: BoxDecoration(
                              color: isPending ? const Color(0xFFFEF3C7) : const Color(0xFFEAF5EF),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              isPending ? 'Pending Approval' : member.status,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: isPending ? const Color(0xFFD97706) : const Color(0xFF3E7C4A),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${member.memberType} • ${member.location} Chapter',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF81161B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Contact Row
                      Row(
                        children: [
                          Icon(Icons.phone_rounded, size: 12, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(member.phone, style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
                          if (!isPending) ...[
                            const SizedBox(width: 10),
                            Icon(Icons.email_rounded, size: 12, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                member.email,
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isPending) ...[
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFFED7AA)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onApprove,
                      icon: const Icon(Icons.check_circle_rounded, size: 16),
                      label: const Text('Approve Member', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onReject,
                      icon: const Icon(Icons.cancel_rounded, size: 16),
                      label: const Text('Reject', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFDC2626),
                        side: const BorderSide(color: Color(0xFFFCA5A5)),
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}


