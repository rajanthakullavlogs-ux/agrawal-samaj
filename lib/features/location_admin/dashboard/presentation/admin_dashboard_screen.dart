import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/widgets.dart';

/// B1 — Location Admin Dashboard Screen
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NASAppBar(title: 'Kathmandu Branch Admin'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.md),
                  const Text('Namaste, Administrator', style: AppText.h1),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Manage the Kathmandu chapter\'s activities, members, and upcoming cultural gatherings.',
                    style: AppText.body,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Stat cards 2x2 grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: const [
                      _AdminMetricCard(
                        icon: Icons.people_rounded,
                        value: '1,248',
                        label: 'Total Members',
                        color: AppColors.primary,
                      ),
                      _AdminMetricCard(
                        icon: Icons.check_circle_rounded,
                        value: '856',
                        label: 'Active Members',
                        color: Colors.green,
                      ),
                      _AdminMetricCard(
                        icon: Icons.event_rounded,
                        value: '12',
                        label: 'Upcoming Events',
                        color: AppColors.accent,
                      ),
                      _AdminMetricCard(
                        icon: Icons.history_rounded,
                        value: '342',
                        label: 'Past Events',
                        color: AppColors.gold,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Quick Admin Actions
                  const Text('Quick Actions', style: AppText.h2),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionTile(
                          icon: Icons.person_add_rounded,
                          title: 'Approve Members',
                          onTap: () => context.go(AppConstants.adminMembers),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ActionTile(
                          icon: Icons.event_available_rounded,
                          title: 'Create Event',
                          onTap: () => context.go(AppConstants.adminEvents),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Recent Activities section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent Activities', style: AppText.h2),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      boxShadow: AppShadow.card,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: const [
                        _ActivityItem(
                          icon: Icons.person_add_rounded,
                          title: 'New Member Registration',
                          time: '10 minutes ago',
                          desc: 'Rajesh Agrawal applied for Individual Membership.',
                        ),
                        Divider(color: AppColors.divider),
                        _ActivityItem(
                          icon: Icons.event_rounded,
                          title: 'Event RSVP Update',
                          time: '2 hours ago',
                          desc: '45 new registrations for Teej Festival 2026.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminMetricCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _AdminMetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadow.card,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppText.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final String desc;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.time,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.accentLight,
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: AppText.h3),
                    Text(time, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(desc, style: AppText.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
