import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF1A237E);
  static const Color backgroundGrey = Color(0xFFF5F7FA);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color dangerRed = Color(0xFFE53935);
  static const Color warningOrange = Color(0xFFFB8C00);
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textLight = Color(0xFF7F8C8D);
}

class AppStyles {
  static const TextStyle headerTitle = TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle questionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w900,
    color: AppColors.textDark,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w800,
  );
  
  static final ButtonStyle mainButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryBlue,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    elevation: 4,
  );
}