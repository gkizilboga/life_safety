import 'package:flutter_test/flutter_test.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/logic/report_engine.dart';
import 'package:life_safety/models/bolum_20_model.dart';
import 'package:life_safety/models/bolum_36_model.dart';
import 'package:life_safety/models/choice_result.dart';

void main() {
  test('Test ReportEngine', () {
    print("Testing Report Engine...");
    BinaStore s = BinaStore.instance;

    s.bolum20 = Bolum20Model(
      normalMerdivenSayisi: 1,
      toplamDisariAcilanMerdivenSayisi: 1,
      isBodrumIndependent: true,
      bodrumNormalMerdivenSayisi: 1,
      bodrumToplamDisariAcilanMerdivenSayisi: 1,
    );
    
    s.bolum36 = Bolum36Model(
      areWidthsSame: true,
      genislikKorunumlu: ChoiceResult(label: "36-Merd-A", uiTitle: "Test", reportText: "Test", uiSubtitle: "Test"),
    );

    try {
      print('getSectionSummary(36)');
      ReportEngine.getSectionSummary(36);
    } catch (e, st) {
      print('FAIL: getSectionSummary(36) -> $e\n$st');
    }

    try {
      print('getSectionFullReport(36)');
      ReportEngine.getSectionFullReport(36);
    } catch (e, st) {
      print('FAIL: getSectionFullReport(36) -> $e\n$st');
    }

    try {
      print('calculateRiskMetrics');
      ReportEngine.calculateRiskMetrics();
    } catch (e, st) {
      print('FAIL: calculateRiskMetrics -> $e\n$st');
    }

    try {
      print('calculateModuleScores');
      ReportEngine.calculateModuleScores();
    } catch (e, st) {
      print('FAIL: calculateModuleScores -> $e\n$st');
    }

    print("Done testing.");
  });
}
