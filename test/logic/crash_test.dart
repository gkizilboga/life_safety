import 'package:flutter_test/flutter_test.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/logic/report_engine.dart';
import 'package:life_safety/logic/handlers/section_36_handler.dart';
import 'package:life_safety/models/bolum_36_model.dart';
import 'package:life_safety/models/bolum_20_model.dart';
import 'package:life_safety/models/bolum_21_model.dart';
import 'package:life_safety/models/bolum_10_model.dart';

void main() {
  setUp(() {
    BinaStore.instance.reset();
  });

  test('Section 36 Handler & ReportEngine Null Safety Test', () {
    final store = BinaStore.instance;
    
    // Simulate old data where some sections are null, and some models have null fields
    store.bolum20 = Bolum20Model(); // All default 0/null
    store.bolum36 = Bolum36Model(); // areWidthsSame = true, others null
    
    // This previously crashed in evaluateYghRequirement because varlik is null
    store.bolum21 = Bolum21Model(varlik: null); 
    
    // This previously crashed in evaluateYghRequirement because bodrumlar elements might be null
    store.bolum10 = Bolum10Model(bodrumlar: [null]);

    // Test Section 36 specific reports
    final h = Section36Handler(store);
    print("Testing Section36Handler reports...");
    h.getSummaryReport();
    h.getDetailedReport();
    h.getFullReport();

    // Test ReportEngine global functions that calls these
    print("Testing ReportEngine summary/full reports...");
    ReportEngine.getSectionSummary(36);
    ReportEngine.getSectionFullReport(36);
    
    print("Testing ReportEngine requirement evaluations...");
    ReportEngine.evaluateBasincRequirement(store: store);
    ReportEngine.evaluateYghRequirement(store: store);
    
    print("Testing ReportEngine risk levels and scores...");
    ReportEngine.getSectionRiskLevel(36, store: store);
    ReportEngine.calculateRiskMetrics(store: store);
    ReportEngine.calculateModuleScores(); // Uses BinaStore.instance
    
    print("All null safety tests passed!");
  });
}
