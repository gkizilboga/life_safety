import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'data/bina_store.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BinaStore.instance.loadFromDisk();
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