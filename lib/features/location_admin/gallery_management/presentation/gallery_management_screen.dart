import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/nas_logo.dart';
import '../../shared/branch_admin_nav_bar.dart';

/// B4 — Gallery Management Screen (Location Admin)
class GalleryManagementScreen extends StatefulWidget {
  const GalleryManagementScreen({super.key});

  @override
  State<GalleryManagementScreen> createState() => _GalleryManagementScreenState();
}

class _GalleryManagementScreenState extends State<GalleryManagementScreen> {
  static const _albumsList = [
    {
      'title': 'Teej Festival 2026',
      'date': '15 Aug 2026',
      'category': 'CULTURAL',
      'count': 18,
      'likes': 126,
      'comments': 18,
      'views': '4.8k',
      'color': Color(0xFF5A080D),
    },
    {
      'title': 'Women Leadership Workshop',
      'date': '05 Aug 2026',
      'category': 'MEETINGS',
      'count': 24,
      'likes': 98,
      'comments': 12,
      'views': '1.2k',
      'color': Color(0xFFE8CAAB),
    },
    {
      'title': 'Community Cleanliness Drive',
      'date': '28 Jul 2026',
      'category': 'ACTIVITIES',
      'count': 15,
      'likes': 75,
      'comments': 10,
      'views': '6.5k',
      'color': Color(0xFF5A080D),
    },
    {
      'title': 'Blood Donation Camp',
      'date': '12 Jul 2026',
      'category': 'EVENTS',
      'count': 10,
      'likes': 156,
      'comments': 24,
      'views': '12.4k',
      'color': Color(0xFF5A080D),
    },
  ];

  @override
  Widget build(BuildContext context) {
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

            // Metrics Strip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: IntrinsicHeight(
                    child: Row(
                      children: const [
                        _MetricCard(
                          title: 'Total Posts',
                          value: '128',
                          trend: '↑ 18 this month',
                          trendColor: Color(0xFF3E7C4A),
                          icon: Icons.image_rounded,
                          iconColor: Color(0xFFE8622C),
                          iconBg: Color(0xFFFBE0D2),
                        ),
                        VerticalDivider(width: 1, color: AppColors.border),
                        _MetricCard(
                          title: 'Total Views',
                          value: '2.4K',
                          trend: '↑ 22% this month',
                          trendColor: Color(0xFF3E7C4A),
                          icon: Icons.visibility_rounded,
                          iconColor: Color(0xFFC4901E),
                          iconBg: Color(0xFFFCF7EB),
                        ),
                        VerticalDivider(width: 1, color: AppColors.border),
                        _MetricCard(
                          title: 'Total Likes',
                          value: '856',
                          trend: '↑ 15% this month',
                          trendColor: Color(0xFF3E7C4A),
                          icon: Icons.favorite_rounded,
                          iconColor: Color(0xFFD64F64),
                          iconBg: Color(0xFFFDECEF),
                        ),
                        VerticalDivider(width: 1, color: AppColors.border),
                        _MetricCard(
                          title: 'Total Comments',
                          value: '142',
                          trend: '↑ 10% this month',
                          trendColor: Color(0xFF3E7C4A),
                          icon: Icons.chat_rounded,
                          iconColor: Color(0xFF3E7C4A),
                          iconBg: Color(0xFFE5F5E9),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Search & Filter Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search posts by title or event...',
                          hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textSecondary),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
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
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE8622C).withValues(alpha: 0.3)),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.filter_alt_outlined, color: Color(0xFFE8622C), size: 18),
                        SizedBox(width: 6),
                        Text('Filters', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFE8622C))),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      children: const [
                        Text('Newest First', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF5A080D))),
                        SizedBox(width: 6),
                        Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF5A080D), size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Filter Chips
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B1216),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Text('All Posts', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 8),
                  _filterChip('Events'),
                  const SizedBox(width: 8),
                  _filterChip('Celebrations'),
                  const SizedBox(width: 8),
                  _filterChip('Meetings'),
                  const SizedBox(width: 8),
                  _filterChip('Activities'),
                  const SizedBox(width: 8),
                  _filterChip('Others'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Albums Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _albumsList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.82,
                ),
                itemBuilder: (context, index) {
                  return _GalleryCard(item: _albumsList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(label, style: const TextStyle(color: Color(0xFF6B1216), fontSize: 12, fontWeight: FontWeight.w600)),
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
                Row(
                  children: [
                    Text(
                      'Kathmandu Branch',
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 11.5, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 2),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: Colors.grey.shade700),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
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
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gallery',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: 8),
            const Text('Share and manage moments\nthat showcase our community.',
                style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.35, fontWeight: FontWeight.w500)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Photos / Videos', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
              ),
            ),
          ],
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
  final String trend;
  final Color trendColor;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.trend,
    required this.trendColor,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 14),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade800, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF5A080D))),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.arrow_upward_rounded, size: 10, color: trendColor),
              const SizedBox(width: 2),
              Expanded(
                child: Text(trend, style: TextStyle(fontSize: 9, color: trendColor, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// GALLERY CARD
// ---------------------------------------------------------------------------
class _GalleryCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const _GalleryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: item['color'],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(Icons.photo_library_outlined, size: 40, color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.image_outlined, size: 10, color: Colors.white),
                          const SizedBox(width: 4),
                          Text('${item['count']}', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title'],
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF5A080D)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(item['date'], style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.favorite_border_rounded, size: 12, color: Color(0xFF6B1216)),
                          const SizedBox(width: 2),
                          Text('${item['likes']}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B1216))),
                          const SizedBox(width: 10),
                          const Icon(Icons.chat_bubble_outline_rounded, size: 12, color: Color(0xFF6B1216)),
                          const SizedBox(width: 2),
                          Text('${item['comments']}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B1216))),
                        ],
                      ),
                    ),
                    const Icon(Icons.more_vert_rounded, size: 14, color: AppColors.textSecondary),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


