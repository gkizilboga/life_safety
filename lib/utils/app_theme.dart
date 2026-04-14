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

  static const Color accentGold = Color(0xFFFFD700);
}

class AppStyles {
  static const TextStyle headerTitle = TextStyle(
    color: Colors.white,
    fontSize: 20, // Reduced from 22
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
  );

  // SORU metinleri için özel stil - Dikkat çekici renk
  static const TextStyle questionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: Color(0xFF4A148C), // Koyu Mor - Sorular için dikkat çekici
    height: 1.4,
    letterSpacing: 0.0,
  );

  // ALT SORU metinleri için stil - Ana sorulardan farklı, daha az baskın
  static const TextStyle subQuestionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: AppColors.textHeader, // Standart nötr renk
    height: 1.4,
  );

  // YANIT metinleri için stil - Daha nötr
  static const TextStyle answerTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Color(0xFF263238),
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
