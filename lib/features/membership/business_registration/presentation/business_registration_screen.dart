import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/design_tokens.dart';
import '../../../../shared/widgets/widgets.dart';

/// A11 — Business Registration Screen (Public Site)
/// Matches design a11._business_registration_public_site/screen.png:
/// - Step indicator: Step 1 (Personal Info) -> Step 2 (Business Info)
/// - Step 1 fields: Full Name, Email, Phone, Address + Next CTA
/// - Step 2 fields: Business Name, Business Type, Reg Number, Address, Upload Registration Document + Submit CTA
class BusinessRegistrationScreen extends ConsumerStatefulWidget {
  const BusinessRegistrationScreen({super.key});

  @override
  ConsumerState<BusinessRegistrationScreen> createState() =>
      _BusinessRegistrationScreenState();
}

class _BusinessRegistrationScreenState
    extends ConsumerState<BusinessRegistrationScreen> {
  int _currentStep = 1;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  // Step 1 Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  // Step 2 Controllers
  final _businessNameController = TextEditingController();
  final _businessTypeController = TextEditingController();
  final _regNumberController = TextEditingController();
  final _businessAddressController = TextEditingController();
  String? _uploadedFileName;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _businessNameController.dispose();
    _businessTypeController.dispose();
    _regNumberController.dispose();
    _businessAddressController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (!_formKey1.currentState!.validate()) return;
    setState(() => _currentStep = 2);
  }

  void _submitBusinessRegistration() {
    if (!_formKey2.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isSubmitting = false);
        NASToast.success(
          context,
          'Business registration submitted! Awaiting review.',
        );
        context.go(AppConstants.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NASAppBar(title: 'Business Membership', showBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NASContentWidth(
              child: Column(
                children: [
                  const SizedBox(height: NASSpacing.md),
                  // Step Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StepCircle(
                        number: 1,
                        label: 'Personal Info',
                        isActive: _currentStep == 1,
                        isDone: _currentStep > 1,
                      ),
                      Container(
                        width: 60,
                        height: 2,
                        color: _currentStep > 1
                            ? NASColors.primary
                            : NASColors.outlineVariant,
                      ),
                      _StepCircle(
                        number: 2,
                        label: 'Business Info',
                        isActive: _currentStep == 2,
                        isDone: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  NASCard(
                    child: _currentStep == 1 ? _buildStep1() : _buildStep2(),
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

  Widget _buildStep1() {
    return Form(
      key: _formKey1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Details',
            style: NASTypography.headlineMdMobile.copyWith(
              color: NASColors.primary,
              fontFamily: NASTypography.headlineFont,
            ),
          ),
          Text(
            'Primary contact for the business membership.',
            style: NASTypography.bodyMd.copyWith(
              color: NASColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: NASSpacing.md),

          NASInputField(
            label: 'Full Name',
            hint: 'e.g. Ramesh Agrawal',
            controller: _nameController,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: NASSpacing.sm),
          NASInputField(
            label: 'Email Address',
            hint: 'ramesh@example.com',
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            validator: (v) =>
                v == null || !v.contains('@') ? 'Valid email required' : null,
          ),
          const SizedBox(height: NASSpacing.sm),
          NASInputField(
            label: 'Phone Number',
            hint: '+977 98XXXXXXXX',
            keyboardType: TextInputType.phone,
            controller: _phoneController,
            validator: (v) =>
                v == null || v.length < 10 ? 'Valid phone required' : null,
          ),
          const SizedBox(height: NASSpacing.sm),
          NASInputField(
            label: 'Residential Address',
            hint: 'City, Ward No, Street',
            controller: _addressController,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: NASSpacing.md),

          NASPrimaryButton(
            label: 'Next →',
            fullWidth: true,
            onPressed: _nextStep,
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Form(
      key: _formKey2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Information',
            style: NASTypography.headlineMdMobile.copyWith(
              color: NASColors.primary,
              fontFamily: NASTypography.headlineFont,
            ),
          ),
          Text(
            'Details of your enterprise or company.',
            style: NASTypography.bodyMd.copyWith(
              color: NASColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: NASSpacing.md),

          NASInputField(
            label: 'Business Name',
            hint: 'e.g. Agrawal Trading Concern Concern',
            controller: _businessNameController,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: NASSpacing.sm),
          NASInputField(
            label: 'Business Sector / Type',
            hint: 'e.g. Manufacturing, Retail, IT...',
            controller: _businessTypeController,
          ),
          const SizedBox(height: NASSpacing.sm),
          NASInputField(
            label: 'Registration / PAN Number',
            hint: 'e.g. PAN 600XXXXXX',
            controller: _regNumberController,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: NASSpacing.sm),
          NASInputField(
            label: 'Business Address',
            hint: 'Commercial location address...',
            controller: _businessAddressController,
          ),
          const SizedBox(height: NASSpacing.sm),

          // Upload Registration Doc
          NASUploadZone(
            label: 'Upload Business Reg Certificate (PDF/PNG)',
            fileName: _uploadedFileName,
            onTap: () {
              setState(() => _uploadedFileName = 'business_reg_certificate.pdf');
              NASToast.success(context, 'Document uploaded.');
            },
          ),
          const SizedBox(height: NASSpacing.md),

          Row(
            children: [
              Expanded(
                child: NASSecondaryButton(
                  label: '← Back',
                  onPressed: () => setState(() => _currentStep = 1),
                ),
              ),
              const SizedBox(width: NASSpacing.sm),
              Expanded(
                child: NASPrimaryButton(
                  label: 'Submit',
                  isLoading: _isSubmitting,
                  onPressed: _submitBusinessRegistration,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int number;
  final String label;
  final bool isActive;
  final bool isDone;

  const _StepCircle({
    required this.number,
    required this.label,
    required this.isActive,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive || isDone
                ? NASColors.primary
                : NASColors.surfaceContainerHigh,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 20, color: Colors.white)
                : Text(
                    '$number',
                    style: TextStyle(
                      color: isActive ? Colors.white : NASColors.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: NASTypography.labelSm.copyWith(
            color: isActive ? NASColors.primary : NASColors.onSurfaceVariant,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
