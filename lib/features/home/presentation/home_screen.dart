import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../shared/widgets/widgets.dart';

/// Refactored HomeScreen matching the exact pixel-perfect design provided in screenshot.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _eventPageController = PageController(viewportFraction: 0.88);
  int _eventPageIndex = 0;

  @override
  void dispose() {
    _eventPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Burgundy Curved Header + Hero Banner Card
            _HeaderSection(
              onBellTap: () => context.push(AppConstants.notifications),
              onProfileTap: () => context.push(AppConstants.profile),
              onBecomeMember: () => context.push(AppConstants.membershipSelector),
              onExploreEvents: () => context.push(AppConstants.events),
            ),
            const SizedBox(height: 20),

            // 4 Stats Cards (Spacious 2x2 Grid)
            const _StatsRow(),
            const SizedBox(height: 28),

            // Upcoming Events Section
            _UpcomingEventsSection(
              controller: _eventPageController,
              currentIndex: _eventPageIndex,
              onPageChanged: (i) => setState(() => _eventPageIndex = i),
            ),
            const SizedBox(height: 28),

            // From Our Community Section
            const _FromOurCommunitySection(),
            const SizedBox(height: 28),

            // Join the Community Banner Card
            _JoinCommunityBanner(
              onBecomeMember: () => context.push(AppConstants.membershipSelector),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
      bottomNavigationBar: const NASBottomNavBar(activeIndex: 0),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. BURGUNDY HEADER + HERO BANNER CARD
// ---------------------------------------------------------------------------
class _HeaderSection extends StatelessWidget {
  final VoidCallback onBellTap;
  final VoidCallback onProfileTap;
  final VoidCallback onBecomeMember;
  final VoidCallback onExploreEvents;

  const _HeaderSection({
    required this.onBellTap,
    required this.onProfileTap,
    required this.onBecomeMember,
    required this.onExploreEvents,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Column(
      children: [
        // Top Deep Burgundy Bar Header
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(16, topPadding + 6, 16, 14),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6B0E1B), Color(0xFF500913), Color(0xFF3F050C)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header Row (Logo + Title/Subtitle + Action Buttons)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Circular Emblem Logo
                  const _HeaderLogo(),
                  const SizedBox(width: 8),

                  // Organization Name & Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Nepal Agrawal Samaj',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.1,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Unity • Culture • Service • Progress',
                          style: TextStyle(
                            color: Color(0xFFE5C158),
                            fontSize: 9.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Notification Bell & Profile Buttons
                  Row(
                    children: [
                      // Bell Button with Red Badge "3"
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          InkWell(
                            onTap: onBellTap,
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.notifications_none_rounded,
                                color: Color(0xFF500913),
                                size: 18,
                              ),
                            ),
                          ),
                          Positioned(
                            top: -1,
                            right: -1,
                            child: Container(
                              padding: const EdgeInsets.all(2.5),
                              decoration: const BoxDecoration(
                                color: Color(0xFFE53935),
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 14,
                                minHeight: 14,
                              ),
                              child: const Text(
                                '3',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),

                      // Profile Button
                      InkWell(
                        onTap: onProfileTap,
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_outline_rounded,
                            color: Color(0xFF500913),
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        // Hero Card overlapping top burgundy header slightly for seamless depth
        Transform.translate(
          offset: const Offset(0, -10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
                  children: [
                    // Background Cream Gradient
                    Container(
                      height: 240,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFFFBF4), Color(0xFFF9F0E0)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),

                    // Right Pagoda Temple Image with smooth multi-stop fade
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      width: MediaQuery.of(context).size.width * 0.58,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/pagoda_header_bg.png',
                            fit: BoxFit.cover,
                            alignment: Alignment.centerRight,
                            errorBuilder: (context, error, stackTrace) => CachedNetworkImage(
                              imageUrl:
                                  'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=1000&q=80',
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Multi-stop Linear Gradient overlay fading into cream left content
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFFFFBF4),
                                  const Color(0xFFFFFBF4).withValues(alpha: 0.90),
                                  const Color(0xFFFFFBF4).withValues(alpha: 0.25),
                                  Colors.transparent,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: const [0.0, 0.22, 0.52, 1.0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Left Content (Greeting, Headline, Subtext & Action Buttons)
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Namaste! 👋
                          const Text(
                            'Namaste! 👋',
                            style: TextStyle(
                              color: Color(0xFF700D15),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Together, We Grow
                          const Text(
                            'Together,',
                            style: TextStyle(
                              color: Color(0xFF500913),
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              height: 1.05,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const Text(
                            'We Grow',
                            style: TextStyle(
                              color: Color(0xFF500913),
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              height: 1.05,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Subtitle Text
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.54,
                            child: const Text(
                              'A united family working for culture, welfare, business growth and a better tomorrow.',
                              style: TextStyle(
                                color: Color(0xFF5A4540),
                                fontSize: 11,
                                height: 1.35,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Single Primary Action Button: Explore Events
                          GestureDetector(
                            onTap: onExploreEvents,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF8B1222), Color(0xFF6B0E1B)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF6B0E1B).withValues(alpha: 0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.calendar_month_rounded, color: Colors.white, size: 15),
                                  SizedBox(width: 6),
                                  Text(
                                    'Explore Events',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 14),
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
          ),
        ),
      ],
    );
  }
}

// Circular Crest Emblem Logo
class _HeaderLogo extends StatelessWidget {
  const _HeaderLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF700D15),
        border: Border.all(color: const Color(0xFFE5C158), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 3,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: Image.asset(
          'assets/images/pagoda_logo_badge.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Icon(
              Icons.account_balance_rounded,
              color: const Color(0xFFE5C158),
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// 2. STATS ROW (Spacious 2x2 Grid Cards)
// ---------------------------------------------------------------------------
class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                child: _StatCard(
                  icon: Icons.groups_rounded,
                  iconBg: Color(0xFFFDE8E8),
                  iconColor: Color(0xFFE53935),
                  value: '2.4K+',
                  label: 'Members',
                  accentLineColor: Color(0xFFE53935),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  icon: Icons.location_on_rounded,
                  iconBg: Color(0xFFFFF4D8),
                  iconColor: Color(0xFFD99B00),
                  value: '18',
                  label: 'Locations',
                  accentLineColor: Color(0xFFD99B00),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Expanded(
                child: _StatCard(
                  icon: Icons.calendar_month_rounded,
                  iconBg: Color(0xFFF3E8FF),
                  iconColor: Color(0xFF8E24AA),
                  value: '42+',
                  label: 'Events (Yearly)',
                  accentLineColor: Color(0xFF8E24AA),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  icon: Icons.workspace_premium_rounded,
                  iconBg: Color(0xFFE8F5E9),
                  iconColor: Color(0xFF2E7D32),
                  value: '28+',
                  label: 'Years of Service',
                  accentLineColor: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String value;
  final String label;
  final Color accentLineColor;

  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.accentLineColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0E8E6), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular Icon Container
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),

          // Value and Label Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1F1210),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
// 3. UPCOMING EVENTS SECTION
// ---------------------------------------------------------------------------
class _UpcomingEventsSection extends StatelessWidget {
  final PageController controller;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const _UpcomingEventsSection({
    required this.controller,
    required this.currentIndex,
    required this.onPageChanged,
  });

  static const _events = [
    (
      title: 'Guru Purnima Satsang',
      dateMonth: 'MAY',
      dateDay: '25',
      time: '5:00 PM',
      location: 'Kathmandu',
      imageUrl: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=600&q=80',
    ),
    (
      title: 'Blood Donation Camp',
      dateMonth: 'JUN',
      dateDay: '08',
      time: '10:00 AM',
      location: 'Biratnagar Branch',
      imageUrl: 'https://images.unsplash.com/photo-1615461066841-6116e61058f4?auto=format&fit=crop&w=600&q=80',
    ),
    (
      title: 'Youth Entrepreneurship Seminar',
      dateMonth: 'JUN',
      dateDay: '22',
      time: '11:00 AM',
      location: 'Lalitpur',
      imageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=600&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: const Color(0xFF700D15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Upcoming Events',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E1615),
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => context.go(AppConstants.events),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF700D15).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF700D15),
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(Icons.arrow_forward_rounded, size: 12, color: Color(0xFF700D15)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal List of Cards
        SizedBox(
          height: 198,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _events.length,
            itemBuilder: (context, i) {
              final ev = _events[i];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: 160,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Image + Date Badge Overlay
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: SizedBox(
                                height: 96,
                                width: double.infinity,
                                child: CachedNetworkImage(
                                  imageUrl: ev.imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(color: const Color(0xFFF0F0F0)),
                                  errorWidget: (context, url, error) => Container(
                                    color: const Color(0xFFE5D5D5),
                                    child: const Icon(Icons.event, color: Color(0xFF700D15)),
                                  ),
                                ),
                              ),
                            ),

                            // Date Badge Overlay (Top-Left)
                            Positioned(
                              top: 6,
                              left: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xEE221B1C),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      ev.dateMonth,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    Text(
                                      ev.dateDay,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        height: 1.05,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Card Details Body
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                ev.title,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E1615),
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.access_time_outlined, size: 11, color: Color(0xFF8C7A75)),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    child: Text(
                                      ev.time,
                                      style: const TextStyle(fontSize: 10, color: Color(0xFF757575), fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 11, color: Color(0xFF8C7A75)),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    child: Text(
                                      ev.location,
                                      style: const TextStyle(fontSize: 10, color: Color(0xFF757575), fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // View Details Pill Button
                              GestureDetector(
                                onTap: () => context.go(AppConstants.events),
                                child: Container(
                                  width: double.infinity,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFDEAEA),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'View Details',
                                        style: TextStyle(
                                          color: Color(0xFF700D15),
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(width: 3),
                                      Icon(Icons.arrow_forward_rounded, size: 11, color: Color(0xFF700D15)),
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
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // Indicator Bars matching screenshot (Active Maroon Bar + Inactive Grey Bar)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF700D15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 16,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 4. FROM OUR COMMUNITY SECTION
// ---------------------------------------------------------------------------
class _FromOurCommunitySection extends StatelessWidget {
  const _FromOurCommunitySection();

  static const _items = [
    (
      title: 'Mahila Sashaktikaran Program',
      timeAgo: '2d ago',
      imageUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=500&q=80',
    ),
    (
      title: 'Tree Plantation Drive',
      timeAgo: '5d ago',
      imageUrl: 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?auto=format&fit=crop&w=500&q=80',
    ),
    (
      title: 'Business Networking Meet',
      timeAgo: '1w ago',
      imageUrl: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&w=500&q=80',
    ),
    (
      title: 'Teej Celebration',
      timeAgo: '2w ago',
      imageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=500&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: const Color(0xFF700D15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'From Our Community',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E1615),
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => context.go(AppConstants.gallery),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF700D15).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF700D15),
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(Icons.arrow_forward_rounded, size: 12, color: Color(0xFF700D15)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal List of Cards
        SizedBox(
          height: 170,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _items.length,
            itemBuilder: (context, i) {
              final item = _items[i];
              return Container(
                width: 155,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                      child: SizedBox(
                        height: 95,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: item.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E1615),
                              height: 1.25,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.timeAgo,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF9E9E9E),
                              fontWeight: FontWeight.w500,
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
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 5. JOIN THE COMMUNITY BANNER
// ---------------------------------------------------------------------------
class _JoinCommunityBanner extends StatelessWidget {
  final VoidCallback onBecomeMember;

  const _JoinCommunityBanner({required this.onBecomeMember});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFF4F4), Color(0xFFFCEBEB)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF7D5D5), width: 0.8),
        ),
        child: Row(
          children: [
            // Left Group Icon Container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFFADCDC),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFEAAFAF), width: 1),
              ),
              child: const Icon(
                Icons.groups_rounded,
                color: Color(0xFF700D15),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),

            // Middle Text Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Join the Community',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF500913),
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Be a part of our family and help create a stronger impact together.',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF6E5D5A),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Right Become a Member Pill Button
            GestureDetector(
              onTap: onBecomeMember,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: const Color(0xFF700D15),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF700D15).withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Become a Member',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 3),
                    Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
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
