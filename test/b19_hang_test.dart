import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/screens/bolum_19_screen.dart';

void main() {
  testWidgets('Test Bolum 19 Devam Et freezes', (WidgetTester tester) async {
    BinaStore.instance.reset(); // Clear state
    BinaStore.instance.currentBinaId = "test1234";

    await tester.pumpWidget(
      const MaterialApp(
        home: Bolum19Screen(),
      ),
    );

    // Wait for initial render
    await tester.pumpAndSettle();

    // Now need to find and click the required options to enable "Devam Et"
    // Option: 'Engel yok'
    await tester.tap(find.text('Engel yok.'));
    await tester.pumpAndSettle();

    // Option: 'Yönlendirme levhalarına sahibim'
    await tester.tap(find.text('EVET, tüm çıkışlarda var.'));
    await tester.pumpAndSettle();

    // Option: 'Yanıltıcı kapım yok'
    await tester.tap(find.text('Yok, çıkışı kolayca bulabilirim.'));
    await tester.pumpAndSettle();

    // The 'Devam Et' button should now be enabled.
    await tester.tap(find.text('DEVAM ET').first);
    
    print("Clicked Devam Et. Pumping UI to see if it freezes...");
    
    // If there is an infinite animation or loop, pumpAndSettle will time out
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    
    print("Transition complete. No freeze detected in test.");
  });
}
