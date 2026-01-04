import 'package:flutter/material.dart';
import '../data/bina_store.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const Icon(Icons.verified_user_rounded, size: 80, color: Color(0xFF1A237E)),
            const SizedBox(height: 20),
            const Text(
              "Yangın Risk Analizi Ön Raporu",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
            ),
            const SizedBox(height: 15),
            const Text(
              "Binanızın güvenliğini profesyonel standartlarda belgeleyin.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            _buildFeatureItem(Icons.analytics_outlined, "Risk Skorlaması", "Binanızın tehlike seviyesini sayısal verilerle görün."),
            _buildFeatureItem(Icons.fact_check_outlined, "Uygunluk Kontrolü", "BYKHY yönetmeliğine göre tam denetim sonuçları."),
            _buildFeatureItem(Icons.lightbulb_outline, "Çözüm Önerileri", "Tespit edilen riskler için profesyonel iyileştirme yolları."),
            _buildFeatureItem(Icons.picture_as_pdf_outlined, "PDF Dışa Aktarım", "Resmi başvurularda ve sunumlarda kullanılabilir format."),
            const SizedBox(height: 50),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  const Text("TEK SEFERLİK ÖDEME", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  const SizedBox(height: 10),
                  const Text("₺299,99", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A237E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () async {
                        // Simüle edilmiş ödeme işlemi
                        await BinaStore.instance.setPremiumStatus(true);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Ödeme Başarılı! Raporunuz Hazır.")),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("RAPORU ŞİMDİ AL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text("Güvenli ödeme altyapısı ile korunmaktadır.", style: TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFF1A237E).withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: const Color(0xFF1A237E), size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(desc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}