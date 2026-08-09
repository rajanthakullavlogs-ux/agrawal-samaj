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
  bool _isListView = true;

  static const _branches = [
    (
      name: 'Kathmandu Branch',
      tag: 'Head Branch',
      address: 'Sinamangal, Kathmandu, Nepal',
      phone: '+977 1-XXXXXXX',
      imageUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=400&q=80',
    ),
    (
      name: 'Biratnagar Branch',
      tag: null,
      address: 'Biratnagar, Koshi Province',
      phone: '+977 21-XXXXXXX',
      imageUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=400&q=80',
    ),
    (
      name: 'Pokhara Branch',
      tag: null,
      address: 'Pokhara, Gandaki Province',
      phone: '+977 61-XXXXXXX',
      imageUrl: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=400&q=80',
    ),
    (
      name: 'Butwal Branch',
      tag: null,
      address: 'Butwal, Lumbini Province',
      phone: '+977 71-XXXXXXX',
      imageUrl: 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?auto=format&fit=crop&w=400&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _searchQuery.isEmpty
        ? _branches
        : _branches.where((b) =>
            b.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            b.address.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F6),
      appBar: const NASAppBar(title: 'Locations', showBackButton: true),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SizedBox(height: 8),

          // Hero Header with Pagoda Graphic
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 100,
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    top: -10,
                    bottom: 0,
                    width: 220,
                    child: Opacity(
                      opacity: 0.85,
                      child: Image(
                        image: const AssetImage('assets/images/pagoda_header_bg.png'),
                        fit: BoxFit.contain,
                        alignment: Alignment.centerRight,
                        errorBuilder: (context, error, stackTrace) => const SizedBox(),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Our Locations',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF5C1414),
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Find Nepal Agrawal Samaj branches\nnear you',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6E645D),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Search & Filter Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFEAE4E0)),
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
                        const Icon(Icons.search_rounded, size: 20, color: Color(0xFF9A928C)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (v) => setState(() => _searchQuery = v),
                            decoration: const InputDecoration(
                              hintText: 'Search by city, district or branch',
                              hintStyle: TextStyle(color: Color(0xFF9A928C), fontSize: 13),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: const TextStyle(fontSize: 13, color: Color(0xFF1F2937)),
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          GestureDetector(
                            onTap: () => setState(() => _searchQuery = ''),
                            child: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF6E645D)),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Filter Button
                Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF0F0),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF9DADA)),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.tune_rounded, size: 18, color: Color(0xFF5C1414)),
                      SizedBox(width: 6),
                      Text(
                        'Filter',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF5C1414),
                        ),
                      ),
                    ],
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

          // 4 Stat Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: const [
                Expanded(
                  child: _StatCard(
                    icon: Icons.account_balance_rounded,
                    value: '18',
                    label: 'Branches',
                    bgColor: Color(0xFFFDF0F0),
                    iconColor: Color(0xFF5C1414),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    icon: Icons.grid_view_rounded,
                    value: '77',
                    label: 'Districts\nCovered',
                    bgColor: Color(0xFFFDF3E7),
                    iconColor: Color(0xFFD97706),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    icon: Icons.groups_rounded,
                    value: '10K+',
                    label: 'Members',
                    bgColor: Color(0xFFF3F0F9),
                    iconColor: Color(0xFF7C3AED),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    icon: Icons.flag_rounded,
                    value: '1 Goal',
                    label: 'United\nCommunity',
                    bgColor: Color(0xFFEEF7F1),
                    iconColor: Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Section Title & View Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'All Branches',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF5C1414),
                  ),
                ),
                // Toggle pill
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEAE4E0)),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _isListView = true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: _isListView ? const Color(0xFF5C1414) : Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.format_list_bulleted_rounded,
                                size: 14,
                                color: _isListView ? Colors.white : const Color(0xFF6E645D),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'List View',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: _isListView ? Colors.white : const Color(0xFF6E645D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _isListView = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: !_isListView ? const Color(0xFF5C1414) : Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.map_outlined,
                                size: 14,
                                color: !_isListView ? Colors.white : const Color(0xFF6E645D),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Map View',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: !_isListView ? Colors.white : const Color(0xFF6E645D),
                                ),
                              ),
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
          const SizedBox(height: 14),

          // List View vs Map View display
          if (_isListView)
            ...List.generate(filtered.length, (i) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: _BranchCard(branch: filtered[i]),
              );
            })
          else
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _NepalMapCard(interactive: true),
            ),
        ],
      ),
      bottomNavigationBar: const NASBottomNavBar(activeIndex: 2),
    );
  }
}

class _NepalMapCard extends StatelessWidget {
  final bool interactive;
  const _NepalMapCard({this.interactive = false});

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
      height: interactive ? 340 : 200,
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
      child: interactive
          ? InteractiveViewer(
              minScale: 1.0,
              maxScale: 3.0,
              child: mapContent,
            )
          : mapContent,
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
  final ({String name, String? tag, String address, String phone, String imageUrl}) branch;
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
          border: Border.all(color: const Color(0xFFEAE4E0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
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
                          color: Color(0xFF5C1414),
                        ),
                      ),
                    ),
                    if (branch.tag != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F4EA),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          branch.tag!,
                          style: const TextStyle(
                            color: Color(0xFF1E8E3E),
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
                          Icon(Icons.near_me_rounded, size: 14, color: Color(0xFF5C1414)),
                          SizedBox(width: 5),
                          Text(
                            'Directions',
                            style: TextStyle(
                              color: Color(0xFF5C1414),
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
        Icon(icon, size: 14, color: const Color(0xFF5C1414)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6E645D),
            ),
          ),
        ),
      ],
    );
  }
}
