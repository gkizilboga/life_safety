import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'screens/dashboard_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/error_screen.dart';
import 'data/bina_store.dart';
import 'utils/app_theme.dart';

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await GoogleSignIn.instance.initialize();

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

class BinaYanginRiskAnaliziApp extends StatefulWidget {
  const BinaYanginRiskAnaliziApp({super.key});

  @override
  State<BinaYanginRiskAnaliziApp> createState() => _BinaYanginRiskAnaliziAppState();
}

class _BinaYanginRiskAnaliziAppState extends State<BinaYanginRiskAnaliziApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      BinaStore.instance.saveToDisk(immediate: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yangın Muayene',
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
    // Giriş ekranı şimdilik kaldırıldı.
    return const DashboardScreen();
  }
}

