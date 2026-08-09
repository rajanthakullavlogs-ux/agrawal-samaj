import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/locations_repository.dart';

/// Location Profile / Details Screen — Redesigned to match exact UI spec
class LocationProfileScreen extends ConsumerWidget {
  final String locationId;

  const LocationProfileScreen({super.key, required this.locationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationName = _displayName(locationId);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: InkWell(
              onTap: () {
                if (GoRouter.of(context).canPop()) {
                  context.pop();
                } else {
                  context.go(AppConstants.locations);
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFFDF0F0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: Color(0xFF5C1414),
                  size: 22,
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          'Location Details',
          style: TextStyle(
            color: Color(0xFF5C1414),
            fontWeight: FontWeight.w700,
            fontSize: 19,
          ),
        ),
        actions: [
          // Notification Bell with Badge
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF5C1414), size: 24),
                onPressed: () => context.push(AppConstants.notifications),
              ),
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD93025),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(Icons.account_circle_outlined, color: Color(0xFF5C1414), size: 24),
              onPressed: () => context.push(AppConstants.profile),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SizedBox(height: 8),

          // Hero Banner Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 200,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Hero background photo
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: _heroImageUrl(locationId),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(color: const Color(0xFF5C1414)),
                    ),
                  ),
                  // Dark Gradient Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.2),
                            Colors.black.withValues(alpha: 0.85),
                          ],
                          stops: const [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Top-Left Round Pagoda Logo Badge
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/pagoda_logo_badge.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: const Color(0xFF5C1414),
                            child: const Icon(Icons.temple_hindu_rounded, color: Colors.white, size: 28),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Bottom-Left Location Title & Subtitle
                  Positioned(
                    left: 16,
                    bottom: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locationName,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _provinceName(locationId),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Information List Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFEAE4E0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Row 1: Location Address
                  _infoRow(
                    icon: Icons.location_on_outlined,
                    title: 'Location',
                    subtitle: '$locationName, ${_provinceName(locationId)}',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, color: Color(0xFFF3ECE7)),
                  ),

                  // Row 2: Location Admin Mail
                  _infoRow(
                    icon: Icons.mail_outline_rounded,
                    title: 'Location Admin Mail',
                    subtitle: '${locationId.toLowerCase()}@nepalagrawalsamaj.org',
                    actionWidget: const Icon(Icons.mail_outline_rounded, color: Color(0xFF5C1414), size: 22),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, color: Color(0xFFF3ECE7)),
                  ),

                  // Row 3: Location Head
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFDF0F0),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_outline_rounded, color: Color(0xFF5C1414), size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Location Head',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF5C1414),
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Rohit Agrawal',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: const [
                                Icon(Icons.call_rounded, size: 12, color: Color(0xFF6E645D)),
                                SizedBox(width: 4),
                                Text(
                                  '+977 9841234567',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6E645D),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Message Button
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF0F0),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.chat_bubble_outline_rounded, size: 14, color: Color(0xFF5C1414)),
                              SizedBox(width: 6),
                              Text(
                                'Message',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF5C1414),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Community Section ("Our Community in Kathmandu")
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFEAE4E0)),
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
                  Text(
                    'Our Community in $locationName',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF5C1414),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Active Youth Members
                      Expanded(
                        child: _communityStat(
                          icon: Icons.groups_rounded,
                          iconBg: const Color(0xFFE8EEFF),
                          iconColor: const Color(0xFF3B82F6),
                          number: '126',
                          numColor: const Color(0xFF1D4ED8),
                          label: 'Active Youth\nMembers',
                        ),
                      ),
                      Container(height: 50, width: 1, color: const Color(0xFFF0EAE6)),

                      // Women Leaders
                      Expanded(
                        child: _communityStat(
                          icon: Icons.person_pin_rounded,
                          iconBg: const Color(0xFFE6F4EA),
                          iconColor: const Color(0xFF1E8E3E),
                          number: '48',
                          numColor: const Color(0xFF1E8E3E),
                          label: 'Women\nLeaders',
                        ),
                      ),
                      Container(height: 50, width: 1, color: const Color(0xFFF0EAE6)),

                      // Girls Members
                      Expanded(
                        child: _communityStat(
                          icon: Icons.face_rounded,
                          iconBg: const Color(0xFFFCE8E6),
                          iconColor: const Color(0xFFD93025),
                          number: '86',
                          numColor: const Color(0xFFD93025),
                          label: 'Girls\nMembers',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Recent Events Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Events',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF5C1414),
                  ),
                ),
                InkWell(
                  onTap: () => context.go(AppConstants.events),
                  child: Row(
                    children: const [
                      Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF5C1414),
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF5C1414)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Events Horizontal Scroll
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                _EventCard(
                  eventId: 'ev-youth',
                  title: 'Youth Leadership\nWorkshop',
                  date: '20 Apr 2026',
                  location: 'Kathmandu',
                  imageUrl: 'https://images.unsplash.com/photo-1523580494863-6f3031224c94?auto=format&fit=crop&w=400&q=80',
                ),
                SizedBox(width: 12),
                _EventCard(
                  eventId: 'ev-women',
                  title: 'Women Empowerment\nSession',
                  date: '15 Mar 2026',
                  location: 'Kathmandu',
                  imageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=400&q=80',
                ),
                SizedBox(width: 12),
                _EventCard(
                  eventId: 'ev-business',
                  title: 'Business Networking\nMeet',
                  date: '25 Feb 2026',
                  location: 'Kathmandu',
                  imageUrl: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&w=400&q=80',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Gallery Highlights Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Gallery Highlights',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF5C1414),
                  ),
                ),
                InkWell(
                  onTap: () => context.go(AppConstants.gallery),
                  child: Row(
                    children: const [
                      Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF5C1414),
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF5C1414)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Gallery Highlights Horizontal Scroll
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                _GalleryThumb(imageUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=400&q=80', width: 140),
                SizedBox(width: 10),
                _GalleryThumb(imageUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=400&q=80', width: 130),
                SizedBox(width: 10),
                _GalleryThumb(imageUrl: 'https://images.unsplash.com/photo-1555244162-803834f70033?auto=format&fit=crop&w=400&q=80', width: 120),
                SizedBox(width: 10),
                _GalleryThumb(imageUrl: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=400&q=80', width: 80),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NASBottomNavBar(activeIndex: 2),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? actionWidget,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFFDF0F0),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF5C1414), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5C1414),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6E645D),
                ),
              ),
            ],
          ),
        ),
        if (actionWidget != null) actionWidget,
      ],
    );
  }

  Widget _communityStat({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String number,
    required Color numColor,
    required String label,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          number,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: numColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6E645D),
            height: 1.2,
          ),
        ),
      ],
    );
  }

  String _displayName(String id) {
    switch (id.toLowerCase()) {
      case 'biratnagar':
        return 'Biratnagar';
      case 'pokhara':
        return 'Pokhara';
      case 'butwal':
        return 'Butwal';
      case 'nepalgunj':
        return 'Nepalgunj';
      default:
        return 'Kathmandu';
    }
  }

  String _provinceName(String id) {
    switch (id.toLowerCase()) {
      case 'biratnagar':
        return 'Koshi Province, Nepal';
      case 'pokhara':
        return 'Gandaki Province, Nepal';
      case 'butwal':
        return 'Lumbini Province, Nepal';
      case 'nepalgunj':
        return 'Lumbini Province, Nepal';
      default:
        return 'Province No. 3, Nepal';
    }
  }

  String _heroImageUrl(String id) {
    switch (id.toLowerCase()) {
      case 'biratnagar':
        return 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=800&q=80';
      case 'pokhara':
        return 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=800&q=80';
      case 'butwal':
        return 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?auto=format&fit=crop&w=800&q=80';
      default:
        return 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=800&q=80';
    }
  }
}

class _EventCard extends StatelessWidget {
  final String eventId;
  final String title;
  final String date;
  final String location;
  final String imageUrl;

  const _EventCard({
    required this.eventId,
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/events/$eventId'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 170,
        clipBehavior: Clip.antiAlias,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(color: const Color(0xFFF3F0EE)),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      date,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 12, color: Color(0xFF5C1414)),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF6E645D),
                          ),
                        ),
                      ),
                      const Icon(Icons.calendar_today_outlined, size: 12, color: Color(0xFF6E645D)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GalleryThumb extends StatelessWidget {
  final String imageUrl;
  final double width;

  const _GalleryThumb({required this.imageUrl, required this.width});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: width,
        height: 90,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Container(color: const Color(0xFFF3F0EE)),
        ),
      ),
    );
  }
}
