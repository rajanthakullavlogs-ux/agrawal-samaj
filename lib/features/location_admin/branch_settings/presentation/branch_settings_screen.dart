import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/nas_logo.dart';
import '../../../settings/data/settings_repository.dart';

/// B5 — Branch Settings Screen (Location Admin)
class BranchSettingsScreen extends ConsumerStatefulWidget {
  const BranchSettingsScreen({super.key});

  @override
  ConsumerState<BranchSettingsScreen> createState() => _BranchSettingsScreenState();
}

class _BranchSettingsScreenState extends ConsumerState<BranchSettingsScreen> {
  late TextEditingController _branchNameController;
  late TextEditingController _missionController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  late TextEditingController _addressController;
  late TextEditingController _leaderNameController;
  late TextEditingController _leaderBioController;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(branchSettingsNotifierProvider);
    _branchNameController = TextEditingController(text: settings.branchName);
    _missionController = TextEditingController(text: settings.mission);
    _phoneController = TextEditingController(text: settings.phone);
    _emailController = TextEditingController(text: settings.email);
    _websiteController = TextEditingController(text: settings.website);
    _addressController = TextEditingController(text: settings.address);
    _leaderNameController = TextEditingController(text: settings.leaderName);
    _leaderBioController = TextEditingController(text: settings.leaderBio);
  }

  @override
  void dispose() {
    _branchNameController.dispose();
    _missionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _leaderNameController.dispose();
    _leaderBioController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    final updated = BranchSettingsModel(
      branchName: _branchNameController.text,
      mission: _missionController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      website: _websiteController.text,
      address: _addressController.text,
      leaderName: _leaderNameController.text,
      leaderBio: _leaderBioController.text,
    );
    ref.read(branchSettingsNotifierProvider.notifier).updateSettings(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Branch settings saved & synced successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            const _AdminTopBar(),
            const SizedBox(height: 14),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _HeroBanner(),
            ),
            const SizedBox(height: 20),

            // Card 1: Branch Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SectionCard(
                icon: Icons.storefront_rounded,
                title: 'Branch Description',
                children: [
                  _inputField('Branch Name', _branchNameController),
                  const SizedBox(height: 12),
                  _inputField('Mission Statement', _missionController, maxLines: 3),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Card 2: Contact Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SectionCard(
                icon: Icons.contact_phone_rounded,
                title: 'Contact Details',
                children: [
                  _inputField('Primary Phone', _phoneController),
                  const SizedBox(height: 12),
                  _inputField('Official Email', _emailController),
                  const SizedBox(height: 12),
                  _inputField('Website (Optional)', _websiteController),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Card 3: Location Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SectionCard(
                icon: Icons.location_on_rounded,
                title: 'Location & Address',
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F8FE),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.map_rounded, color: AppColors.primary, size: 32),
                          SizedBox(height: 4),
                          Text('Kamaladi, Kathmandu Map Preview',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _inputField('Physical Address', _addressController),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Card 4: Leader Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SectionCard(
                icon: Icons.person_rounded,
                title: 'Branch Leadership Profile',
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: const Color(0xFFFCEEE4),
                          child: const Icon(Icons.person_rounded, size: 40, color: AppColors.primary),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _inputField('Leader Name', _leaderNameController),
                  const SizedBox(height: 12),
                  _inputField('Leader Bio', _leaderBioController, maxLines: 2),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Save / Discard Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go(AppConstants.adminDashboard),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      ),
                      child: const Text('Discard', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _saveSettings,
                      icon: const Icon(Icons.save_rounded, size: 18),
                      label: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.w700)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _AdminBottomNavBar(activeIndex: 4),
    );
  }

  Widget _inputField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
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
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TOP BAR WITH EXIT BUTTON
// ---------------------------------------------------------------------------
class _AdminTopBar extends StatelessWidget {
  const _AdminTopBar();

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
                  'Branch Settings',
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Branch Settings ⚙️',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 4),
                Text('Manage Kathmandu Central Branch profile, contact details, map location, and leadership bio.',
                    style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.35)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: const Icon(Icons.tune_rounded, color: AppColors.primary, size: 32),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ADMIN BOTTOM NAV
// ---------------------------------------------------------------------------
class _AdminBottomNavBar extends StatelessWidget {
  final int activeIndex;
  const _AdminBottomNavBar({required this.activeIndex});

  static const _items = [
    (icon: Icons.dashboard_rounded, label: 'Dashboard', route: AppConstants.adminDashboard),
    (icon: Icons.people_alt_rounded, label: 'Members', route: AppConstants.adminMembers),
    (icon: Icons.event_rounded, label: 'Events', route: AppConstants.adminEvents),
    (icon: Icons.photo_library_rounded, label: 'Gallery', route: AppConstants.adminGallery),
    (icon: Icons.settings_rounded, label: 'Settings', route: AppConstants.adminSettings),
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
