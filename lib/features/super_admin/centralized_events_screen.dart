import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/design_tokens.dart';
import '../../shared/widgets/nas_logo.dart';

class CentralizedEventsScreen extends StatelessWidget {
  const CentralizedEventsScreen({super.key});

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
              child: _TopEventsChart(),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _UpcomingEventsSection(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _SuperAdminBottomNavBar(activeIndex: 3),
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
                  'Super Admin Panel',
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
                  'Events Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Monitor and oversee all events organized across branches.',
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
              Icons.event_note_rounded,
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
// ---------------------------------------------------------------------------
// OVERVIEW SECTION
// ---------------------------------------------------------------------------
class _OverviewSection extends StatelessWidget {
  const _OverviewSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _OverviewCard(
            icon: Icons.event_note_rounded,
            value: '156',
            label: 'Total Events',
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _OverviewCard(
            icon: Icons.check_circle_rounded,
            value: '68',
            label: 'Upcoming Events',
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _OverviewCard(
            icon: Icons.groups_rounded,
            value: '32',
            label: 'Events Completed',
          ),
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
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2D6D3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF500913).withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
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
// TOP EVENTS CHART
// ---------------------------------------------------------------------------
class _TopEventsChart extends StatelessWidget {
  const _TopEventsChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2D6D3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Clean Managed Graph Heading (No View All)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Top Events by Branch',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary),
              ),
              const SizedBox(height: 2),
              Text(
                'Branch-wise event participation breakdown (This Month)',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _BranchBar(name: 'Kathmandu Branch', value: 56, maxValue: 60),
          const SizedBox(height: 16),
          const _BranchBar(name: 'Pokhara Branch', value: 48, maxValue: 60),
          const SizedBox(height: 16),
          const _BranchBar(name: 'Chitwan Branch', value: 41, maxValue: 60),
          const SizedBox(height: 16),
          const _BranchBar(name: 'Butwal Branch', value: 38, maxValue: 60),
          const SizedBox(height: 16),
          const _BranchBar(name: 'Biratnagar Branch', value: 34, maxValue: 60),
          const SizedBox(height: 16),
          
          // X-Axis labels
          Row(
            children: [
              const SizedBox(width: 100), // Match label width
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                    Text('20', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                    Text('40', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                    Text('60', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
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
          width: 100,
          child: Text(name, style: TextStyle(fontSize: 11, color: Colors.grey.shade800, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double percent = value / maxValue;
              return Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
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
          width: 28,
          child: Text(value.toString(), style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w800), textAlign: TextAlign.right),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// UPCOMING EVENTS SECTION
// ---------------------------------------------------------------------------
class _UpcomingEventsSection extends StatefulWidget {
  const _UpcomingEventsSection();

  @override
  State<_UpcomingEventsSection> createState() => _UpcomingEventsSectionState();
}

class _UpcomingEventsSectionState extends State<_UpcomingEventsSection> {
  String _selectedLocation = 'All Locations';
  String _selectedCategory = 'All Categories';

  final List<Map<String, dynamic>> _allEvents = [
    {
      'icon': Icons.event_note_rounded,
      'title': 'Women Leadership Workshop',
      'location': 'Kathmandu Branch',
      'category': 'Workshop',
      'date': '24 May 2025, Sat • 10:00 AM',
      'registered': '128',
    },
    {
      'icon': Icons.groups_rounded,
      'title': 'Blood Donation Camp',
      'location': 'Pokhara Branch',
      'category': 'Social Service',
      'date': '20 Jun 2025, Fri • 9:00 AM',
      'registered': '95',
    },
    {
      'icon': Icons.festival_rounded,
      'title': 'Teej Festival Celebration',
      'location': 'Chitwan Branch',
      'category': 'Cultural',
      'date': '05 Jul 2025, Sat • 5:00 PM',
      'registered': '210',
    },
    {
      'icon': Icons.school_rounded,
      'title': 'Entrepreneurship Seminar',
      'location': 'Butwal Branch',
      'category': 'Seminar',
      'date': '18 Jul 2025, Fri • 11:00 AM',
      'registered': '76',
    },
    {
      'icon': Icons.group_add_rounded,
      'title': 'General Meeting',
      'location': 'Biratnagar Branch',
      'category': 'Meeting',
      'date': '02 Aug 2025, Sat • 10:00 AM',
      'registered': '64',
    },
  ];

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFFAFAFA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, -4)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                // Header with Icon & Close Button
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Filter Events',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded, color: AppColors.primary, size: 18),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Section 1: Location
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    const Text('BRANCH LOCATION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 0.5)),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['All Locations', 'Kathmandu Branch', 'Pokhara Branch', 'Chitwan Branch', 'Butwal Branch', 'Biratnagar Branch'].map((loc) {
                    final isSelected = _selectedLocation == loc;
                    return ChoiceChip(
                      avatar: isSelected ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
                      label: Text(loc),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) {
                          setModalState(() => _selectedLocation = loc);
                          setState(() => _selectedLocation = loc);
                        }
                      },
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: isSelected ? AppColors.primary : const Color(0xFFE2D6D3)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                // Section 2: Category
                Row(
                  children: [
                    const Icon(Icons.category_rounded, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    const Text('EVENT CATEGORY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 0.5)),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['All Categories', 'Workshop', 'Social Service', 'Cultural', 'Seminar', 'Meeting'].map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return ChoiceChip(
                      avatar: isSelected ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) {
                          setModalState(() => _selectedCategory = cat);
                          setState(() => _selectedCategory = cat);
                        }
                      },
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: isSelected ? AppColors.primary : const Color(0xFFE2D6D3)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Action Buttons Bar with FittedBox so text never splits letter-by-letter!
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: OutlinedButton(
                        onPressed: () {
                          setModalState(() {
                            _selectedLocation = 'All Locations';
                            _selectedCategory = 'All Categories';
                          });
                          setState(() {
                            _selectedLocation = 'All Locations';
                            _selectedCategory = 'All Categories';
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Reset Filters',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 13),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 5,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 2,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Apply Filters',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _allEvents.where((e) {
      final locMatch = _selectedLocation == 'All Locations' || e['location'] == _selectedLocation;
      final catMatch = _selectedCategory == 'All Categories' || e['category'] == _selectedCategory;
      return locMatch && catMatch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading with Attractive Filter Button on Right (No separate filter row!)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming Events',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary),
            ),
            InkWell(
              onTap: _showFilterSheet,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.tune_rounded, size: 15, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      _selectedLocation == 'All Locations' && _selectedCategory == 'All Categories'
                          ? 'Filter'
                          : 'Filtered (${filteredEvents.length})',
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Filtered Event List
        if (filteredEvents.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Center(
              child: Text(
                'No events match selected filters',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
              ),
            ),
          )
        else
          ...filteredEvents.map((e) => _EventTile(
                icon: e['icon'] as IconData,
                title: e['title'] as String,
                subtitle1: '${e['location']} • ${e['category']}',
                subtitle2: e['date'] as String,
                registered: e['registered'] as String,
              )),
      ],
    );
  }
}

class _EventTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle1;
  final String subtitle2;
  final String registered;

  const _EventTile({
    required this.icon,
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
    required this.registered,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle1,
                  style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 11, color: AppColors.primary.withValues(alpha: 0.7)),
                    const SizedBox(width: 4),
                    Text(
                      subtitle2,
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.people_alt_rounded, color: AppColors.primary, size: 15),
                const SizedBox(height: 2),
                Text(
                  registered,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.primary),
                ),
                Text(
                  'Registered',
                  style: TextStyle(fontSize: 8, color: Colors.grey.shade700, fontWeight: FontWeight.w700),
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
