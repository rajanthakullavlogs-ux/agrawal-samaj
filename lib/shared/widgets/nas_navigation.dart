import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

import '../../core/design_tokens.dart';

/// Public site top app bar — fixed, with hamburger menu on mobile and nav links on desktop.
/// Matches the header from Screen A1 and the nav section of Screen D.
class NASAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onMenuTap;

  const NASAppBar({
    super.key,
    this.title = 'Nepal Agrawal Samaj',
    this.actions,
    this.showBackButton = false,
    this.onMenuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final canPop = showBackButton || ModalRoute.of(context)?.canPop == true || GoRouter.of(context).canPop();
    return AppBar(
      leading: canPop
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: NASColors.primary),
              onPressed: () {
                if (GoRouter.of(context).canPop()) {
                  context.pop();
                } else if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  context.go(AppConstants.home);
                }
              },
            )
          : IconButton(
              icon: const Icon(Icons.menu),
              onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
            ),
      title: Text(
        title,
        style: NASTypography.headlineMdMobile.copyWith(
          color: NASColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: actions ??
          [
            IconButton(
              icon: const Icon(Icons.account_circle_outlined, color: NASColors.primary),
              onPressed: () => context.push(AppConstants.profile),
            ),
          ],
    );
  }
}

/// Admin panel sidebar navigation — matches Screen D's admin sidebar mockup.
/// Active item has pill-shaped secondary-container highlight.
class NASAdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTap;
  final List<NASNavItem> items;
  final String title;

  const NASAdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemTap,
    required this.items,
    this.title = 'Admin Panel',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: NASColors.surfaceContainerLow,
        border: const Border(
          right: BorderSide(color: NASColors.surfaceVariant),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(NASSpacing.md),
            decoration: const BoxDecoration(
              color: NASColors.surfaceContainer,
              border: Border(
                bottom: BorderSide(color: NASColors.surfaceVariant),
              ),
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: NASTypography.titleLg.copyWith(
                    color: NASColors.primary,
                  ),
                ),
              ],
            ),
          ),
          // Nav items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: NASSpacing.sm),
              child: Column(
                children: items.asMap().entries.map((entry) {
                  final isSelected = entry.key == selectedIndex;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: NASSpacing.xs,
                      vertical: 2,
                    ),
                    child: Material(
                      color: isSelected
                          ? NASColors.secondaryContainer
                          : Colors.transparent,
                      borderRadius: NASRadius.fullBorderRadius,
                      child: InkWell(
                        onTap: () => onItemTap(entry.key),
                        borderRadius: NASRadius.fullBorderRadius,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: NASSpacing.sm,
                            vertical: NASSpacing.xs,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                entry.value.icon,
                                color: isSelected
                                    ? NASColors.onSecondaryContainer
                                    : NASColors.onSurfaceVariant,
                                size: 22,
                              ),
                              const SizedBox(width: NASSpacing.sm),
                              Text(
                                entry.value.label,
                                style: NASTypography.labelMd.copyWith(
                                  color: isSelected
                                      ? NASColors.onSecondaryContainer
                                      : NASColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom navigation bar for mobile — matches the bottom nav from Screen D.
/// Active item has primary-container pill highlight.
class NASBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTap;
  final List<NASNavItem> items;

  const NASBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NASColors.surface,
        border: const Border(
          top: BorderSide(color: NASColors.outlineVariant),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(NASRadius.lg),
          topRight: Radius.circular(NASRadius.lg),
        ),
        boxShadow: NASShadows.topShadow,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final isSelected = entry.key == selectedIndex;
              return GestureDetector(
                onTap: () => onItemTap(entry.key),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: NASSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? NASColors.primaryContainer
                        : Colors.transparent,
                    borderRadius: NASRadius.xlBorderRadius,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected
                            ? entry.value.activeIcon ?? entry.value.icon
                            : entry.value.icon,
                        color: isSelected
                            ? NASColors.onPrimaryContainer
                            : NASColors.onSurfaceVariant,
                        size: 24,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        entry.value.label,
                        style: NASTypography.labelSm.copyWith(
                          color: isSelected
                              ? NASColors.onPrimaryContainer
                              : NASColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// Footer widget — matches the footer from Screens A1 and D.
class NASFooter extends StatelessWidget {
  const NASFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: NASColors.surfaceContainerHighest,
      padding: const EdgeInsets.only(
        top: NASSpacing.lg,
        bottom: NASSpacing.sm,
        left: NASSpacing.marginMobile,
        right: NASSpacing.marginMobile,
      ),
      child: Column(
        children: [
          // Top section
          Wrap(
            spacing: NASSpacing.xl,
            runSpacing: NASSpacing.md,
            children: [
              // Brand
              SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nepal Agrawal Samaj',
                      style: NASTypography.headlineMd.copyWith(
                        color: NASColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: NASSpacing.xs),
                    Text(
                      'Upholding heritage, fostering unity, and serving the community since 1989. Join us in building a stronger future together.',
                      style: NASTypography.bodyMd.copyWith(
                        color: NASColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Quick Links
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Links',
                    style: NASTypography.labelMd.copyWith(
                      color: NASColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: NASSpacing.xs),
                  ...[
                    'Privacy Policy',
                    'Terms of Service',
                    'FAQ',
                    'Donate',
                  ].map(
                    (link) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        link,
                        style: NASTypography.labelSm.copyWith(
                          color: NASColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Contact
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact',
                    style: NASTypography.labelMd.copyWith(
                      color: NASColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: NASSpacing.xs),
                  ...[
                    'Kathmandu, Nepal',
                    '+977 1 4XXXXXX',
                    'info@agrawalsamaj.org.np',
                  ].map(
                    (text) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        text,
                        style: NASTypography.labelSm.copyWith(
                          color: NASColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: NASSpacing.xl),
          // Bottom bar
          const Divider(color: NASColors.outlineVariant),
          const SizedBox(height: NASSpacing.sm),
          Text(
            '© 2024 Nepal Agrawal Samaj. All Rights Reserved.',
            style: NASTypography.labelSm.copyWith(
              color: NASColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Data class for navigation items.
class NASNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const NASNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}

/// Global Public Site Bottom Navigation Bar — matches the exact design from screenshot
class NASBottomNavBar extends StatelessWidget {
  final int activeIndex;
  const NASBottomNavBar({super.key, this.activeIndex = 0});

  static const _items = [
    (icon: Icons.home_rounded, activeIcon: Icons.home_rounded, label: 'Home', route: AppConstants.home),
    (icon: Icons.calendar_today_outlined, activeIcon: Icons.calendar_today_rounded, label: 'Events', route: AppConstants.events),
    (icon: Icons.groups_rounded, activeIcon: Icons.groups_rounded, label: 'Membership', route: AppConstants.membershipSelector),
    (icon: Icons.photo_library_outlined, activeIcon: Icons.photo_library_rounded, label: 'Gallery', route: AppConstants.gallery),
    (icon: Icons.grid_view_rounded, activeIcon: Icons.grid_view_rounded, label: 'More', route: AppConstants.about),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (int i = 0; i < _items.length; i++) ...[
                if (i == 2)
                  // Center Membership Button (Golden circular button)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.go(_items[i].route),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFF9C846), Color(0xFFEAA010)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFEAA010).withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.groups_rounded,
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _items[i].label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: i == activeIndex ? FontWeight.w700 : FontWeight.w500,
                              color: i == activeIndex ? const Color(0xFF700D15) : const Color(0xFF6E6E6E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.go(_items[i].route),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                              decoration: BoxDecoration(
                                color: i == activeIndex ? const Color(0xFFFFF0F0) : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                i == activeIndex ? _items[i].activeIcon : _items[i].icon,
                                size: 22,
                                color: i == activeIndex ? const Color(0xFF700D15) : const Color(0xFF757575),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _items[i].label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: i == activeIndex ? FontWeight.w700 : FontWeight.w500,
                                color: i == activeIndex ? const Color(0xFF700D15) : const Color(0xFF757575),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

