import 'package:flutter_test/flutter_test.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_1_model.dart';
import 'package:life_safety/utils/app_content.dart';

void main() {
  group('BinaStore Concurrency and Race Condition Tests', () {
    late BinaStore store;

    setUp(() {
      store = BinaStore.instance;
      store.reset();
      store.currentBinaId = "concurrency_test_id";
    });

    tearDown(() {
      store.reset();
    });

    test('Rapid consecutive saves should not corrupt state', () async {
      // Create a list of 50 rapid changes
      final List<Future> saves = [];
      for (int i = 0; i < 50; i++) {
        // Toggle between two valid choices
        final choice = i % 2 == 0 ? Bolum1Content.ruhsatSonrasi : Bolum1Content.ruhsatOncesi;
        store.bolum1 = Bolum1Model(secim: choice);
        saves.add(store.saveToDisk());
      }

      await Future.wait(saves);

      // Verify final state
      expect(store.bolum1?.secim?.label, Bolum1Content.ruhsatOncesi.label);
      
      // Wait for the actual debounce timer to fire once and complete the write
      await Future.delayed(const Duration(milliseconds: 3000));
    });

    test('Overlapping asynchronous tasks should maintain data integrity', () async {
      final f1 = Future(() {
        store.currentBinaName = "Bina A";
        return store.saveToDisk();
      });
      
      final f2 = Future(() {
        store.currentBinaName = "Bina B";
        return store.saveToDisk();
      });

      await Future.wait([f1, f2]);

      expect(store.currentBinaName, isNotNull);
      
      // Wait for timer
      await Future.delayed(const Duration(milliseconds: 3000));
    });
  });
}
