import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../shared/widgets/widgets.dart';

/// Notifications Screen — Redesigned to match exact reference spec pixel-for-pixel
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  String _selectedFilter = 'All'; // 'All', 'Unread', 'Mentions'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F6),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Deep Burgundy Top Header Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF500913),
              ),
              padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, 24),
              child: Column(
                children: [
                  // App Bar Row (Back Arrow + Title + Settings Gear)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          if (GoRouter.of(context).canPop()) {
                            context.pop();
                          } else {
                            context.go(AppConstants.home);
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
                        onPressed: () => _showNotificationSettingsModal(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Floating Segmented Filter Bar Container Overlapping Header
            Transform.translate(
              offset: const Offset(0, -14),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0EC),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // All Filter
                      Expanded(
                        child: _FilterSegment(
                          icon: Icons.notifications_active_outlined,
                          label: 'All',
                          isSelected: _selectedFilter == 'All',
                          onTap: () => setState(() => _selectedFilter = 'All'),
                        ),
                      ),
                      // Unread Filter
                      Expanded(
                        child: _FilterSegment(
                          icon: Icons.mail_outline_rounded,
                          label: 'Unread',
                          isSelected: _selectedFilter == 'Unread',
                          onTap: () => setState(() => _selectedFilter = 'Unread'),
                        ),
                      ),
                      // Mentions Filter
                      Expanded(
                        child: _FilterSegment(
                          icon: Icons.alternate_email_rounded,
                          label: 'Mentions',
                          isSelected: _selectedFilter == 'Mentions',
                          onTap: () => setState(() => _selectedFilter = 'Mentions'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Content Sections
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),

                  // Section 1: Recent
                  if (_selectedFilter == 'All' || _selectedFilter == 'Unread') ...[
                    const Text(
                      'Recent',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6E645D),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
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
                          _NotificationItemTile(
                            icon: Icons.event_note_rounded,
                            iconBg: const Color(0xFFFDF0F0),
                            iconColor: const Color(0xFF700D15),
                            title: 'New Event Added',
                            subtitle: 'Agrawal Yuva Sammelan 2081 is scheduled on 15 Nov 2081.',
                            timeStr: '10:30 AM',
                            isUnread: true,
                            onTap: () => context.push('/events/ev-2'),
                          ),
                          const Divider(height: 1, color: Color(0xFFF3ECE7)),
                          _NotificationItemTile(
                            icon: Icons.people_outline_rounded,
                            iconBg: const Color(0xFFFFF8E7),
                            iconColor: const Color(0xFF9A7818),
                            title: 'New Member Registered',
                            subtitle: 'A new member has joined Kathmandu location.',
                            timeStr: '9:15 AM',
                            isUnread: true,
                            onTap: () => context.push(AppConstants.locations),
                          ),
                          const Divider(height: 1, color: Color(0xFFF3ECE7)),
                          _NotificationItemTile(
                            icon: Icons.image_outlined,
                            iconBg: const Color(0xFFF3E8FF),
                            iconColor: const Color(0xFF7E22CE),
                            title: 'Photos Added to Gallery',
                            subtitle: 'New photos from “Diwali Milan 2081” have been added.',
                            timeStr: '8:45 AM',
                            isUnread: true,
                            onTap: () => context.push(AppConstants.gallery),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Section 2: Earlier
                  if (_selectedFilter == 'All') ...[
                    const Text(
                      'Earlier',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6E645D),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
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
                          _NotificationItemTile(
                            icon: Icons.campaign_outlined,
                            iconBg: const Color(0xFFE6F4EA),
                            iconColor: const Color(0xFF1E8E3E),
                            title: 'Important Announcement',
                            subtitle: 'Annual General Meeting will be held on 25 Aug 2081.',
                            timeStr: 'Yesterday\n6:30 PM',
                            isUnread: false,
                            onTap: () {},
                          ),
                          const Divider(height: 1, color: Color(0xFFF3ECE7)),
                          _NotificationItemTile(
                            icon: Icons.location_on_outlined,
                            iconBg: const Color(0xFFE8EEFF),
                            iconColor: const Color(0xFF1D4ED8),
                            title: 'Location Update',
                            subtitle: 'Pokhara location has updated their contact information.',
                            timeStr: 'Yesterday\n2:10 PM',
                            isUnread: false,
                            onTap: () => context.push('/locations/pokhara'),
                          ),
                          const Divider(height: 1, color: Color(0xFFF3ECE7)),
                          _NotificationItemTile(
                            icon: Icons.favorite_border_rounded,
                            iconBg: const Color(0xFFFCEAEA),
                            iconColor: const Color(0xFF700D15),
                            title: 'Thank You!',
                            subtitle: 'Thank you to all members who participated in Blood Donation Drive.',
                            timeStr: '12 Aug 2081',
                            isUnread: false,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Section 3: You're all caught up Banner Card
                  Container(
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
                    child: Row(
                      children: [
                        // Maroon Checkmark Circle
                        Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                            color: Color(0xFF700D15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 14),
                        // Title & Subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "You're all caught up!",
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E1615),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'No new notifications',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6E645D),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Golden Bell Graphic
                        Image.asset(
                          'assets/images/notification_bell_caught_up.png',
                          height: 48,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.notifications_active_rounded,
                            color: Color(0xFFD97706),
                            size: 36,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100), // Bottom space above navigation bar
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NASBottomNavBar(activeIndex: 4),
    );
  }

  void _showNotificationSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.tune_rounded, color: Color(0xFF700D15)),
                  const SizedBox(width: 8),
                  const Text('Notification Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Event Alerts', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                subtitle: const Text('Get notified when new events are posted'),
                value: true,
                activeColor: const Color(0xFF700D15),
                onChanged: (v) {},
              ),
              SwitchListTile(
                title: const Text('Member Updates', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                subtitle: const Text('New member join requests & directory updates'),
                value: true,
                activeColor: const Color(0xFF700D15),
                onChanged: (v) {},
              ),
              SwitchListTile(
                title: const Text('Gallery Uploads', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                subtitle: const Text('Alerts when new photo albums are added'),
                value: false,
                activeColor: const Color(0xFF700D15),
                onChanged: (v) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterSegment extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterSegment({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 38,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF700D15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF6E645D),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF1E1615),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItemTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String timeStr;
  final bool isUnread;
  final VoidCallback onTap;

  const _NotificationItemTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.timeStr,
    required this.isUnread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Category Icon Badge
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 12),

            // Middle Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1615),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6E645D),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Right Timestamp & Red Dot / Chevron
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeStr,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8C7A75),
                  ),
                ),
                const SizedBox(height: 8),
                if (isUnread)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD93025),
                      shape: BoxShape.circle,
                    ),
                  )
                else
                  const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF9CA3AF)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
