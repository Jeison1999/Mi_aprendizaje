import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppStyles {
  static TextStyle title(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.montserrat(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: isDark ? Colors.white : AppColors.textPrimary,
    );
  }

  static TextStyle subtitle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.montserrat(
      fontSize: 16,
      color: isDark ? Colors.grey[300] : AppColors.textSecondary,
    );
  }

  static TextStyle button(BuildContext context) {
    return const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }

  static final RoundedRectangleBorder cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  );

  static final RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  );
}
