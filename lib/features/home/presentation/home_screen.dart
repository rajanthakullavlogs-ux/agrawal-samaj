import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/design_tokens.dart';
import '../../../shared/widgets/widgets.dart';

/// Home Screen — Matches the new "Nepal Agrawal Samaj" design image & spec exactly.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _eventPage = 0;
  final PageController _eventPageController = PageController(viewportFraction: 0.72);

  static const List<_EventData> _events = [
    _EventData(
      id: 'ev-1',
      month: 'MAY',
      day: '25',
      title: 'Guru Purnima Satsang',
      time: '5:00 PM',
      location: 'Kathmandu',
      imageUrl: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=800&q=80',
      imageIcon: Icons.local_fire_department_rounded,
      imageColor: Color(0xFFB8622B),
    ),
    _EventData(
      id: 'ev-4',
      month: 'JUN',
      day: '08',
      title: 'Blood Donation Camp',
      time: '10:00 AM',
      location: 'Biratnagar Branch',
      imageUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=800&q=80',
      imageIcon: Icons.favorite_rounded,
      imageColor: Color(0xFFC0392B),
    ),
    _EventData(
      id: 'ev-2',
      month: 'JUN',
      day: '22',
      title: 'Youth Entrepreneurship Seminar',
      time: '11:00 AM',
      location: 'Lalitpur',
      imageUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=800&q=80',
      imageIcon: Icons.groups_2_rounded,
      imageColor: Color(0xFF34495E),
    ),
  ];

  static const List<_CommunityPost> _posts = [
    _CommunityPost(
      title: 'Mahila Sashaktikaran Program',
      timeAgo: '2d ago',
      imageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=400&q=80',
      imageIcon: Icons.diversity_1_rounded,
      imageColor: Color(0xFFD4A017),
    ),
    _CommunityPost(
      title: 'Tree Plantation Drive',
      timeAgo: '5d ago',
      imageUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=400&q=80',
      imageIcon: Icons.park_rounded,
      imageColor: Color(0xFF2E7D32),
    ),
    _CommunityPost(
      title: 'Business Networking Meet',
      timeAgo: '1w ago',
      imageUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=400&q=80',
      imageIcon: Icons.business_center_rounded,
      imageColor: Color(0xFF34495E),
    ),
    _CommunityPost(
      title: 'Teej Celebration',
      timeAgo: '2w ago',
      imageUrl: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=400&q=80',
      imageIcon: Icons.celebration_rounded,
      imageColor: Color(0xFF8E2A3B),
    ),
  ];

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
        bottom: false,
        child: Column(
          children: [
            // Top Header banner
            _TopHeader(
              onBellTap: () => _showNotificationsSheet(context),
              onProfileTap: () => context.push(AppConstants.profile),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    _HeroSection(
                      onBecomeMember: () => context.push(AppConstants.membershipSelector),
                      onExploreEvents: () => context.push(AppConstants.events),
                    ),
                    const SizedBox(height: 16),
                    _StatsRow(
                      onStatTap: (type) {
                        if (type == 'locations') {
                          context.go(AppConstants.locations);
                        } else if (type == 'events') {
                          context.go(AppConstants.events);
                        } else {
                          context.push(AppConstants.membershipSelector);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    _SectionHeader(
                      title: 'Upcoming Events',
                      onSeeAll: () => context.go(AppConstants.events),
                    ),
                    SizedBox(
                      height: 330,
                      child: PageView.builder(
                        controller: _eventPageController,
                        itemCount: _events.length,
                        onPageChanged: (i) => setState(() => _eventPage = i),
                        itemBuilder: (context, i) {
                          final event = _events[i];
                          return Padding(
                            padding: const EdgeInsets.only(left: 12, right: 6),
                            child: _EventCard(
                              event: event,
                              onViewDetails: () => context.push('/events/${event.id}'),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Page indicator dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_events.length, (i) {
                        final bool active = i == _eventPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: active ? 18 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: active ? AppColors.maroon : AppColors.cardBorder,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    _SectionHeader(
                      title: 'From Our Community',
                      onSeeAll: () => context.go(AppConstants.gallery),
                    ),
                    SizedBox(
                      height: 175,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _posts.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, i) => _CommunityCard(
                          post: _posts[i],
                          onTap: () => context.go(AppConstants.gallery),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _JoinBanner(
                      onBecomeMember: () => context.push(AppConstants.membershipSelector),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NASBottomNavBar(activeIndex: 0),
    );
  }
}

// ---------------------------------------------------------------------------
// NOTIFICATIONS BOTTOM SHEET
// ---------------------------------------------------------------------------
void _showNotificationsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notifications_active_rounded, color: AppColors.maroon, size: 24),
              const SizedBox(width: 8),
              const Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _notifTile(Icons.event_available_rounded, const Color(0xFFE3EEFD), const Color(0xFF2E6FE0),
              'Upcoming: Annual Heritage Gala', '2 days away • Kathmandu'),
          const Divider(height: 20),
          _notifTile(Icons.person_add_alt_1_rounded, const Color(0xFFE5F5E9), const Color(0xFF3E7C4A),
              'Membership Approved', 'Welcome to Nepal Agrawal Samaj!'),
          const Divider(height: 20),
          _notifTile(Icons.photo_library_rounded, const Color(0xFFEFE7FB), const Color(0xFF7B4FD6),
              'New Gallery Upload', '12 photos from Dashain 2025 added'),
          const SizedBox(height: 10),
        ],
      ),
    ),
  );
}

Widget _notifTile(IconData icon, Color bg, Color color, String title, String subtitle) {
  return Row(
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: color),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          ],
        ),
      ),
    ],
  );
}

// ---------------------------------------------------------------------------
// DATA MODELS
// ---------------------------------------------------------------------------
class _EventData {
  final String id;
  final String month;
  final String day;
  final String title;
  final String time;
  final String location;
  final String imageUrl;
  final IconData imageIcon;
  final Color imageColor;

  const _EventData({
    required this.id,
    required this.month,
    required this.day,
    required this.title,
    required this.time,
    required this.location,
    required this.imageUrl,
    required this.imageIcon,
    required this.imageColor,
  });
}

class _CommunityPost {
  final String title;
  final String timeAgo;
  final String imageUrl;
  final IconData imageIcon;
  final Color imageColor;

  const _CommunityPost({
    required this.title,
    required this.timeAgo,
    required this.imageUrl,
    required this.imageIcon,
    required this.imageColor,
  });
}

// ---------------------------------------------------------------------------
// TOP HEADER
// ---------------------------------------------------------------------------
class _TopHeader extends StatelessWidget {
  final VoidCallback onBellTap;
  final VoidCallback onProfileTap;

  const _TopHeader({required this.onBellTap, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.maroon,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular logo/emblem
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.creamLight,
              border: Border.all(color: AppColors.gold, width: 2),
            ),
            child: const Padding(
              padding: EdgeInsets.all(5.0),
              child: Icon(Icons.temple_hindu, color: AppColors.maroon, size: 28),
            ),
          ),
          const SizedBox(width: 12),
          // Title + tagline
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nepal Agrawal Samaj',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.5,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3),
                Text(
                  'Unity • Culture • Service • Progress',
                  style: TextStyle(
                    color: AppColors.goldLight,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Notification bell with badge
          _HeaderCircleIconButton(
            icon: Icons.notifications_none_rounded,
            badgeCount: 3,
            onTap: onBellTap,
          ),
          const SizedBox(width: 10),
          // Profile icon
          _HeaderCircleIconButton(
            icon: Icons.person_outline_rounded,
            onTap: onProfileTap,
          ),
        ],
      ),
    );
  }
}

class _HeaderCircleIconButton extends StatelessWidget {
  final IconData icon;
  final int? badgeCount;
  final VoidCallback onTap;

  const _HeaderCircleIconButton({
    required this.icon,
    required this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(icon, color: AppColors.maroon, size: 22),
          ),
          if (badgeCount != null && badgeCount! > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(3),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                decoration: BoxDecoration(
                  color: AppColors.pinkIcon,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    '$badgeCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// HERO SECTION
// ---------------------------------------------------------------------------
class _HeroSection extends StatelessWidget {
  final VoidCallback onBecomeMember;
  final VoidCallback onExploreEvents;

  const _HeroSection({required this.onBecomeMember, required this.onExploreEvents});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.creamLight, AppColors.creamDark],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative temple silhouette on the right
          Positioned(
            right: -10,
            bottom: 0,
            top: 20,
            child: Opacity(
              opacity: 0.9,
              child: Icon(
                Icons.temple_hindu,
                size: 190,
                color: AppColors.maroonDark.withValues(alpha: 0.85),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text('Namaste!',
                        style: TextStyle(
                          color: AppColors.maroon,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                    SizedBox(width: 6),
                    Text('👋', style: TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Together,',
                  style: TextStyle(
                    color: AppColors.maroon,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                const Text(
                  'We Grow',
                  style: TextStyle(
                    color: AppColors.maroon,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 12),
                const SizedBox(
                  width: 210,
                  child: Text(
                    'A united family working for culture, welfare, business growth and a better tomorrow.',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 13.5,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: onBecomeMember,
                      icon: const Icon(Icons.groups_rounded, size: 18, color: Colors.white),
                      label: const Text('Become a Member'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.maroon,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: onExploreEvents,
                      icon: const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.maroon),
                      label: const Text('Explore Events'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.maroon,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: AppColors.maroon, width: 1.3),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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

// ---------------------------------------------------------------------------
// STATS ROW
// ---------------------------------------------------------------------------
class _StatItem {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String value;
  final String label;
  final Color underlineColor;
  final String type;

  const _StatItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.underlineColor,
    required this.type,
  });
}

class _StatsRow extends StatelessWidget {
  final ValueChanged<String> onStatTap;

  const _StatsRow({required this.onStatTap});

  static const List<_StatItem> _stats = [
    _StatItem(
      icon: Icons.groups_rounded,
      iconBg: AppColors.pinkBg,
      iconColor: AppColors.pinkIcon,
      value: '2.4K+',
      label: 'Members',
      underlineColor: AppColors.pinkIcon,
      type: 'members',
    ),
    _StatItem(
      icon: Icons.location_on_rounded,
      iconBg: AppColors.amberBg,
      iconColor: AppColors.amberIcon,
      value: '18',
      label: 'Locations',
      underlineColor: AppColors.amberIcon,
      type: 'locations',
    ),
    _StatItem(
      icon: Icons.calendar_month_rounded,
      iconBg: AppColors.purpleBg,
      iconColor: AppColors.purpleIcon,
      value: '42+',
      label: 'Events (Yearly)',
      underlineColor: AppColors.purpleIcon,
      type: 'events',
    ),
    _StatItem(
      icon: Icons.workspace_premium_rounded,
      iconBg: AppColors.greenBg,
      iconColor: AppColors.greenIcon,
      value: '28+',
      label: 'Years of Service',
      underlineColor: AppColors.greenIcon,
      type: 'service',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(_stats.length, (i) {
          final s = _stats[i];
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == _stats.length - 1 ? 0 : 8),
              child: InkWell(
                onTap: () => onStatTap(s.type),
                borderRadius: BorderRadius.circular(16),
                child: _StatCard(stat: s),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final _StatItem stat;

  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: stat.iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(stat.icon, color: stat.iconColor, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            stat.value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            stat.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Container(
            width: 20,
            height: 3,
            decoration: BoxDecoration(
              color: stat.underlineColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SECTION HEADER
// ---------------------------------------------------------------------------
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          InkWell(
            onTap: onSeeAll,
            child: const Row(
              children: [
                Text(
                  'See all',
                  style: TextStyle(
                    color: AppColors.maroon,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 3),
                Icon(Icons.arrow_forward_rounded, size: 15, color: AppColors.maroon),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// EVENT CARD
// ---------------------------------------------------------------------------
class _EventCard extends StatelessWidget {
  final _EventData event;
  final VoidCallback onViewDetails;

  const _EventCard({required this.event, required this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image preview with date badge overlay
          Stack(
            children: [
              SizedBox(
                height: 130,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: event.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (ctx, url) => Container(
                    color: event.imageColor.withValues(alpha: 0.2),
                    child: Center(
                      child: Icon(event.imageIcon, size: 36, color: event.imageColor),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        event.month,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        event.day,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textGrey),
                    const SizedBox(width: 5),
                    Text(event.time,
                        style: const TextStyle(fontSize: 12.5, color: AppColors.textGrey)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textGrey),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(event.location,
                          style: const TextStyle(fontSize: 12.5, color: AppColors.textGrey),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: onViewDetails,
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.viewDetailsBg,
                      foregroundColor: AppColors.maroon,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('View Details',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 15),
                      ],
                    ),
                  ),
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
// COMMUNITY CARD
// ---------------------------------------------------------------------------
class _CommunityCard extends StatelessWidget {
  final _CommunityPost post;
  final VoidCallback onTap;

  const _CommunityCard({required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                height: 110,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: post.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (ctx, url) => Container(
                    color: post.imageColor.withValues(alpha: 0.2),
                    child: Icon(post.imageIcon, size: 34, color: post.imageColor),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              post.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              post.timeAgo,
              style: const TextStyle(fontSize: 11.5, color: AppColors.textLightGrey),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// JOIN BANNER
// ---------------------------------------------------------------------------
class _JoinBanner extends StatelessWidget {
  final VoidCallback onBecomeMember;

  const _JoinBanner({required this.onBecomeMember});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.joinBannerBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(Icons.diversity_3_rounded, color: AppColors.maroon, size: 26),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Join the Community',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.maroon,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Be a part of our family and help create a stronger impact together.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textGrey,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onBecomeMember,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.maroon,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Become a Member',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
