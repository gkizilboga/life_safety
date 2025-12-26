import '../data/bina_store.dart';
import '../models/report_status.dart';
import '../models/choice_result.dart';

class ReportEngine {
  static ReportStatus getStatus(ChoiceResult? choice) {
    if (choice == null) return ReportStatus.info;
    String text = choice.reportText;
    if (text.contains("✅")) return ReportStatus.compliant;
    if (text.contains("🚨") || text.contains("☢️") || text.contains("KRİTİK") || text.contains("RİSK")) return ReportStatus.risk;
    if (text.contains("⚠️")) return ReportStatus.warning;
    if (text.contains("❓")) return ReportStatus.unknown;
    return ReportStatus.info;
  }

  static List<PillarResult> generatePillars() {
    return [
      PillarResult(
        title: "Bina Profili ve Genel Riskler",
        sectionIds: [1, 2, 3, 4, 6, 8, 9, 10],
        stats: _calculateStats([1, 2, 3, 4, 6, 8, 9, 10]),
      ),
      PillarResult(
        title: "Yapısal Dayanım ve Yalıtım",
        sectionIds: [12, 13, 15, 16, 17, 18],
        stats: _calculateStats([12, 13, 15, 16, 17, 18]),
      ),
      PillarResult(
        title: "Kaçış Yolları ve Tahliye",
        sectionIds: [11, 19, 20, 24, 25, 26, 27, 28, 33, 35, 36],
        stats: _calculateStats([11, 19, 20, 24, 25, 26, 27, 28, 33, 35, 36]),
      ),
      PillarResult(
        title: "Asansör ve Teknik Sistemler",
        sectionIds: [21, 22, 23, 30, 31, 32, 34],
        stats: _calculateStats([21, 22, 23, 30, 31, 32, 34]),
      ),
      PillarResult(
        title: "İşletme ve Temizlik Düzeni",
        sectionIds: [29],
        stats: _calculateStats([29]),
      ),
    ];
  }

  static Map<ReportStatus, int> _calculateStats(List<int> ids) {
    Map<ReportStatus, int> stats = {
      ReportStatus.compliant: 0,
      ReportStatus.risk: 0,
      ReportStatus.warning: 0,
      ReportStatus.unknown: 0,
      ReportStatus.info: 0,
    };

    final store = BinaStore.instance;
    for (var id in ids) {
      List<ChoiceResult?> results = getResultsBySection(id, store);
      for (var res in results) {
        if (res != null) {
          stats[getStatus(res)] = (stats[getStatus(res)] ?? 0) + 1;
        }
      }
    }
    return stats;
  }

  static List<ChoiceResult?> getResultsBySection(int id, BinaStore store) {
    switch (id) {
      case 1: return [store.bolum1?.secim];
      case 2: return [store.bolum2?.secim];
      case 3: return [store.bolum3?.yukseklikTercihi];
      case 4: return [store.bolum4?.binaYukseklikSinifi, store.bolum4?.yapiYuksekligiUyarisi];
      case 6: return [store.bolum6?.otoparkTipi];
      case 8: return [store.bolum8?.secim];
      case 9: return [store.bolum9?.secim];
      case 10: return [store.bolum10?.secim];
      case 11: return [store.bolum11?.mesafe, store.bolum11?.engel, store.bolum11?.zayifNokta];
      case 12: return [store.bolum12?.celikKoruma, store.bolum12?.betonPaspayi, store.bolum12?.ahsapKesit, store.bolum12?.yigmaDuvar];
      case 13: return [store.bolum13?.otoparkKapi, store.bolum13?.kazanKapi, store.bolum13?.asansorKapi, store.bolum13?.jeneratorKapi, store.bolum13?.elektrikKapi, store.bolum13?.trafoKapi, store.bolum13?.depoKapi, store.bolum13?.copKapi, store.bolum13?.ortakDuvar, store.bolum13?.ticariKapi];
      case 15: return [store.bolum15?.kaplama, store.bolum15?.yalitim, store.bolum15?.tavan, store.bolum15?.tesisat];
      case 16: return [store.bolum16?.mantolama, store.bolum16?.sagirYuzey, store.bolum16?.bitisikNizam];
      case 17: return [store.bolum17?.kaplama, store.bolum17?.iskelet, store.bolum17?.bitisikDuvar, store.bolum17?.isiklik];
      case 18: return [store.bolum18?.duvarKaplama, store.bolum18?.boruTipi];
      case 19: return [store.bolum19?.engel, store.bolum19?.levha, store.bolum19?.yanilticiKapi];
      case 20: return [store.bolum20?.tekKatCikis, store.bolum20?.tekKatRampa, store.bolum20?.bodrumMerdivenDevami];
      case 21: return [store.bolum21?.varlik, store.bolum21?.malzeme, store.bolum21?.kapi, store.bolum21?.esya];
      case 22: return [store.bolum22?.varlik, store.bolum22?.konum, store.bolum22?.boyut, store.bolum22?.kabin, store.bolum22?.enerji, store.bolum22?.basinc];
      case 23: return [store.bolum23?.bodrum, store.bolum23?.yanginModu, store.bolum23?.konum, store.bolum23?.levha, store.bolum23?.havalandirma];
      case 24: return [store.bolum24?.tip, store.bolum24?.pencere, store.bolum24?.kapi];
      case 25: return [store.bolum25?.kapasite, store.bolum25?.basamak, store.bolum25?.basKurtarma];
      case 26: return [store.bolum26?.varlik, store.bolum26?.egim, store.bolum26?.sahanlik, store.bolum26?.otopark];
      case 27: return [store.bolum27?.boyut, store.bolum27?.yon, store.bolum27?.kilit, store.bolum27?.dayanim];
      case 28: return [store.bolum28?.mesafe, store.bolum28?.dubleks, store.bolum28?.alan, store.bolum28?.cikis];
      case 29: return [store.bolum29?.otopark, store.bolum29?.kazan, store.bolum29?.cati, store.bolum29?.asansor, store.bolum29?.jenerator, store.bolum29?.pano, store.bolum29?.trafo, store.bolum29?.depo, store.bolum29?.cop, store.bolum29?.siginak];
      case 30: return [store.bolum30?.konum, store.bolum30?.kapi, store.bolum30?.hava, store.bolum30?.yakit, store.bolum30?.drenaj, store.bolum30?.tup];
      case 31: return [store.bolum31?.yapi, store.bolum31?.tip, store.bolum31?.cukur, store.bolum31?.sondurme, store.bolum31?.cevre];
      case 32: return [store.bolum32?.yapi, store.bolum32?.yakit, store.bolum32?.cevre, store.bolum32?.egzoz];
      case 33: return [store.bolum33?.normalKatSonuc, store.bolum33?.zeminKatSonuc, store.bolum33?.bodrumKatSonuc];
      case 34: return [store.bolum34?.zemin, store.bolum34?.bodrum];
      case 35: return [store.bolum35?.tekYon, store.bolum35?.ciftYon, store.bolum35?.cikmaz, store.bolum35?.cikmazMesafe];
      case 36: return [store.bolum36?.disMerd, store.bolum36?.konum, store.bolum36?.kapiTipi, store.bolum36?.gorunurluk];
      default: return [];
    }
  }
}