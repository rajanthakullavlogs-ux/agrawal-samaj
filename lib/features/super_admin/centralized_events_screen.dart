import 'package:flutter/material.dart';

import '../../../core/design_tokens.dart';
import '../../../shared/widgets/widgets.dart';

/// C4 — Centralized Events Screen (Super Admin)
/// Centralized view for super admins to oversee all chapter events across Nepal.
class CentralizedEventsScreen extends StatelessWidget {
  const CentralizedEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NASAppBar(title: 'Centralized Events'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NASContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: NASSpacing.md),
                  Text(
                    'Centralized Events Overview',
                    style: NASTypography.headlineMd.copyWith(
                      color: NASColors.primary,
                      fontFamily: NASTypography.headlineFont,
                    ),
                  ),
                  const SizedBox(height: NASSpacing.xs),
                  Text(
                    'Oversee all events from all 14 regional chapters across Nepal.',
                    style: NASTypography.bodyMd.copyWith(color: NASColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: NASSpacing.lg),

                  const NASCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('All Chapters Activity', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('24 upcoming events scheduled this quarter across Bagmati, Madhesh, Koshi, Gandaki, and Lumbini provinces.'),
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
