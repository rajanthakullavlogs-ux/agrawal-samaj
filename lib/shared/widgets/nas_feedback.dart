import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// Loading skeleton — animated pulse shimmer effect.
/// Matches the "Loading State" from the Global Component Sheet (Screen D).
class NASLoadingSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const NASLoadingSkeleton({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return _ShimmerContainer(
      width: width,
      height: height,
      borderRadius: borderRadius ?? NASRadius.defaultBorderRadius,
    );
  }

  /// Card skeleton — mimics the layout of a member card.
  static Widget card() {
    return Container(
      padding: const EdgeInsets.all(NASSpacing.md),
      decoration: BoxDecoration(
        color: NASColors.surfaceContainerLowest,
        borderRadius: NASRadius.lgBorderRadius,
        border: Border.all(color: NASColors.surfaceVariant),
      ),
      child: Row(
        children: [
          const _ShimmerContainer(
            width: 48,
            height: 48,
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          const SizedBox(width: NASSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerContainer(
                  width: 120,
                  height: 16,
                  borderRadius: NASRadius.defaultBorderRadius,
                ),
                const SizedBox(height: NASSpacing.xs),
                _ShimmerContainer(
                  width: 200,
                  height: 12,
                  borderRadius: NASRadius.defaultBorderRadius,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// List of card skeletons.
  static Widget list({int count = 3}) {
    return Column(
      children: List.generate(
        count,
        (i) => Padding(
          padding: EdgeInsets.only(bottom: i < count - 1 ? NASSpacing.sm : 0),
          child: card(),
        ),
      ),
    );
  }

  /// Grid skeleton for gallery/events.
  static Widget grid({int count = 4, int crossAxisCount = 2}) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: NASSpacing.sm,
      crossAxisSpacing: NASSpacing.sm,
      children: List.generate(
        count,
        (_) => _ShimmerContainer(
          borderRadius: NASRadius.lgBorderRadius,
        ),
      ),
    );
  }
}

class _ShimmerContainer extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  const _ShimmerContainer({
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  State<_ShimmerContainer> createState() => _ShimmerContainerState();
}

class _ShimmerContainerState extends State<_ShimmerContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: NASColors.surfaceVariant.withValues(alpha: _animation.value),
            borderRadius: widget.borderRadius,
          ),
        );
      },
    );
  }
}

/// Empty state — centered icon, title, and description.
/// Matches the "Empty State" from the Global Component Sheet (Screen D).
class NASEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final Widget? action;

  const NASEmptyState({
    super.key,
    this.icon = Icons.search_off,
    required this.title,
    this.description,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: NASSpacing.md,
        vertical: NASSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: NASColors.surfaceContainerLow,
        borderRadius: NASRadius.lgBorderRadius,
        border: Border.all(color: NASColors.surfaceVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: NASColors.outline),
          const SizedBox(height: NASSpacing.sm),
          Text(
            title,
            style: NASTypography.titleLg.copyWith(color: NASColors.onSurface),
            textAlign: TextAlign.center,
          ),
          if (description != null) ...[
            const SizedBox(height: NASSpacing.xs),
            Text(
              description!,
              style: NASTypography.bodyMd.copyWith(
                color: NASColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: NASSpacing.md),
            action!,
          ],
        ],
      ),
    );
  }
}

/// Toast / Snackbar helper that matches the design system's feedback style.
class NASToast {
  NASToast._();

  /// Show a success toast (dark background with green checkmark).
  static void success(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: NASColors.tertiaryFixedDim),
            const SizedBox(width: NASSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: NASTypography.labelMd.copyWith(
                  color: NASColors.inverseOnSurface,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: NASColors.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: NASRadius.defaultBorderRadius),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show an error toast (error container background).
  static void error(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: NASColors.onErrorContainer),
            const SizedBox(width: NASSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: NASTypography.labelMd.copyWith(
                  color: NASColors.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: NASColors.errorContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: NASRadius.defaultBorderRadius),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
