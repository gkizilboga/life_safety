import 'screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:life_safety/screens/bolum_1_screen.dart';
import 'package:life_safety/utils/app_theme.dart';

void main() {
  runApp(const BinaKarnesiApp());
}

class BinaKarnesiApp extends StatelessWidget {
  const BinaKarnesiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BinaKarnesi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryBlue,
        scaffoldBackgroundColor: AppColors.backgroundGrey,
        useMaterial3: true,
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(style: AppStyles.mainButton),
      ),
      home: const DashboardScreen(),
    );
  }
}