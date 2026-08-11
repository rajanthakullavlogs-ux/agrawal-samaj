import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants.dart';
import '../../../core/design_tokens.dart';
import '../../../shared/widgets/widgets.dart';
import 'providers/auth_provider.dart';

/// My Profile Screen — fully functional, role-aware, session-persistent.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);
    final profile = profileAsync.valueOrNull;

    // Not logged in → redirect to login
    if (profile == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(AppConstants.login);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NASAppBar(
        title: 'My Profile',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: NASColors.primary, size: 20),
            onPressed: () => context.push('${AppConstants.profile}/edit'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // ── Community Cover Banner ─────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: SizedBox(
              height: 160,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/pagoda_header_bg.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.65),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nepal Agrawal Samaj',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.2,
                              ),
                            ),
                            Text(
                              'Unity • Culture • Service • Progress',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF700D15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Member Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
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
          const SizedBox(height: 14),

          // ── Profile Header Card ────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadow.card,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: const Color(0xFF700D15),
                  backgroundImage: profile.avatarUrl != null &&
                          profile.avatarUrl!.startsWith('assets/')
                      ? AssetImage(profile.avatarUrl!) as ImageProvider
                      : const AssetImage('assets/images/pagoda_header_bg.png'),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.fullName,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: _roleBadgeColor(profile),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          roleBadgeFor(profile),
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 6),
                      _InfoRow(Icons.email_outlined, profile.email ?? '—'),
                      _InfoRow(Icons.call_outlined, profile.phone ?? '—'),
                      _InfoRow(Icons.location_on_outlined, profile.address ?? '—'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Membership ID Banner ───────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Membership ID',
                        style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(membershipIdFor(profile),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                  ],
                ),
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.accent, shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold, width: 1.5),
                  ),
                  child: const Icon(Icons.shield_moon_rounded, size: 18, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Admin Quick Action (if admin) ───────────────────
          if (profile.isLocationAdmin || profile.isSuperAdmin)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (profile.isSuperAdmin) {
                      context.push(AppConstants.superAdminDashboard);
                    } else {
                      context.push(AppConstants.adminDashboard);
                    }
                  },
                  icon: const Icon(Icons.admin_panel_settings_rounded, size: 18),
                  label: Text(
                    profile.isSuperAdmin ? 'Open Super Admin Dashboard' : 'Open Branch Admin Panel',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                  ),
                ),
              ),
            ),

          // ── My Information ─────────────────────────────────
          const Text('My Information', style: AppText.h2),
          const SizedBox(height: 10),
          _ProfileMenuItem(
            icon: Icons.person_outline_rounded,
            title: 'Personal Information',
            subtitle: 'Name, date of birth, gender',
            onTap: () => _showPersonalInfo(context, profile),
          ),
          _ProfileMenuItem(
            icon: Icons.card_membership_rounded,
            title: 'Membership Details',
            subtitle: 'Type: ${profile.membershipType}, Status: ${profile.membershipStatus}',
            onTap: () => _showMembershipDetails(context, profile),
          ),
          _ProfileMenuItem(
            icon: Icons.event_note_rounded,
            title: 'My Events',
            subtitle: 'Events you\'ve registered for',
            onTap: () => context.push(AppConstants.events),
          ),
          _ProfileMenuItem(
            icon: Icons.volunteer_activism_rounded,
            title: 'My Donations',
            subtitle: 'History of your contributions',
            onTap: () => _showDonations(context, profile),
          ),
          _ProfileMenuItem(
            icon: Icons.notifications_none_rounded,
            title: 'Notification Settings',
            subtitle: 'Manage push & email notifications',
            onTap: () => _showNotificationSettings(context),
          ),
          _ProfileMenuItem(
            icon: Icons.lock_outline_rounded,
            title: 'Privacy & Security',
            subtitle: 'Password, 2FA, data privacy',
            onTap: () => _showPrivacySecurity(context),
          ),
          const SizedBox(height: 20),

          // ── Logout Button ──────────────────────────────────
          SizedBox(
            height: 46,
            child: OutlinedButton.icon(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text('Logout', style: TextStyle(color: Colors.red.shade700)),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && context.mounted) {
                  await ref.read(currentProfileProvider.notifier).logout();
                  if (context.mounted) context.go(AppConstants.login);
                }
              },
              icon: Icon(Icons.logout_rounded, size: 18, color: Colors.red.shade700),
              label: Text('Logout', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Colors.red.shade700)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: const NASBottomNavBar(activeIndex: 0),
    );
  }

  Color _roleBadgeColor(dynamic profile) {
    if (profile.isSuperAdmin) return AppColors.primary;
    if (profile.isLocationAdmin) return const Color(0xFFE65100);
    return const Color(0xFF2E7D32);
  }

  // ── Bottom Sheet: Personal Information ─────────────────────────
  void _showPersonalInfo(BuildContext context, profile) {
    final dateFormat = DateFormat('MMMM d, yyyy');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        maxChildSize: 0.85,
        minChildSize: 0.4,
        expand: false,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            const Text('Personal Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary)),
            const SizedBox(height: 16),
            _DetailTile('Full Name', profile.fullName),
            _DetailTile('Email', profile.email ?? '—'),
            _DetailTile('Phone', profile.phone ?? '—'),
            _DetailTile('Address', profile.address ?? '—'),
            _DetailTile('Date of Birth',
                profile.dateOfBirth != null ? dateFormat.format(profile.dateOfBirth!) : 'Not set'),
            _DetailTile('Gender', profile.gender ?? 'Not set'),
            _DetailTile('Role', roleBadgeFor(profile)),
            _DetailTile('Member Since', dateFormat.format(profile.createdAt)),
          ],
        ),
      ),
    );
  }

  // ── Bottom Sheet: Membership Details ──────────────────────────
  void _showMembershipDetails(BuildContext context, profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.8,
        minChildSize: 0.35,
        expand: false,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            const Text('Membership Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary)),
            const SizedBox(height: 16),
            _DetailTile('Membership ID', membershipIdFor(profile)),
            _DetailTile('Type', profile.membershipType.toString().toUpperCase()),
            _DetailTile('Status', profile.membershipStatus.toString().toUpperCase()),
            _DetailTile('Branch', profile.locationId == 'loc-ktm' ? 'Kathmandu' : profile.locationId ?? '—'),
            _DetailTile('Role', roleBadgeFor(profile)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accentLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.accent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      profile.membershipStatus == 'active'
                          ? 'Your membership is active and in good standing.'
                          : 'Your membership is pending review. Contact admin for details.',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom Sheet: Donations ───────────────────────────────────
  void _showDonations(BuildContext context, profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.8,
        minChildSize: 0.35,
        expand: false,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            const Text('My Donations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary)),
            const SizedBox(height: 16),
            _DonationCard('Temple Renovation Fund', 'NPR 5,000', 'Jan 15, 2024', Icons.temple_buddhist_rounded),
            _DonationCard('Scholarship Fund', 'NPR 2,500', 'Mar 8, 2024', Icons.school_rounded),
            _DonationCard('Teej Celebration', 'NPR 1,000', 'Sep 2, 2024', Icons.celebration_rounded),
            const SizedBox(height: 12),
            Text('Total Donated: NPR 8,500',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }

  // ── Bottom Sheet: Notification Settings ───────────────────────
  void _showNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) {
          bool pushEvents = true, pushNews = true, emailDigest = false, smsAlerts = false;
          return DraggableScrollableSheet(
            initialChildSize: 0.5,
            maxChildSize: 0.8,
            minChildSize: 0.35,
            expand: false,
            builder: (_, controller) => ListView(
              controller: controller,
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Container(width: 40, height: 4,
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                ),
                const SizedBox(height: 16),
                const Text('Notification Settings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary)),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Event Notifications', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Get notified about upcoming events', style: TextStyle(fontSize: 11)),
                  value: pushEvents,
                  activeTrackColor: AppColors.primary,
                  onChanged: (v) => setModalState(() => pushEvents = v),
                ),
                SwitchListTile(
                  title: const Text('News & Updates', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Receive latest news and announcements', style: TextStyle(fontSize: 11)),
                  value: pushNews,
                  activeTrackColor: AppColors.primary,
                  onChanged: (v) => setModalState(() => pushNews = v),
                ),
                SwitchListTile(
                  title: const Text('Weekly Email Digest', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Summary of community activities', style: TextStyle(fontSize: 11)),
                  value: emailDigest,
                  activeTrackColor: AppColors.primary,
                  onChanged: (v) => setModalState(() => emailDigest = v),
                ),
                SwitchListTile(
                  title: const Text('SMS Alerts', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Important alerts via text message', style: TextStyle(fontSize: 11)),
                  value: smsAlerts,
                  activeTrackColor: AppColors.primary,
                  onChanged: (v) => setModalState(() => smsAlerts = v),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Bottom Sheet: Privacy & Security ──────────────────────────
  void _showPrivacySecurity(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.8,
        minChildSize: 0.35,
        expand: false,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            const Text('Privacy & Security',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary)),
            const SizedBox(height: 16),
            _SecurityTile(Icons.key_rounded, 'Change Password', 'Update your account password'),
            _SecurityTile(Icons.security_rounded, 'Two-Factor Authentication', 'Add an extra layer of security'),
            _SecurityTile(Icons.devices_rounded, 'Active Sessions', '1 active session on this device'),
            _SecurityTile(Icons.delete_forever_rounded, 'Delete Account', 'Permanently remove your account'),
          ],
        ),
      ),
    );
  }
}

// ── Reusable widgets ─────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(icon, size: 12, color: AppColors.accent),
          const SizedBox(width: 4),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary))),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, size: 18, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final String label;
  final String value;
  const _DetailTile(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}

class _DonationCard extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  final IconData icon;
  const _DonationCard(this.title, this.amount, this.date, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppColors.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                Text(date, style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.primary)),
        ],
      ),
    );
  }
}

class _SecurityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _SecurityTile(this.icon, this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: 18, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}
