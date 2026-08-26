import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/design_tokens.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/contact_repository.dart';

/// A12 — Refactored High-End Contact Us Screen
class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  
  String _selectedTopic = 'General Inquiry';
  bool _isSubmitting = false;

  final List<String> _topics = [
    'General Inquiry',
    'Membership',
    'Event Support',
    'Branch Query',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _isSubmitting = true);

    final success = await ref.read(contactRepositoryProvider).sendMessage(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          message: '[Topic: $_selectedTopic] ' + _messageController.text.trim(),
        );

    setState(() => _isSubmitting = false);

    if (mounted) {
      if (success) {
        _showSuccessDialog();
        _nameController.clear();
        _phoneController.clear();
        _emailController.clear();
        _messageController.clear();
        setState(() => _selectedTopic = 'General Inquiry');
      } else {
        NASToast.error(context, 'Failed to send message. Please try again.');
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFA5D6A7), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 36),
              ),
              const SizedBox(height: 16),
              const Text(
                'Message Sent!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF500913)),
              ),
              const SizedBox(height: 8),
              Text(
                'Thank you for reaching out. Our central executive team will get back to you shortly.',
                style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF500913),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  ),
                  child: const Text('Done', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const NASAppBar(title: 'Contact Us', showBackButton: true),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.only(bottom: 30),
          children: [
            // Hero Banner
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF500913), Color(0xFF700D15)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF500913).withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Icon(
                        Icons.contact_support_rounded,
                        size: 140,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5C8A6).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: const Color(0xFFE5C8A6).withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.support_agent_rounded, size: 13, color: Color(0xFFE5C8A6)),
                                SizedBox(width: 5),
                                Text(
                                  'WE\'RE HERE TO HELP',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFFE5C8A6),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Get in Touch with Us',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Have questions about membership, events, branch activities, or community services? Reach out to our central team.',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.white.withValues(alpha: 0.85),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Quick Action Info Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Direct Contact Details',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF500913)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _quickActionCard(
                          icon: Icons.phone_in_talk_rounded,
                          title: 'Call Us',
                          subtitle: '+977 1-4220000',
                          color: const Color(0xFF1565C0),
                          bgColor: const Color(0xFFE3F2FD),
                          onTap: () => _makePhoneCall('+97714220000'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _quickActionCard(
                          icon: Icons.mail_rounded,
                          title: 'Email Us',
                          subtitle: 'info@agrawalsamaj.org',
                          color: const Color(0xFFE8622C),
                          bgColor: const Color(0xFFFBE0D2),
                          onTap: () => _sendEmail('info@nepalagrawalsamaj.org'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _quickActionCard(
                          icon: Icons.location_on_rounded,
                          title: 'Headquarters',
                          subtitle: 'Kamaladi, Kathmandu',
                          color: const Color(0xFFD64F64),
                          bgColor: const Color(0xFFFDECEF),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _quickActionCard(
                          icon: Icons.access_time_filled_rounded,
                          title: 'Office Hours',
                          subtitle: 'Sun-Fri 9AM - 6PM',
                          color: const Color(0xFFC4901E),
                          bgColor: const Color(0xFFFCF7EB),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Form Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.send_rounded, size: 18, color: Color(0xFF500913)),
                          SizedBox(width: 8),
                          Text(
                            'Send Us a Direct Message',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF500913)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Fill out the form below and we will get back to you.',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 16),

                      // Topic Chips
                      const Text(
                        'Select Inquiry Topic',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _topics.map((topic) {
                          final isSel = _selectedTopic == topic;
                          return InkWell(
                            onTap: () => setState(() => _selectedTopic = topic),
                            borderRadius: BorderRadius.circular(100),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: isSel ? const Color(0xFF500913) : const Color(0xFFF9F6F0),
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: isSel ? const Color(0xFF500913) : const Color(0xFFEFE8E5),
                                ),
                              ),
                              child: Text(
                                topic,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                                  color: isSel ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 18),

                      // Name Field
                      _buildInputLabel('Full Name *'),
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        decoration: _inputDecoration('e.g. Ramesh Agrawal', Icons.person_outline_rounded),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Please enter your name' : null,
                      ),
                      const SizedBox(height: 14),

                      // Phone Field
                      _buildInputLabel('Phone / Mobile Number *'),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        decoration: _inputDecoration('+977 9801XXXXXX', Icons.phone_outlined),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Please enter phone number' : null,
                      ),
                      const SizedBox(height: 14),

                      // Email Field
                      _buildInputLabel('Email Address *'),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        decoration: _inputDecoration('e.g. name@example.com', Icons.email_outlined),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Please enter email address' : null,
                      ),
                      const SizedBox(height: 14),

                      // Message Field
                      _buildInputLabel('Your Message *'),
                      TextFormField(
                        controller: _messageController,
                        maxLines: 4,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        decoration: _inputDecoration(
                          'Write your inquiry or feedback here...',
                          Icons.chat_bubble_outline_rounded,
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Please enter your message' : null,
                      ),
                      const SizedBox(height: 22),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF500913),
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.send_rounded, size: 16),
                                    SizedBox(width: 8),
                                    Text(
                                      'Send Message',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 0.3),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color bgColor,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: Color(0xFF500913)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText, IconData icon) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
      prefixIcon: Icon(icon, size: 18, color: const Color(0xFF500913)),
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF500913), width: 1.5),
      ),
    );
  }
}
