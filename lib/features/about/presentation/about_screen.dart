import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/design_tokens.dart';
import '../../../shared/widgets/widgets.dart';

/// Screen 2 — More Screen (Public Site)
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _quickLinks = [
    (icon: Icons.card_membership_rounded, title: 'Membership', subtitle: 'Join & Benefits', route: AppConstants.membershipSelector),
    (icon: Icons.event_note_rounded, title: 'Events', subtitle: 'All Events', route: AppConstants.events),
    (icon: Icons.newspaper_rounded, title: 'News & Updates', subtitle: 'Latest News', route: null),
    (icon: Icons.volunteer_activism_rounded, title: 'Donations', subtitle: 'Support Us', route: null),
    (icon: Icons.campaign_rounded, title: 'Notice Board', subtitle: 'Announcements', route: null),
    (icon: Icons.groups_rounded, title: 'Leadership', subtitle: 'Our Team', route: null),
    (icon: Icons.description_rounded, title: 'Documents', subtitle: 'Downloads', route: null),
    (icon: Icons.help_outline_rounded, title: 'FAQs', subtitle: 'Common Questions', route: null),
    (icon: Icons.support_agent_rounded, title: 'Contact Us', subtitle: 'Get in Touch', route: AppConstants.contact),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const NASAppBar(title: 'About Us', showBackButton: true),
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
                  'About Us',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    fontFamily: NASTypography.headlineFont,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Explore more about Nepal Agrawal Samaj',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),

                const Text('Quick Links', style: AppText.h2),
                const SizedBox(height: 12),

                // 3x3 Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _quickLinks.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (context, i) {
                    final item = _quickLinks[i];
                    return GestureDetector(
                      onTap: () {
                        if (item.route != null) {
                          context.go(item.route!);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(color: AppColors.border),
                          boxShadow: AppShadow.card,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(item.icon, color: AppColors.primary, size: 24),
                            const SizedBox(height: 6),
                            Text(
                              item.title,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11.5),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.subtitle,
                              style: TextStyle(fontSize: 9.5, color: Colors.grey.shade600),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // "Be Part of Our Mission" Saffron Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accentLight,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Be Part of Our Mission',
                              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Together we can build a stronger community.',
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 11),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text('Donate Now', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                                  SizedBox(width: 4),
                                  Icon(Icons.arrow_forward_rounded, size: 12),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.volunteer_activism_rounded, size: 54, color: AppColors.accent),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Follow Us
                const Text('Follow Us', style: AppText.h2),
                const SizedBox(height: 4),
                Text('Stay connected on our social media', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(height: 12),

                Row(
                  children: [
                    _socialButton(Icons.facebook_rounded, Colors.blue.shade800),
                    const SizedBox(width: 10),
                    _socialButton(Icons.camera_alt_rounded, Colors.pink.shade600),
                    const SizedBox(width: 10),
                    _socialButton(Icons.play_arrow_rounded, Colors.red.shade700),
                    const SizedBox(width: 10),
                    _socialButton(Icons.flutter_dash_rounded, Colors.lightBlue.shade600),
                    const SizedBox(width: 10),
                    _socialButton(Icons.work_rounded, Colors.blue.shade900),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NASBottomNavBar(activeIndex: 4),
    );
  }

  Widget _socialButton(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
