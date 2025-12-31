import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';
import '../logic/report_engine.dart';
import '../data/bina_store.dart';

class ReportSummaryScreen extends StatelessWidget {
  const ReportSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          const ModernHeader(
            title: "Yangın Risk Analiz Raporu",
            subtitle: "Bina Durum Karnesi ve Modüler Tespitler",
            screenType: ReportSummaryScreen,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ReportModule.values.length,
              itemBuilder: (context, index) {
                final module = ReportModule.values[index];
                return _buildModuleCard(context, module);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, ReportModule module) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: const Icon(Icons.fact_check_outlined, color: Color(0xFF1A237E)),
          title: Text(
            module.title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E), fontSize: 16),
          ),
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
      title: Text("Bölüm $id", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
      subtitle: Text(summary, style: const TextStyle(fontSize: 14, color: Color(0xFF2C3E50), fontWeight: FontWeight.w500)),
      trailing: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
      ),
    );
  }

  void _showDetailSheet(BuildContext context, int id, String title, String report, Color color) {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Container(width: 4, height: 24, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 12),
                Expanded(
                  child: Text("Bölüm $id: $title", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text("ANALİZ TESPİTİ VE TAVSİYE:", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1)),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(15), border: Border.all(color: color.withOpacity(0.1))),
              child: Text(
                report,
                style: const TextStyle(fontSize: 15, color: Color(0xFF2C3E50), height: 1.5, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
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