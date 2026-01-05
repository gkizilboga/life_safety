import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_widgets.dart';

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
          icon: const Icon(Icons.close, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const Icon(Icons.verified_user_rounded, size: 80, color: AppColors.primaryBlue),
                  const SizedBox(height: 24),
                  const Text(
                    "Profesyonel Rapor Erişimi",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "36 bölümden oluşan detaylı risk analiz raporunuzu PDF formatında almak ve arşivlemek için premium erişim gereklidir.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: AppColors.textLight, height: 1.5),
                  ),
                  const SizedBox(height: 40),
                  _buildFeatureRow(Icons.picture_as_pdf, "Kapsamlı PDF Raporu"),
                  _buildFeatureRow(Icons.analytics_outlined, "Detaylı Risk Skorlaması"),
                  _buildFeatureRow(Icons.gavel_outlined, "Mevzuata Uygun Teknik Dil"),
                  _buildFeatureRow(Icons.cloud_done_outlined, "Sınırsız Arşivleme İmkanı"),
                  const SizedBox(height: 50),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGrey,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primaryBlue.withOpacity(0.1)),
                    ),
                    child: const Column(
                      children: [
                        Text("TEK SEFERLİK ÖDEME", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryBlue, letterSpacing: 1)),
                        SizedBox(height: 8),
                        Text("₺499,99", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.textDark)),
                        Text("Tüm özellikler süresiz açılır", style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomAction(context),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.successGreen, size: 24),
          const SizedBox(width: 16),
          Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textDark)),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                // HATA BURADA DÜZELTİLDİ: setPremiumStatus yerine doğrudan isPremium kullanıldı
                BinaStore.instance.isPremium = true;
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Premium erişim aktif edildi. Raporunuzu şimdi alabilirsiniz.")),
                );
                Navigator.pop(context);
              },
              child: const Text("ŞİMDİ SATIN AL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 12),
          const Text("Güvenli ödeme altyapısı ile korunmaktadır.", style: TextStyle(fontSize: 11, color: AppColors.textLight)),
        ],
      ),
    );
  }
}