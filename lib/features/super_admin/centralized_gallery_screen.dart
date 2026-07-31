import 'package:flutter/material.dart';

import '../../../core/design_tokens.dart';
import '../../../shared/widgets/widgets.dart';

/// C5 — Centralized Gallery Screen (Super Admin)
/// Centralized view for super admins to oversee all photo archives.
class CentralizedGalleryScreen extends StatelessWidget {
  const CentralizedGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NASAppBar(title: 'Centralized Gallery'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NASContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: NASSpacing.md),
                  Text(
                    'Centralized Photo Archive',
                    style: NASTypography.headlineMd.copyWith(
                      color: NASColors.primary,
                      fontFamily: NASTypography.headlineFont,
                    ),
                  ),
                  const SizedBox(height: NASSpacing.xs),
                  Text(
                    'National archive of cultural photos, event galleries, and historical documents.',
                    style: NASTypography.bodyMd.copyWith(color: NASColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  const NASCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('National Photo Vault', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('Over 12,000 photos stored securely across all branch chapters.'),
                      ],
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
