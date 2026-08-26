import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/nas_logo.dart';

class LocationsManagementScreen extends StatelessWidget {
  const LocationsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: const [
            _SuperAdminTopBar(),
            SizedBox(height: 14),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _HeroBanner(),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _OverviewSection(),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _BranchesUpdateOverview(),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _BranchActivitySummary(),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _BranchesNeedingAttention(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _SuperAdminBottomNavBar(activeIndex: 2),
    );
  }
}

// ---------------------------------------------------------------------------
// TOP BAR
// ---------------------------------------------------------------------------
class _SuperAdminTopBar extends StatelessWidget {
  const _SuperAdminTopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const NasLogo(size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Nepal Agrawal Samaj',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Locations Management',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w600),
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
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Locations Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Monitor and oversee all branches across Nepal.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
            ),
            child: const Icon(
              Icons.location_city_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// OVERVIEW SECTION
// ---------------------------------------------------------------------------
class _OverviewSection extends StatelessWidget {
  const _OverviewSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary),
        ),
        const SizedBox(height: 12),
        Row(
          children: const [
            Expanded(
              child: _OverviewCard(
                icon: Icons.account_balance_rounded,
                value: '24',
                label: 'Total Branches',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _OverviewCard(
                icon: Icons.location_on_rounded,
                value: '77',
                label: 'Districts Covered',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _OverviewCard(
                icon: Icons.map_rounded,
                value: '7',
                label: 'Provinces Covered',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _OverviewCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2D6D3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF500913).withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// BRANCHES UPDATE OVERVIEW
// ---------------------------------------------------------------------------
class _BranchesUpdateOverview extends StatelessWidget {
  const _BranchesUpdateOverview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Branches Update Overview', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 36,
                          sections: [
                            PieChartSectionData(color: AppColors.primary, value: 42, title: '', radius: 24),
                            PieChartSectionData(color: AppColors.primary.withValues(alpha: 0.5), value: 33, title: '', radius: 24),
                            PieChartSectionData(color: AppColors.primary.withValues(alpha: 0.2), value: 25, title: '', radius: 24),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('24', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
                          Text('Total Branches', style: TextStyle(fontSize: 8, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 6,
                child: Column(
                  children: const [
                    _UpdateLegendItem(
                      color: AppColors.primary,
                      title: 'Updated This Month',
                      subtitle: '10 branches (42%)',
                      pillText: '↑ 42%',
                      pillColor: Color(0xFFE8F5E9),
                      pillTextColor: Color(0xFF2E7D32),
                    ),
                    SizedBox(height: 12),
                    _UpdateLegendItem(
                      color: Color(0xFFB37373), // approximate AppColors.primary with 0.5 opacity
                      title: 'No Update This Month',
                      subtitle: '8 branches (33%)',
                      pillText: '↓ 33%',
                      pillColor: Color(0xFFFFF3E0),
                      pillTextColor: Color(0xFFE65100),
                    ),
                    SizedBox(height: 12),
                    _UpdateLegendItem(
                      color: Color(0xFFE6D0D0), // approximate AppColors.primary with 0.2 opacity
                      title: 'Not Updated for 2+ Months',
                      subtitle: '6 branches (25%)',
                      pillText: '↑ 25%',
                      pillColor: Color(0xFFFFEBEE),
                      pillTextColor: Color(0xFFC62828),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UpdateLegendItem extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final String pillText;
  final Color pillColor;
  final Color pillTextColor;

  const _UpdateLegendItem({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.pillText,
    required this.pillColor,
    required this.pillTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 9, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: pillColor, borderRadius: BorderRadius.circular(100)),
          child: Text(pillText, style: TextStyle(fontSize: 9, color: pillTextColor, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// BRANCH ACTIVITY SUMMARY
// ---------------------------------------------------------------------------
class _BranchActivitySummary extends StatelessWidget {
  const _BranchActivitySummary();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Branch Activity Summary', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: const [
              Expanded(child: _ActivityStat(icon: Icons.event_note_rounded, value: '156', label: 'Events Organized\n(This Month)')),
              _VerticalDivider(),
              Expanded(child: _ActivityStat(icon: Icons.photo_library_rounded, value: '2.4K', label: 'Photos Shared\n(This Month)')),
              _VerticalDivider(),
              Expanded(child: _ActivityStat(icon: Icons.campaign_rounded, value: '32', label: 'Notices Broadcast\n(This Month)')),
              _VerticalDivider(),
              Expanded(child: _ActivityStat(icon: Icons.person_add_alt_1_rounded, value: '325', label: 'New Members Added\n(This Month)')),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActivityStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _ActivityStat({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), shape: BoxShape.circle),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(height: 12),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
        const SizedBox(height: 4),
        Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 8, color: Colors.grey.shade700, fontWeight: FontWeight.w500, height: 1.3)),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 60,
      color: Colors.grey.shade200,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

// ---------------------------------------------------------------------------
// BRANCHES NEEDING ATTENTION
// ---------------------------------------------------------------------------
class _BranchesNeedingAttention extends StatelessWidget {
  const _BranchesNeedingAttention();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Branches Needing Attention', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
            InkWell(
              onTap: () => _showAllBranchesAttentionModal(context),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  children: const [
                    Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    SizedBox(width: 2),
                    Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.primary),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _AttentionTile(title: 'Dolakha Branch', subtitle: 'No update for 65 days', lastUpdated: 'Jun 22, 2026'),
        const _AttentionTile(title: 'Rukum Branch', subtitle: 'No update for 48 days', lastUpdated: 'Jul 09, 2026'),
        const _AttentionTile(title: 'Bajhang Branch', subtitle: 'No update for 40 days', lastUpdated: 'Jul 17, 2026'),
      ],
    );
  }
}

class _AttentionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String lastUpdated;

  const _AttentionTile({required this.title, required this.subtitle, required this.lastUpdated});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), shape: BoxShape.circle),
            child: const Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text('$subtitle • Last: $lastUpdated', style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(100)),
            child: const Text('No Update', style: TextStyle(fontSize: 9, color: Color(0xFFC62828), fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 16),
        ],
      ),
    );
  }
}

void _showAllBranchesAttentionModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const _AllBranchesAttentionSheet(),
  );
}

class _AllBranchesAttentionSheet extends StatefulWidget {
  const _AllBranchesAttentionSheet();

  @override
  State<_AllBranchesAttentionSheet> createState() => _AllBranchesAttentionSheetState();
}

class _AllBranchesAttentionSheetState extends State<_AllBranchesAttentionSheet> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _branchesStatusList = [
    {
      'name': 'Dolakha Branch',
      'province': 'Bagmati Province',
      'admin': 'Ramesh Agrawal',
      'phone': '+977 9851099887',
      'status': 'Outdated',
      'lastUpdated': 'Jun 22, 2026',
      'daysAgo': '65 days ago',
      'color': const Color(0xFFC62828),
      'bg': const Color(0xFFFFEBEE),
    },
    {
      'name': 'Rukum Branch',
      'province': 'Karnali Province',
      'admin': 'Sunil Agrawal',
      'phone': '+977 9858011223',
      'status': 'Outdated',
      'lastUpdated': 'Jul 09, 2026',
      'daysAgo': '48 days ago',
      'color': const Color(0xFFC62828),
      'bg': const Color(0xFFFFEBEE),
    },
    {
      'name': 'Bajhang Branch',
      'province': 'Sudurpashchim Province',
      'admin': 'Dipendra Agrawal',
      'phone': '+977 9857022334',
      'status': 'Needs Update',
      'lastUpdated': 'Jul 17, 2026',
      'daysAgo': '40 days ago',
      'color': const Color(0xFFE65100),
      'bg': const Color(0xFFFFF3E0),
    },
    {
      'name': 'Dharan Branch',
      'province': 'Koshi Province',
      'admin': 'Anil Agrawal',
      'phone': '+977 9852033445',
      'status': 'Needs Update',
      'lastUpdated': 'Jul 28, 2026',
      'daysAgo': '29 days ago',
      'color': const Color(0xFFE65100),
      'bg': const Color(0xFFFFF3E0),
    },
    {
      'name': 'Kathmandu Branch',
      'province': 'Bagmati Province',
      'admin': 'Rajesh Agrawal',
      'phone': '+977 9851000000',
      'status': 'Updated',
      'lastUpdated': 'Aug 25, 2026',
      'daysAgo': '1 day ago',
      'color': const Color(0xFF2E7D32),
      'bg': const Color(0xFFE8F5E9),
    },
    {
      'name': 'Pokhara Branch',
      'province': 'Gandaki Province',
      'admin': 'Bishal Agrawal',
      'phone': '+977 9856011111',
      'status': 'Updated',
      'lastUpdated': 'Aug 24, 2026',
      'daysAgo': '2 days ago',
      'color': const Color(0xFF2E7D32),
      'bg': const Color(0xFFE8F5E9),
    },
    {
      'name': 'Chitwan Branch',
      'province': 'Bagmati Province',
      'admin': 'Manish Agrawal',
      'phone': '+977 9855022222',
      'status': 'Updated',
      'lastUpdated': 'Aug 20, 2026',
      'daysAgo': '6 days ago',
      'color': const Color(0xFF2E7D32),
      'bg': const Color(0xFFE8F5E9),
    },
    {
      'name': 'Butwal Branch',
      'province': 'Lumbini Province',
      'admin': 'Suresh Agrawal',
      'phone': '+977 9857033333',
      'status': 'Updated',
      'lastUpdated': 'Aug 18, 2026',
      'daysAgo': '8 days ago',
      'color': const Color(0xFF2E7D32),
      'bg': const Color(0xFFE8F5E9),
    },
    {
      'name': 'Biratnagar Branch',
      'province': 'Koshi Province',
      'admin': 'Kamal Agrawal',
      'phone': '+977 9852044444',
      'status': 'Updated',
      'lastUpdated': 'Aug 15, 2026',
      'daysAgo': '11 days ago',
      'color': const Color(0xFF2E7D32),
      'bg': const Color(0xFFE8F5E9),
    },
    {
      'name': 'Nepalgunj Branch',
      'province': 'Lumbini Province',
      'admin': 'Prakash Agrawal',
      'phone': '+977 9858055555',
      'status': 'Updated',
      'lastUpdated': 'Aug 12, 2026',
      'daysAgo': '14 days ago',
      'color': const Color(0xFF2E7D32),
      'bg': const Color(0xFFE8F5E9),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _branchesStatusList.where((b) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Needs Attention') return b['status'] == 'Outdated' || b['status'] == 'Needs Update';
      return b['status'] == _selectedFilter;
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, -4)),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 40,
              height: 4.5,
              decoration: BoxDecoration(
                color: const Color(0xFFD6C7C2),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header Row with Title on Left and BACK Button in TOP RIGHT CORNER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.info_rounded, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Branch Update Status',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary),
                      ),
                      Text(
                        'Complete update logs and activity status',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                // BACK BUTTON IN TOP RIGHT CORNER
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_rounded, color: AppColors.primary, size: 20),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Filter Pills Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: ['All', 'Needs Attention', 'Updated', 'Outdated'].map((filter) {
                final isSel = filter == _selectedFilter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSel,
                    onSelected: (val) {
                      if (val) setState(() => _selectedFilter = filter);
                    },
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      fontSize: 11.5,
                      fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                      color: isSel ? Colors.white : AppColors.primary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSel ? AppColors.primary : Colors.grey.shade300,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 24),

          // Branch List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final b = filtered[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2D6D3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                b['name'] as String,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: b['bg'] as Color,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              b['status'] as String,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: b['color'] as Color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Province: ${b['province']} • Admin: ${b['admin']}',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.access_time_rounded, size: 14, color: AppColors.primary),
                                const SizedBox(width: 6),
                                const Text(
                                  'Last Updated: ',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                                Text(
                                  b['lastUpdated'] as String,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                            Text(
                              b['daysAgo'] as String,
                              style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SUPER ADMIN BOTTOM NAV
// ---------------------------------------------------------------------------
class _SuperAdminBottomNavBar extends StatelessWidget {
  final int activeIndex;
  const _SuperAdminBottomNavBar({required this.activeIndex});

  static const _items = [
    (icon: Icons.dashboard_rounded, label: 'Dashboard', route: AppConstants.superAdminDashboard),
    (icon: Icons.people_rounded, label: 'Members', route: AppConstants.superAdminAnalytics),
    (icon: Icons.location_city_rounded, label: 'Locations', route: AppConstants.superAdminLocations),
    (icon: Icons.event_note_rounded, label: 'Events', route: AppConstants.superAdminEvents),
    (icon: Icons.settings_rounded, label: 'Settings', route: AppConstants.superAdminSettings),
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
