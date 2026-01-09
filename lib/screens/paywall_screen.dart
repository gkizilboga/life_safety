import 'dart:ui';
import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import '../logic/report_engine.dart';
import '../utils/app_theme.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final metrics = ReportEngine.calculateRiskMetrics();
    final String profession = BinaStore.instance.userProfession;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildScoreHeader(metrics),
            const SizedBox(height: 30),
            _buildBlurredPreview(),
            const SizedBox(height: 30),
            _buildValueProposition(profession, metrics['criticalCount']),
            const SizedBox(height: 40),
            _buildPricingOptions(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreHeader(Map<String, dynamic> metrics) {
    return Column(
      children: [
        const Text("BİNANIZIN YANGIN GÜVENLİK SKORU", 
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.grey)),
        const SizedBox(height: 10),
        Text("%${metrics['score']}", 
          style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900, color: AppColors.primaryBlue)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(20)),
          child: Text("${metrics['criticalCount']} ADET KRİTİK RİSK TESPİT EDİLDİ", 
            style: TextStyle(color: Colors.red.shade900, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildBlurredPreview() {
    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 30, offset: const Offset(0, 10))],
        color: AppColors.backgroundGrey,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 15, width: 150, color: Colors.grey.shade300),
                  const SizedBox(height: 10),
                  Container(height: 10, width: 250, color: Colors.grey.shade200),
                  const SizedBox(height: 20),
                  Container(height: 40, width: double.infinity, color: Colors.orange.shade50),
                  const SizedBox(height: 10),
                  Container(height: 10, width: 200, color: Colors.grey.shade200),
                ],
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                alignment: Alignment.center,
                color: Colors.white.withOpacity(0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle),
                      child: const Icon(Icons.lock_outline, color: Colors.white, size: 32),
                    ),
                    const SizedBox(height: 15),
                    const Text("MÜHENDİSLİK ÇÖZÜMLERİ KİLİTLİ", 
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue, fontSize: 14)),
                    const Text("Tam raporu satın alarak çözüm yollarını görün", 
                      style: TextStyle(color: AppColors.textLight, fontSize: 11)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueProposition(String profession, int criticalCount) {
    String nudgeText = "Binanızdaki $criticalCount kritik uygunsuzluğu Yönetmelik maddeleriyle belgeleyin.";
    if (profession.contains("Yönetici")) nudgeText = "634 sayılı KMK uyarınca yasal sorumluluğunuzu dökümante edin.";
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Text(nudgeText, 
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 25),
          _buildFeatureRow(Icons.fact_check_outlined, "36 Bölüm Detaylı Teknik Analiz"),
          _buildFeatureRow(Icons.auto_fix_high_outlined, "Yangın Güvenliği İyileştirme Çözümleri"),
          _buildFeatureRow(Icons.gavel_outlined, "Yasal Mevzuat ve Dayanakları"),
          _buildFeatureRow(Icons.picture_as_pdf_outlined, "Paylaşılabilir Profesyonel PDF Çıktısı"),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppColors.successGreen, size: 20),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildPricingOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildPriceCard(context, "TEKLİ ANALİZ", "499 TL", "Tek bina için tam rapor ve reçete", false, 1),
          const SizedBox(height: 12),
          _buildPriceCard(context, "ÜÇLÜ PAKET", "1,199 TL", "Rapor başı 399 TL - En Popüler", true, 3),
          const SizedBox(height: 12),
          _buildPriceCard(context, "PRO PLAN", "1,999 TL", "Aylık 10 Rapor", false, 10),
        ],
      ),
    );
  }

  Widget _buildPriceCard(BuildContext context, String title, String price, String sub, bool isPopular, int credits) {
    return InkWell(
      onTap: () {
        BinaStore.instance.reportCredits += credits;
        BinaStore.instance.isPremium = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$title aktif edildi. $credits adet rapor kredisi eklendi.")),
        );
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isPopular ? AppColors.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isPopular ? AppColors.primaryBlue : Colors.grey.shade200, width: 2),
          boxShadow: isPopular ? [BoxShadow(color: AppColors.primaryBlue.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))] : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isPopular ? Colors.white : AppColors.textDark, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(sub, style: TextStyle(fontSize: 11, color: isPopular ? Colors.white70 : AppColors.textLight)),
                ],
              ),
            ),
            Text(price, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isPopular ? Colors.white : AppColors.primaryBlue)),
          ],
        ),
      ),
    );
  }
}