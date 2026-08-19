import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../shared/widgets/widgets.dart';

/// Refactored AboutScreen (More Page) matching pixel-for-pixel the reference UI screenshot.
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Navigation Bar
            _MoreTopBar(
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppConstants.home);
                }
              },
              onNotification: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications opened')),
                );
              },
              onProfile: () => context.push(AppConstants.profile),
            ),
            const SizedBox(height: 16),

            // Samaj Header Banner Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SamajHeaderBanner(
                onTap: () => context.push(AppConstants.about),
              ),
            ),
            const SizedBox(height: 16),

            // Open Branch Admin Panel Shortcut Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => context.push(AppConstants.adminDashboard),
                  icon: const Icon(Icons.admin_panel_settings_rounded, size: 22, color: Color(0xFFE5C158)),
                  label: const Text(
                    'Open Branch Admin Panel',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      letterSpacing: 0.2,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF500913),
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shadowColor: const Color(0xFF500913).withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // "My Activity" Section Header & 3-Column Card
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'My Activity',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1615),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _MyActivityCard(
                onRegistrationsTap: () => context.push(AppConstants.events),
                onContributionsTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('My Contributions opened')),
                  );
                },
                onAnnouncementsTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Announcements & Notices opened')),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // "Community" Section Header & 4-Item List Card
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Community',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1615),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _CommunityCard(
                onBecomeMember: () => context.push(AppConstants.membershipSelector),
                onLeadership: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Leadership & Committee members opened')),
                  );
                },
                onPartners: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Our Partners & Sponsors opened')),
                  );
                },
                onAchievements: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Milestones & Achievements opened')),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // "Support & Info" Section Header, 4-Card Row & Bottom Action Bar
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Support & Info',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1615),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SupportAndInfoGrid(
                onAboutUs: () => context.push(AppConstants.about),
                onContactUs: () => context.push(AppConstants.contact),
                onHelpFaq: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Help & FAQ opened')),
                  );
                },
                onPrivacyTerms: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Privacy Policy & Terms opened')),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Bottom Quick Actions Bar (Share App / Rate Us / Report Issue)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _QuickActionsBar(
                onShare: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share Nepal Agrawal Samaj App link copied!')),
                  );
                },
                onRate: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Rating dialog opened')),
                  );
                },
                onReport: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report an Issue form opened')),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: const NASBottomNavBar(activeIndex: 4),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. TOP NAVIGATION BAR (MORE, BELL BADGE, PROFILE)
// ---------------------------------------------------------------------------
class _MoreTopBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onNotification;
  final VoidCallback onProfile;

  const _MoreTopBar({
    required this.onBack,
    required this.onNotification,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF9F7F5),
      padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFF0EAE8),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF500913), size: 20),
            ),
          ),

          // Title
          const Text(
            'More',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFF500913),
              letterSpacing: -0.3,
            ),
          ),

          // Right Actions: Notification Bell + Profile Circle
          Row(
            children: [
              GestureDetector(
                onTap: onNotification,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0EAE8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications_outlined, color: Color(0xFF500913), size: 20),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53935),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: onProfile,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_outline_rounded, color: Color(0xFF500913), size: 18),
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
// 2. SAMAJ HEADER BANNER CARD
// ---------------------------------------------------------------------------
class _SamajHeaderBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _SamajHeaderBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF6B0E1B),
              Color(0xFF3F050C),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6B0E1B).withValues(alpha: 0.30),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main Banner Content Padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Circular Emblem Logo Box
                  Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF700D15), width: 1.5),
                        ),
                        child: const Center(
                          child: Icon(Icons.account_balance_rounded, color: Color(0xFF700D15), size: 24),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Title & Tagline
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Nepal Agrawal Samaj',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Together for Community,\nGrowth & Prosperity',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Colors.white70,
                            fontWeight: FontWeight.w400,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right Chevron Arrow
                  const Icon(Icons.chevron_right_rounded, color: Colors.white70, size: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. MY ACTIVITY SECTION (SYMMETRICAL 3-COLUMN CARD)
// ---------------------------------------------------------------------------
class _MyActivityCard extends StatelessWidget {
  final VoidCallback onRegistrationsTap;
  final VoidCallback onContributionsTap;
  final VoidCallback onAnnouncementsTap;

  const _MyActivityCard({
    required this.onRegistrationsTap,
    required this.onContributionsTap,
    required this.onAnnouncementsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5D0D0), width: 0.9),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF500913).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Column 1: Registrations
            Expanded(
              child: _buildSymmetricalColumn(
                icon: Icons.event_available_rounded,
                iconBg: const Color(0xFFFDF0F0),
                iconColor: const Color(0xFF700D15),
                badgeText: 'Events',
                title: 'Registrations',
                subtitle: 'Registered\npasses & events',
                onTap: onRegistrationsTap,
              ),
            ),
            const VerticalDivider(width: 1, color: Color(0xFFE5D0D0), thickness: 0.8, indent: 4, endIndent: 4),

            // Column 2: Contributions
            Expanded(
              child: _buildSymmetricalColumn(
                icon: Icons.volunteer_activism_rounded,
                iconBg: const Color(0xFFF0EEFF),
                iconColor: const Color(0xFF6B4FD6),
                badgeText: 'Activity',
                title: 'Contributions',
                subtitle: 'Community\nparticipations',
                onTap: onContributionsTap,
              ),
            ),
            const VerticalDivider(width: 1, color: Color(0xFFE5D0D0), thickness: 0.8, indent: 4, endIndent: 4),

            // Column 3: Announcements
            Expanded(
              child: _buildSymmetricalColumn(
                icon: Icons.campaign_rounded,
                iconBg: const Color(0xFFFFF4E8),
                iconColor: const Color(0xFFE67E22),
                badgeText: 'Notices',
                title: 'Announcements',
                subtitle: 'Official news\n& updates',
                onTap: onAnnouncementsTap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymmetricalColumn({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String badgeText,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon in rounded tile
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 8),

            // Title
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1615),
                  letterSpacing: -0.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 3),

            // Subtitle
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w400,
                color: Color(0xFF756A67),
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. COMMUNITY SECTION (4 LIST ITEMS CARD)
// ---------------------------------------------------------------------------
class _CommunityCard extends StatelessWidget {
  final VoidCallback onBecomeMember;
  final VoidCallback onLeadership;
  final VoidCallback onPartners;
  final VoidCallback onAchievements;

  const _CommunityCard({
    required this.onBecomeMember,
    required this.onLeadership,
    required this.onPartners,
    required this.onAchievements,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5D0D0), width: 0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildItem(
            icon: Icons.people_outline_rounded,
            iconBg: const Color(0xFFFDF0F0),
            iconColor: const Color(0xFF700D15),
            title: 'Become a Member',
            subtitle: 'Join our community and make an impact',
            onTap: onBecomeMember,
            isTop: true,
          ),
          const Divider(height: 1, color: Color(0xFFF0EAE8), indent: 64),
          _buildItem(
            icon: Icons.person_outline_rounded,
            iconBg: const Color(0xFFF0EEFF),
            iconColor: const Color(0xFF6B4FD6),
            title: 'Our Leadership',
            subtitle: 'Meet our leaders and committee members',
            onTap: onLeadership,
          ),
          const Divider(height: 1, color: Color(0xFFF0EAE8), indent: 64),
          _buildItem(
            icon: Icons.handshake_outlined,
            iconBg: const Color(0xFFEEF7F2),
            iconColor: const Color(0xFF27AE60),
            title: 'Our Partners',
            subtitle: 'Organizations and partners who support us',
            onTap: onPartners,
          ),
          const Divider(height: 1, color: Color(0xFFF0EAE8), indent: 64),
          _buildItem(
            icon: Icons.star_outline_rounded,
            iconBg: const Color(0xFFFFF4E8),
            iconColor: const Color(0xFFE67E22),
            title: 'Achievements',
            subtitle: 'Milestones and accomplishments',
            onTap: onAchievements,
            isBottom: true,
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isTop = false,
    bool isBottom = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1615),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF8C7A75), size: 20),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5. SUPPORT & INFO GRID (4 CARDS ROW)
// ---------------------------------------------------------------------------
class _SupportAndInfoGrid extends StatelessWidget {
  final VoidCallback onAboutUs;
  final VoidCallback onContactUs;
  final VoidCallback onHelpFaq;
  final VoidCallback onPrivacyTerms;

  const _SupportAndInfoGrid({
    required this.onAboutUs,
    required this.onContactUs,
    required this.onHelpFaq,
    required this.onPrivacyTerms,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Card 1: About Us
        Expanded(
          child: _buildCard(
            icon: Icons.info_outline_rounded,
            iconBg: const Color(0xFFE8F4FE),
            iconColor: const Color(0xFF2980B9),
            title: 'About Us',
            subtitle: 'Our mission\nand vision',
            onTap: onAboutUs,
          ),
        ),
        const SizedBox(width: 8),

        // Card 2: Contact Us
        Expanded(
          child: _buildCard(
            icon: Icons.article_outlined,
            iconBg: const Color(0xFFFDF0F0),
            iconColor: const Color(0xFF700D15),
            title: 'Contact Us',
            subtitle: 'Get in touch\nwith us',
            onTap: onContactUs,
          ),
        ),
        const SizedBox(width: 8),

        // Card 3: Help & FAQ
        Expanded(
          child: _buildCard(
            icon: Icons.help_outline_rounded,
            iconBg: const Color(0xFFF0EEFF),
            iconColor: const Color(0xFF6B4FD6),
            title: 'Help & FAQ',
            subtitle: 'Find answers to\ncommon questions',
            onTap: onHelpFaq,
          ),
        ),
        const SizedBox(width: 8),

        // Card 4: Privacy & Terms
        Expanded(
          child: _buildCard(
            icon: Icons.shield_outlined,
            iconBg: const Color(0xFFEEF7F2),
            iconColor: const Color(0xFF27AE60),
            title: 'Privacy &\nTerms',
            subtitle: 'Policies and\nterms',
            onTap: onPrivacyTerms,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5D0D0), width: 0.9),
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
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1615),
                height: 1.15,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w400,
                color: Color(0xFF666666),
                height: 1.15,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. QUICK ACTIONS BAR (SHARE APP / RATE US / REPORT ISSUE)
// ---------------------------------------------------------------------------
class _QuickActionsBar extends StatelessWidget {
  final VoidCallback onShare;
  final VoidCallback onRate;
  final VoidCallback onReport;

  const _QuickActionsBar({
    required this.onShare,
    required this.onRate,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF2F0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5D0D0), width: 0.9),
      ),
      child: Row(
        children: [
          // Column 1: Share App
          Expanded(
            child: _buildActionColumn(
              icon: Icons.shortcut_rounded,
              title: 'Share App',
              subtitle: 'Invite your friends',
              onTap: onShare,
            ),
          ),
          Container(width: 1, height: 40, color: const Color(0xFFE5D0D0)),

          // Column 2: Rate Us
          Expanded(
            child: _buildActionColumn(
              icon: Icons.star_outline_rounded,
              title: 'Rate Us',
              subtitle: 'Let us know your\nfeedback',
              onTap: onRate,
            ),
          ),
          Container(width: 1, height: 40, color: const Color(0xFFE5D0D0)),

          // Column 3: Report an Issue
          Expanded(
            child: _buildActionColumn(
              icon: Icons.error_outline_rounded,
              title: 'Report an Issue',
              subtitle: 'Help us improve\nour app',
              onTap: onReport,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionColumn({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF700D15), size: 22),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1615),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF666666),
                    height: 1.15,
                  ),
                  maxLines: 2,
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
