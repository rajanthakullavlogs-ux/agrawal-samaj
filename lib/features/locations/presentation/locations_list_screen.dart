import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/widgets.dart';

/// Screen 1 — Our Locations Screen (Redesigned matching exact UI spec)
class LocationsListScreen extends ConsumerStatefulWidget {
  const LocationsListScreen({super.key});

  @override
  ConsumerState<LocationsListScreen> createState() => _LocationsListScreenState();
}

class _LocationsListScreenState extends ConsumerState<LocationsListScreen> {
  String _searchQuery = '';
  String? _selectedProvince; // null = All
  String? _selectedTag; // null = All

  static const _branches = [
    (
      name: 'Kathmandu Branch',
      tag: 'Head Branch',
      province: 'Bagmati',
      address: 'Sinamangal, Kathmandu, Nepal',
      phone: '+977 1-XXXXXXX',
      imageUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=400&q=80',
    ),
    (
      name: 'Biratnagar Branch',
      tag: 'Regional Office',
      province: 'Koshi',
      address: 'Biratnagar, Koshi Province',
      phone: '+977 21-XXXXXXX',
      imageUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=400&q=80',
    ),
    (
      name: 'Pokhara Branch',
      tag: 'Regional Office',
      province: 'Gandaki',
      address: 'Pokhara, Gandaki Province',
      phone: '+977 61-XXXXXXX',
      imageUrl: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=400&q=80',
    ),
    (
      name: 'Butwal Branch',
      tag: 'Regional Office',
      province: 'Lumbini',
      address: 'Butwal, Lumbini Province',
      phone: '+977 71-XXXXXXX',
      imageUrl: 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?auto=format&fit=crop&w=400&q=80',
    ),
    (
      name: 'Nepalgunj Branch',
      tag: 'Regional Office',
      province: 'Lumbini',
      address: 'Nepalgunj, Lumbini Province',
      phone: '+977 81-XXXXXXX',
      imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=400&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _branches.where((b) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesQuery = b.name.toLowerCase().contains(query) || b.address.toLowerCase().contains(query);
        if (!matchesQuery) return false;
      }
      if (_selectedProvince != null && b.province != _selectedProvince) {
        return false;
      }
      if (_selectedTag != null && b.tag != _selectedTag) {
        return false;
      }
      return true;
    }).toList();

    final activeFilterCount = (_selectedProvince != null ? 1 : 0) + (_selectedTag != null ? 1 : 0);
    final hasActiveFilter = activeFilterCount > 0;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: const NASAppBar(title: 'Locations', showBackButton: true),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SizedBox(height: 10),

          // Hero Header Row with Pagoda Photo Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Our Locations',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF3F050C),
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Find Nepal Agrawal Samaj\nbranches near you',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF756E68),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Container(
                  width: 105,
                  height: 105,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/pagoda_header_bg.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF500913),
                        child: const Icon(Icons.temple_hindu_rounded, color: Colors.white, size: 40),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Ultra-Premium Modern Search Bar & Interactive Filter Button Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: _searchQuery.isNotEmpty ? const Color(0xFF500913) : const Color(0xFFEBE5E1),
                        width: _searchQuery.isNotEmpty ? 1.5 : 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF500913).withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: const Color(0xFF500913).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.search_rounded, size: 18, color: Color(0xFF500913)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            onChanged: (v) => setState(() => _searchQuery = v),
                            decoration: const InputDecoration(
                              hintText: 'Search city, district or branch...',
                              hintStyle: TextStyle(color: Color(0xFF9E958F), fontSize: 13, fontWeight: FontWeight.w500),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF1E1615)),
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          GestureDetector(
                            onTap: () => setState(() => _searchQuery = ''),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFEBE5E1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close_rounded, size: 14, color: Color(0xFF500913)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Interactive Filter Button with Active Badge Accent
                GestureDetector(
                  onTap: () => _showLocationsFilterModalSheet(context),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: hasActiveFilter ? const Color(0xFF500913) : const Color(0xFFFBEBEB),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: hasActiveFilter
                          ? [
                              BoxShadow(
                                color: const Color(0xFF500913).withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.tune_rounded,
                          size: 18,
                          color: hasActiveFilter ? Colors.white : const Color(0xFF500913),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          hasActiveFilter ? 'Filter ($activeFilterCount)' : 'Filter',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: hasActiveFilter ? Colors.white : const Color(0xFF500913),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Nepal Map Card
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _NepalMapCard(),
          ),
          const SizedBox(height: 16),

          // 4 Stat Cards Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: const [
                Expanded(
                  child: _StatCard(
                    icon: Icons.account_balance_rounded,
                    value: '18',
                    label: 'Branches',
                    bgColor: Color(0xFFFDEEEE),
                    iconColor: Color(0xFF500913),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    icon: Icons.grid_view_rounded,
                    value: '77',
                    label: 'Districts\nCovered',
                    bgColor: Color(0xFFFFF3E0),
                    iconColor: Color(0xFFE67E22),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    icon: Icons.groups_rounded,
                    value: '10K+',
                    label: 'Members',
                    bgColor: Color(0xFFF0EDFB),
                    iconColor: Color(0xFF7B4FD6),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    icon: Icons.flag_rounded,
                    value: '1 Goal',
                    label: 'United\nCommunity',
                    bgColor: Color(0xFFE8F5E9),
                    iconColor: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // All Branches Header Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF500913),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'All Branches',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1615),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF500913).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF500913).withValues(alpha: 0.15)),
                  ),
                  child: Text(
                    '${filtered.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF500913),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Branch Cards List View display
          ...List.generate(filtered.length, (i) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: _BranchCard(branch: filtered[i]),
            );
          }),
        ],
      ),
      bottomNavigationBar: const NASBottomNavBar(activeIndex: 2),
    );
  }

  void _showLocationsFilterModalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final activeCount = (_selectedProvince != null ? 1 : 0) + (_selectedTag != null ? 1 : 0);

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Drag Indicator Bar
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Header Card with Burgundy Gradient
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6B0E1B), Color(0xFF45060E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6B0E1B).withValues(alpha: 0.25),
                            blurRadius: 10,
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
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.tune_rounded, color: Color(0xFFE5C158), size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Filter Locations',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  activeCount > 0
                                      ? '$activeCount active filter${activeCount > 1 ? 's' : ''} applied'
                                      : 'Explore branches by province & category',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (activeCount > 0)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedProvince = null;
                                  _selectedTag = null;
                                });
                                setModalState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white30),
                                ),
                                child: const Text(
                                  'Reset',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section 1: Province Selection
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: const [
                            Icon(Icons.location_on_rounded, size: 16, color: Color(0xFF500913)),
                            SizedBox(width: 6),
                            Text(
                              'Filter by Province',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E1615),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          'All Provinces',
                          'Bagmati',
                          'Gandaki',
                          'Koshi',
                          'Lumbini',
                          'Madhesh',
                          'Sudurpashchim',
                        ].map((pr) {
                          final isAll = pr == 'All Provinces';
                          final isSel = isAll ? _selectedProvince == null : _selectedProvince == pr;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedProvince = isAll ? null : pr;
                              });
                              setModalState(() {});
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSel ? const Color(0xFF500913) : const Color(0xFFF7F5F4),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSel ? const Color(0xFF500913) : const Color(0xFFEBE5E1),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isSel) ...[
                                    const Icon(Icons.check_rounded, size: 14, color: Colors.white),
                                    const SizedBox(width: 5),
                                  ],
                                  Text(
                                    pr,
                                    style: TextStyle(
                                      color: isSel ? Colors.white : const Color(0xFF500913),
                                      fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section 2: Branch Category
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: const [
                            Icon(Icons.category_rounded, size: 16, color: Color(0xFF500913)),
                            SizedBox(width: 6),
                            Text(
                              'Branch Category',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E1615),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          'All Types',
                          'Head Branch',
                          'Regional Office',
                        ].map((tg) {
                          final isAll = tg == 'All Types';
                          final isSel = isAll ? _selectedTag == null : _selectedTag == tg;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedTag = isAll ? null : tg;
                              });
                              setModalState(() {});
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSel ? const Color(0xFF500913) : const Color(0xFFF7F5F4),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSel ? const Color(0xFF500913) : const Color(0xFFEBE5E1),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isSel) ...[
                                    const Icon(Icons.check_rounded, size: 14, color: Colors.white),
                                    const SizedBox(width: 5),
                                  ],
                                  Text(
                                    tg,
                                    style: TextStyle(
                                      color: isSel ? Colors.white : const Color(0xFF500913),
                                      fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Apply Filters Action Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF500913),
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: const Color(0xFF500913).withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                          child: const Text(
                            'Apply Location Filters',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NepalMapCard extends StatelessWidget {
  const _NepalMapCard();

  static const _pinDetails = [
    (name: 'Nepalgunj', offset: Offset(0.18, 0.62)),
    (name: 'Butwal', offset: Offset(0.30, 0.56)),
    (name: 'Pokhara', offset: Offset(0.48, 0.36)),
    (name: 'Kathmandu', offset: Offset(0.64, 0.48)),
    (name: 'Biratnagar', offset: Offset(0.84, 0.66)),
  ];

  @override
  Widget build(BuildContext context) {
    Widget mapContent = LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Nepal map terrain background
            Positioned.fill(
              child: Image(
                image: const AssetImage('assets/images/nepal_map_bg_v2.png'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFE5EFE2),
                  child: Center(
                    child: Icon(Icons.map_rounded, color: Colors.green.withValues(alpha: 0.2), size: 100),
                  ),
                ),
              ),
            ),

            // City Pins with White Badges
            for (final p in _pinDetails)
              Positioned(
                left: p.offset.dx * constraints.maxWidth - 36,
                top: p.offset.dy * constraints.maxHeight - 14,
                child: GestureDetector(
                  onTap: () => context.push('/locations/${p.name.toLowerCase()}'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on_rounded, color: Color(0xFF5C1414), size: 14),
                        const SizedBox(width: 3),
                        Text(
                          p.name,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Floating Location Target Button (Bottom Right)
            Positioned(
              right: 14,
              bottom: 14,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.my_location_rounded, color: Color(0xFF5C1414), size: 20),
                ),
              ),
            ),
          ],
        );
      },
    );

    return Container(
      height: 200,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F3E5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAE4E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: mapContent,
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color bgColor;
  final Color iconColor;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.bgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6E645D),
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _BranchCard extends StatelessWidget {
  final ({String name, String? tag, String? province, String address, String phone, String imageUrl}) branch;
  const _BranchCard({required this.branch});

  @override
  Widget build(BuildContext context) {
    final slug = branch.name.toLowerCase().split(' ').first;

    return InkWell(
      onTap: () => context.push('/locations/$slug'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEBE5E1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 84,
                height: 94,
                child: CachedNetworkImage(
                  imageUrl: branch.imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    color: const Color(0xFFF3F0EE),
                    child: const Icon(Icons.image_outlined, color: Color(0xFF9A928C)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          branch.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: Color(0xFF500913),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      if (branch.tag != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            branch.tag!,
                            style: const TextStyle(
                              color: Color(0xFF2E7D32),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      const Icon(Icons.chevron_right_rounded, size: 20, color: Color(0xFF9A928C)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _iconLine(Icons.location_on_rounded, branch.address),
                  const SizedBox(height: 4),
                  _iconLine(Icons.call_rounded, branch.phone),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF0F0),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.near_me_rounded, size: 14, color: Color(0xFF500913)),
                            SizedBox(width: 5),
                            Text(
                              'Directions',
                              style: TextStyle(
                                color: Color(0xFF500913),
                                fontWeight: FontWeight.w700,
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconLine(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF500913)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF756E68),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
