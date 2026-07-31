import 'package:flutter/material.dart';
import '../../core/design_tokens.dart';

/// NAS Logo widget used across the top bar, headers, and branding areas.
class NasLogo extends StatelessWidget {
  final double size;
  const NasLogo({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.temple_hindu_rounded,
              color: AppColors.gold,
              size: size * 0.45,
            ),
            Text(
              'NAS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: size * 0.2,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
