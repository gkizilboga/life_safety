import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import 'active_systems_input_dialog.dart';
import 'active_systems_report_screen.dart';

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
      appBar: AppBar(title: const Text("Premium Modül")),
      body: Padding(
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
              "Bu modül, binanız için gerekli olan tüm Yangın Algılama, Söndürme, Duman Tahliye ve diğer aktif sistemlerin hangilerinin zorunlu olduğunu hesaplar.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              "Detaylı rapor ve gereksinim listesi için Premium Modülü satın alınız.",
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
    );
  }
}

// Wrapper class to handle navigation logic (Input Dialog check)
class ActiveSystemsReportScreenWrapper extends StatefulWidget {
  const ActiveSystemsReportScreenWrapper({super.key});

  @override
  State<ActiveSystemsReportScreenWrapper> createState() =>
      _ActiveSystemsReportScreenWrapperState();
}

class _ActiveSystemsReportScreenWrapperState
    extends State<ActiveSystemsReportScreenWrapper> {
  bool _isLoading = true;
  double? _facadeWidth;
  double? _parkingArea;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInputDialog();
    });
  }

  Future<void> _showInputDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ActiveSystemsInputDialog(
        onConfirmed: (facade, parking) {
          setState(() {
            _facadeWidth = facade;
            _parkingArea = parking;
            // zone ignored
            _isLoading = false;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return ActiveSystemsReportScreen(
      facadeWidth: _facadeWidth,
      parkingArea: _parkingArea,
    );
  }
}
