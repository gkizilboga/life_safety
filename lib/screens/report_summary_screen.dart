import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';
import '../logic/report_engine.dart';
import '../data/bina_store.dart';
import '../utils/app_strings.dart';

class ReportSummaryScreen extends StatelessWidget {
  const ReportSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final metrics = ReportEngine.calculateRiskMetrics();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          const ModernHeader(
            title: "Yangın Risk Analizi Ön Raporu",
            subtitle: "Kullanıcı Beyanına Dayalı Teknik Tespitler",
            screenType: ReportSummaryScreen,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildRiskPanel(metrics),
                const SizedBox(height: 16),
                _buildLegalWarningCard(),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 12),
                  child: Text("ANALİZ DETAYLARI", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
                ),
                ...ReportModule.values.map((module) => _buildModuleCard(context, module)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalWarningCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.gavel_rounded, color: Colors.amber.shade900, size: 20),
              const SizedBox(width: 8),
              Text("HUKUKİ BİLGİLENDİRME", style: TextStyle(color: Colors.amber.shade900, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            AppStrings.legalDisclaimerContent,
            style: TextStyle(fontSize: 11, color: Colors.black87, height: 1.4),
          ),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("GÜVENLİK SKORU", style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text("%${m['score']}", style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900)),
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
              _buildStatItem("Kritik Risk", "${m['criticalCount']}", const Color(0xFFEF5350)),
              _buildStatItem("Gri Alan", "${m['warningCount']}", Colors.orangeAccent),
              _buildStatItem("Tamamlanma", "%${m['completion']}", Colors.blueAccent),
            ],
          ),
          if (m['criticalCount'] > 0) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF5350), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Acil müdahale gereken konular: ${m['criticals'].join(', ')}...",
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
            valueColor: AlwaysStoppedAnimation<Color>(score > 70 ? Colors.greenAccent : (score > 40 ? Colors.orangeAccent : Colors.redAccent)),
          ),
          Center(child: Icon(score > 70 ? Icons.verified_user : Icons.gavel, color: Colors.white, size: 24)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String val, Color color) {
    return Column(
      children: [
        Text(val, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
      ],
    );
  }

  Widget _buildModuleCard(BuildContext context, ReportModule module) {
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
          leading: const Icon(Icons.fact_check_outlined, color: Color(0xFF1A237E)),
          title: Text(module.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E), fontSize: 15)),
          children: module.sectionIds.map((id) => _buildSectionTile(context, id)).toList(),
        ),
      ),
    );
  }

  Widget _buildSectionTile(BuildContext context, int id) {
    final summary = ReportEngine.getSectionSummary(id);
    final result = BinaStore.instance.getResultForSection(id);
    final statusColor = ReportEngine.getStatusColor(result);
    final fullReport = ReportEngine.getSectionFullReport(id);

    return ListTile(
      onTap: () => _showDetailSheet(context, id, summary, fullReport, statusColor),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      title: Text("Bölüm $id", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey)),
      subtitle: Text(summary, style: const TextStyle(fontSize: 14, color: Color(0xFF2C3E50), fontWeight: FontWeight.w500)),
      trailing: Container(width: 10, height: 10, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
    );
  }

  void _showDetailSheet(BuildContext context, int id, String title, String report, Color color) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 25),
            Text("Bölüm $id: $title", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(15), border: Border.all(color: color.withOpacity(0.1))),
              child: Text(report, style: const TextStyle(fontSize: 15, color: Color(0xFF2C3E50), height: 1.5, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () => Navigator.pop(context),
                child: const Text("ANLADIM", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}