import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_widgets.dart';
import '../utils/app_strings.dart';

class LegislationLibraryScreen extends StatelessWidget {
  const LegislationLibraryScreen({super.key});

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Bağlantı açılamadı: $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Column(
        children: [
          const ModernHeader(
            title: AppStrings.legislationTitle,
            subtitle: AppStrings.legislationSubtitle,
            screenType: LegislationLibraryScreen,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildLegislationCard(
                  context,
                  "Binaların Yangından Korunması Hakkında Yönetmelik (BYKHY)",
                  "Resmi Gazete Mevzuat Sistemi",
                  Icons.local_fire_department_outlined, // HATA BURADA DÜZELTİLDİ
                  Colors.red.shade900,
                  "Yangın güvenliğine ilişkin temel yasal düzenleme ve zorunluluklar.",
                  "https://www.mevzuat.gov.tr/mevzuat?MevzuatNo=200712937&MevzuatTur=21&MevzuatTertip=5",
                ),
                _buildLegislationCard(
                  context,
                  "Binaların Yangından Korunması Hakkında Yönetmelik Kılavuzu (BYKHY Kılavuzu)",
                  "Çevre, Şehircilik ve İklim Değişikliği Bakanlığı",
                  Icons.auto_stories_outlined,
                  Colors.blue.shade900,
                  "Yönetmelik hükümlerinin teknik açıklamaları ve uygulama detayları.",
                  "https://webdosya.csb.gov.tr/db/meslekihizmetler/haberler/r2-b-nalarin-yangin-korunmasi-hakkinda-yonetmel-k-kilavuzu-etk-les-ml--20241221082232.pdf",
                ),
                _buildLegislationCard(
                  context,
                  "Yapı Malzemeleri Yönetmeliği",
                  "Resmi Gazete Mevzuat Sistemi",
                  Icons.category_outlined,
                  Colors.orange.shade900,
                  "Binalarda kullanılacak malzemelerin standartları ve uygunluk kriterleri.",
                  "https://mevzuat.gov.tr/mevzuat?MevzuatNo=18568&MevzuatTur=7&MevzuatTertip=5",
                ),
                _buildLegislationCard(
                  context,
                  "Planlı Alanlar İmar Yönetmeliği",
                  "Resmi Gazete Mevzuat Sistemi",
                  Icons.architecture_outlined,
                  Colors.green.shade900,
                  "Yapılaşma koşulları ve imar disiplinine dair temel hükümler.",
                  "https://www.mevzuat.gov.tr/mevzuat?MevzuatNo=23722&MevzuatTur=7&MevzuatTertip=5",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegislationCard(BuildContext context, String title, String subtitle, IconData icon, Color color, String description, String url) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 26),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textLight,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => _launchURL(url),
                icon: const Icon(Icons.open_in_new, size: 18),
                label: const Text(
                  "RESMİ DOKÜMANI AÇ",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}