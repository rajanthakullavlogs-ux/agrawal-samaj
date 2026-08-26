import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/services/branch_data_store.dart';
import '../../../../shared/widgets/nas_logo.dart';

class SuperAdminDashboardScreen extends StatefulWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  State<SuperAdminDashboardScreen> createState() => _SuperAdminDashboardScreenState();
}

class _SuperAdminDashboardScreenState extends State<SuperAdminDashboardScreen> {
  DateTimeRange? _selectedDateRange;
  String _selectedRangeLabel = 'All Time';

  // Dynamic metrics based on selected date range
  Map<String, String> get _currentMetrics {
    final store = BranchDataStore.instance;
    final totalM = store.totalMembers;
    final formattedM = totalM >= 1000 ? '${(totalM / 1000).toStringAsFixed(1)}K' : '$totalM';

    switch (_selectedRangeLabel) {
      case 'This Month':
        return {
          'branches': '${store.totalBranches}',
          'admins': '${store.totalBranches * 2}',
          'members': '1.2K',
          'events': '18',
        };
      case 'Last 30 Days':
        return {
          'branches': '${store.totalBranches}',
          'admins': '${store.totalBranches * 2}',
          'members': '1.8K',
          'events': '24',
        };
      case 'Last 3 Months':
        return {
          'branches': '${store.totalBranches}',
          'admins': '${store.totalBranches * 2}',
          'members': '4.5K',
          'events': '52',
        };
      case 'Year 2026':
        return {
          'branches': '${store.totalBranches}',
          'admins': '${store.totalBranches * 2}',
          'members': formattedM,
          'events': '${store.totalEvents}',
        };
      default:
        if (_selectedDateRange != null) {
          final days = _selectedDateRange!.duration.inDays + 1;
          final estimatedMembers = (days * 45).clamp(50, totalM);
          final estimatedEvents = (days * 1.2).clamp(1, store.totalEvents).toInt();
          return {
            'branches': '${store.totalBranches}',
            'admins': '${store.totalBranches * 2}',
            'members': estimatedMembers > 999
                ? '${(estimatedMembers / 1000).toStringAsFixed(1)}K'
                : '$estimatedMembers',
            'events': '$estimatedEvents',
          };
        }
        return {
          'branches': '${store.totalBranches}',
          'admins': '${store.totalBranches * 2}',
          'members': formattedM,
          'events': '${store.totalEvents}',
        };
    }
  }

  void _showDateRangeModalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final isRangeActive = _selectedDateRange != null || _selectedRangeLabel != 'All Time';

          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFAFAFA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  // Drag Handle Bar
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
                  const SizedBox(height: 14),

                  // Premium Burgundy Header Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF500913), Color(0xFF700D15)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF500913).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE5C8A6).withValues(alpha: 0.5), width: 1.2),
                          ),
                          child: const Icon(Icons.date_range_rounded, color: Color(0xFFE5C8A6), size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Filter Dashboard Data',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isRangeActive
                                    ? 'Active: $_selectedRangeLabel'
                                    : 'Select quick preset or pick custom date range',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isRangeActive ? FontWeight.w700 : FontWeight.w400,
                                  color: isRangeActive ? const Color(0xFFE5C8A6) : Colors.white70,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (isRangeActive)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDateRange = null;
                                _selectedRangeLabel = 'All Time';
                              });
                              Navigator.pop(ctx);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.white30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.refresh_rounded, color: Colors.white, size: 13),
                                  SizedBox(width: 4),
                                  Text(
                                    'Reset',
                                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          // Presets Heading
                          Row(
                            children: const [
                              Icon(Icons.bolt_rounded, size: 16, color: Color(0xFF500913)),
                              SizedBox(width: 6),
                              Text(
                                'QUICK RANGE PRESETS',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF500913),
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Presets Grid
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 2.6,
                            children: [
                              _buildPresetCard(
                                title: 'All Time',
                                subtitle: 'Cumulative summary',
                                icon: Icons.all_inclusive_rounded,
                                isSelected: _selectedRangeLabel == 'All Time',
                                onTap: () {
                                  setState(() {
                                    _selectedDateRange = null;
                                    _selectedRangeLabel = 'All Time';
                                  });
                                  Navigator.pop(ctx);
                                },
                              ),
                              _buildPresetCard(
                                title: 'This Month',
                                subtitle: 'Current month metrics',
                                icon: Icons.calendar_today_rounded,
                                isSelected: _selectedRangeLabel == 'This Month',
                                onTap: () {
                                  final now = DateTime.now();
                                  final start = DateTime(now.year, now.month, 1);
                                  final end = DateTime(now.year, now.month + 1, 0);
                                  setState(() {
                                    _selectedDateRange = DateTimeRange(start: start, end: end);
                                    _selectedRangeLabel = 'This Month';
                                  });
                                  Navigator.pop(ctx);
                                },
                              ),
                              _buildPresetCard(
                                title: 'Last 30 Days',
                                subtitle: 'Past 30 days activity',
                                icon: Icons.date_range_outlined,
                                isSelected: _selectedRangeLabel == 'Last 30 Days',
                                onTap: () {
                                  final now = DateTime.now();
                                  final start = now.subtract(const Duration(days: 30));
                                  setState(() {
                                    _selectedDateRange = DateTimeRange(start: start, end: now);
                                    _selectedRangeLabel = 'Last 30 Days';
                                  });
                                  Navigator.pop(ctx);
                                },
                              ),
                              _buildPresetCard(
                                title: 'Last 3 Months',
                                subtitle: 'Quarterly analytics',
                                icon: Icons.update_rounded,
                                isSelected: _selectedRangeLabel == 'Last 3 Months',
                                onTap: () {
                                  final now = DateTime.now();
                                  final start = now.subtract(const Duration(days: 90));
                                  setState(() {
                                    _selectedDateRange = DateTimeRange(start: start, end: now);
                                    _selectedRangeLabel = 'Last 3 Months';
                                  });
                                  Navigator.pop(ctx);
                                },
                              ),
                              _buildPresetCard(
                                title: 'Year 2026',
                                subtitle: 'Full 2026 calendar',
                                icon: Icons.event_available_rounded,
                                isSelected: _selectedRangeLabel == 'Year 2026',
                                onTap: () {
                                  setState(() {
                                    _selectedDateRange = DateTimeRange(
                                      start: DateTime(2026, 1, 1),
                                      end: DateTime(2026, 12, 31),
                                    );
                                    _selectedRangeLabel = 'Year 2026';
                                  });
                                  Navigator.pop(ctx);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // Custom Date Range Section
                          Row(
                            children: const [
                              Icon(Icons.edit_calendar_rounded, size: 16, color: Color(0xFF500913)),
                              SizedBox(width: 6),
                              Text(
                                'CUSTOM DATE RANGE',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF500913),
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Clean Individual From / To Pickers (No Automatic Pre-selection)
                          Row(
                            children: [
                              // Start Date Box
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: _selectedDateRange?.start ?? DateTime.now(),
                                      firstDate: DateTime(2024, 1, 1),
                                      lastDate: DateTime(2030, 12, 31),
                                      builder: (context, child) => Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: Color(0xFF500913),
                                            onPrimary: Colors.white,
                                            surface: Colors.white,
                                            onSurface: Color(0xFF1E1615),
                                          ),
                                        ),
                                        child: child!,
                                      ),
                                    );
                                    if (picked != null) {
                                      setModalState(() {
                                        final end = _selectedDateRange?.end ?? picked.add(const Duration(days: 30));
                                        final finalEnd = end.isBefore(picked) ? picked : end;
                                        _selectedDateRange = DateTimeRange(start: picked, end: finalEnd);
                                        final shortStart = DateFormat('MMM d').format(picked);
                                        final shortEnd = DateFormat('MMM d, yyyy').format(finalEnd);
                                        _selectedRangeLabel = '$shortStart – $shortEnd';
                                      });
                                      setState(() {});
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(14),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: _selectedDateRange != null ? const Color(0xFF500913) : const Color(0xFFE2D6D3),
                                        width: _selectedDateRange != null ? 1.5 : 1.0,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'FROM DATE',
                                          style: TextStyle(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF8C7A75),
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          _selectedDateRange != null
                                              ? DateFormat('MMM d, yyyy').format(_selectedDateRange!.start)
                                              : 'Select Start Date',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w800,
                                            color: _selectedDateRange != null ? const Color(0xFF500913) : Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Icon(Icons.arrow_forward_rounded, size: 16, color: Color(0xFF500913)),
                              ),
                              // End Date Box
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: _selectedDateRange?.end ?? DateTime.now(),
                                      firstDate: DateTime(2024, 1, 1),
                                      lastDate: DateTime(2030, 12, 31),
                                      builder: (context, child) => Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: Color(0xFF500913),
                                            onPrimary: Colors.white,
                                            surface: Colors.white,
                                            onSurface: Color(0xFF1E1615),
                                          ),
                                        ),
                                        child: child!,
                                      ),
                                    );
                                    if (picked != null) {
                                      setModalState(() {
                                        final start = _selectedDateRange?.start ?? picked.subtract(const Duration(days: 30));
                                        final finalStart = start.isAfter(picked) ? picked : start;
                                        _selectedDateRange = DateTimeRange(start: finalStart, end: picked);
                                        final shortStart = DateFormat('MMM d').format(finalStart);
                                        final shortEnd = DateFormat('MMM d, yyyy').format(picked);
                                        _selectedRangeLabel = '$shortStart – $shortEnd';
                                      });
                                      setState(() {});
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(14),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: _selectedDateRange != null ? const Color(0xFF500913) : const Color(0xFFE2D6D3),
                                        width: _selectedDateRange != null ? 1.5 : 1.0,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'TO DATE',
                                          style: TextStyle(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF8C7A75),
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          _selectedDateRange != null
                                              ? DateFormat('MMM d, yyyy').format(_selectedDateRange!.end)
                                              : 'Select End Date',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w800,
                                            color: _selectedDateRange != null ? const Color(0xFF500913) : Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Done Button
                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(ctx),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF500913),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              child: const Text(
                                'Apply Date Filter',
                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                              ),
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
        },
      ),
    );
  }

  Widget _buildPresetCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF500913) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF500913) : const Color(0xFFE2D6D3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? const Color(0xFFE5C8A6) : const Color(0xFF500913),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white70 : AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _currentMetrics;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F9),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 30),
          children: [
            const _SuperAdminTopBar(),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _HeroBanner(),
            ),
            const SizedBox(height: 16),

            // Interactive Date Range Selector Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () => _showDateRangeModalSheet(context),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _selectedRangeLabel != 'All Time'
                          ? const Color(0xFF500913)
                          : Colors.grey.shade200,
                      width: _selectedRangeLabel != 'All Time' ? 1.5 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF500913).withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.calendar_month_rounded, color: Color(0xFF500913), size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'FILTER BY DATE RANGE',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF8C7A75),
                                letterSpacing: 0.4,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _selectedDateRange != null
                                  ? '${DateFormat('MMM d').format(_selectedDateRange!.start)} – ${DateFormat('MMM d, yyyy').format(_selectedDateRange!.end)}'
                                  : _selectedRangeLabel,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: Color(0xFF500913),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF500913), size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Dynamic Metrics Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _MetricsRow(metrics: metrics),
            ),
            const SizedBox(height: 24),

            const _QuickActionsSection(),
            const SizedBox(height: 24),
            const _TopPerformingSection(),
            const SizedBox(height: 24),
            const _RecentActivitiesSection(),
          ],
        ),
      ),
      bottomNavigationBar: const _SuperAdminBottomNavBar(activeIndex: 0),
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
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          const NasLogo(size: 46),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nepal Agrawal Samaj',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Super Admin Panel',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
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
                  'Welcome, Super Admin!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Oversee and empower every branch, strengthen our community.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.3,
                    fontWeight: FontWeight.w500,
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
              Icons.dashboard_rounded,
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
  final Map<String, String> metrics;
  const _MetricsRow({required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _MetricItem(icon: Icons.account_balance_rounded, number: metrics['branches'] ?? '24', title: 'Total Branches')),
            const SizedBox(width: 12),
            Expanded(child: _MetricItem(icon: Icons.people_alt_rounded, number: metrics['admins'] ?? '48', title: 'Branch Admins')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _MetricItem(icon: Icons.group_rounded, number: metrics['members'] ?? '12.4K', title: 'Total Members')),
            const SizedBox(width: 12),
            Expanded(child: _MetricItem(icon: Icons.event_available_rounded, number: metrics['events'] ?? '156', title: 'Events Organized')),
          ],
        ),
      ],
    );
  }
}

class _MetricItem extends StatelessWidget {
  final IconData icon;
  final String number;
  final String title;

  const _MetricItem({required this.icon, required this.number, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(height: 12),
          Text(number, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
          const SizedBox(height: 2),
          Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// QUICK ACTIONS
// ---------------------------------------------------------------------------
class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF500913),
              letterSpacing: -0.2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: _QuickActionItem(
                  icon: Icons.account_balance_rounded,
                  label: 'Manage\nBranches',
                  onTap: () => context.go(AppConstants.superAdminLocations),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickActionItem(
                  icon: Icons.assessment_rounded,
                  label: 'View\nReports',
                  onTap: () => context.go(AppConstants.superAdminAnalytics),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickActionItem(
                  icon: Icons.person_rounded,
                  label: 'Manage\nAdmins',
                  onTap: () => context.go(AppConstants.superAdminSettings),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickActionItem(
                  icon: Icons.campaign_rounded,
                  label: 'Broadcast\nNotice',
                  onTap: () => _showBroadcastModal(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2D6D3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF500913).withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF500913), size: 22),
              ),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF500913),
                    height: 1.25,
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
// TOP PERFORMING BRANCHES (CHART)
// ---------------------------------------------------------------------------
class _TopPerformingSection extends StatefulWidget {
  const _TopPerformingSection();

  @override
  State<_TopPerformingSection> createState() => _TopPerformingSectionState();
}

class _TopPerformingSectionState extends State<_TopPerformingSection> {
  String _selectedMetric = 'By Events';

  final List<String> _metricsList = [
    'By Events',
    'By Members',
    'By Activity Rate',
    'By Growth Rate',
  ];

  Map<String, dynamic> get _currentData {
    final allBranches = BranchDataStore.instance.branches;
    switch (_selectedMetric) {
      case 'By Members':
        final sorted = List<BranchMetrics>.from(allBranches)
          ..sort((a, b) => b.memberCount.compareTo(a.memberCount));
        final maxVal = sorted.isNotEmpty ? sorted.first.memberCount.toDouble() : 3000.0;
        return {
          'max': maxVal > 0 ? maxVal : 3000.0,
          'yFormat': (double v) => '${(v / 1000).toStringAsFixed(1)}K',
          'bars': sorted.map((b) {
            final formatted = b.memberCount >= 1000
                ? '${(b.memberCount / 1000).toStringAsFixed(1)}K'
                : '${b.memberCount}';
            return {
              'label': b.name,
              'value': b.memberCount.toDouble(),
              'display': formatted,
            };
          }).toList(),
        };
      case 'By Activity Rate':
        final sorted = List<BranchMetrics>.from(allBranches)
          ..sort((a, b) => b.activityRate.compareTo(a.activityRate));
        return {
          'max': 100.0,
          'yFormat': (double v) => '${v.toInt()}%',
          'bars': sorted.map((b) {
            return {
              'label': b.name,
              'value': b.activityRate,
              'display': '${b.activityRate.toInt()}%',
            };
          }).toList(),
        };
      case 'By Growth Rate':
        final sorted = List<BranchMetrics>.from(allBranches)
          ..sort((a, b) => b.growthRate.compareTo(a.growthRate));
        return {
          'max': 50.0,
          'yFormat': (double v) => '${v.toInt()}%',
          'bars': sorted.map((b) {
            return {
              'label': b.name,
              'value': b.growthRate,
              'display': '+${b.growthRate.toInt()}%',
            };
          }).toList(),
        };
      case 'By Events':
      default:
        final sorted = List<BranchMetrics>.from(allBranches)
          ..sort((a, b) => b.eventCount.compareTo(a.eventCount));
        final maxVal = sorted.isNotEmpty ? sorted.first.eventCount.toDouble() : 40.0;
        return {
          'max': maxVal > 0 ? maxVal : 40.0,
          'yFormat': (double v) => '${v.toInt()}',
          'bars': sorted.map((b) {
            return {
              'label': b.name,
              'value': b.eventCount.toDouble(),
              'display': '${b.eventCount}',
            };
          }).toList(),
        };
    }
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.leaderboard_rounded, color: Color(0xFF500913)),
                SizedBox(width: 8),
                Text(
                  'Filter Top Branches By',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF500913)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ..._metricsList.map((metric) {
              final isSel = metric == _selectedMetric;
              return InkWell(
                onTap: () {
                  setState(() => _selectedMetric = metric);
                  Navigator.pop(ctx);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSel ? const Color(0xFF500913).withValues(alpha: 0.08) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSel ? const Color(0xFF500913) : Colors.grey.shade200,
                      width: isSel ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        metric,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                          color: isSel ? const Color(0xFF500913) : Colors.black87,
                        ),
                      ),
                      if (isSel)
                        const Icon(Icons.check_circle_rounded, color: Color(0xFF500913), size: 18),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _currentData;
    final maxVal = data['max'] as double;
    final yFormat = data['yFormat'] as String Function(double);
    final bars = data['bars'] as List<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: const Text(
                  'Top Performing Branches',
                  style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: Color(0xFF500913)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _showFilterModal(context),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF500913).withValues(alpha: 0.06),
                    border: Border.all(color: const Color(0xFF500913).withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _selectedMetric,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF500913), fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: Color(0xFF500913)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2D6D3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: bars.map((b) {
                return _HorizontalBarRow(
                  label: b['label'] as String,
                  value: b['value'] as double,
                  max: maxVal,
                  display: b['display'] as String,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _HorizontalBarRow extends StatelessWidget {
  final String label;
  final double value;
  final double max;
  final String display;

  const _HorizontalBarRow({
    required this.label,
    required this.value,
    required this.max,
    required this.display,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.replaceAll('\n', ' '),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E1615),
                ),
              ),
              Text(
                display,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF500913),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              final barWidth = ((value / max) * totalWidth).clamp(20.0, totalWidth);
              return Stack(
                children: [
                  Container(
                    height: 10,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF500913).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    height: 10,
                    width: barWidth,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF700D15), Color(0xFF500913)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF500913).withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// RECENT ACTIVITIES
// ---------------------------------------------------------------------------
class _RecentActivitiesSection extends StatelessWidget {
  const _RecentActivitiesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Activities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF500913))),
              InkWell(
                onTap: () => _showAllActivitiesModal(context),
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    children: const [
                      Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF500913))),
                      SizedBox(width: 3),
                      Icon(Icons.arrow_forward_ios_rounded, size: 11, color: Color(0xFF500913)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: const [
              _ActivityItem(
                icon: Icons.event_available_rounded,
                title: 'New event "Women Leadership Workshop"',
                subtitle: 'by Kathmandu Branch',
                time: '2h ago',
              ),
              SizedBox(height: 12),
              _ActivityItem(
                icon: Icons.group_add_rounded,
                title: '25 new members joined',
                subtitle: 'from Pokhara Branch',
                time: '5h ago',
              ),
              SizedBox(height: 12),
              _ActivityItem(
                icon: Icons.photo_library_rounded,
                title: 'Pokhara Branch added 36 new photos',
                subtitle: 'to album "Teej Festival 2025"',
                time: '1d ago',
              ),
              SizedBox(height: 12),
              _ActivityItem(
                icon: Icons.campaign_rounded,
                title: 'Notice broadcasted by Biratnagar Branch',
                subtitle: 'on "Blood Donation Camp"',
                time: '2d ago',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void _showAllActivitiesModal(BuildContext context) {
  final List<Map<String, dynamic>> allActivities = [
    {
      'icon': Icons.event_available_rounded,
      'title': 'New event "Women Leadership Workshop"',
      'branch': 'Kathmandu Branch',
      'time': '2 hours ago',
      'category': 'Event',
    },
    {
      'icon': Icons.group_add_rounded,
      'title': '25 new members joined Samaj',
      'branch': 'Pokhara Branch',
      'time': '5 hours ago',
      'category': 'Membership',
    },
    {
      'icon': Icons.photo_library_rounded,
      'title': 'Added 36 new photos to album "Teej Festival 2025"',
      'branch': 'Pokhara Branch',
      'time': '1 day ago',
      'category': 'Gallery',
    },
    {
      'icon': Icons.campaign_rounded,
      'title': 'Notice broadcasted on "Blood Donation Camp"',
      'branch': 'Biratnagar Branch',
      'time': '2 days ago',
      'category': 'Notice',
    },
    {
      'icon': Icons.account_balance_rounded,
      'title': 'Branch settings and executive team updated',
      'branch': 'Butwal Branch',
      'time': '3 days ago',
      'category': 'Admin',
    },
    {
      'icon': Icons.event_available_rounded,
      'title': 'Organized "Youth Business Mentorship Summit"',
      'branch': 'Chitwan Branch',
      'time': '4 days ago',
      'category': 'Event',
    },
    {
      'icon': Icons.handshake_rounded,
      'title': 'Community health screening camp organized',
      'branch': 'Dharan Branch',
      'time': '5 days ago',
      'category': 'Social',
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

          // Header Row with Title on Left and BACK / CLOSE Button in TOP RIGHT CORNER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF500913).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.history_rounded, color: Color(0xFF500913), size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All Recent Activities',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF500913)),
                      ),
                      Text(
                        'Complete community updates across all branches',
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
                    child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF500913), size: 20),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 20),

          // Activities List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: allActivities.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final act = allActivities[index];
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
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF500913).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(act['icon'] as IconData, color: const Color(0xFF500913), size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              act['title'] as String,
                              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF1E1615)),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Text(
                                  act['branch'] as String,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF500913)),
                                ),
                                const SizedBox(width: 6),
                                const Text('•', style: TextStyle(color: Colors.grey, fontSize: 10)),
                                const SizedBox(width: 6),
                                Text(
                                  act['time'] as String,
                                  style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
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

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityItem({required this.icon, required this.title, required this.subtitle, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(time, style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// BOTTOM NAV BAR
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

void _showBroadcastModal(BuildContext context) {
  final messageController = TextEditingController();
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: const [
          Icon(Icons.campaign_rounded, color: AppColors.primary),
          SizedBox(width: 8),
          Text('Broadcast Notice', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: messageController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Type announcement message to broadcast to all branches...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Notice broadcasted successfully to all branches!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                    child: const Text('Send'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
