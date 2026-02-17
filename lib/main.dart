import 'dart:async';
import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/register_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/error_screen.dart';
import 'screens/login_screen.dart';
import 'data/bina_store.dart';
import 'utils/app_theme.dart';

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Flutter framework hatalarını yakala (Render hataları vb.)
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        // Burada loglama servisine hata gönderilebilir (Sentry, Firebase vs)
      };

      // Release modunda "Kırmızı Ekran" yerine bizim ekranımızı göster
      ErrorWidget.builder = (FlutterErrorDetails details) {
        return ErrorScreen(
          error: details.exception,
          stackTrace: details.stack,
          onRestart: () {
            // Basit yeniden başlatma mantığı - Ana ekrana dön
            runApp(const BinaYanginRiskAnaliziApp());
          },
        );
      };

      await BinaStore.instance.loadFromDisk();
      runApp(const BinaYanginRiskAnaliziApp());
    },
    (error, stack) {
      // Flutter dışı (Asenkron) hataları yakala
      debugPrint("GLOBAL HATA YAKALANDI: $error");
      debugPrint(stack.toString());
      // Burada da loglama yapılabilir

      // Eğer bir context'e erişimimiz olsaydı burada ErrorScreen'e yönlendirebilirdik.
      // Ancak main içindeyiz. En azından uygulama çökmeden loglanmış oldu.
      // Kritik hatalarda runApp(ErrorScreen(...)) çağrılabilir.
      runApp(
        MaterialApp(
          home: ErrorScreen(
            error: error,
            stackTrace: stack,
            onRestart: () => main(),
          ),
          debugShowCheckedModeBanner: false,
        ),
      );
    },
  );
}

class BinaYanginRiskAnaliziApp extends StatelessWidget {
  const BinaYanginRiskAnaliziApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NORA: Yangın Risk Analizi',
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
      return const OnboardingScreen();
    }
    if (!store.isRegistered) {
      return const LoginScreen();
    }
    return const DashboardScreen();
  }
}
