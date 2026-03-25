import 'package:life_safety/data/bina_store.dart';
import '../../models/choice_result.dart';
import '../../models/report_status.dart';
import '../report_engine.dart';

class Section21Handler {
  final BinaStore _store;

  Section21Handler(this._store);

  void _addDetail(
    List<Map<String, dynamic>> details, {
    required String label,
    required String value,
    required String report,
    String? advice,
    RiskLevel? level,
  }) {
    details.add({
      'label': label,
      'value': value,
      'report': report,
      'advice': advice ?? '',
      'status': level != null ? ReportStatus.fromRiskLevel(level) : ReportStatus.info,
    });
  }

  List<Map<String, dynamic>> getDetailedReport() {
    List<Map<String, dynamic>> details = [];
    final b21 = _store.bolum21;
    if (b21 != null) {
      _addDetail(
        details,
        label: 'Merdiven önünde Yangın Güvenlik Holü var mı?',
        value: b21.varlik?.uiTitle ?? '-',
        report: '',
        advice: b21.varlik?.adviceText,
        level: b21.varlik?.level,
      );

      if (b21.varlik?.label.contains("21-1-A") == true) {
        _addDetail(
          details,
          label: 'YGH (Hol) içindeki kaplama malzemeleri yanmaz özellikte mi?',
          value: b21.malzeme?.uiTitle ?? '-',
          report: '',
          advice: b21.malzeme?.adviceText,
          level: b21.malzeme?.level,
        );
        _addDetail(
          details,
          label: 'YGH (Hol) kapıları duman sızdırmaz ve yangına dayanıklı mı?',
          value: b21.kapi?.uiTitle ?? '-',
          report: '',
          advice: b21.kapi?.adviceText,
          level: b21.kapi?.level,
        );
        _addDetail(
          details,
          label: 'YGH (Hol) içinde eşya (bisiklet, dolap vb.) var mı?',
          value: b21.esya?.uiTitle ?? '-',
          report: '',
          advice: b21.esya?.adviceText,
          level: b21.esya?.level,
        );
      }

      final yghReasons = ReportEngine.evaluateYghRequirement(store: _store);
      if (yghReasons.isNotEmpty) {
        _addDetail(
          details,
          label: 'YGH Teknik Değerlendirmesi',
          value: 'ZORUNLU',
          report:
              'Binadaki teknik verilere göre Yangın Güvenlik Holü (YGH) zorunluluğu bulunmaktadır:\n${yghReasons.join('\n')}',
          level: RiskLevel.critical,
        );
      } else {
        _addDetail(
          details,
          label: 'YGH Teknik Değerlendirmesi',
          value: 'UYGUN/GEREKLİ DEĞİL',
          report:
              'Mevcut verilere göre binada Yangın Güvenlik Holü (YGH) zorunluluğu tespit edilmemiştir.',
          level: RiskLevel.info,
        );
      }
    }
    return details;
  }

  String getSectionFullReport() {
    final b21 = _store.bolum21;
    final yghReasons = ReportEngine.evaluateYghRequirement(store: _store);
    final bool hasYgh = b21?.varlik?.label.contains("21-1-A") ?? false;
    final bool noYgh = b21?.varlik?.label.contains("21-1-B") ?? false;
    final bool isMandatory = yghReasons.isNotEmpty;

    List<String> parts = [];

    // 1. Değerlendirme Özeti
    if (isMandatory) {
      parts.add(
        "BİLGİ: YGH ZORUNLUDUR\nBinada aşağıdaki teknik gerekçelerden dolayı Yangın Güvenlik Holü (YGH) bulunması zorunludur:\n${yghReasons.join('\n')}",
      );
    } else {
      parts.add(
        "BİLGİ: YGH ZORUNLU DEĞİLDİR\nMevcut yapı ile ilgili beyanlara göre bu binada Yangın Güvenlik Holü (YGH) zorunluluğu tespit edilmemiştir.",
      );
    }

    // 2. Mevcut Durum Raporu
    if (hasYgh) {
      parts.add("DURUM: Binada Yangın Güvenlik Holü (YGH) mevcuttur.");
      if (b21?.malzeme != null) parts.add(b21!.malzeme!.reportText);
      if (b21?.kapi != null) parts.add(b21!.kapi!.reportText);
      if (b21?.esya != null) parts.add(b21!.esya!.reportText);
    } else if (noYgh) {
      if (isMandatory) {
        parts.add(
          "KRİTİK RİSK: Binada YGH zorunlu olmasına rağmen, binada mevcut olmadığı beyan edilmiştir.",
        );
      } else {
        parts.add(
          "DURUM: Binada Yangın Güvenlik Holü (YGH) bulunmamaktadır.",
        );
      }
    }

    return parts.join("\n\n");
  }

  String getSummaryReport(String baseLabel) {
    final yghReasons = ReportEngine.evaluateYghRequirement(store: _store);
    final bool isMandatory = yghReasons.isNotEmpty;
    final String mandatoryText = isMandatory ? " (Zorunlu)" : " (Zorunlu Değil)";
    return "$baseLabel$mandatoryText";
  }
}
