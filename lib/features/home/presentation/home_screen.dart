import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/design_tokens.dart';
import '../../../shared/widgets/widgets.dart';

/// Home screen — matches the "Nepal Agrawal Samaj" design screenshot exactly.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _eventPageController = PageController();
  int _eventPageIndex = 0;

  @override
  void dispose() {
    _eventPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            HeroSection(
              onBecomeMember: () => context.go(AppConstants.membershipSelector),
              onExploreEvents: () => context.go(AppConstants.events),
              onBellTap: () {},
              onProfileTap: () => context.push(AppConstants.profile),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionHeader(
              title: 'Upcoming Event',
              onViewAll: () => context.go(AppConstants.events),
            ),
            const SizedBox(height: AppSpacing.sm),
            _UpcomingEventCarousel(
              controller: _eventPageController,
              currentIndex: _eventPageIndex,
              onPageChanged: (i) => setState(() => _eventPageIndex = i),
            ),
            const SizedBox(height: AppSpacing.lg),
            const _AboutSection(),
            const SizedBox(height: AppSpacing.lg),
            _SectionHeader(
              title: 'What We Do',
              onViewAll: () => context.go(AppConstants.about),
              padded: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            const _WhatWeDoGrid(),
            const SizedBox(height: AppSpacing.lg),
            const _JoinCommunityBanner(),
            const SizedBox(height: AppSpacing.xl),
            _SectionHeader(
              title: 'Upcoming Events',
              onViewAll: () => context.go(AppConstants.events),
              padded: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            const _UpcomingEventsHorizontalList(),
            const SizedBox(height: AppSpacing.xl),
            _SectionHeader(
              title: 'Our Locations',
              onViewAll: () => context.go(AppConstants.locations),
              padded: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            const _NepalMapPlaceholder(),
            const SizedBox(height: AppSpacing.md),
            const _FeaturedLocationCard(),
            const SizedBox(height: AppSpacing.xl),
            _SectionHeader(
              title: 'Gallery Highlights',
              onViewAll: () => context.go(AppConstants.gallery),
              padded: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            const _GalleryHighlightsGrid(),
            const SizedBox(height: AppSpacing.xl),
            const _BecomeAMemberSection(),
            const SizedBox(height: AppSpacing.lg),
            const _TogetherBanner(),
            const SizedBox(height: AppSpacing.lg),
            const _ConnectWithUs(),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
      bottomNavigationBar: const NASBottomNavBar(activeIndex: 0),
    );
  }
}

// ---------------------------------------------------------------------------
// HERO SECTION
// ---------------------------------------------------------------------------
class HeroSection extends StatelessWidget {
  final VoidCallback? onBecomeMember;
  final VoidCallback? onExploreEvents;
  final VoidCallback? onBellTap;
  final VoidCallback? onProfileTap;

  const HeroSection({
    super.key,
    this.onBecomeMember,
    this.onExploreEvents,
    this.onBellTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Stack(
        children: [
          // ---- Background photo + fade ----
          const Positioned.fill(
            child: _HeroBackgroundImage(),
          ),

          // ---- Foreground content ----
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar: logo on left, notifications + profile on right
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _NasLogo(),
                    Row(
                      children: [
                        _iconCircleButton(Icons.notifications_none_rounded, onBellTap),
                        const SizedBox(width: 8),
                        _iconCircleButton(Icons.person_rounded, onProfileTap, filled: true),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Heading
                const Text(
                  'Nepal',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    height: 1.05,
                    color: AppColors.primary,
                  ),
                ),
                const Text(
                  'Agrawal Samaj',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    height: 1.05,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),

                // Tagline
                const Text(
                  'Unity • Culture • Service',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 16),

                // Ornamental divider
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppColors.accent.withValues(alpha: 0.35),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Transform.rotate(
                        angle: 0.785398, // 45°
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.accent, width: 1.4),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppColors.accent.withValues(alpha: 0.35),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Description
                SizedBox(
                  width: 300,
                  child: Text(
                    'Connecting families, strengthening businesses, preserving '
                    'traditions and creating opportunities for future generations.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.55,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: _GradientButton(
                        label: 'Become a Member',
                        icon: Icons.person_add_alt_1_rounded,
                        onTap: onBecomeMember,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 5,
                      child: _OutlinedIconButton(
                        label: 'Explore Events',
                        icon: Icons.event_available_rounded,
                        onTap: onExploreEvents,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Floating stats card cleanly below buttons
                const _StatsCard(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconCircleButton(IconData icon, VoidCallback? onTap, {bool filled = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? AppColors.accentLight : Colors.transparent,
          border: filled ? Border.all(color: AppColors.primary, width: 1.4) : null,
        ),
        child: Icon(icon, size: 22, color: AppColors.primary),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// BACKGROUND PHOTO
// ---------------------------------------------------------------------------
class _HeroBackgroundImage extends StatelessWidget {
  const _HeroBackgroundImage();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Mountain & temple hero photo
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl:
                'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=1200&q=80',
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE7EEF3), Color(0xFFD8C9AE), Color(0xFF8B6B4A)],
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
        ),
        // Horizontal fade: page background on the left, photo visible on the right
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.background,
                  AppColors.background.withValues(alpha: 0.85),
                  AppColors.background.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.35, 0.6, 1.0],
              ),
            ),
          ),
        ),
        // Bottom fade back to page background so the stats card overlaps cleanly
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, AppColors.background],
                stops: const [0.7, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// NAS CREST LOGO — laurel + star + shield + "NAS" ribbon
// ---------------------------------------------------------------------------
class _NasLogo extends StatelessWidget {
  const _NasLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      height: 92,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          // Laurel branches
          Positioned(
            top: 18,
            left: -2,
            child: Transform.rotate(
              angle: -0.5,
              child: const Icon(Icons.grass_rounded, size: 34, color: AppColors.gold),
            ),
          ),
          Positioned(
            top: 18,
            right: -2,
            child: Transform.flip(
              flipX: true,
              child: Transform.rotate(
                angle: -0.5,
                child: const Icon(Icons.grass_rounded, size: 34, color: AppColors.gold),
              ),
            ),
          ),
          // Star
          const Positioned(
            top: 0,
            child: Icon(Icons.star_rounded, size: 18, color: AppColors.gold),
          ),
          // Shield
          Positioned(
            top: 20,
            child: ClipPath(
              clipper: _ShieldClipper(),
              child: Container(
                width: 38,
                height: 44,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE13B2E), Color(0xFFB5241C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.auto_awesome, size: 16, color: AppColors.gold),
              ),
            ),
          ),
          // Ribbon banner with "NAS"
          Positioned(
            top: 62,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Text(
                'NAS',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShieldClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h * 0.55)
      ..quadraticBezierTo(w, h * 0.85, w / 2, h)
      ..quadraticBezierTo(0, h * 0.85, 0, h * 0.55)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// ---------------------------------------------------------------------------
// BUTTONS
// ---------------------------------------------------------------------------
class _GradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  const _GradientButton({required this.label, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          height: 52,
          decoration: BoxDecoration(
            gradient: AppColors.orangeGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlinedIconButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  const _OutlinedIconButton({required this.label, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary, width: 1.4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.event_note_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
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
// STATS CARD — floating card with 4 stats separated by thin dividers
// ---------------------------------------------------------------------------
class _StatsCard extends StatelessWidget {
  const _StatsCard();

  static const _stats = [
    (icon: Icons.groups_rounded, value: '5,200+', label: 'Active Members'),
    (icon: Icons.location_on_rounded, value: '18', label: 'Branches'),
    (icon: Icons.event_note_rounded, value: '130+', label: 'Annual Events'),
    (icon: Icons.workspace_premium_rounded, value: '38', label: 'Years of Service'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          for (int i = 0; i < _stats.length; i++) ...[
            if (i != 0)
              Container(width: 1, height: 44, color: Colors.grey.shade200),
            Expanded(
              child: Column(
                children: [
                  Icon(_stats[i].icon, color: AppColors.accent, size: 24),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _stats[i].value,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _stats[i].label,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SECTION HEADER ("Title" ............ "View All")
// ---------------------------------------------------------------------------
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;
  final bool padded;
  const _SectionHeader({required this.title, required this.onViewAll, this.padded = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppText.h2),
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(foregroundColor: AppColors.primary, padding: EdgeInsets.zero),
            child: const Text('View All', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// UPCOMING EVENT — single large carousel card w/ dot indicator
// ---------------------------------------------------------------------------
class _UpcomingEventCarousel extends StatelessWidget {
  final PageController controller;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  const _UpcomingEventCarousel({
    required this.controller,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    const eventCount = 4;
    return Column(
      children: [
        SizedBox(
          height: 215,
          child: PageView.builder(
            controller: controller,
            onPageChanged: onPageChanged,
            itemCount: eventCount,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: AppShadow.card,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppRadius.lg),
                          bottomLeft: Radius.circular(AppRadius.lg),
                        ),
                        child: SizedBox(
                          width: 110,
                          height: 215,
                          child: _networkImage(
                            url: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=800&q=80',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Annual Business Summit 2026',
                                style: AppText.h3,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              _iconText(Icons.calendar_today_rounded, '20 Aug, 2026 • 10:00 AM'),
                              const SizedBox(height: 4),
                              _iconText(Icons.location_on_rounded, 'Kathmandu, Nepal'),
                              const SizedBox(height: 6),
                              const Text(
                                'A flagship event bringing together entrepreneurs, leaders and professionals.',
                                style: AppText.bodySmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 32,
                                      child: ElevatedButton(
                                        onPressed: () => context.go(AppConstants.events),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          elevation: 0,
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(AppRadius.pill)),
                                        ),
                                        child: const Text('Register Now', style: TextStyle(fontSize: 11)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: SizedBox(
                                      height: 32,
                                      child: OutlinedButton(
                                        onPressed: () => context.go(AppConstants.events),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: AppColors.primary,
                                          side: const BorderSide(color: AppColors.border),
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(AppRadius.pill)),
                                        ),
                                        child: const Text('Learn More', style: TextStyle(fontSize: 11)),
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
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(eventCount, (i) {
            final active = i == currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.accent),
        const SizedBox(width: 4),
        Expanded(
          child: Text(text, style: AppText.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// ABOUT SECTION
// ---------------------------------------------------------------------------
class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.workspace_premium_rounded, color: AppColors.accent, size: 20),
              SizedBox(width: 8),
              Text('About Nepal Agrawal Samaj', style: AppText.h2),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Founded in 1988, Nepal Agrawal Samaj has grown into a strong '
            'nationwide network dedicated to the welfare of the Agrawal '
            'community and society at large.',
            style: AppText.body,
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(
            onPressed: () => context.go(AppConstants.about),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Discover Our Story', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward_rounded, size: 15),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: SizedBox(
                    height: 90,
                    child: _networkImage(
                      url: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=400&q=80',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: SizedBox(
                    height: 90,
                    child: _networkImage(
                      url: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=400&q=80',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: SizedBox(
                    height: 90,
                    child: _networkImage(
                      url: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=400&q=80',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// WHAT WE DO — 3x2 grid
// ---------------------------------------------------------------------------
class _WhatWeDoGrid extends StatelessWidget {
  const _WhatWeDoGrid();

  static const _items = [
    (icon: Icons.temple_hindu_rounded, title: 'Culture', desc: 'Preserving traditions and heritage'),
    (icon: Icons.work_rounded, title: 'Business', desc: 'Connecting businesses'),
    (icon: Icons.school_rounded, title: 'Education', desc: 'Supporting education and scholarships'),
    (icon: Icons.groups_rounded, title: 'Youth', desc: 'Empowering youth and leadership'),
    (icon: Icons.volunteer_activism_rounded, title: 'Social Work', desc: 'Serving society with compassion'),
    (icon: Icons.diversity_3_rounded, title: 'Women Empowerment', desc: 'Encouraging women entrepreneurship'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, i) {
          final item = _items[i];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: AppColors.primary, size: 22),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  item.desc,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// JOIN OUR COMMUNITY — orange gradient banner
// ---------------------------------------------------------------------------
class _JoinCommunityBanner extends StatelessWidget {
  const _JoinCommunityBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Join Our Community',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text(
            'Become part of a growing community dedicated to unity, culture, '
            'business and social development.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton(
                onPressed: () => context.go(AppConstants.membershipSelector),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.accent,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                ),
                child: const Text('Become a Member', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
              ),
              OutlinedButton(
                onPressed: () => context.go(AppConstants.contact),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                ),
                child: const Text('Get in Touch', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// UPCOMING EVENTS — horizontal list w/ date badge
// ---------------------------------------------------------------------------
class _UpcomingEventsHorizontalList extends StatelessWidget {
  const _UpcomingEventsHorizontalList();

  static const _events = [
    (
      month: 'AUG',
      day: '20',
      title: 'Annual Business Summit 2026',
      time: '10:00 AM - 4:00 PM',
      place: 'Kathmandu',
      imageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=400&q=80',
    ),
    (
      month: 'SEP',
      day: '05',
      title: 'Teej Cultural Celebration',
      time: '11:00 AM - 3:00 PM',
      place: 'Pokhara',
      imageUrl: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=400&q=80',
    ),
    (
      month: 'SEP',
      day: '18',
      title: 'Mega Blood Donation Drive',
      time: '9:00 AM - 1:00 PM',
      place: 'Biratnagar',
      imageUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=400&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: _events.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final e = _events[i];
          return Container(
            width: 160,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: AppShadow.card,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
                      child: SizedBox(
                        height: 110,
                        width: double.infinity,
                        child: _networkImage(url: e.imageUrl, fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(e.month,
                                style: const TextStyle(
                                    fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.badgeMaroon)),
                            Text(e.day,
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.badgeMaroon)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.title,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.access_time_rounded, size: 11, color: AppColors.accent),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(e.time,
                              style: AppText.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ]),
                      const SizedBox(height: 2),
                      Row(children: [
                        const Icon(Icons.location_on_rounded, size: 11, color: AppColors.accent),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(e.place,
                              style: AppText.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ]),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: double.infinity,
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () => context.go(AppConstants.events),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                          ),
                          child: const Text('Register Now', style: TextStyle(fontSize: 11)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// OUR LOCATIONS — Nepal map placeholder + pins
// ---------------------------------------------------------------------------
class _NepalMapPlaceholder extends StatelessWidget {
  const _NepalMapPlaceholder();

  static const _pins = [
    Offset(0.28, 0.35),
    Offset(0.40, 0.55),
    Offset(0.52, 0.30),
    Offset(0.58, 0.60),
    Offset(0.68, 0.42),
    Offset(0.80, 0.50),
    Offset(0.88, 0.65),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.subtleCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.15,
                  child: Icon(Icons.map, size: 120, color: AppColors.primary),
                ),
              ),
              for (final p in _pins)
                Positioned(
                  left: p.dx * constraints.maxWidth - 10,
                  top: p.dy * constraints.maxHeight - 20,
                  child: const Icon(Icons.location_on_rounded, color: AppColors.accent, size: 22),
                ),
              const Positioned(
                right: 40,
                bottom: 30,
                child: Icon(Icons.location_on_rounded, color: AppColors.primary, size: 30),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FeaturedLocationCard extends StatelessWidget {
  const _FeaturedLocationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadow.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: SizedBox(
              width: 90,
              height: 110,
              child: _networkImage(
                url: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=400&q=80',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Kathmandu Branch', style: AppText.h3),
                const SizedBox(height: 6),
                _iconRow(Icons.groups_rounded, '1,200+ Members'),
                const SizedBox(height: 4),
                _iconRow(Icons.event_rounded, '18 Events'),
                const SizedBox(height: 4),
                _iconRow(Icons.badge_rounded, 'Branch Leader\nMr. Rajesh Agrawal'),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => context.go(AppConstants.locations),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Explore Location', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, size: 12),
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

  Widget _iconRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 13, color: AppColors.accent),
        const SizedBox(width: 5),
        Expanded(child: Text(text, style: AppText.bodySmall)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// GALLERY HIGHLIGHTS — 4x2 photo grid
// ---------------------------------------------------------------------------
class _GalleryHighlightsGrid extends StatelessWidget {
  const _GalleryHighlightsGrid();

  static const _galleryPhotos = [
    'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=400&q=80',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, i) => ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: _networkImage(url: _galleryPhotos[i], fit: BoxFit.cover),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// BECOME A MEMBER — maroon card w/ two membership options
// ---------------------------------------------------------------------------
class _BecomeAMemberSection extends StatelessWidget {
  const _BecomeAMemberSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          const Text('Become a Member',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _membershipCard(
                  context: context,
                  icon: Icons.person_rounded,
                  iconBg: Colors.white24,
                  title: 'Normal\nMembership',
                  desc: 'Join as an individual and enjoy exclusive benefits and events.',
                  buttonColor: AppColors.primary,
                  onTap: () => context.go(AppConstants.normalRegistration),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _membershipCard(
                  context: context,
                  icon: Icons.work_rounded,
                  iconBg: AppColors.accentLight,
                  title: 'Business\nMembership',
                  desc: 'Grow your business, connect and get featured.',
                  buttonColor: AppColors.accent,
                  buttonTextColor: Colors.white,
                  onTap: () => context.go(AppConstants.businessRegistration),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _membershipCard({
    required BuildContext context,
    required IconData icon,
    required Color iconBg,
    required String title,
    required String desc,
    required Color buttonColor,
    Color buttonTextColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 18, backgroundColor: iconBg, child: Icon(icon, color: AppColors.primary, size: 18)),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.primary)),
          const SizedBox(height: 6),
          Text(desc, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, height: 1.3)),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: buttonTextColor,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
              ),
              child: const Text('Join Now →', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TOGETHER WE BUILD banner
// ---------------------------------------------------------------------------
class _TogetherBanner extends StatelessWidget {
  const _TogetherBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: const [
          Expanded(
            child: Text(
              'Together We Build\nA Stronger Community',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.accent, height: 1.3),
            ),
          ),
          Icon(Icons.groups_rounded, color: AppColors.accent, size: 34),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CONNECT WITH US
// ---------------------------------------------------------------------------
class _ConnectWithUs extends StatelessWidget {
  const _ConnectWithUs();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadow.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Connect With Us', style: AppText.h3),
                const SizedBox(height: 10),
                _row(Icons.call_rounded, '+977 1-4220000'),
                const SizedBox(height: 8),
                _row(Icons.email_rounded, 'info@nepalagrawalsamaj.org'),
                const SizedBox(height: 8),
                _row(Icons.location_on_rounded, 'Kathmandu, Nepal'),
                const SizedBox(height: 8),
                _row(Icons.access_time_rounded, 'Sun - Fri (9:00 AM - 6:00 PM)'),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: SizedBox(
              width: 80,
              height: 130,
              child: _networkImage(
                url: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=400&q=80',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.accent),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: AppText.bodySmall)),
      ],
    );
  }
}



// ---------------------------------------------------------------------------
// SHARED NETWORK IMAGE WITH CACHED LOADING
// ---------------------------------------------------------------------------
Widget _networkImage({required String url, BoxFit fit = BoxFit.cover}) {
  return CachedNetworkImage(
    imageUrl: url,
    fit: fit,
    placeholder: (context, url) => Container(
      color: AppColors.subtleCard,
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
      ),
    ),
    errorWidget: (context, url, error) => Container(
      color: AppColors.subtleCard,
      child: const Center(
        child: Icon(Icons.image_rounded, color: AppColors.border, size: 24),
      ),
    ),
  );
}
