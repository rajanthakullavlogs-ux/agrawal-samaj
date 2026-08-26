import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/nas_logo.dart';

/// C7 — Global Settings Screen (Super Admin)
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _enableMemberRegistrations = true;
  bool _requireBranchApproval = true;
  bool _enableEmailNotifications = true;
  bool _enableMaintenanceMode = false;
  bool _allowBranchBroadcasts = true;
  bool _enableAutoBackups = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            const _SuperAdminTopBar(),
            const SizedBox(height: 14),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _HeroBanner(),
            ),
            const SizedBox(height: 20),

            // Controls Section 1: Member Policies
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SectionCard(
                icon: Icons.shield_rounded,
                title: 'Registration & Member Controls',
                children: [
                  _switchTile(
                    title: 'Allow Public Member Registrations',
                    subtitle: 'Enable new members to sign up via public website',
                    value: _enableMemberRegistrations,
                    onChanged: (v) => setState(() => _enableMemberRegistrations = v),
                  ),
                  const Divider(height: 1, color: Color(0xFFE2D6D3)),
                  _switchTile(
                    title: 'Require Chapter Admin Approval',
                    subtitle: 'Registrations must be vetted by branch admins before active status',
                    value: _requireBranchApproval,
                    onChanged: (v) => setState(() => _requireBranchApproval = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Controls Section 2: System Notifications & Maintenance
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SectionCard(
                icon: Icons.notifications_active_rounded,
                title: 'System & Security Settings',
                children: [
                  _switchTile(
                    title: 'Global Email & SMS Notifications',
                    subtitle: 'Send automated updates for events & approvals',
                    value: _enableEmailNotifications,
                    onChanged: (v) => setState(() => _enableEmailNotifications = v),
                  ),
                  const Divider(height: 1, color: Color(0xFFE2D6D3)),
                  _switchTile(
                    title: 'Allow Branch Notice Broadcasts',
                    subtitle: 'Permit local branch admins to dispatch broadcast notices',
                    value: _allowBranchBroadcasts,
                    onChanged: (v) => setState(() => _allowBranchBroadcasts = v),
                  ),
                  const Divider(height: 1, color: Color(0xFFE2D6D3)),
                  _switchTile(
                    title: 'Automated Daily Cloud Backups',
                    subtitle: 'Snapshot member & financial database at 00:00 UTC',
                    value: _enableAutoBackups,
                    onChanged: (v) => setState(() => _enableAutoBackups = v),
                  ),
                  const Divider(height: 1, color: Color(0xFFE2D6D3)),
                  _switchTile(
                    title: 'Maintenance Mode',
                    subtitle: 'Temporarily lock public site for database maintenance',
                    value: _enableMaintenanceMode,
                    onChanged: (v) => setState(() => _enableMaintenanceMode = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Controls Section 3: RBAC Roles
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SectionCard(
                icon: Icons.admin_panel_settings_rounded,
                title: 'Role-Based Access Control (RBAC)',
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: const Icon(Icons.security_rounded, color: AppColors.primary, size: 22),
                    ),
                    title: const Text('Manage Admin Roles & Keys', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: AppColors.textPrimary)),
                    subtitle: const Text('Assign super admin, location admin, and moderator roles', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    trailing: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.primary),
                    ),
                    onTap: () => _showRbacModal(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Save Settings CTA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: const [
                          Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 10),
                          Text('Global Super Admin settings saved successfully!', style: TextStyle(fontWeight: FontWeight.w700)),
                        ],
                      ),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                icon: const Icon(Icons.save_rounded, size: 20),
                label: const Text('Save System Configurations', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 3,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _SuperAdminBottomNavBar(activeIndex: 4),
    );
  }

  Widget _switchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.textPrimary)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      value: value,
      activeThumbColor: AppColors.primary,
      onChanged: onChanged,
    );
  }
}

// ---------------------------------------------------------------------------
// SECTION CARD CONTAINER
// ---------------------------------------------------------------------------
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TOP BAR WITH EXIT BUTTON
// ---------------------------------------------------------------------------
class _SuperAdminTopBar extends StatelessWidget {
  const _SuperAdminTopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => context.go(AppConstants.home),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.home_rounded, size: 22, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 8),
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
                Text(
                  'System Settings',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 11.5, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Global Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Configure nationwide security policies, registration rules, RBAC admin permissions, and site maintenance.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
            ),
            child: const Icon(
              Icons.settings_suggest_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SUPER ADMIN BOTTOM NAV
// ---------------------------------------------------------------------------
class _SuperAdminBottomNavBar extends StatelessWidget {
  final int activeIndex;
  const _SuperAdminBottomNavBar({required this.activeIndex});

  static const _items = [
    (icon: Icons.dashboard_rounded, label: 'Dashboard', route: AppConstants.superAdminDashboard),
    (icon: Icons.people_rounded, label: 'Members', route: AppConstants.superAdminAnalytics),
    (icon: Icons.location_city_rounded, label: 'Locations', route: AppConstants.superAdminLocations),
    (icon: Icons.event_note_rounded, label: 'Events', route: AppConstants.superAdminEvents),
    (icon: Icons.settings_rounded, label: 'Settings', route: AppConstants.superAdminSettings),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (int i = 0; i < _items.length; i++)
              Expanded(
                child: InkWell(
                  onTap: () => context.go(_items[i].route),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: i == activeIndex
                            ? BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              )
                            : null,
                        child: Icon(
                          _items[i].icon,
                          size: 20,
                          color: i == activeIndex ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _items[i].label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: i == activeIndex ? FontWeight.w700 : FontWeight.w500,
                          color: i == activeIndex ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
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

void _showRbacModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      title: Row(
        children: const [
          Icon(Icons.security_rounded, color: AppColors.primary),
          SizedBox(width: 8),
          Text('RBAC Role & Key Control', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Super Admin Role Key', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFF3F8FE), borderRadius: BorderRadius.circular(AppRadius.md)),
              child: Row(
                children: const [
                  Icon(Icons.key_rounded, size: 16, color: Color(0xFF2E6FE0)),
                  SizedBox(width: 6),
                  Expanded(child: Text('sb_super_admin_key_9941x28', style: TextStyle(fontSize: 11, fontFamily: 'monospace'))),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text('Active Admin Privileges', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('• 18 Location Administrators Assigned\n• 3 Super Admin Executive Accounts\n• Row Level Security (RLS) Active',
                style: TextStyle(fontSize: 11.5, color: Colors.grey.shade700, height: 1.4)),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('RBAC Security Keys re-generated & synchronized!')),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          child: const Text('Regenerate Key', style: TextStyle(fontWeight: FontWeight.w700)),
        ),
      ],
    ),
  );
}
