import 'package:flutter/material.dart';
import '../logic/report_engine.dart';
import '../models/report_status.dart';
import '../models/choice_result.dart';
import '../widgets/custom_widgets.dart';
import '../data/bina_store.dart';

class ReportDetailScreen extends StatelessWidget {
  final PillarResult pillar;

  const ReportDetailScreen({super.key, required this.pillar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          ModernHeader(
            title: pillar.title,
            subtitle: "Detaylı Analiz Maddeleri",
            screenType: ReportDetailScreen,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pillar.sectionIds.length,
              itemBuilder: (context, index) {
                int sectionId = pillar.sectionIds[index];
                return _buildSectionResults(sectionId);
              },
            ),
          ),
        ],
      ),
    );
  }

Widget _buildSectionResults(int sectionId) {
    final store = BinaStore.instance;
    // O bölüme ait tüm ChoiceResult'ları alıyoruz
    List<ChoiceResult?> results = ReportEngine.getResultsBySection(sectionId, store);
    
    // Eğer o bölümle ilgili hiç veri yoksa (atlandıysa) boş dön
    if (results.every((element) => element == null)) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            "BÖLÜM $sectionId", // İleride buraya Bölüm Başlıklarını da ekleyebiliriz
            style: TextStyle(
              fontWeight: FontWeight.w900, 
              fontSize: 12, 
              color: Colors.blueGrey.shade700,
              letterSpacing: 1.2
            ),
          ),
        ),
...results.where((res) => res != null).map((res) {
  ReportStatus status = ReportEngine.getStatus(res);
  return _buildResultCard(
    res!.uiTitle, 
    status, 
    res.reportText
  );
}), // Buradaki .toList() silindi
      ],
    );
  }

  Widget _buildResultCard(String title, ReportStatus status, String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: status.color, width: 6)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(status == ReportStatus.compliant ? Icons.check_circle : Icons.warning, color: status.color, size: 20),
              const SizedBox(width: 8),
              Text(status.label, style: TextStyle(color: status.color, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(message, style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87)),
        ],
      ),
    );
  }
}