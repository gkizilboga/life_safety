import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_safety/logic/report_engine.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_27_model.dart';
import 'package:life_safety/models/bolum_33_model.dart';
import 'package:life_safety/models/bolum_34_model.dart';
import 'package:life_safety/models/bolum_36_model.dart';
import 'package:life_safety/utils/app_content.dart';
import 'package:life_safety/models/choice_result.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  final store = BinaStore.instance;

  setUp(() {
    store.reset();
  });

  group('Section 27 Dynamic Logic Tests', () {
    test('Door Direction (27-2-B) - Below 50 threshold - Positive', () {
      store.bolum33 = Bolum33Model(yukZemin: 40, yukNormal: 30, yukBodrum: 20);
      store.bolum27 = Bolum27Model(yon: [Bolum27Content.yonOptionB]);

      final details = ReportEngine.getSectionDetailedReport(27, store: store);
      final yonDetail = details.firstWhere((d) => d['label'].contains('yöne açılıyor'));
      
      expect(yonDetail['report'], contains('OLUMLU'));
      expect(yonDetail['report'], contains('50 kişiyi aşmadığı'));
      
      final riskLevel = ReportEngine.getSectionRiskLevel(27, store: store);
      expect(riskLevel, RiskLevel.positive);
    });

    test('Door Direction (27-2-B) - Above 50 threshold - Critical', () {
      store.bolum33 = Bolum33Model(yukZemin: 60, yukNormal: 30, yukBodrum: 20);
      store.bolum27 = Bolum27Model(yon: [Bolum27Content.yonOptionB]);

      final details = ReportEngine.getSectionDetailedReport(27, store: store);
      final yonDetail = details.firstWhere((d) => d['label'].contains('yöne açılıyor'));
      
      expect(yonDetail['report'], contains('KRİTİK RİSK'));
      expect(yonDetail['report'], contains('50 kişiyi aştığı'));
      expect(yonDetail['report'], contains('60 kişi'));
      
      final riskLevel = ReportEngine.getSectionRiskLevel(27, store: store);
      expect(riskLevel, RiskLevel.critical);
    });

    test('Lock Mechanism (27-3-B) - Below 100 threshold - Positive', () {
      store.bolum33 = Bolum33Model(yukZemin: 90, yukNormal: 30, yukBodrum: 20);
      store.bolum27 = Bolum27Model(kilit: [Bolum27Content.kilitOptionB]);

      final details = ReportEngine.getSectionDetailedReport(27, store: store);
      final kilitDetail = details.firstWhere((d) => d['label'].contains('kilit mekanizması'));
      
      expect(kilitDetail['report'], contains('OLUMLU'));
      expect(kilitDetail['report'], contains('100 kişiyi aşmadığı'));
      
      final riskLevel = ReportEngine.getSectionRiskLevel(27, store: store);
      expect(riskLevel, RiskLevel.positive);
    });

    test('Lock Mechanism (27-3-B) - Above 100 threshold - Critical', () {
      store.bolum33 = Bolum33Model(yukZemin: 110, yukNormal: 30, yukBodrum: 20);
      store.bolum27 = Bolum27Model(kilit: [Bolum27Content.kilitOptionB]);

      final details = ReportEngine.getSectionDetailedReport(27, store: store);
      final kilitDetail = details.firstWhere((d) => d['label'].contains('kilit mekanizması'));
      
      expect(kilitDetail['report'], contains('KRİTİK RİSK'));
      expect(kilitDetail['report'], contains('100 kişiyi aştığı'));
      expect(kilitDetail['report'], contains('110 kişi'));
      
      final riskLevel = ReportEngine.getSectionRiskLevel(27, store: store);
      expect(riskLevel, RiskLevel.critical);
    });

    test('Section 34 Independence - Zemin load should be ignored if independent', () {
      // Zemin load is 150 (above thresholds), but it has independent exit
      store.bolum33 = Bolum33Model(yukZemin: 150, yukNormal: 30, yukBodrum: 20);
      store.bolum34 = Bolum34Model(zemin: Bolum34Content.zeminOptionA); // 34-1-A is independent
      store.bolum27 = Bolum27Model(
        yon: [Bolum27Content.yonOptionB],
        kilit: [Bolum27Content.kilitOptionB],
      );

      final riskLevel = ReportEngine.getSectionRiskLevel(27, store: store);
      // Max load remains 30 (normal kat), which is below both 50 and 100
      expect(riskLevel, RiskLevel.positive);

      final details = ReportEngine.getSectionDetailedReport(27, store: store);
      final yonDetail = details.firstWhere((d) => d['label'].contains('yöne açılıyor'));
      expect(yonDetail['report'], contains('OLUMLU'));
    });

    test('Scoring Integration - Critical risk should penalize score by 3 points', () {
      store.bolum33 = Bolum33Model(yukZemin: 60, yukNormal: 30, yukBodrum: 20);
      store.bolum27 = Bolum27Model(yon: [Bolum27Content.yonOptionB]);
      store.bolum36 = Bolum36Model(); // Completion 100%

      final metrics = ReportEngine.calculateRiskMetrics(store: store);
      // Base score 100 - 3 (critical risk from Section 27) = 97
      expect(metrics['criticalCount'], greaterThanOrEqualTo(1));
      expect(metrics['score'], lessThanOrEqualTo(97));
    });
  }
);
}
