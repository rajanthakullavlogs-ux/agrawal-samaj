import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/widgets.dart';

/// B5 — Branch Settings Screen (Location Admin)
/// Matches design b5._settings_location_admin/screen.png:
/// - Header "Branch Settings" + subtext
/// - Card 1: Branch Description (Branch Name, Mission Statement)
/// - Card 2: Contact Details (Primary Phone, Official Email, Website)
/// - Card 3: Location Info (Map preview, Address, City/Region)
/// - Card 4: Leader Info (Leader avatar + camera badge, Full Name, Brief Bio)
/// - Bottom bar: Discard + "Save Changes" primary CTA
class BranchSettingsScreen extends StatefulWidget {
  const BranchSettingsScreen({super.key});

  @override
  State<BranchSettingsScreen> createState() => _BranchSettingsScreenState();
}

class _BranchSettingsScreenState extends State<BranchSettingsScreen> {
  final _branchNameController =
      TextEditingController(text: 'Kathmandu Central Branch');
  final _missionController = TextEditingController(
    text:
        'Dedicated to preserving the Agrawal heritage in the heart of Nepal, providing a platform for unity, business networking, and social welfare.',
  );
  final _phoneController = TextEditingController(text: '+977-1-4423XXX');
  final _emailController =
      TextEditingController(text: 'kathmandu@nepalagrawal.org');
  final _websiteController =
      TextEditingController(text: 'https://kathmandu.agrawalsamaj.org.np');
  final _addressController =
      TextEditingController(text: 'Kamaladi, Kathmandu, Ward No. 28');
  final _leaderNameController =
      TextEditingController(text: 'Shree Ram Agrawal');
  final _leaderBioController = TextEditingController(
    text:
        'Respected entrepreneur and community activist with over 30 years of experience in trade and philanthropy.',
  );

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
    NASToast.success(context, 'Branch settings saved successfully!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NASAppBar(title: 'Branch Settings'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NASContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: NASSpacing.md),
                  Text(
                    'Branch Settings',
                    style: NASTypography.headlineMd.copyWith(
                      color: NASColors.primary,
                      fontFamily: NASTypography.headlineFont,
                    ),
                  ),
                  const SizedBox(height: NASSpacing.xs),
                  Text(
                    'Manage the Kathmandu Central Branch profile and contact details.',
                    style: NASTypography.bodyMd.copyWith(
                      color: NASColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  // Section 1: Branch Description
                  NASCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.description_outlined,
                                color: NASColors.primary),
                            const SizedBox(width: NASSpacing.xs),
                            Text(
                              'Branch Description',
                              style: NASTypography.titleLg.copyWith(
                                color: NASColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: NASSpacing.md),
                        NASInputField(
                          label: 'Branch Name',
                          controller: _branchNameController,
                        ),
                        const SizedBox(height: NASSpacing.sm),
                        NASInputField(
                          label: 'Mission Statement',
                          maxLines: 3,
                          controller: _missionController,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: NASSpacing.md),

                  // Section 2: Contact Details
                  NASCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.contact_phone_outlined,
                                color: NASColors.primary),
                            const SizedBox(width: NASSpacing.xs),
                            Text(
                              'Contact Details',
                              style: NASTypography.titleLg.copyWith(
                                color: NASColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: NASSpacing.md),
                        NASInputField(
                          label: 'Primary Phone',
                          controller: _phoneController,
                        ),
                        const SizedBox(height: NASSpacing.sm),
                        NASInputField(
                          label: 'Official Email',
                          controller: _emailController,
                        ),
                        const SizedBox(height: NASSpacing.sm),
                        NASInputField(
                          label: 'Website (Optional)',
                          controller: _websiteController,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: NASSpacing.md),

                  // Section 3: Location Info
                  NASCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                color: NASColors.primary),
                            const SizedBox(width: NASSpacing.xs),
                            Text(
                              'Location Info',
                              style: NASTypography.titleLg.copyWith(
                                color: NASColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: NASSpacing.sm),
                        ClipRRect(
                          borderRadius: NASRadius.defaultBorderRadius,
                          child: Container(
                            height: 120,
                            width: double.infinity,
                            color: NASColors.surfaceContainerHigh,
                            child: const Center(
                              child: Icon(Icons.map_outlined,
                                  size: 40, color: NASColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(height: NASSpacing.md),
                        NASInputField(
                          label: 'Address',
                          controller: _addressController,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: NASSpacing.md),

                  // Section 4: Leader Info
                  NASCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person_outline,
                                color: NASColors.primary),
                            const SizedBox(width: NASSpacing.xs),
                            Text(
                              'Leader Info',
                              style: NASTypography.titleLg.copyWith(
                                color: NASColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: NASSpacing.md),

                        Center(
                          child: Stack(
                            children: [
                              const CircleAvatar(
                                radius: 40,
                                backgroundColor: NASColors.surfaceVariant,
                                child: Icon(Icons.person,
                                    size: 48, color: NASColors.primary),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: NASColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.camera_alt,
                                      size: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: NASSpacing.md),

                        NASInputField(
                          label: 'Full Name',
                          controller: _leaderNameController,
                        ),
                        const SizedBox(height: NASSpacing.sm),
                        NASInputField(
                          label: 'Brief Bio',
                          maxLines: 2,
                          controller: _leaderBioController,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: NASSecondaryButton(
                          label: 'Discard',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: NASSpacing.sm),
                      Expanded(
                        child: NASPrimaryButton(
                          label: 'Save Changes',
                          icon: Icons.save_outlined,
                          onPressed: _saveSettings,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: NASSpacing.xl),
            const NASFooter(),
          ],
        ),
      ),
      bottomNavigationBar: NASBottomNav(
        selectedIndex: 4,
        onItemTap: (index) {
          switch (index) {
            case 0:
              context.go(AppConstants.adminDashboard);
            case 1:
              context.go(AppConstants.adminMembers);
            case 2:
              context.go(AppConstants.adminEvents);
            case 3:
              context.go(AppConstants.adminGallery);
            case 4:
              break;
          }
        },
        items: const [
          NASNavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard'),
          NASNavItem(icon: Icons.people_outlined, activeIcon: Icons.people, label: 'Members'),
          NASNavItem(icon: Icons.event_outlined, activeIcon: Icons.event, label: 'Events'),
          NASNavItem(icon: Icons.photo_library_outlined, activeIcon: Icons.photo_library, label: 'Gallery'),
          NASNavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'Settings'),
        ],
      ),
    );
  }
}
