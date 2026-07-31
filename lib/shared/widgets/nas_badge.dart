import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// Status badge/chip — pill-shaped with semantic background colors.
/// Matches the "Badges & Chips" section from the Global Component Sheet (Screen D).
///
/// Usage:
/// ```dart
/// NASBadge.active()      // Green — "Active Member"
/// NASBadge.business()    // Gold — "Business"
/// NASBadge.cultural()    // Coral — "Cultural"
/// NASBadge.overdue()     // Red — "Overdue"
/// NASBadge.pending()     // Gray — "Pending Approval"
/// NASBadge.custom(...)   // Custom colors
/// ```
class NASBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const NASBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
  });

  /// Active member — green.
  factory NASBadge.active({String label = 'Active'}) {
    return NASBadge(
      label: label,
      backgroundColor: NASColors.tertiaryContainer,
      textColor: NASColors.onTertiaryContainer,
    );
  }

  /// Business membership — gold.
  factory NASBadge.business({String label = 'Business'}) {
    return NASBadge(
      label: label,
      backgroundColor: NASColors.secondaryContainer,
      textColor: NASColors.onSecondaryContainer,
    );
  }

  /// Cultural/event — coral.
  factory NASBadge.cultural({String label = 'Cultural'}) {
    return NASBadge(
      label: label,
      backgroundColor: NASColors.primaryFixed,
      textColor: NASColors.onPrimaryFixed,
    );
  }

  /// Overdue/error — red.
  factory NASBadge.overdue({String label = 'Overdue'}) {
    return NASBadge(
      label: label,
      backgroundColor: NASColors.errorContainer,
      textColor: NASColors.onErrorContainer,
    );
  }

  /// Pending — gray.
  factory NASBadge.pending({String label = 'Pending'}) {
    return NASBadge(
      label: label,
      backgroundColor: NASColors.surfaceContainerHighest,
      textColor: NASColors.onSurfaceVariant,
    );
  }

  /// Inactive — muted red.
  factory NASBadge.inactive({String label = 'Inactive'}) {
    return NASBadge(
      label: label,
      backgroundColor: NASColors.surfaceContainerHighest,
      textColor: NASColors.onSurfaceVariant,
    );
  }

  /// Status badge from a membership status string.
  factory NASBadge.fromStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return NASBadge.active();
      case 'pending':
        return NASBadge.pending();
      case 'inactive':
        return NASBadge.inactive();
      default:
        return NASBadge.pending(label: status);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: NASRadius.fullBorderRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label.toUpperCase(),
            style: NASTypography.labelSm.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
