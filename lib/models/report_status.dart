import 'package:flutter/material.dart';
import 'choice_result.dart';

enum ReportStatus {
  compliant(Colors.green, "Olumlu"),
  risk(Colors.red, "Kritik Risk"),
  warning(Colors.orange, "Uyarı"),
  unknown(Colors.grey, "Bilinmiyor"),
  info(Colors.blue, "Bilgi");

  final Color color;
  final String label;
  const ReportStatus(this.color, this.label);

  static ReportStatus fromRiskLevel(RiskLevel level) {
    switch (level) {
      case RiskLevel.critical:
        return ReportStatus.risk;
      case RiskLevel.warning:
        return ReportStatus.warning;
      case RiskLevel.positive:
        return ReportStatus.compliant;
      case RiskLevel.unknown:
        return ReportStatus.unknown;
      case RiskLevel.info:
        return ReportStatus.info;
    }
  }
}

class PillarResult {
  final String title;
  final Map<ReportStatus, int> stats;
  final List<int> sectionIds;

  PillarResult({
    required this.title,
    required this.stats,
    required this.sectionIds,
  });
}
