import 'package:life_safety/data/bina_store.dart';
import '../../models/choice_result.dart';
import '../../models/report_status.dart';
import '../../utils/app_content.dart';
import '../report_engine.dart';

class Section27Handler {
  final BinaStore _store;

  Section27Handler(this._store);

  void _addDetail(
    List<Map<String, dynamic>> details, {
    required String label,
    required String value,
    required String report,
    String? advice,
    RiskLevel? level,
    ReportStatus? status,
  }) {
    details.add({
      'label': label,
      'value': value,
      'report': report,
      'advice': advice ?? '',
      'status':
          status ??
          (level != null
              ? ReportStatus.fromRiskLevel(level)
              : ReportStatus.info),
    });
  }

  RiskLevel _maxLevel(List<RiskLevel> levels) {
    if (levels.isEmpty) return RiskLevel.positive;
    RiskLevel maxL = levels.first;
    for (var l in levels) {
      if (l.priority > maxL.priority) {
        maxL = l;
      }
    }
    return maxL;
  }

  List<Map<String, dynamic>> getDetailedReport() {
    List<Map<String, dynamic>> details = [];
    final b27 = _store.bolum27;
    if (b27 != null) {
      if (b27.boyut != null) {
        _addDetail(
          details,
          label: Bolum27Content.questionBoyut,
          value: b27.boyut!.uiTitle,
          report: b27.boyut!.reportText,
          advice: b27.boyut!.adviceText,
          level: b27.boyut!.level,
        );
      }

      final bool zeminIndependent =
          _store.bolum34?.zemin?.label.contains("34-1-A") ?? false;
      final bool bodrumIndependent =
          _store.bolum34?.bodrum?.label.contains("34-2-A") ?? false;
      final bool normalIndependent =
          _store.bolum34?.normal?.label.contains("34-3-A") ?? false;

      final int yukZemin = zeminIndependent
          ? 0
          : (_store.bolum33?.yukZemin ?? 0);
      final int yukNormal = normalIndependent
          ? 0
          : (_store.bolum33?.yukNormal ?? 0);
      final int yukBodrum = bodrumIndependent
          ? 0
          : (_store.bolum33?.yukBodrum ?? 0);

      if (b27.yon.isNotEmpty) {
        List<String> exceed50List = [];
        if (yukZemin > 50) exceed50List.add("Zemin Kat ($yukZemin kişi)");
        if (yukNormal > 50) exceed50List.add("Normal Kat ($yukNormal kişi)");
        if (yukBodrum > 50) exceed50List.add("Bodrum Kat ($yukBodrum kişi)");

        List<String> reports = [];
        List<RiskLevel> levels = [];
        for (var e in b27.yon) {
          if (e.label == "27-2-B") {
            if (exceed50List.isEmpty) {
              reports.add(
                "OLUMLU: Kaçış yolu üzerindeki kapıların içeriye doğru açılması, kullanıcı yükü hiçbir katta 50 kişiyi aşmadığı için uygun gözükmektedir.",
              );
              levels.add(RiskLevel.positive);
            } else {
              reports.add(
                "KRİTİK RİSK: ${exceed50List.join(", ")} gibi katlarınızda kullanıcı yükü 50 kişiyi aştığı için kapıların içeriye doğru açılması uygun değildir. Kapıların kaçış yönüne (dışarıya) doğru açılması zorunludur.",
              );
              levels.add(RiskLevel.critical);
            }
          } else {
            reports.add(e.reportText);
            levels.add(e.level);
          }
        }

        _addDetail(
          details,
          label: Bolum27Content.questionYon,
          value: b27.yon.map((e) => e.uiTitle).join(' | '),
          report: reports.join('\n\n'),
          advice: b27.yon.map((e) => e.adviceText ?? "").join('\n\n'),
          level: _maxLevel(levels),
        );
      }

      if (b27.kilit.isNotEmpty) {
        List<String> exceed100List = [];
        if (yukZemin > 100) exceed100List.add("Zemin Kat ($yukZemin kişi)");
        if (yukNormal > 100) exceed100List.add("Normal Kat ($yukNormal kişi)");
        if (yukBodrum > 100) exceed100List.add("Bodrum Kat ($yukBodrum kişi)");

        List<String> reports = [];
        List<RiskLevel> levels = [];
        for (var e in b27.kilit) {
          if (e.label == "27-3-B") {
            if (exceed100List.isEmpty) {
              reports.add(
                "OLUMLU: Kaçış yolu üzerindeki kapılarda normal kapı kolu kullanımı, kullanıcı yükü 100 kişiyi aşmadığı için uygun gözükmektedir.",
              );
              levels.add(RiskLevel.positive);
            } else {
              reports.add(
                "KRİTİK RİSK: ${exceed100List.join(", ")} gibi katlarınızda kullanıcı yükü 100 kişiyi aştığı için kapılarda Panik Bar mekanizması kullanımı zorunludur. Mevcut kapılardaki kol mekanizması uygun değildir.",
              );
              levels.add(RiskLevel.critical);
            }
          } else {
            reports.add(e.reportText);
            levels.add(e.level);
          }
        }

        _addDetail(
          details,
          label: Bolum27Content.questionKilit,
          value: b27.kilit.map((e) => e.uiTitle).join(' | '),
          report: reports.join('\n\n'),
          advice: b27.kilit.map((e) => e.adviceText ?? "").join('\n\n'),
          level: _maxLevel(levels),
        );
      }

      if (b27.dayanim != null) {
        _addDetail(
          details,
          label: Bolum27Content.questionDayanim,
          value: b27.dayanim!.uiTitle,
          report: b27.dayanim!.reportText,
          advice: b27.dayanim!.adviceText,
          level: b27.dayanim!.level,
        );
      }

      String overridden = getSectionFullReport();
      if (overridden.contains("UYARI") &&
          !b27.yon.any((e) => overridden.contains(e.reportText))) {
        _addDetail(
          details,
          label: 'Kullanıcı Yükü Değerlendirmesi',
          value: "",
          report: overridden,
          status: ReportStatus.warning,
        );
      }
    }
    return details;
  }

  String getSectionFullReport() {
    final b27 = _store.bolum27;
    final b33 = _store.bolum33;

    if (b27 != null && b33 != null) {
      List<String> reportParts = [];

      List<String> loadDetails = [];
      if ((b33.yukZemin ?? 0) > 0)
        loadDetails.add("- Zemin Kat: ${b33.yukZemin} kişi");
      if ((b33.yukNormal ?? 0) > 0)
        loadDetails.add("- Normal Kat: ${b33.yukNormal} kişi");
      if ((b33.yukBodrum ?? 0) > 0)
        loadDetails.add("- Bodrum Kat: ${b33.yukBodrum} kişi");

      if (loadDetails.isNotEmpty) {
        reportParts.add(
          "BİLGİ: Hesaplanan Kullanıcı Yükleri:\n${loadDetails.join('\n')}",
        );
      }

      for (var y in b27.yon) {
        reportParts.add(y.reportText);
      }
      for (var k in b27.kilit) {
        reportParts.add(k.reportText);
      }
      if (b27.dayanim != null) reportParts.add(b27.dayanim!.reportText);

      final yukZemin = b33.yukZemin ?? 0;
      final yukNormal = b33.yukNormal ?? 0;
      final yukBodrum = b33.yukBodrum ?? 0;

      List<String> exceed50 = [];
      if (yukZemin > 50) exceed50.add("Zemin Kat ($yukZemin kişi)");
      if (yukNormal > 50) exceed50.add("Normal Kat ($yukNormal kişi)");
      if (yukBodrum > 50) exceed50.add("Bodrum Kat ($yukBodrum kişi)");

      List<String> exceed100 = [];
      if (yukZemin > 100) exceed100.add("Zemin Kat ($yukZemin kişi)");
      if (yukNormal > 100) exceed100.add("Normal Kat ($yukNormal kişi)");
      if (yukBodrum > 100) exceed100.add("Bodrum Kat ($yukBodrum kişi)");

      bool yonRiski =
          b27.yon.any(
            (e) => e.label.contains("27-2-B") || e.label.contains("27-2-D"),
          ) &&
          exceed50.isNotEmpty;

      bool kilitRiski =
          b27.kilit.any(
            (e) => e.label.contains("27-3-B") || e.label.contains("27-3-D"),
          ) &&
          exceed100.isNotEmpty;

      if (yonRiski || kilitRiski) {
        String context = "";
        if (yonRiski && kilitRiski) {
          context =
              "${exceed50.join(", ")} gibi katlarınızda kullanıcı yükü 50 ve 100 kişi sınırlarını aşmaktadır.";
        } else if (yonRiski) {
          context =
              "${exceed50.join(", ")} gibi katlarınızda kullanıcı yükü 50 kişi sınırını aşmaktadır.";
        } else {
          context =
              "${exceed100.join(", ")} gibi katlarınızda kullanıcı yükü 100 kişi sınırını aşmaktadır.";
        }

        reportParts.add(
          "UYARI: $context Bu doğrultuda kapı özelliklerinin (yön ve kilit) ilgili katlardaki kişi sayılarına göre Yönetmeliğe uygun hale getirilmesi gerekmektedir. Kullanıcı yükünün aşıldığı ticari alan, otopark vb. gibi yerlerin kendilerine ait, binadan bağımsız başka çıkışları var ise, kişi adedine bağlı olan kuralların binanın tamamında sağlanması gerekmez, yalnızca o katta uygulanması yeterli olur.",
        );
      }

      if (reportParts.isNotEmpty) {
        return reportParts.join("\n\n");
      }
    }
    return "";
  }
}
