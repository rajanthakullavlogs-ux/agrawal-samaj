import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// Standard card with optional gold left-border accent.
/// Matches the card style from the Global Component Sheet (Screen D):
/// 16px corner radius, white bg, soft ambient shadow.
class NASCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool hasGoldAccent;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const NASCard({
    super.key,
    required this.child,
    this.padding,
    this.hasGoldAccent = false,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: NASColors.surfaceContainerLowest,
          borderRadius: borderRadius ?? NASRadius.lgBorderRadius,
          border: hasGoldAccent
              ? const Border(
                  left: BorderSide(
                    color: NASColors.secondaryContainer,
                    width: 4,
                  ),
                )
              : Border.all(color: NASColors.outlineVariant.withValues(alpha: 0.5)),
          boxShadow: NASShadows.sm,
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(NASSpacing.md),
          child: child,
        ),
      ),
    );
  }
}

/// Stat card — glass-morphism style with icon, label, and value.
/// Matches the stat card from Screen D.
class NASStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? trend;
  final Color? iconBackgroundColor;
  final Color? iconColor;

  const NASStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.trend,
    this.iconBackgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return NASCard(
      hasGoldAccent: true,
      padding: const EdgeInsets.symmetric(
        horizontal: NASSpacing.sm,
        vertical: NASSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconBackgroundColor ??
                  NASColors.secondaryContainer.withValues(alpha: 0.3),
              borderRadius: NASRadius.defaultBorderRadius,
            ),
            child: Icon(
              icon,
              color: iconColor ?? NASColors.secondary,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: NASTypography.headlineMd.copyWith(color: NASColors.primary),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: NASTypography.labelSm.copyWith(
              color: NASColors.onSurfaceVariant,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (trend != null) ...[
            const SizedBox(height: 2),
            Text(
              trend!,
              style: NASTypography.labelSm.copyWith(
                color: NASColors.onTertiaryContainer,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

/// Event card with image, date badge, title, and action button.
/// Matches the event card pattern from Screens A1, A3, and D.
class NASEventCard extends StatelessWidget {
  final String title;
  final String? description;
  final String? imageUrl;
  final String? day;
  final String? month;
  final VoidCallback? onTap;
  final VoidCallback? onRegister;

  const NASEventCard({
    super.key,
    required this.title,
    this.description,
    this.imageUrl,
    this.day,
    this.month,
    this.onTap,
    this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: NASColors.surface,
          borderRadius: NASRadius.xlBorderRadius,
          border: Border.all(color: NASColors.outlineVariant),
          boxShadow: NASShadows.md,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + date badge
            Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  color: NASColors.surfaceVariant,
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 2, color: NASColors.primary),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(Icons.event, size: 48, color: NASColors.outline),
                          ),
                        )
                      : const Center(
                          child: Icon(Icons.event, size: 48, color: NASColors.outline),
                        ),
                ),
                if (day != null && month != null)
                  Positioned(
                    top: NASSpacing.sm,
                    right: NASSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: NASSpacing.sm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: NASColors.secondaryContainer,
                        borderRadius: NASRadius.defaultBorderRadius,
                        boxShadow: NASShadows.sm,
                      ),
                      child: Column(
                        children: [
                          Text(
                            day!,
                            style: NASTypography.titleLg.copyWith(
                              color: NASColors.onSecondaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            month!.toUpperCase(),
                            style: NASTypography.labelSm.copyWith(
                              color: NASColors.onSecondaryContainer,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(NASSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: NASTypography.titleLg.copyWith(
                      color: NASColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      description!,
                      style: NASTypography.bodyMd.copyWith(
                        color: NASColors.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: NASSpacing.xs),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: onRegister ?? onTap,
                      child: const Text('Register Now'),
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
}

/// Member card with avatar, name, role, and status.
/// Matches the member card from Screen D with gold left-border accent.
class NASMemberCard extends StatelessWidget {
  final String name;
  final String? subtitle;
  final String? avatarUrl;
  final String? status;
  final String? memberType;
  final String? locationName;
  final VoidCallback? onTap;

  const NASMemberCard({
    super.key,
    required this.name,
    this.subtitle,
    this.avatarUrl,
    this.status,
    this.memberType,
    this.locationName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NASCard(
      hasGoldAccent: true,
      onTap: onTap,
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 28,
            backgroundColor: NASColors.surfaceVariant,
            backgroundImage:
                avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: NASTypography.titleLg.copyWith(
                      color: NASColors.primary,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: NASSpacing.sm),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: NASTypography.titleLg.copyWith(
                          color: NASColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (status != null) ...[
                      const SizedBox(width: NASSpacing.xs),
                      _buildStatusBadge(status!),
                    ],
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: NASTypography.labelSm.copyWith(
                      color: NASColors.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: NASSpacing.xs),
                Row(
                  children: [
                    if (memberType != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: NASColors.surfaceContainerHigh,
                          borderRadius: NASRadius.defaultBorderRadius,
                        ),
                        child: Text(
                          memberType!,
                          style: NASTypography.labelSm.copyWith(
                            color: NASColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    if (locationName != null) ...[
                      const SizedBox(width: NASSpacing.xs),
                      Icon(Icons.location_on_outlined,
                          size: 14, color: NASColors.onSurfaceVariant),
                      const SizedBox(width: 2),
                      Text(
                        locationName!,
                        style: NASTypography.labelSm.copyWith(
                          color: NASColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color fg;
    switch (status.toLowerCase()) {
      case 'active':
        bg = NASColors.tertiaryContainer;
        fg = NASColors.onTertiaryContainer;
        break;
      case 'pending':
        bg = NASColors.errorContainer;
        fg = NASColors.onErrorContainer;
        break;
      case 'inactive':
        bg = NASColors.surfaceContainerHighest;
        fg = NASColors.onSurfaceVariant;
        break;
      default:
        bg = NASColors.surfaceContainerHighest;
        fg = NASColors.onSurfaceVariant;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: NASRadius.fullBorderRadius,
      ),
      child: Text(
        status.toUpperCase(),
        style: NASTypography.labelSm.copyWith(color: fg, fontSize: 10),
      ),
    );
  }
}
