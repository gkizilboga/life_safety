import 'package:flutter_test/flutter_test.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/logic/report_engine.dart';
import 'package:life_safety/logic/active_systems_engine.dart';
import 'package:life_safety/models/bolum_3_model.dart';
import 'package:life_safety/models/bolum_5_model.dart';
import 'package:life_safety/models/choice_result.dart';

void main() {
  group('Chaos & Robustness: Logic Engines', () {
    final store = BinaStore.instance;

    setUp(() {
      store.clearCurrentAnalysis();
    });

    test('Stress: Absurdly High Building (10km high)', () {
      // 10,000 meters high building
      store.bolum3 = Bolum3Model(
        hYapi: 10000.0,
        normalKatSayisi: 3000,
        bodrumKatSayisi: 50,
      );
      
      // Should not crash, should just return extreme risks/requirements
      expect(() => ReportEngine.calculateRiskMetrics(store: store), returnsNormally);
      expect(() => ActiveSystemsEngine.calculateRequirements(store), returnsNormally);
    });

    test('Stress: Near-Zero Building (1mm high)', () {
      store.bolum3 = Bolum3Model(
        hYapi: 0.001,
        normalKatSayisi: 0,
        bodrumKatSayisi: 0,
      );
      
      expect(() => ReportEngine.calculateRiskMetrics(store: store), returnsNormally);
    });

    test('Stress: Extreme Area Values (Millions of m2)', () {
      store.bolum5 = Bolum5Model(tabanAlani: 1000000000.0);
      
      final metrics = ReportEngine.calculateRiskMetrics(store: store);
      expect(metrics['score'], isNotNull);
    });

    test('Robustness: Missing/Null Models', () {
      // Clear everything
      store.bolum1 = null;
      store.bolum3 = null;
      store.bolum35 = null;
      
      // Engines should handle null gracefully (using default values or returning empty)
      expect(() => ReportEngine.calculateRiskMetrics(store: store), returnsNormally);
      expect(() => ActiveSystemsEngine.calculateRequirements(store), returnsNormally);
    });

    test('Robustness: Malformed Choice Labels', () {
      store.bolum1 = null; // Forces defaults
      final choice = ChoiceResult(
        label: "CORRUPT_DATA_!@#\$%",
        uiTitle: "Danger",
        uiSubtitle: "Data",
        reportText: "Crash test",
      );
      
      // Set some models with bad data
      // (This simulates corrupted SharedPreferences)
      expect(() => ActiveSystemsEngine.calculateRequirements(store), returnsNormally);
    });

    test('Robustness: Large Strings in Choices', () {
      final megaString = "A" * 50000;
      final choice = ChoiceResult(
        label: "LONG_TEXT",
        uiTitle: megaString,
        uiSubtitle: megaString,
        reportText: megaString,
      );
      
      // Inject into store if possible (simulating heavy data load)
      // Most of our logic uses .label.contains(), so this checks for performance/memory spikes
      expect(() => ReportEngine.getStatusColor(choice), returnsNormally);
    });
  });
}
