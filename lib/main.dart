import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/register_screen.dart';
import 'screens/onboarding_screen.dart';
import 'data/bina_store.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BinaStore.instance.loadFromDisk();
  runApp(const BinaYanginRiskAnaliziApp());
}

class BinaYanginRiskAnaliziApp extends StatelessWidget {
  const BinaYanginRiskAnaliziApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bina Yangın Risk Analizi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryBlue,
        scaffoldBackgroundColor: AppColors.backgroundGrey,
        useMaterial3: true,
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: AppStyles.mainButton,
        ),
      ),
      home: _getInitialScreen(),
    );
  }

  Widget _getInitialScreen() {
    final store = BinaStore.instance;
    if (!store.hasSeenOnboarding) {
      return const OnboardingScreen(); // buildingName parametresi OLMAMALI
    }
    if (!store.isRegistered) {
      return const RegisterScreen();
    }
    return const DashboardScreen();
  }
}
