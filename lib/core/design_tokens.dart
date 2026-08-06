import 'package:flutter/material.dart';

/// Design tokens extracted from the Heritage & Unity design system
/// (~/Downloads/agrawal samaj design/heritage_unity/DESIGN.md)
///
/// These tokens are the single source of truth for the entire app's
/// visual design. Every screen references these constants rather than
/// hardcoding colors, spacing, or typography values.
class NASColors {
  NASColors._();

  // ── Primary (Maroon) ─────────────────────────────────────────────
  static const Color primary = Color(0xFF570000);
  static const Color primaryContainer = Color(0xFF800000);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFFF8371);
  static const Color inversePrimary = Color(0xFFFFB4A8);
  static const Color surfaceTint = Color(0xFFB22B1D);

  // ── Primary Fixed ────────────────────────────────────────────────
  static const Color primaryFixed = Color(0xFFFFDAD4);
  static const Color primaryFixedDim = Color(0xFFFFB4A8);
  static const Color onPrimaryFixed = Color(0xFF410000);
  static const Color onPrimaryFixedVariant = Color(0xFF8F0F07);

  // ── Secondary (Saffron Gold) ─────────────────────────────────────
  static const Color secondary = Color(0xFF795900);
  static const Color secondaryContainer = Color(0xFFFCC340);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF6F5100);

  // ── Secondary Fixed ──────────────────────────────────────────────
  static const Color secondaryFixed = Color(0xFFFFDEA0);
  static const Color secondaryFixedDim = Color(0xFFF6BE3B);
  static const Color onSecondaryFixed = Color(0xFF261900);
  static const Color onSecondaryFixedVariant = Color(0xFF5C4300);

  // ── Tertiary (Forest Green) ──────────────────────────────────────
  static const Color tertiary = Color(0xFF002E06);
  static const Color tertiaryContainer = Color(0xFF00470E);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFF69B966);

  // ── Tertiary Fixed ───────────────────────────────────────────────
  static const Color tertiaryFixed = Color(0xFFA3F69C);
  static const Color tertiaryFixedDim = Color(0xFF88D982);
  static const Color onTertiaryFixed = Color(0xFF002204);
  static const Color onTertiaryFixedVariant = Color(0xFF005312);

  // ── Error ────────────────────────────────────────────────────────
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);

  // ── Surface & Background ─────────────────────────────────────────
  static const Color surface = Color(0xFFFBF9F8);
  static const Color surfaceDim = Color(0xFFDCD9D9);
  static const Color surfaceBright = Color(0xFFFBF9F8);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF6F3F2);
  static const Color surfaceContainer = Color(0xFFF0EDED);
  static const Color surfaceContainerHigh = Color(0xFFEAE8E7);
  static const Color surfaceContainerHighest = Color(0xFFE4E2E1);
  static const Color surfaceVariant = Color(0xFFE4E2E1);
  static const Color background = Color(0xFFFBF9F8);

  // ── On Surface ───────────────────────────────────────────────────
  static const Color onSurface = Color(0xFF1B1C1C);
  static const Color onSurfaceVariant = Color(0xFF5A413D);
  static const Color onBackground = Color(0xFF1B1C1C);

  // ── Inverse ──────────────────────────────────────────────────────
  static const Color inverseSurface = Color(0xFF303030);
  static const Color inverseOnSurface = Color(0xFFF3F0F0);

  // ── Outline ──────────────────────────────────────────────────────
  static const Color outline = Color(0xFF8E706C);
  static const Color outlineVariant = Color(0xFFE2BFB9);

  // ── Semantic Aliases ─────────────────────────────────────────────
  static const Color success = tertiaryContainer;
  static const Color onSuccess = onTertiaryContainer;
  static const Color warning = secondaryContainer;
  static const Color onWarning = onSecondaryContainer;

  // ── Gradients ────────────────────────────────────────────────────
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surface, surfaceContainerLow],
  );

  static LinearGradient cardOverlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, primary.withValues(alpha: 0.8)],
  );
}

/// Spacing scale based on 4px base unit.
class NASSpacing {
  NASSpacing._();

  static const double base = 4.0;
  static const double xs = 8.0;
  static const double sm = 16.0;
  static const double md = 24.0;
  static const double lg = 40.0;
  static const double xl = 64.0;
  static const double gutter = 16.0;
  static const double marginMobile = 20.0;
  static const double maxWidth = 1200.0;

  // Commonly used EdgeInsets
  static const EdgeInsets pagePaddingMobile =
      EdgeInsets.symmetric(horizontal: marginMobile);
  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets sectionPaddingVertical =
      EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets sectionPaddingLarge =
      EdgeInsets.symmetric(vertical: lg);
}

/// Border radius constants.
class NASRadius {
  NASRadius._();

  static const double sm = 4.0;
  static const double defaultRadius = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 9999.0;

  static final BorderRadius smBorderRadius = BorderRadius.circular(sm);
  static final BorderRadius defaultBorderRadius =
      BorderRadius.circular(defaultRadius);
  static final BorderRadius mdBorderRadius = BorderRadius.circular(md);
  static final BorderRadius lgBorderRadius = BorderRadius.circular(lg);
  static final BorderRadius xlBorderRadius = BorderRadius.circular(xl);
  static final BorderRadius fullBorderRadius = BorderRadius.circular(full);
}

/// Elevation / Shadow definitions.
/// Uses warm-tinted shadows per the design system spec.
class NASShadows {
  NASShadows._();

  static List<BoxShadow> get sm => [
        BoxShadow(
          color: NASColors.primary.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get md => [
        BoxShadow(
          color: NASColors.primary.withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get lg => [
        BoxShadow(
          color: NASColors.primary.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get topShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, -2),
        ),
      ];
}

/// Typography style definitions.
/// Headlines: Playfair Display  |  Body & UI: Inter
class NASTypography {
  NASTypography._();

  static const String headlineFont = 'Playfair Display';
  static const String bodyFont = 'Inter';

  static const TextStyle displayLg = TextStyle(
    fontFamily: headlineFont,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 56 / 48,
    letterSpacing: -0.96, // -0.02em
  );

  static const TextStyle displayLgMobile = TextStyle(
    fontFamily: headlineFont,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    letterSpacing: -0.32, // -0.01em
  );

  static const TextStyle headlineMd = TextStyle(
    fontFamily: headlineFont,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 40 / 32,
  );

  static const TextStyle headlineMdMobile = TextStyle(
    fontFamily: headlineFont,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
  );

  static const TextStyle titleLg = TextStyle(
    fontFamily: bodyFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: bodyFont,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  static const TextStyle labelMd = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: 0.14, // 0.01em
  );

  static const TextStyle labelSm = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
  );
}

/// Icon configuration matching the design spec:
/// "Line-style icons with a consistent 2px stroke weight"
class NASIcons {
  NASIcons._();

  static const double defaultSize = 24.0;
  static const double smallSize = 20.0;
  static const double largeSize = 32.0;
  static const double heroSize = 48.0;
}

// ── App Token Aliases (for modern UI component compatibility) ────────
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF7A1B22); // Maroon matching design image
  static const Color maroon = Color(0xFF7A1B22);
  static const Color maroonDark = Color(0xFF5C1219);
  static const Color maroonLight = Color(0xFF8F2530);

  static const Color accent = Color(0xFFD32F2F);
  static const Color accentLight = Color(0xFFFBE9E7);

  static const Color gold = Color(0xFFE8A93A);
  static const Color goldDark = Color(0xFFD79424);
  static const Color goldLight = Color(0xFFF4C766);

  static const Color creamLight = Color(0xFFFDF3DC);
  static const Color creamDark = Color(0xFFF3DDB0);

  static const Color textDark = Color(0xFF2B2320);
  static const Color textGrey = Color(0xFF6E645D);
  static const Color textLightGrey = Color(0xFF9A928C);

  static const Color pinkBg = Color(0xFFFBE3E4);
  static const Color pinkIcon = Color(0xFFE0596B);
  static const Color amberBg = Color(0xFFFCEBD3);
  static const Color amberIcon = Color(0xFFE8A93A);
  static const Color purpleBg = Color(0xFFEAE3F7);
  static const Color purpleIcon = Color(0xFF8B5FC7);
  static const Color greenBg = Color(0xFFE1F2E3);
  static const Color greenIcon = Color(0xFF4CA85B);

  static const Color viewDetailsBg = Color(0xFFF7E2E2);
  static const Color joinBannerBg = Color(0xFFFBE7E7);
  static const Color cardBorder = Color(0xFFEDEAE6);

  static const Color background = Color(0xFFF7F5F3);
  static const Color cardBackground = NASColors.surfaceContainerLowest;
  static const Color subtleCard = NASColors.surfaceContainerLow;
  static const Color border = NASColors.outlineVariant;
  static const Color divider = NASColors.surfaceVariant;
  static const Color textSecondary = NASColors.onSurfaceVariant;
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color badgeMaroon = Color(0xFF7A1B22);

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFE65100), Color(0xFFF57C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient maroonGradient = LinearGradient(
    colors: [Color(0xFF7A1B22), Color(0xFF5C1219)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppSpacing {
  AppSpacing._();

  static const double xs = NASSpacing.xs; // 8.0
  static const double sm = NASSpacing.xs; // 8.0
  static const double md = NASSpacing.sm; // 16.0
  static const double lg = NASSpacing.md; // 24.0
  static const double xl = NASSpacing.lg; // 40.0
}

class AppRadius {
  AppRadius._();

  static const double sm = NASRadius.sm;
  static const double md = NASRadius.defaultRadius;
  static const double lg = NASRadius.lg;
  static const double pill = NASRadius.full;
}

class AppShadow {
  AppShadow._();

  static List<BoxShadow> get card => NASShadows.sm;
}

class AppText {
  AppText._();

  static const TextStyle h1 = TextStyle(
    fontFamily: NASTypography.headlineFont,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: NASTypography.headlineFont,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: NASTypography.bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle tagline = TextStyle(
    fontFamily: NASTypography.bodyFont,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.gold,
    letterSpacing: 1.2,
  );

  static const TextStyle body = TextStyle(
    fontFamily: NASTypography.bodyFont,
    fontSize: 13,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: NASTypography.bodyFont,
    fontSize: 11,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: NASTypography.bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle statNumber = TextStyle(
    fontFamily: NASTypography.bodyFont,
    fontSize: 15,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  static const TextStyle statLabel = TextStyle(
    fontFamily: NASTypography.bodyFont,
    fontSize: 10,
    color: AppColors.textSecondary,
  );
}
