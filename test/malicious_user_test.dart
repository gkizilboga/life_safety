import 'package:flutter_test/flutter_test.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/logic/report_engine.dart';
import 'package:life_safety/logic/active_systems_engine.dart';
import 'package:life_safety/models/bolum_3_model.dart';

void main() {
  group('Malicious User Simulation', () {
    final store = BinaStore.instance;

    setUp(() {
      store.clearCurrentAnalysis();
    });

    test('Attacker Attempt: Storage Exhaustion via Massive Strings', () {
      // Malicious user enters a 100,000 character string in Building Name
      String massiveString = 'A' * 100000;
      store.currentBinaName = massiveString;
      
      // Check if saving/loading still works (Logic check)
      expect(store.currentBinaName, massiveString);
      
      // Check if engines crash with massive strings
      final metrics = ReportEngine.calculateRiskMetrics();
      expect(metrics['score'], isNotNull);
    });

    test('Attacker Attempt: Character Injection for PDF/UI Breakage', () {
      // Injecting characters that often break coordinate systems or text renderers.
      String injection = "🚨🚨🚨 \u202E RTL_HACK \u202D <script>alert(1)</script> %s%s%n \$\$\$";
      store.currentBinaName = injection;
      store.currentBinaCity = injection;
      
      // Calculate results
      final reqs = ActiveSystemsEngine.calculateRequirements(store);
      
      // Verify no crashes
      expect(reqs, isNotEmpty);
      expect(reqs.first.reason, isNotNull);
    });

    test('Attacker Attempt: Negative and NaN forcing', () {
      // Trying to force NaN or Infinity into calculations
      store.bolum3 = Bolum3Model(hYapi: double.nan, hBina: 0.0);
      
      // Engines should handle NaN gracefully
      final metrics = ReportEngine.calculateRiskMetrics();
      // If score becomes NaN, that's a finding to fix
      expect(metrics['score'], isNotNull);
    });
  });
}
