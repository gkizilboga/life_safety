import 'package:flutter/material.dart';

enum ReportStatus {
  compliant(Colors.green, "Yeterli Görünüyor"),
  risk(Colors.red, "Kritik Risk"),
  warning(Colors.orange, "Uyarı / İyileştirme"),
  unknown(Colors.grey, "İnceleme Gerekiyor"),
  info(Colors.blue, "Bilgi");

  final Color color;
  final String label;
  const ReportStatus(this.color, this.label);
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
