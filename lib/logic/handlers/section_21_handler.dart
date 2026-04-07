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
    String? subtitle,
    String? advice,
    RiskLevel? level,
  }) {
    details.add({
      'label': label,
      'value': value,
      'subtitle': subtitle ?? '',
      'report': report,
      'advice': advice ?? '',
      'status': level != null
          ? ReportStatus.fromRiskLevel(level)
          : ReportStatus.info,
    });
  }

  List<Map<String, dynamic>> getDetailedReport() {
    List<Map<String, dynamic>> details = [];
    final b21 = _store.bolum21;
    if (b21 != null) {
      final yghReasons = ReportEngine.evaluateYghRequirement(store: _store);
      final bool isMandatory = yghReasons.isNotEmpty;
      final bool hasYgh = b21.varlik?.label.contains("21-1-A") == true;

      String evaluationMessage = "";
      RiskLevel finalLevel = b21.varlik?.level ?? RiskLevel.info;

      if (isMandatory) {
        if (hasYgh) {
          evaluationMessage =
              "OLUMLU: Binadaki aşağıdaki teknik veriler nedeniyle YGH zorunluluğu bulunmakta olup, kullanıcı tarafından binada MEVCUT olduğu beyan edilmiştir:\n- ${yghReasons.join('\n- ')}";
          finalLevel = RiskLevel.positive;
        } else {
          evaluationMessage =
              "KRİTİK RİSK: Bina teknik verilerine göre Yangın Güvenlik Holü (YGH) ZORUNLU olmasına rağmen binada MEVCUT OLMADIĞI beyan edilmiştir. Bu durum tahliye güvenliği adına yüksek risk oluşturmaktadır.\n\nBinadaki YGH zorunluluğu gerekçeleri:\n- ${yghReasons.join('\n- ')}";
          finalLevel = RiskLevel.critical;
        }
      } else {
        evaluationMessage =
            "Mevcut bina verilerine göre (yükseklik, kullanım amacı vb.) bu binada Yangın Güvenlik Holü (YGH) zorunluluğu tespit edilmemiştir.";
        finalLevel = hasYgh ? RiskLevel.positive : RiskLevel.info;
      }

      _addDetail(
        details,
        label: 'Merdiven önünde Yangın Güvenlik Holü var mı?',
        value: b21.varlik?.uiTitle ?? '-',
        subtitle: b21.varlik?.uiSubtitle,
        report: '',
        advice: b21.varlik?.adviceText,
        level: hasYgh ? RiskLevel.positive : RiskLevel.info,
      );

      if (hasYgh) {
        _addDetail(
          details,
          label: 'YGH (Hol) içindeki kaplama malzemeleri yanmaz özellikte mi?',
          value: b21.malzeme?.uiTitle ?? '-',
          subtitle: b21.malzeme?.uiSubtitle,
          report: '',
          advice: b21.malzeme?.adviceText,
          level: b21.malzeme?.level,
        );
        _addDetail(
          details,
          label: 'YGH (Hol) kapıları duman sızdırmaz ve yangına dayanıklı mı?',
          value: b21.kapi?.uiTitle ?? '-',
          subtitle: b21.kapi?.uiSubtitle,
          report: '',
          advice: b21.kapi?.adviceText,
          level: b21.kapi?.level,
        );
        _addDetail(
          details,
          label: 'YGH (Hol) içinde eşya (bisiklet, dolap vb.) var mı?',
          value: b21.esya?.uiTitle ?? '-',
          subtitle: b21.esya?.uiSubtitle,
          report: '',
          advice: b21.esya?.adviceText,
          level: b21.esya?.level,
        );
      }

      // Otomatik Gereksinim Analizi (Tabloyu bölmemesi için en sona taşındı)
      _addDetail(
        details,
        label: 'YGH Gereksinimi',
        value: '',
        report: isMandatory
            ? "DURUM: ZORUNLU\n\n$evaluationMessage"
            : "DURUM: ŞART DEĞİL\n\n$evaluationMessage",
        level: finalLevel,
      );
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
        parts.add("DURUM: Binada Yangın Güvenlik Holü (YGH) bulunmamaktadır.");
      }
    }

    return parts.join("\n\n");
  }

  String getSummaryReport(String baseLabel) {
    final yghReasons = ReportEngine.evaluateYghRequirement(store: _store);
    final bool isMandatory = yghReasons.isNotEmpty;
    final String mandatoryText = isMandatory
        ? " (Zorunlu)"
        : " (Zorunlu Değil)";
    return "$baseLabel$mandatoryText";
  }
}
