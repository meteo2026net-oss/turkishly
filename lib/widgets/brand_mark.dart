import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 56, this.dark = false});

  final double size;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: dark ? AppColors.white : AppColors.navy,
        borderRadius: BorderRadius.circular(size * 0.30),
        border: Border.all(color: AppColors.gold, width: size * 0.035),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.14),
            blurRadius: size * 0.22,
            offset: Offset(0, size * 0.08),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.menu_book_rounded,
              size: size * 0.66,
              color: dark ? AppColors.navy : AppColors.white),
          Positioned(
            top: size * 0.08,
            right: size * 0.15,
            child: Icon(Icons.local_florist_rounded,
                size: size * 0.40, color: AppColors.red),
          ),
          Positioned(
            bottom: size * 0.11,
            child: Container(
              width: size * 0.34,
              height: size * 0.035,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
