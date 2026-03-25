import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_safety/utils/app_theme.dart';
import 'package:life_safety/screens/bolum_5_screen.dart';

void main() {
  group('Visual Consistency and Style Compliance Tests', () {
    testWidgets('Section 5 input labels should be "silky" (black38 or grey)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            primaryColor: AppColors.primaryBlue,
            scaffoldBackgroundColor: AppColors.backgroundGrey,
            useMaterial3: true,
          ),
          home: const Bolum5Screen(),
        ),
      );

      // Verify that labels like "500" or similar hints are correctly styled
      bool foundSilky = false;

      for (var element in tester.allWidgets) {
        if (element is Text) {
          final style = element.style;
          // Check for the "silky" (de-emphasized) colors requested by the user
          // Colors.grey.shade400 is also used in hintStyle in Bolum5Screen
          if (style?.color == Colors.black38 || 
              style?.color == Colors.grey || 
              style?.color == AppColors.textHint ||
              style?.color == Colors.grey.shade400) {
            foundSilky = true;
          }
        }
      }
      
      expect(foundSilky, isTrue, reason: "Bölüm 5'te silik (silky) yazı tipi rengi bulunmalı.");
      
      // Clear pending timers from BinaStore.saveToDisk
      await tester.pump(const Duration(milliseconds: 3000));
    });

    test('AppColors.accentGold should be defined and consistent', () {
      expect(AppColors.accentGold, isNotNull);
      expect(AppColors.accentGold.red, greaterThan(200));
      expect(AppColors.accentGold.green, greaterThan(150));
    });

    test('Question title colors should be unified (Deep Purple)', () {
      expect(AppStyles.questionTitle.color, const Color(0xFF4A148C));
    });
  });
}
