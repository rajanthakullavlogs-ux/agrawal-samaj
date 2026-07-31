import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/design_tokens.dart';

/// Responsive layout builder that switches between mobile and desktop layouts.
/// Uses the breakpoints from the design system (12-col fluid grid on desktop,
/// 4-col fluid grid on mobile).
class NASResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const NASResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  /// Returns true if the current screen is mobile width.
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < AppConstants.mobileBreakpoint;

  /// Returns true if the current screen is tablet width.
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= AppConstants.mobileBreakpoint &&
        width < AppConstants.desktopBreakpoint;
  }

  /// Returns true if the current screen is desktop width.
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= AppConstants.desktopBreakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppConstants.desktopBreakpoint) {
          return desktop;
        } else if (constraints.maxWidth >= AppConstants.mobileBreakpoint) {
          return tablet ?? desktop;
        }
        return mobile;
      },
    );
  }
}

/// A constrained content wrapper that limits max width to 1200px
/// (the design system's max-width) with centered alignment.
class NASContentWidth extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const NASContentWidth({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: NASSpacing.maxWidth),
        child: Padding(
          padding: padding ?? NASSpacing.pagePaddingMobile,
          child: child,
        ),
      ),
    );
  }
}

/// Section wrapper with standard vertical padding for page sections.
class NASSection extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const NASSection({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: padding ?? NASSpacing.sectionPaddingVertical,
      child: NASContentWidth(child: child),
    );
  }
}
