import 'package:flutter_test/flutter_test.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/logic/report_engine.dart';
import 'package:life_safety/models/bolum_33_model.dart';
import 'package:life_safety/models/bolum_34_model.dart';
import 'package:life_safety/models/choice_result.dart';

void main() {
  group('Complex Exit Scenarios (Section 33/34) Matrix', () {
    late BinaStore store;

    setUp(() {
      store = BinaStore.instance;
      store.reset();
    });

    test('Scenario: Independent Zemin exit, dependent Normal floor exit', () {
      // Zemin has independent commercial exit
      store.bolum34 = Bolum34Model(
        zemin: ChoiceResult(
          label: "34-1-A",
          uiTitle: "Evet, bağımsız çıkış var",
          uiSubtitle: "",
          reportText: "",
        ),
        normal: ChoiceResult(
          label: "34-3-B",
          uiTitle: "Hayır, ortak kullanıyor",
          uiSubtitle: "",
          reportText: "",
        ),
      );

      // High user load on both
      store.bolum33 = Bolum33Model(
        yukZemin: 300,
        yukNormal: 150,
        mevcutUst: 1,
        gerekliZemin: 2,
        gerekliNormal: 2,
      );

      final report = ReportEngine.getSectionFullReport(33, store: store);
      
      // Zemin should be OLUMLU because of independent exit
      expect(report.contains("ZEMIN KAT"), isTrue);
      expect(report.contains("OLUMLU"), isTrue);
      expect(report.contains("bağımsız çıkışları olduğundan"), isTrue);
      
      // Normal floor should be KRİTİK RİSK because it uses main stairs
      expect(report.contains("NORMAL KATLAR"), isTrue);
      expect(report.contains("KRİTİK RİSK"), isTrue);
    });

    test('Scenario: All floors have independent exits', () {
      store.bolum34 = Bolum34Model(
        zemin: ChoiceResult(
          label: "34-1-A",
          uiTitle: "Evet",
          uiSubtitle: "",
          reportText: "",
        ),
        normal: ChoiceResult(
          label: "34-3-A",
          uiTitle: "Evet",
          uiSubtitle: "",
          reportText: "",
        ),
        bodrum: ChoiceResult(
          label: "34-2-A",
          uiTitle: "Evet",
          uiSubtitle: "",
          reportText: "",
        ),
      );

      store.bolum33 = Bolum33Model(
        yukZemin: 500,
        yukNormal: 450,
        yukBodrum: 300,
        mevcutUst: 1,
        mevcutBodrum: 1,
        gerekliZemin: 3,
        gerekliNormal: 3,
        gerekliBodrum: 2,
      );

      final report = ReportEngine.getSectionFullReport(33, store: store);
      
      // Everything should be OLUMLU despite low current exit count
      expect(report.contains("KRİTİK RİSK"), isFalse);
      expect(report.contains("ZEMIN KAT"), isTrue);
      expect(report.contains("NORMAL KATLAR"), isTrue);
      expect(report.contains("BODRUM KATLAR"), isTrue);
      expect(report.contains("OLUMLU"), isTrue);
    });
  });
}
