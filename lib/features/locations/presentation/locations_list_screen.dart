import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_tokens.dart';
import '../../../shared/widgets/widgets.dart';

/// Screen 1 — Our Locations Screen
class LocationsListScreen extends ConsumerStatefulWidget {
  const LocationsListScreen({super.key});

  @override
  ConsumerState<LocationsListScreen> createState() => _LocationsListScreenState();
}

class _LocationsListScreenState extends ConsumerState<LocationsListScreen> {
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const NASAppBar(title: 'Locations', showBackButton: true),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Our Locations',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    fontFamily: NASTypography.headlineFont,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Find Nepal Agrawal Samaj branches near you',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),

                // Search bar + Filter button row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search_rounded, size: 18, color: Colors.grey.shade400),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Search by city or branch',
                                style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.tune_rounded, size: 18, color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Nepal Map Card
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _NepalMapCard(),
          ),
          const SizedBox(height: 14),

          // Stat chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: const [
                Expanded(child: _StatChip(icon: Icons.event_note_rounded, value: '18', label: 'Branches')),
                SizedBox(width: 10),
                Expanded(child: _StatChip(icon: Icons.grid_view_rounded, value: 'All 77', label: 'Districts')),
                SizedBox(width: 10),
                Expanded(child: _StatChip(icon: Icons.emoji_flags_rounded, value: '1 Goal', label: 'United Community')),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text('All Branches', style: AppText.h2),
          ),
          const SizedBox(height: 10),

          ...List.generate(_branches.length, (i) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: _BranchCard(branch: _branches[i]),
            );
          }),
        ],
      ),
      bottomNavigationBar: const NASBottomNavBar(activeIndex: 2),
    );
  }
}

class _NepalMapCard extends StatelessWidget {
  const _NepalMapCard();

  static const _pins = [
    Offset(0.12, 0.35),
    Offset(0.25, 0.58),
    Offset(0.35, 0.28),
    Offset(0.48, 0.62),
    Offset(0.65, 0.45),
    Offset(0.75, 0.58),
    Offset(0.88, 0.38),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        color: AppColors.subtleCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Nepal map vector silhouette representation
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Icon(Icons.map_rounded, color: AppColors.accent.withValues(alpha: 0.15), size: 140),
                ),
              ),
              for (final p in _pins)
                Positioned(
                  left: p.dx * constraints.maxWidth - 9,
                  top: p.dy * constraints.maxHeight - 18,
                  child: const Icon(Icons.location_on_rounded, color: AppColors.accent, size: 20),
                ),
              const Positioned(
                right: 70,
                bottom: 45,
                child: Icon(Icons.location_on_rounded, color: AppColors.primary, size: 26),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatChip({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: AppColors.accent),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.primary)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
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
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadow.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: SizedBox(
              width: 72,
              height: 82,
              child: CachedNetworkImage(
                imageUrl: branch.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(branch.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                    ),
                    if (branch.tag != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          branch.tag!,
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                _iconLine(Icons.location_on_rounded, branch.address),
                const SizedBox(height: 4),
                _iconLine(Icons.call_rounded, branch.phone),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Directions',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, size: 13, color: AppColors.primary),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconLine(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.accent),
        const SizedBox(width: 5),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary))),
      ],
    );
  }
}
