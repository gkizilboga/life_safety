import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF1A237E);
  static const Color backgroundGrey = Color(
    0xFFF8F9FA,
  ); // 0xFFF5F7F9 was used too
  static const Color cardBackground = Color(0xFFF5F7F9);
  static const Color cardBorder = Color(0xFFE1E8ED);

  static const Color successGreen = Color(0xFF4CAF50);
  static const Color dangerRed = Color(0xFFE53935);
  static const Color warningOrange = Color(0xFFFB8C00); // 0xFFFF9800 or similar

  static const Color textHeader = Color(0xFF263238); // Dark Blue Grey
  static const Color textBody = Color(0xFF37474F);
  static const Color textLabel = Color(0xFF455A64);
  static const Color textHint = Color(0xFF90A4AE);

  // Legacy aliases
  static const Color textDark = textHeader;
  static const Color textLight = textLabel;

  static const Color inputFill = Colors.white;
  static const Color inputBorder = Color(0xFFCFD8DC);
}

class AppStyles {
  // --- Text Styles ---
  static const TextStyle headerTitle = TextStyle(
    color: Colors.white,
    fontSize: 20, // Reduced from 22
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
  );

  static const TextStyle questionTitle = TextStyle(
    fontSize: 16, // Reduced from 18
    fontWeight: FontWeight.bold,
    color: AppColors.textHeader,
    height: 1.3,
  );

  static const TextStyle inputLabel = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: AppColors.textLabel,
  );

  // --- Theme Data Helpers ---
  static final ButtonStyle mainButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryBlue,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14), // Reduced from 16
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    textStyle: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
    elevation: 0,
  );

  static InputDecoration inputDecoration(
    String hint, {
    String? errorText,
    String? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      errorText: errorText,
      suffixText: suffix,
      filled: true,
      fillColor: AppColors.inputFill,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
      ),
    );
  }
}
