import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import '../models/choice_result.dart';

enum ReportModule {
  genel("Bina Genel Bilgileri", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]),
  modul1("Modül 1: Yapısal Analiz", [11, 12, 13, 14, 15]),
  modul2("Modül 2: Tahliye Güvenliği", [16, 17, 18, 19, 20]),
  modul3("Modül 3: Yangın Sistemleri", [21, 22, 23, 24, 25]),
  modul4("Modül 4: Teknik Hacimler", [26, 27, 28, 29, 30]),
  modul5("Modül 5: Kapasite ve Final", [31, 32, 33, 34, 35, 36]);

  final String title;
  final List<int> sectionIds;
  const ReportModule(this.title, this.sectionIds);
}

class ReportEngine {
  static String getSectionSummary(int id) {
    final result = BinaStore.instance.getResultForSection(id);
    if (result == null) return "Veri Girilmedi";
    return result.uiTitle.isNotEmpty ? result.uiTitle : result.label;
  }

  static List<ChoiceResult> getSectionSubResults(int id) {
    final store = BinaStore.instance;
    List<ChoiceResult?> results = [];

    switch (id) {
      case 13:
        final m = store.bolum13;
        results = [m?.otoparkKapi, m?.kazanKapi, m?.asansorKapi, m?.jeneratorKapi, m?.elektrikKapi, m?.trafoKapi, m?.depoKapi, m?.copKapi, m?.ortakDuvar, m?.ticariKapi];
        break;
      case 20:
        final m = store.bolum20;
        if (m == null) break;
        if (m.normalMerdivenSayisi > 0) results.add(ChoiceResult(label: "20-1", uiTitle: "Normal Merdiven", uiSubtitle: "${m.normalMerdivenSayisi} Adet", reportText: "Binada ${m.normalMerdivenSayisi} adet normal apartman merdiveni beyan edilmiştir."));
        if (m.binaIciYanginMerdiveniSayisi > 0) results.add(ChoiceResult(label: "20-2", uiTitle: "İç Yangın Merdiveni", uiSubtitle: "${m.binaIciYanginMerdiveniSayisi} Adet", reportText: "Binada ${m.binaIciYanginMerdiveniSayisi} adet bina içi kapalı yangın merdiveni mevcuttur."));
        if (m.binaDisiAcikYanginMerdiveniSayisi > 0) results.add(ChoiceResult(label: "20-4", uiTitle: "Dış Açık Merdiven", uiSubtitle: "${m.binaDisiAcikYanginMerdiveniSayisi} Adet", reportText: "Binada ${m.binaDisiAcikYanginMerdiveniSayisi} adet bina dışı açık çelik yangın merdiveni mevcuttur."));
        if (m.bodrumMerdivenDevami != null) results.add(m.bodrumMerdivenDevami);
        break;
      case 29:
        final m = store.bolum29;
        results = [m?.otopark, m?.kazan, m?.cati, m?.asansor, m?.jenerator, m?.pano, m?.trafo, m?.depo, m?.cop, m?.siginak];
        break;
      case 33:
        final m = store.bolum33;
        results = [m?.zeminKatSonuc, m?.normalKatSonuc, m?.bodrumKatSonuc];
        break;
      default:
        results = [store.getResultForSection(id)];
    }
    return results.whereType<ChoiceResult>().toList();
  }

  static Color getStatusColor(ChoiceResult? result) {
    if (result == null) return Colors.grey.shade300;
    final text = result.reportText.toLowerCase();
    if (text.contains("bilinmiyor") || text.contains("bilmiyorum")) return Colors.orange.shade300;
    if (text.contains("risk") || text.contains("yetersiz") || text.contains("uygun değil")) return Colors.red.shade400;
    if (text.contains("olumlu") || text.contains("uygun") || text.contains("yeterli")) return Colors.green.shade400;
    return Colors.blue.shade400;
  }
}