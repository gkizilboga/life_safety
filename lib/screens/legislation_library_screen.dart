import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_widgets.dart';

class LegislationLibraryScreen extends StatelessWidget {
  const LegislationLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Column(
        children: [
          const ModernHeader(
            title: "Yangın Yönetmeliği",
            subtitle: "BYKHY Hükümleri",
            screenType: LegislationLibraryScreen,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildChapter(
                  "BİRİNCİ KISIM",
                  "Genel Hükümler",
                  "Amaç, Kapsam, Dayanak ve Tanımlar. Yönetmeliğin hangi binaları kapsadığı ve temel terimlerin açıklamaları.",
                ),
                _buildChapter(
                  "İKİNCİ KISIM",
                  "Binaların Kullanım Sınıfları",
                  "Konutlar, konaklama amaçlı binalar, kurumsal binalar, büro binaları, ticaret binaları ve endüstriyel yapıların sınıflandırılması.",
                ),
                _buildChapter(
                  "ÜÇÜNCÜ KISIM",
                  "Binaların Yangın Dayanımı",
                  "Yapı elemanlarının yangına direnç süreleri, yangın kompartımanları ve duvarların özellikleri.",
                ),
                _buildChapter(
                  "DÖRDÜNCÜ KISIM",
                  "Kaçış Yolları ve Merdivenler",
                  "Kaçış uzaklıkları, kaçış merdiveni özellikleri, kapı genişlikleri ve tahliye kapasitesi hesaplamaları.",
                ),
                _buildChapter(
                  "BEŞİNCİ KISIM",
                  "Bina Bölümleri ve Tesisatlar",
                  "Kazan daireleri, yakıt depoları, mutfaklar, asansörler ve elektrik tesisatlarına ilişkin güvenlik önlemleri.",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapter(String title, String subtitle, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedAlignment: Alignment.topLeft,
        children: [
          const Divider(),
          Text(content, style: const TextStyle(fontSize: 13, color: AppColors.textLight, height: 1.5)),
          const SizedBox(height: 15),
          TextButton.icon(
            onPressed: () {}, // İleride resmi PDF linkine yönlendirilebilir
            icon: const Icon(Icons.open_in_new, size: 16),
            label: const Text("Resmi Gazete Metnini Gör", style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}