import 'package:flutter/material.dart';
import '../logic/report_engine.dart';
import '../models/report_status.dart';
import '../widgets/custom_widgets.dart';

class ReportSummaryScreen extends StatelessWidget {
  const ReportSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pillars = ReportEngine.generatePillars();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          const ModernHeader(
            title: "Bina Güvenlik Karnesi",
            subtitle: "Denetim Sonuçları ve Risk Analizi",
            screenType: ReportSummaryScreen,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pillars.length,
              itemBuilder: (context, index) {
                return _buildPillarCard(pillars[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillarCard(PillarResult pillar) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              pillar.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(ReportStatus.compliant, pillar.stats[ReportStatus.compliant] ?? 0),
                _buildStatItem(ReportStatus.risk, pillar.stats[ReportStatus.risk] ?? 0),
                _buildStatItem(ReportStatus.warning, pillar.stats[ReportStatus.warning] ?? 0),
                _buildStatItem(ReportStatus.unknown, pillar.stats[ReportStatus.unknown] ?? 0),
              ],
            ),
          ),
          LinearProgressIndicator(
            value: _calculatePillarProgress(pillar),
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1A237E)),
            minHeight: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(ReportStatus status, int count) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: status.color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          status.label.split(' ')[0], // Kısa isim
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  double _calculatePillarProgress(PillarResult pillar) {
    // Bu sütundaki toplam cevaplanan soru sayısının toplam soru sayısına oranı
    return 1.0; // Şimdilik sabit
  }
}