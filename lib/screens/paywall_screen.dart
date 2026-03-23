import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import 'active_systems_report_screen.dart';
import '../widgets/custom_widgets.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  void _onPurchase(BuildContext context) {
    // Burada satın alma işlemi simüle ediliyor.
    // Gerçek uygulamada IAP entegrasyonu yapılmalıdır.
    BinaStore.instance.isPremium = true;

    // Satın alımdan sonra direkt rapor ekranına değil, dashboard'a dönüp oradan girilmesi daha doğru olabilir
    // Veya direkt akışı devam ettirebiliriz.
    // Kullanıcı satın aldıktan sonra direkt ilerlemek ister.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ActiveSystemsReportScreenWrapper(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ModernHeader(
            title: "Premium Modül",
            screenType: PaywallScreen,
          ),
          Expanded(
            child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, size: 80, color: Colors.amber),
            const SizedBox(height: 24),
            const Text(
              "Aktif Sistem Gereksinimleri",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "Bu modül, binanız için gerekli olan Yangın Algılama, Söndürme, Duman Tahliye ve diğer aktif sistemlerin hangilerinin zorunlu olduğunu belirler.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              "Detaylı gereksinim listesi için Premium Modülü satın alınız.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
              ),
              onPressed: () => _onPurchase(context),
              child: const Text(
                "SATIN AL / KİLİDİ AÇ",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    ),
  ],
),
);
}
}

// Wrapper class to handle navigation logic
class ActiveSystemsReportScreenWrapper extends StatelessWidget {
  const ActiveSystemsReportScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Giriş diyaloğuna artık gerek kalmadığı için direkt raporu gösteriyoruz.
    return const ActiveSystemsReportScreen();
  }
}

