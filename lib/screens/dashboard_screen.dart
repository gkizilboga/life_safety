import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:life_safety/screens/settings_screen.dart';
import 'bolum_1_screen.dart';
import 'bolum_2_screen.dart';
import 'bolum_3_screen.dart';
import 'bolum_4_screen.dart';
import 'bolum_5_screen.dart';
import 'bolum_6_screen.dart';
import 'bolum_7_screen.dart';
import 'bolum_8_screen.dart';
import 'bolum_9_screen.dart';
import 'bolum_10_screen.dart';
import 'bolum_11_screen.dart';
import 'bolum_12_screen.dart';
import 'bolum_13_screen.dart';
import 'bolum_14_screen.dart';
import 'bolum_15_screen.dart';
import 'bolum_16_screen.dart';
import 'bolum_17_screen.dart';
import 'bolum_18_screen.dart';
import 'bolum_19_screen.dart';
import 'bolum_20_screen.dart';
import 'bolum_21_screen.dart';
import 'bolum_22_screen.dart';
import 'bolum_23_screen.dart';
import 'bolum_24_screen.dart';
import 'bolum_25_screen.dart';
import 'bolum_26_screen.dart';
import 'bolum_27_screen.dart';
import 'bolum_28_screen.dart';
import 'bolum_29_screen.dart';
import 'bolum_30_screen.dart';
import 'bolum_31_screen.dart';
import 'bolum_32_screen.dart';
import 'bolum_33_screen.dart';
import 'bolum_34_screen.dart';
import 'bolum_35_screen.dart';
import 'bolum_36_screen.dart';

import 'archive_screen.dart';
import 'building_setup_screen.dart';
import 'legislation_library_screen.dart';
import 'legal_text_screen.dart';
import 'report_summary_screen.dart';
import '../../data/bina_store.dart';
import '../services/pdf_service.dart';
import 'paywall_screen.dart';
import '../logic/report_engine.dart';
import '../utils/app_theme.dart';
import '../services/analysis_file_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final archive = BinaStore.instance.archive;
    final ongoingActions = archive
        .where((b) => !(b['isCompleted'] ?? false))
        .where(
          (b) => (b['name'] != "İsimsiz Bina"),
        ) // Filter out default unnamed
        .toList();
    final completedActions = archive
        .where((b) => (b['isCompleted'] ?? false))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                if (ongoingActions.isNotEmpty) ...[
                  _buildSectionLabel("DEVAM EDEN ANALİZLER"),
                  ...ongoingActions.reversed
                      .take(3)
                      .map(
                        (b) =>
                            _buildAnalysisCard(context, b, isCompleted: false),
                      ),
                  const SizedBox(height: 20),
                ],
                if (completedActions.isNotEmpty) ...[
                  _buildSectionLabel("TAMAMLANAN ANALİZLER"),
                  ...completedActions.reversed
                      .take(3)
                      .map(
                        (b) =>
                            _buildAnalysisCard(context, b, isCompleted: true),
                      ),
                  const SizedBox(height: 20),
                ],
                _buildSectionLabel("HIZLI ERİŞİM"),
                _buildMainActions(context),
                const SizedBox(height: 25),
                _buildSectionLabel("BİLGİLER VE AYARLAR"),
                _buildSecondaryMenu(context),
                const SizedBox(height: 25),
                _buildSectionLabel("PAYLAŞIM VE TRANSFER"),
                _buildFileActionSection(context, completedActions),
                const SizedBox(height: 25),
                _buildSectionLabel("DESTEK VE İLETİŞİM"),
                _buildSupportCard(context),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        24,
        MediaQuery.of(context).padding.top + 16,
        24,
        24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "YANGIN RİSK ANALİZİ",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 10,
              letterSpacing: 1.8,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "HOŞ GELDİNİZ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard(
    BuildContext context,
    Map<String, dynamic> building, {
    required bool isCompleted,
  }) {
    final String name = building['name'] ?? "İsimsiz Analiz";
    final String dateStr = building['date'].toString().split('T')[0];

    // We need to calculate completion for THIS building
    // However, metrics are global current.
    // For a list, we might just show basic info or pre-calculated completion if we added it to data.
    // We DO have lastActiveSection.
    final int lastSection = building['lastActiveSection'] ?? 1;
    final double completion = (lastSection / 36.0 * 100).clamp(0, 100);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusChip(isCompleted),
              Text(
                dateStr,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 15),
          if (!isCompleted) ...[
            _buildProgressBar(completion.toInt()),
            const SizedBox(height: 15),
          ],
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCompleted
                        ? AppColors.primaryBlue
                        : Colors.white,
                    foregroundColor: isCompleted
                        ? Colors.white
                        : AppColors.primaryBlue,
                    elevation: 0,
                    side: isCompleted
                        ? null
                        : const BorderSide(color: AppColors.primaryBlue),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    BinaStore.instance.loadBuildingFromArchive(building['id']);
                    if (isCompleted) {
                      // Bir frame bekle: store'un tamamen settle olmasını garantile
                      await Future.delayed(Duration.zero);
                      if (!context.mounted) return;
                      try {
                        await PdfService.generateRiskAnalysisPdf();
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("PDF hatası: $e")),
                          );
                        }
                      }
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _getResumeScreen(),
                        ),
                      );
                    }
                  },
                  child: Text(
                    isCompleted ? "ÖN RAPORU GÖR" : "DEVAM ET",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              if (!isCompleted) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () =>
                      _showDeleteConfirmation(context, building['id'], name),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                ),
              ],
            ],
          ),
          if (isCompleted) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await PdfService.generateActiveSystemsPdf();
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("PDF Hatası: $e")));
                    }
                  }
                },
                icon: const Icon(
                  Icons.settings_system_daydream_outlined,
                  size: 18,
                ),
                label: const Text("AKTİF SİSTEM GEREKSİNİMLERİ"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primaryBlue,
                  elevation: 0,
                  side: const BorderSide(color: AppColors.primaryBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChip(bool isCompleted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isCompleted ? "TAMAMLANDI" : "DEVAM EDİYOR",
        style: TextStyle(
          color: isCompleted ? Colors.green.shade700 : Colors.orange.shade700,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Analizi Sil"),
        content: Text("'$name' analizini silmek istediğinize emin misiniz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("VAZGEÇ", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              BinaStore.instance.deleteFromArchive(id);
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("SİL"),
          ),
        ],
      ),
    );
  }

  // Unused methods removed

  Widget _buildProgressBar(int percent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "İlerleme Durumu",
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "%$percent",
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 6,
            backgroundColor: Colors.grey.shade100,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primaryBlue,
            ),
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
            () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ArchiveScreen()),
              );
              if (mounted) setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String sub,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: title == "Yeni Analiz" ? Colors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sub,
              style: const TextStyle(color: AppColors.textLight, fontSize: 10),
            ),
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
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LegislationLibraryScreen(),
            ),
          ),
        ),
        _buildMenuTile(
          Icons.gavel_outlined,
          "Yasal Bilgilendirme",
          "KVKK ve Kullanım Şartları",
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LegalTextScreen()),
          ),
        ),
        _buildMenuTile(
          Icons.settings_outlined,
          "Uygulama Ayarları",
          "Profil ve Tercihler",
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTile(
    IconData icon,
    String title,
    String sub,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryBlue, size: 22),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.textDark,
          ),
        ),
        subtitle: Text(
          sub,
          style: const TextStyle(fontSize: 11, color: AppColors.textLight),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 12,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 15),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.textLight,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  void _startNewAnalysis(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BuildingSetupScreen()),
    );
    if (mounted) setState(() {});
  }

  Widget _buildSupportCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.green.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Uzman Desteği Alın",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Yangın güvenliği uzmanımızla görüşün",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green.shade800,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _launchWhatsApp,
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
                  label: const Text("WhatsApp"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _launchEmail,
                  icon: const Icon(Icons.email_outlined, size: 20),
                  label: const Text("E-Posta"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchWhatsApp() async {
    const String phoneNumber = "905555555555";
    final Uri url = Uri.parse("https://wa.me/$phoneNumber");

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        debugPrint('Could not launch WhatsApp');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("WhatsApp açılamadı.")));
        }
      }
    } catch (e) {
      debugPrint("WhatsApp error: $e");
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'destek@yanginguvenlik.com',
      query: _encodeQueryParameters(<String, String>{
        'subject': 'Yangın Risk Analizi Destek',
      }),
    );

    try {
      if (!await launchUrl(emailLaunchUri)) {
        debugPrint('Could not launch Email');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("E-posta uygulaması açılamadı.")),
          );
        }
      }
    } catch (e) {
      debugPrint("Email error: $e");
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  Widget _buildFileActionSection(
    BuildContext context,
    List<Map<String, dynamic>> completedActions,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _buildFileActionButton(
            context,
            icon: Icons.upload_file_rounded,
            title: "Analiz Dosyası Yükle (.lsf)",
            color: AppColors.primaryBlue,
            onTap: () async {
              final success = await AnalysisFileService.importAnalysis(context);
              if (success && mounted) {
                setState(() {});
              }
            },
          ),
          if (completedActions.isNotEmpty) ...[
            const Divider(height: 24, thickness: 0.5),
            _buildFileActionButton(
              context,
              icon: Icons.ios_share_rounded,
              title: "Tamamlanan Analizi Paylaş",
              color: Colors.orange.shade700,
              onTap: () {
                // En son tamamlananı paylaş
                final latest = completedActions.last;
                AnalysisFileService.exportAnalysis(latest);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFileActionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.textDark,
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _getResumeScreen() {
    final int lastIndex = BinaStore.instance.lastActiveSection;
    switch (lastIndex) {
      case 1:
        return const Bolum1Screen();
      case 2:
        return const Bolum2Screen();
      case 3:
        return const Bolum3Screen();
      case 4:
        return const Bolum4Screen();
      case 5:
        return const Bolum5Screen();
      case 6:
        return const Bolum6Screen();
      case 7:
        return const Bolum7Screen();
      case 8:
        return const Bolum8Screen();
      case 9:
        return const Bolum9Screen();
      case 10:
        return const Bolum10Screen();
      case 11:
        return const Bolum11Screen();
      case 12:
        return const Bolum12Screen();
      case 13:
        return const Bolum13Screen();
      case 14:
        return const Bolum14Screen();
      case 15:
        return const Bolum15Screen();
      case 16:
        return const Bolum16Screen();
      case 17:
        return const Bolum17Screen();
      case 18:
        return const Bolum18Screen();
      case 19:
        return const Bolum19Screen();
      case 20:
        return const Bolum20Screen();
      case 21:
        return const Bolum21Screen();
      case 22:
        return const Bolum22Screen();
      case 23:
        return const Bolum23Screen();
      case 24:
        return const Bolum24Screen();
      case 25:
        return const Bolum25Screen();
      case 26:
        return const Bolum26Screen();
      case 27:
        return const Bolum27Screen();
      case 28:
        return const Bolum28Screen();
      case 29:
        return const Bolum29Screen();
      case 30:
        return const Bolum30Screen();
      case 31:
        return const Bolum31Screen();
      case 32:
        return const Bolum32Screen();
      case 33:
        return const Bolum33Screen();
      case 34:
        return const Bolum34Screen();
      case 35:
        return const Bolum35Screen();
      case 36:
        return const Bolum36Screen();
      default:
        return const Bolum1Screen();
    }
  }
}
