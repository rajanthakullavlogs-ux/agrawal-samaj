import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/design_tokens.dart';

/// Builds the app-wide [ThemeData] from the Heritage & Unity design tokens.
///
/// Every screen should use `Theme.of(context)` or the design token constants
/// rather than hardcoding values, so the whole app stays consistent.
class NASTheme {
  NASTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: NASColors.primary,
      onPrimary: NASColors.onPrimary,
      primaryContainer: NASColors.primaryContainer,
      onPrimaryContainer: NASColors.onPrimaryContainer,
      secondary: NASColors.secondary,
      onSecondary: NASColors.onSecondary,
      secondaryContainer: NASColors.secondaryContainer,
      onSecondaryContainer: NASColors.onSecondaryContainer,
      tertiary: NASColors.tertiary,
      onTertiary: NASColors.onTertiary,
      tertiaryContainer: NASColors.tertiaryContainer,
      onTertiaryContainer: NASColors.onTertiaryContainer,
      error: NASColors.error,
      onError: NASColors.onError,
      errorContainer: NASColors.errorContainer,
      onErrorContainer: NASColors.onErrorContainer,
      surface: NASColors.surface,
      onSurface: NASColors.onSurface,
      onSurfaceVariant: NASColors.onSurfaceVariant,
      outline: NASColors.outline,
      outlineVariant: NASColors.outlineVariant,
      inverseSurface: NASColors.inverseSurface,
      onInverseSurface: NASColors.inverseOnSurface,
      inversePrimary: NASColors.inversePrimary,
      surfaceTint: NASColors.surfaceTint,
      surfaceContainerLowest: NASColors.surfaceContainerLowest,
      surfaceContainerLow: NASColors.surfaceContainerLow,
      surfaceContainer: NASColors.surfaceContainer,
      surfaceContainerHigh: NASColors.surfaceContainerHigh,
      surfaceContainerHighest: NASColors.surfaceContainerHighest,
      surfaceDim: NASColors.surfaceDim,
      surfaceBright: NASColors.surfaceBright,
    );

    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: NASColors.surface,
    );

    return baseTheme.copyWith(
      // ── Typography ──────────────────────────────────────────────
      textTheme: GoogleFonts.interTextTheme(
        TextTheme(
          displayLarge: NASTypography.displayLg.copyWith(color: NASColors.primary),
          displayMedium:
              NASTypography.displayLgMobile.copyWith(color: NASColors.primary),
          headlineMedium:
              NASTypography.headlineMd.copyWith(color: NASColors.primary),
          headlineSmall:
              NASTypography.headlineMdMobile.copyWith(color: NASColors.primary),
          titleLarge: NASTypography.titleLg.copyWith(color: NASColors.onSurface),
          bodyLarge:
              NASTypography.bodyLg.copyWith(color: NASColors.onSurfaceVariant),
          bodyMedium:
              NASTypography.bodyMd.copyWith(color: NASColors.onSurfaceVariant),
          labelLarge: NASTypography.labelMd.copyWith(color: NASColors.onSurface),
          labelMedium:
              NASTypography.labelMd.copyWith(color: NASColors.onSurfaceVariant),
          labelSmall:
              NASTypography.labelSm.copyWith(color: NASColors.onSurfaceVariant),
        ),
      ),

      // ── AppBar ──────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: NASColors.surface,
        foregroundColor: NASColors.primary,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: NASColors.surface,
        titleTextStyle:
            NASTypography.headlineMdMobile.copyWith(color: NASColors.primary),
        iconTheme: const IconThemeData(color: NASColors.primary),
      ),

      // ── Cards ───────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: NASColors.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: NASRadius.lgBorderRadius,
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Elevated Button (Primary) ──────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: NASColors.primary,
          foregroundColor: NASColors.onPrimary,
          textStyle: NASTypography.labelMd.copyWith(
            fontWeight: FontWeight.w700,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: NASSpacing.xl,
            vertical: 12,
          ),
          shape: const StadiumBorder(),
          elevation: 2,
        ),
      ),

      // ── Outlined Button (Secondary) ────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: NASColors.primary,
          textStyle: NASTypography.labelMd.copyWith(
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: NASSpacing.xl,
            vertical: 12,
          ),
          shape: const StadiumBorder(),
          side: const BorderSide(color: NASColors.primary),
        ),
      ),

      // ── Text Button ────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: NASColors.primary,
          textStyle: NASTypography.labelMd.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Input Decoration ───────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NASColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: NASSpacing.sm,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: NASRadius.defaultBorderRadius,
          borderSide: const BorderSide(color: NASColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: NASRadius.defaultBorderRadius,
          borderSide: const BorderSide(color: NASColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: NASRadius.defaultBorderRadius,
          borderSide: const BorderSide(color: NASColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: NASRadius.defaultBorderRadius,
          borderSide: const BorderSide(color: NASColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: NASRadius.defaultBorderRadius,
          borderSide: const BorderSide(color: NASColors.error, width: 2),
        ),
        labelStyle: NASTypography.labelMd.copyWith(
          color: NASColors.onSurfaceVariant,
        ),
        hintStyle: NASTypography.bodyMd.copyWith(
          color: NASColors.outline,
        ),
        errorStyle: NASTypography.labelSm.copyWith(
          color: NASColors.error,
        ),
      ),

      // ── Chip ───────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: NASColors.surfaceContainerHighest,
        labelStyle: NASTypography.labelSm,
        shape: RoundedRectangleBorder(
          borderRadius: NASRadius.fullBorderRadius,
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),

      // ── Bottom Navigation ──────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: NASColors.surface,
        selectedItemColor: NASColors.primary,
        unselectedItemColor: NASColors.onSurfaceVariant,
        selectedLabelStyle: NASTypography.labelSm,
        unselectedLabelStyle: NASTypography.labelSm,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // ── Navigation Rail (Desktop admin sidebar) ────────────────
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: NASColors.surfaceContainerLow,
        selectedIconTheme: const IconThemeData(color: NASColors.onSecondaryContainer),
        unselectedIconTheme: const IconThemeData(color: NASColors.onSurfaceVariant),
        selectedLabelTextStyle:
            NASTypography.labelMd.copyWith(color: NASColors.onSecondaryContainer),
        unselectedLabelTextStyle:
            NASTypography.labelMd.copyWith(color: NASColors.onSurfaceVariant),
        indicatorColor: NASColors.secondaryContainer,
        indicatorShape: const StadiumBorder(),
      ),

      // ── Snackbar ───────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: NASColors.inverseSurface,
        contentTextStyle:
            NASTypography.labelMd.copyWith(color: NASColors.inverseOnSurface),
        shape: RoundedRectangleBorder(
          borderRadius: NASRadius.defaultBorderRadius,
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Divider ────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: NASColors.outlineVariant,
        thickness: 1,
        space: 0,
      ),

      // ── Dialog ─────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: NASColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: NASRadius.lgBorderRadius,
        ),
        titleTextStyle:
            NASTypography.titleLg.copyWith(color: NASColors.onSurface),
      ),

      // ── TabBar ─────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: NASColors.primary,
        unselectedLabelColor: NASColors.onSurfaceVariant,
        labelStyle: NASTypography.labelMd.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: NASTypography.labelMd,
        indicatorColor: NASColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
      ),

      // ── FloatingActionButton ───────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: NASColors.primaryContainer,
        foregroundColor: NASColors.onPrimaryContainer,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // ── Switch ─────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return NASColors.onSecondary;
          }
          return NASColors.surfaceContainerLowest;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return NASColors.secondary;
          }
          return NASColors.surfaceVariant;
        }),
      ),
    );
  }
}
