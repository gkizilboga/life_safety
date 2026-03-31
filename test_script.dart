import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/logic/report_engine.dart';
import 'package:life_safety/models/bolum_20_model.dart';
import 'package:life_safety/models/bolum_36_model.dart';
import 'package:life_safety/models/choice_result.dart';
import 'package:life_safety/utils/app_content.dart';

void main() async {
  // Setup dummy bina store
  BinaStore s = BinaStore.instance;

  // Let's populate minimal required fields for Bolum 20 and Bolum 36
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

  print('Testing ReportEngine...');
  
  try {
    print('Testing getSectionSummary(36)');
    String sum36 = ReportEngine.getSectionSummary(36);
    print('OK: $sum36');
  } catch(e, st) {
    print('Summary 36 failed: $e\n$st');
  }

  try {
    print('Testing getSectionFullReport(36)');
    String full36 = ReportEngine.getSectionFullReport(36);
    print('OK: $full36');
  } catch(e, st) {
    print('Full 36 failed: $e\n$st');
  }

  try {
    print('Testing calculateRiskMetrics');
    var metrics = ReportEngine.calculateRiskMetrics();
    print('OK: $metrics');
  } catch(e, st) {
    print('calculateRiskMetrics failed: $e\n$st');
  }

  try {
    print('Testing calculateModuleScores');
    var scores = ReportEngine.calculateModuleScores();
    print('OK: $scores');
  } catch(e, st) {
    print('calculateModuleScores failed: $e\n$st');
  }

  print('Done.');
}
