import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/services/branch_data_store.dart';
import '../../../../shared/widgets/nas_logo.dart';

class MemberAnalyticsScreen extends StatelessWidget {
  const MemberAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: BranchDataStore.instance,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 20),
              children: [
                const _SuperAdminTopBar(),
                const SizedBox(height: 14),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _HeroBanner(),
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _MetricsRow(),
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _MembersByBranch(),
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _MemberDemographics(),
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _RecentMembers(),
                ),
              ],
            ),
          ),
          bottomNavigationBar: const _SuperAdminBottomNavBar(activeIndex: 1),
        );
      },
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
                  'Members Management',
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
                  'Members Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Manage and connect with members across all branches.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.85),
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
              Icons.groups_rounded,
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
// METRICS ROW
// ---------------------------------------------------------------------------
class _MetricsRow extends StatelessWidget {
  const _MetricsRow();

  @override
  Widget build(BuildContext context) {
    final total = BranchDataStore.instance.totalMembers;
    final formattedTotal = '${(total / 1000).toStringAsFixed(1)}K';

    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.groups_rounded,
            value: formattedTotal,
            label: 'Total Members',
            trend: '↑ 8% this month',
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: _MetricCard(
            icon: Icons.person_add_alt_1_rounded,
            value: '325',
            label: 'New Members',
            trend: '↑ 12% this month',
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final String trend;

  const _MetricCard({required this.icon, required this.value, required this.label, required this.trend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary)),
                const SizedBox(height: 2),
                Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade800, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                Text(trend, style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MEMBERS BY BRANCH
// ---------------------------------------------------------------------------
class _MembersByBranch extends StatelessWidget {
  const _MembersByBranch();

  @override
  Widget build(BuildContext context) {
    final branches = BranchDataStore.instance.branches;
    final maxVal = branches.fold(3000, (max, b) => b.memberCount > max ? b.memberCount : max);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Members by Branch', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 20),
          ...branches.map((b) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _BranchBar(
                name: b.name,
                value: b.memberCount,
                maxValue: maxVal,
              ),
            );
          }).toList(),
          const SizedBox(height: 8),
          
          // X-Axis labels
          Row(
            children: [
              const SizedBox(width: 110), // Match label width
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                    Text('1K', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                    Text('2K', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                    Text('${(maxVal / 1000).toInt()}K', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(width: 40), // Match trailing value width
            ],
          ),
        ],
      ),
    );
  }
}

class _BranchBar extends StatelessWidget {
  final String name;
  final int value;
  final int maxValue;

  const _BranchBar({required this.name, required this.value, required this.maxValue});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            name,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade800, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double percent = (value / maxValue).clamp(0.02, 1.0);
              return Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    height: 8,
                    width: constraints.maxWidth * percent,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 40,
          child: Text(
            value.toString(),
            style: TextStyle(fontSize: 11, color: Colors.grey.shade800, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// MEMBER DEMOGRAPHICS
// ---------------------------------------------------------------------------
class _MemberDemographics extends StatelessWidget {
  const _MemberDemographics();

  @override
  Widget build(BuildContext context) {
    final total = BranchDataStore.instance.totalMembers;
    final formattedTotal = '${(total / 1000).toStringAsFixed(1)}K';
    final maleCount = (total * 0.60).round();
    final femaleCount = (total * 0.38).round();
    final otherCount = total - maleCount - femaleCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Member Demographics',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gender Distribution
            Expanded(
              child: Container(
                height: 180,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Gender Distribution', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 110,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                PieChart(
                                  PieChartData(
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 28,
                                    sections: [
                                      PieChartSectionData(color: AppColors.primary, value: 60, title: '', radius: 12),
                                      PieChartSectionData(color: AppColors.primary.withValues(alpha: 0.6), value: 38, title: '', radius: 12),
                                      PieChartSectionData(color: AppColors.primary.withValues(alpha: 0.2), value: 2, title: '', radius: 12),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(formattedTotal, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                                    Text('Total', style: TextStyle(fontSize: 9, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _LegendItem(color: AppColors.primary, label: 'Male', val1: maleCount.toString(), val2: '60%'),
                                  const SizedBox(height: 6),
                                  _LegendItem(color: const Color(0xFFB37373), label: 'Female', val1: femaleCount.toString(), val2: '38%'),
                                  const SizedBox(height: 6),
                                  _LegendItem(color: const Color(0xFFE6D0D0), label: 'Others', val1: otherCount.toString(), val2: '2%'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Age Group
            Expanded(
              child: Container(
                height: 180,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Age Group', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    _AgeBar(label: '18 - 30', val1: (total * 0.23).round().toString(), val2: '(23%)', percent: 0.23),
                    _AgeBar(label: '31 - 45', val1: (total * 0.41).round().toString(), val2: '(41%)', percent: 0.41),
                    _AgeBar(label: '46 - 60', val1: (total * 0.28).round().toString(), val2: '(28%)', percent: 0.28),
                    _AgeBar(label: '60+', val1: (total * 0.08).round().toString(), val2: '(8%)', percent: 0.08),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String val1;
  final String val2;

  const _LegendItem({required this.color, required this.label, required this.val1, required this.val2});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text('$val1 ($val2)', style: TextStyle(fontSize: 9, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}

class _AgeBar extends StatelessWidget {
  final String label;
  final String val1;
  final String val2;
  final double percent;

  const _AgeBar({required this.label, required this.val1, required this.val2, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Text(label, style: TextStyle(fontSize: 9, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  Container(
                    height: 6,
                    width: constraints.maxWidth * (percent / 0.45), // Scale relative to max 41%
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 50,
          child: Text('$val1 $val2', style: TextStyle(fontSize: 8, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}


// ---------------------------------------------------------------------------
// RECENT MEMBERS
// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// RECENT MEMBERS
// ---------------------------------------------------------------------------
class _RecentMembers extends StatelessWidget {
  const _RecentMembers();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Members', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
            InkWell(
              onTap: () => _showAllRecentMembersModal(context),
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
        const _MemberTile(name: 'Aman Agrawal', email: 'aman.agrawal@email.com', branch: 'Kathmandu Branch', time: '2h ago'),
        const _MemberTile(name: 'Pooja Agrawal', email: 'pooja.agrawal@email.com', branch: 'Pokhara Branch', time: '5h ago'),
        const _MemberTile(name: 'Rohit Agrawal', email: 'rohit.agrawal@email.com', branch: 'Chitwan Branch', time: '1d ago'),
        const _MemberTile(name: 'Neha Agrawal', email: 'neha.agrawal@email.com', branch: 'Butwal Branch', time: '2d ago'),
      ],
    );
  }
}

void _showAllRecentMembersModal(BuildContext context) {
  final List<Map<String, String>> allRecentMembers = [
    {
      'name': 'Aman Agrawal',
      'email': 'aman.agrawal@email.com',
      'branch': 'Kathmandu Branch',
      'phone': '+977 9851011223',
      'time': '2 hours ago',
      'status': 'Verified',
    },
    {
      'name': 'Pooja Agrawal',
      'email': 'pooja.agrawal@email.com',
      'branch': 'Pokhara Branch',
      'phone': '+977 9856022334',
      'time': '5 hours ago',
      'status': 'Verified',
    },
    {
      'name': 'Rohit Agrawal',
      'email': 'rohit.agrawal@email.com',
      'branch': 'Chitwan Branch',
      'phone': '+977 9855033445',
      'time': '1 day ago',
      'status': 'Verified',
    },
    {
      'name': 'Neha Agrawal',
      'email': 'neha.agrawal@email.com',
      'branch': 'Butwal Branch',
      'phone': '+977 9857044556',
      'time': '2 days ago',
      'status': 'Pending Verification',
    },
    {
      'name': 'Sanjay Agrawal',
      'email': 'sanjay.agrawal@email.com',
      'branch': 'Biratnagar Branch',
      'phone': '+977 9852055667',
      'time': '3 days ago',
      'status': 'Verified',
    },
    {
      'name': 'Kavita Agrawal',
      'email': 'kavita.agrawal@email.com',
      'branch': 'Nepalgunj Branch',
      'phone': '+977 9858066778',
      'time': '4 days ago',
      'status': 'Verified',
    },
    {
      'name': 'Vikram Agrawal',
      'email': 'vikram.agrawal@email.com',
      'branch': 'Kathmandu Branch',
      'phone': '+977 9851077889',
      'time': '5 days ago',
      'status': 'Verified',
    },
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      height: MediaQuery.of(ctx).size.height * 0.85,
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
                  child: const Icon(Icons.people_alt_rounded, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Members Joined',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary),
                      ),
                      Text(
                        'Newly registered members across all branches',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                // BACK BUTTON IN TOP RIGHT CORNER
                GestureDetector(
                  onTap: () => Navigator.pop(ctx),
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
          const Divider(height: 20),

          // List of Recent Members
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: allRecentMembers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final m = allRecentMembers[index];
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
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  m['name']!,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: m['status'] == 'Verified'
                                        ? const Color(0xFF2E7D32).withValues(alpha: 0.1)
                                        : const Color(0xFFE65100).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    m['status']!,
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      color: m['status'] == 'Verified'
                                          ? const Color(0xFF2E7D32)
                                          : const Color(0xFFE65100),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              m['email']!,
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  m['branch']!,
                                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                                const SizedBox(width: 6),
                                const Text('•', style: TextStyle(color: Colors.grey, fontSize: 10)),
                                const SizedBox(width: 6),
                                Text(
                                  m['time']!,
                                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                                ),
                              ],
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
    ),
  );
}

class _MemberTile extends StatelessWidget {
  final String name;
  final String email;
  final String branch;
  final String time;

  const _MemberTile({required this.name, required this.email, required this.branch, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(email, style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(branch, style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(time, style: TextStyle(fontSize: 9, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
            ],
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
    (icon: Icons.location_on_rounded, label: 'Locations', route: AppConstants.superAdminLocations),
    (icon: Icons.calendar_today_rounded, label: 'Events', route: AppConstants.superAdminEvents),
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
