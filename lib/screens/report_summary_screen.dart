import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/custom_widgets.dart';
import '../logic/report_engine.dart';
import '../data/bina_store.dart';
import 'dashboard_screen.dart';
import 'paywall_screen.dart';
import '../utils/app_content.dart';

class ReportSummaryScreen extends StatefulWidget {
  const ReportSummaryScreen({super.key});

  @override
  State<ReportSummaryScreen> createState() => _ReportSummaryScreenState();
}

class _ReportSummaryScreenState extends State<ReportSummaryScreen> {
  late Map<String, dynamic> _metrics;
  late List<String> _yghReasons;
  late Map<ReportModule, double> _moduleScores;
  late bool _isPremium;

  Color _getUiRiskColor(String text) {
    if (text.contains('KRİTİK RİSK')) return const Color(0xFFEF5350); // Red
    if (text.contains('UYARI')) return const Color(0xFFFFD600); // Yellow (A700)
    if (text.contains('BİLİNMİYOR')) return Colors.grey;
    if (text.contains('OLUMLU')) return const Color(0xFF66BB6A); // Green
    if (text.contains('BİLGİ')) return const Color(0xFF42A5F5); // Blue
    return Colors.grey;
  }

  @override
  void initState() {
    super.initState();
    // Perform heavy calculations once
    _metrics = ReportEngine.calculateRiskMetrics();
    _yghReasons = ReportEngine.evaluateYghRequirement();
    _moduleScores = ReportEngine.calculateModuleScores();
    _isPremium = BinaStore.instance.isPremium;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      BinaStore.instance.markAsCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          const ModernHeader(
            title: "ÖZET",
            subtitle: "",
            screenType: ReportSummaryScreen,
          ),
          Expanded(
            child: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildRiskPanel(_metrics),
                    const SizedBox(height: 20),
                    _buildVisualAnalysis(_moduleScores),
                    if (_yghReasons.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _buildYghEvaluationPanel(_yghReasons),
                    ],
                    const SizedBox(height: 25),
                    const Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 12),
                      child: Text(
                        "YANGIN RİSK ANALİZİ",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    ...ReportModule.values.map(
                      (ReportModule module) =>
                          _buildModuleCard(context, module),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
                if (!_isPremium) _buildBlurredOverlay(context),
              ],
            ),
          ),
          _buildBottomAction(context, _isPremium),
        ],
      ),
    );
  }

  Widget _buildBlurredOverlay(BuildContext context) {
    return Positioned(
      top: 550,
      left: 0,
      right: 0,
      bottom: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.9),
                  Colors.white,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A237E),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "ÖN RAPOR VE İYİLEŞTİRME ÖNERİLERİ KİLİTLİ",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                  child: Text(
                    "Binanızdaki risklerin çözüm yollarını ve ön raporun tamamını görmek için devam edin.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVisualAnalysis(Map<ReportModule, double> scores) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "YANGIN RİSK ANALİZİ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Color(0xFF1A237E),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                dataSets: [
                  RadarDataSet(
                    fillColor: const Color(0xFF1A237E).withValues(alpha: 0.2),
                    borderColor: const Color(0xFF1A237E),
                    entryRadius: 3,
                    dataEntries: scores.values
                        .map((e) => RadarEntry(value: e))
                        .toList(),
                  ),
                ],
                radarBackgroundColor: Colors.transparent,
                borderData: FlBorderData(show: false),
                radarBorderData: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
                titlePositionPercentageOffset: 0.15,
                titleTextStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
                getTitle: (index, angle) {
                  return RadarChartTitle(
                    text: scores.keys.elementAt(index).title,
                    angle: angle,
                  );
                },
                tickCount: 4,
                ticksTextStyle: const TextStyle(color: Colors.transparent),
                gridBorderData: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Merkeze yakın noktalar riskli durumları temsil eder.",
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYghEvaluationPanel(List<String> reasons) {
    return CustomInfoNote(
      icon: Icons.security_rounded,
      margin: const EdgeInsets.only(top: 20),
      richText: TextSpan(
        children: [
          TextSpan(
            text: "YGH DEĞERLENDİRMESİ\n",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const TextSpan(
            text:
                "Binanızda Yangın Güvenlik Holü (YGH) zorunluluğu tespit edilmiştir:\n\n",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ...reasons.map((reason) => TextSpan(text: "• $reason\n")),
        ],
      ),
    );
  }

  Widget _buildRiskPanel(Map<String, dynamic> m) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A237E),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "YANGIN GÜVENLİK SKORU",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${m['score']} / 100",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              _buildCircularProgress(m['score']),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white12),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                "Kritik Risk",
                "${m['criticalCount']}",
                const Color(0xFFEF5350),
              ),
              _buildStatItem(
                "Uyarı",
                "${m['warningCount']}",
                const Color(0xFFFFC107),
              ),
              _buildStatItem(
                "Tamamlanma",
                "%${m['completion']}",
                Colors.blueAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularProgress(int score) {
    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 8,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(
              score > 70
                  ? Colors.greenAccent
                  : (score > 40 ? Colors.orangeAccent : Colors.redAccent),
            ),
          ),
          Center(
            child: Icon(
              score > 70 ? Icons.verified_user : Icons.gavel,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String val, Color color) {
    return Column(
      children: [
        Text(
          val,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildModuleCard(BuildContext context, ReportModule module) {
    List<Widget> visibleSections = [];
    for (int id in module.sectionIds) {
      final res = BinaStore.instance.getResultForSection(id);
      if (res == null) continue;
      visibleSections.add(_buildSectionTile(context, id));
    }
    if (visibleSections.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: const Icon(
            Icons.fact_check_outlined,
            color: Color(0xFF1A237E),
          ),
          title: Text(
            module.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
              fontSize: 15,
            ),
          ),
          children: visibleSections,
        ),
      ),
    );
  }

  Widget _buildSectionTile(BuildContext context, int id) {
    try {
      final summary = ReportEngine.getSectionSummary(id);
      final fullReport = ReportEngine.getSectionFullReport(id);
      final riskColor = _getUiRiskColor(fullReport);
      return ListTile(
        onTap: () =>
            _showDetailSheet(context, id, summary, fullReport, riskColor),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        title: Text(
          "Bölüm $id: ${AppDefinitions.getSectionTitle(id)}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
        subtitle: Text(
          summary,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: riskColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: riskColor.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        title: Text(
          "Bölüm $id",
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        subtitle: const Text(
          "Veri yüklenemedi",
          style: TextStyle(fontSize: 14, color: Colors.red),
        ),
      );
    }
  }

  void _showDetailSheet(
    BuildContext context,
    int id,
    String title,
    String report,
    Color color,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                "Bölüm $id: $title",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: color.withOpacity(0.1)),
                    ),
                    child: Text(
                      report,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2C3E50),
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "ANLADIM",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, bool isPremium) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // PDF indirme bilgi notu
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A237E).withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF1A237E).withOpacity(0.2),
                ),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFF1A237E),
                    size: 18,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Binanıza ait iki PDF raporu hazırlanmaktadır: "
                      "\"Yangın Risk Analizi\" (yaklaşık 15–25 sayfa) ve "
                      "\"Aktif Sistem Gereksinimleri\" raporu. "
                      "Her indirme işlemi 10–20 saniye sürebilir; bu sürede yazı tipleri yüklenmektedir. "
                      "Lütfen bekleyiniz, işlem tamamlandığında rapor otomatik açılacaktır.",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF1A237E),
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  // Her durumda önce kaydet
                  BinaStore.instance.saveToDisk();

                  if (isPremium) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),
                      (r) => false,
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaywallScreen(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  isPremium
                      ? "ANALİZİ TAMAMLA VE ANA SAYFAYA DÖN"
                      : "ANALİZİ AL",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 12,
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
