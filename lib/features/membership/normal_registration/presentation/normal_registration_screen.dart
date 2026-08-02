import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/widgets.dart';

/// A10 — Normal Registration Screen (Public Site)
/// Matches design a10._normal_registration_public_site/screen.png:
/// - Title "Membership Registration"
/// - Inputs: Full Name, Email, Phone (+977 formatting), Permanent Address, Date of Birth, Gender selector, Regional Location dropdown, Declaration checkbox
/// - Submit Registration CTA button
class NormalRegistrationScreen extends ConsumerStatefulWidget {
  const NormalRegistrationScreen({super.key});

  @override
  ConsumerState<NormalRegistrationScreen> createState() =>
      _NormalRegistrationScreenState();
}

class _NormalRegistrationScreenState
    extends ConsumerState<NormalRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedGender = 'Male';
  String? _selectedLocation;
  bool _agreedToTerms = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submitRegistration() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      NASToast.error(context, 'Please agree to the Samaj Bylaws to proceed.');
      return;
    }

    setState(() => _isSubmitting = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isSubmitting = false);
        NASToast.success(
            context, 'Registration submitted! Awaiting location admin approval.');
        context.go(AppConstants.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NASAppBar(title: 'Individual Registration', showBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NASContentWidth(
              child: Column(
                children: [
                  const SizedBox(height: NASSpacing.md),
                  Text(
                    'Membership Registration',
                    style: NASTypography.headlineMd.copyWith(
                      color: NASColors.primary,
                      fontFamily: NASTypography.headlineFont,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: NASSpacing.xs),
                  Text(
                    'Join our community to preserve heritage and foster unity among Agrawal members in Nepal.',
                    style: NASTypography.bodyMd.copyWith(
                      color: NASColors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  NASCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NASInputField(
                            label: 'Full Name',
                            hint: 'e.g. Rajesh Kumar Agrawal',
                            controller: _nameController,
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: NASSpacing.sm),
                          NASInputField(
                            label: 'Email Address',
                            hint: 'rajesh.agrawal@example.com',
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            validator: (v) => v == null || !v.contains('@')
                                ? 'Valid email required'
                                : null,
                          ),
                          const SizedBox(height: NASSpacing.sm),
                          NASInputField(
                            label: 'Phone Number',
                            hint: '+977 98012XXXXX',
                            keyboardType: TextInputType.phone,
                            controller: _phoneController,
                            validator: (v) =>
                                v == null || v.length < 10 ? 'Valid 10-digit number required' : null,
                          ),
                          const SizedBox(height: NASSpacing.sm),
                          NASInputField(
                            label: 'Permanent Address',
                            hint: 'House No, Street, Ward, City...',
                            maxLines: 2,
                            controller: _addressController,
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: NASSpacing.sm),

                          // Gender Selector
                          Text(
                            'Gender',
                            style: NASTypography.labelMd.copyWith(
                              color: NASColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              color: NASColors.surfaceContainerHigh,
                              borderRadius: NASRadius.defaultBorderRadius,
                            ),
                            child: Row(
                              children: ['Male', 'Female', 'Other'].map((gender) {
                                final isSelected = _selectedGender == gender;
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => _selectedGender = gender),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? NASColors.surfaceContainerLowest
                                            : Colors.transparent,
                                        borderRadius: NASRadius.defaultBorderRadius,
                                      ),
                                      child: Text(
                                        gender,
                                        textAlign: TextAlign.center,
                                        style: NASTypography.labelMd.copyWith(
                                          color: isSelected
                                              ? NASColors.primary
                                              : NASColors.onSurfaceVariant,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: NASSpacing.sm),

                          // Location / Chapter Dropdown
                          NASSelectField<String>(
                            label: 'Regional Chapter *',
                            hint: 'Select your local chapter / province',
                            value: _selectedLocation,
                            items: const [
                              DropdownMenuItem(value: 'kathmandu', child: Text('Kathmandu Chapter (Bagmati)')),
                              DropdownMenuItem(value: 'birgunj', child: Text('Birgunj Chapter (Madhesh)')),
                              DropdownMenuItem(value: 'biratnagar', child: Text('Biratnagar Chapter (Koshi)')),
                              DropdownMenuItem(value: 'pokhara', child: Text('Pokhara Chapter (Gandaki)')),
                              DropdownMenuItem(value: 'butwal', child: Text('Butwal Chapter (Lumbini)')),
                            ],
                            validator: (v) => v == null || v.isEmpty ? 'Please select your regional chapter' : null,
                            onChanged: (val) => setState(() => _selectedLocation = val),
                          ),
                          const SizedBox(height: NASSpacing.md),

                          // Declaration Checkbox
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _agreedToTerms,
                                activeColor: NASColors.primary,
                                onChanged: (val) => setState(
                                  () => _agreedToTerms = val ?? false,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'I hereby declare that the information provided is true and I agree to abide by the Samaj\'s Bylaws.',
                                  style: NASTypography.bodyMd.copyWith(
                                    color: NASColors.onSurfaceVariant,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: NASSpacing.md),

                          NASPrimaryButton(
                            label: 'Submit Registration',
                            icon: Icons.send,
                            fullWidth: true,
                            isLoading: _isSubmitting,
                            onPressed: _submitRegistration,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: NASSpacing.xl),
            const NASFooter(),
          ],
        ),
      ),
    );
  }
}
