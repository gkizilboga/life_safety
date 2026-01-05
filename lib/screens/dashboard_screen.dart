import 'package:flutter/material.dart';
import 'package:life_safety/screens/settings_screen.dart';
import 'bolum_1_screen.dart';
import 'archive_screen.dart';
import 'building_setup_screen.dart';
import 'legislation_library_screen.dart';
import 'legal_text_screen.dart';
import '../../data/bina_store.dart';
import '../services/pdf_service.dart';
import 'paywall_screen.dart';
import '../logic/report_engine.dart';
import '../utils/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final metrics = ReportEngine.calculateRiskMetrics();
    final bool hasOngoing = BinaStore.instance.currentBinaId != null && BinaStore.instance.bolum1 != null;
    final String buildingName = BinaStore.instance.currentBinaName ?? "İsimsiz Analiz";
    final currentModule = _getCurrentModule(metrics['completion']);

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Column(
        children: [
          _buildHeader(context, metrics, currentModule),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                if (hasOngoing) _buildOngoingCard(context, buildingName, metrics, currentModule),
                const SizedBox(height: 20),
                _buildSectionLabel("HIZLI ERİŞİM"),
                _buildMainActions(context),
                const SizedBox(height: 25),
                _buildSectionLabel("BİLGİLER VE AYARLAR"),
                _buildSecondaryMenu(context),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic> metrics, ReportModule module) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
      decoration: const BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("BİNA YANGIN RİSK ANALİZİ", 
            style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("HOŞ GELDİNİZ,", 
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(BinaStore.instance.userName.toUpperCase(), 
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
              _buildRankBadge(module),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankBadge(ReportModule module) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: const Column(
        children: [
          Icon(Icons.shield_outlined, color: Color(0xFFFFD700), size: 24),
          SizedBox(height: 4),
          Text("KADEME", style: TextStyle(color: Colors.white70, fontSize: 8, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildOngoingCard(BuildContext context, String name, Map<String, dynamic> metrics, ReportModule module) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusChip(),
              IconButton(
                onPressed: () => _showResetConfirmation(context),
                icon: Icon(Icons.delete_sweep_outlined, color: Colors.red.shade300, size: 22),
                tooltip: "Analizi Sıfırla",
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(name, style: AppStyles.questionTitle),
          const SizedBox(height: 8),
          Text(module.rankDescription, 
            maxLines: 2, overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textLight, fontSize: 12, height: 1.4)),
          const SizedBox(height: 20),
          _buildProgressBar(metrics['completion']),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.primaryBlue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum1Screen())),
                  child: const Text("ANALİZE DÖN", style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warningOrange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  onPressed: () async {
                    if (BinaStore.instance.isPremium) {
                      await PdfService.generateAndShowPdf();
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PaywallScreen()));
                    }
                  },
                  child: const Text("ÖN RAPORU GÖR", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Analizi Sıfırla", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Mevcut analize ait tüm veriler temizlenecektir. Bu işlem geri alınamaz. Emin misiniz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("VAZGEÇ", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade800,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              setState(() {
                BinaStore.instance.clearCurrentAnalysis();
              });
              Navigator.pop(context);
            },
            child: const Text("EVET, SIFIRLA"),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text("AKTİF ANALİZ", 
        style: TextStyle(color: AppColors.primaryBlue, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
    );
  }

  Widget _buildProgressBar(int percent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("İlerleme Durumu", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600)),
            Text("%$percent", style: const TextStyle(fontSize: 10, color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 6,
            backgroundColor: Colors.grey.shade100,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
          ),
        ),
      ],
    );
  }

  Widget _buildMainActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context,
            "Yeni Analiz",
            "Sıfırdan Başlat",
            Icons.add_moderator_outlined,
            AppColors.successGreen,
            () => _startNewAnalysis(context),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildActionCard(
            context,
            "Arşiv",
            "Geçmiş Kayıtlar",
            Icons.inventory_2_outlined,
            AppColors.primaryBlue,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ArchiveScreen())),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, String title, String sub, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(20), 
          border: Border.all(color: Colors.grey.shade100)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 15),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
            const SizedBox(height: 4),
            Text(sub, style: const TextStyle(color: AppColors.textLight, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryMenu(BuildContext context) {
    return Column(
      children: [
        _buildMenuTile(
          Icons.menu_book_outlined, 
          "Mevzuatlar", 
          "Yönetmelik Hükümleri",
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LegislationLibraryScreen())),
        ),
        _buildMenuTile(
          Icons.gavel_outlined, 
          "Yasal Bilgilendirme", 
          "KVKK ve Kullanım Şartları",
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LegalTextScreen())),
        ),
        _buildMenuTile(
          Icons.settings_outlined, 
          "Uygulama Ayarları", 
          "Profil ve Tercihler",
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
        ),
      ],
    );
  }

  Widget _buildMenuTile(IconData icon, String title, String sub, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100)
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryBlue, size: 22),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
        subtitle: Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 15),
      child: Text(label, 
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textLight, letterSpacing: 1.2)),
    );
  }

  ReportModule _getCurrentModule(int completion) {
    if (completion <= 27) return ReportModule.binaBilgileri;
    if (completion <= 41) return ReportModule.modul1;
    if (completion <= 55) return ReportModule.modul2;
    if (completion <= 69) return ReportModule.modul3;
    if (completion <= 83) return ReportModule.modul4;
    return ReportModule.modul5;
  }

  void _startNewAnalysis(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const BuildingSetupScreen()));
  }
}