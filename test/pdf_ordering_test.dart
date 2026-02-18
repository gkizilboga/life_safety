import 'package:flutter_test/flutter_test.dart';
import 'package:life_safety/logic/active_systems_engine.dart';
import 'package:life_safety/data/bina_store.dart';

void main() {
  test('Active Systems Engine Requirement Ordering', () {
    // We use the singleton BinaStore instance for testing the logic.
    final store = BinaStore.instance;

    // Trigger calculation
    final requirements = ActiveSystemsEngine.calculateRequirements(store);

    if (requirements.isNotEmpty) {
      // 1. Yangın Senaryosu should be first
      expect(requirements.first.name, "Yangın Senaryosu");
      print('Verified: Yangın Senaryosu is first.');

      // 2. If Gaz Algılama Sistemi exists, it must be LAST
      bool hasGas = requirements.any((r) => r.name == "Gaz Algılama Sistemi");
      if (hasGas) {
        expect(requirements.last.name, "Gaz Algılama Sistemi");
        print("Verified: Gaz Algılama Sistemi is last.");
      }
    }
  });
}
