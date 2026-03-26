import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_safety/screens/report_summary_screen.dart';
import 'package:life_safety/data/bina_store.dart';

void main() {
  testWidgets('Bölüm 36 - Özet Ekranı Asenkron Geçiş Testi', (WidgetTester tester) async {
    // 1. Mock BinaStore Initialization
    BinaStore.instance.reset();
    
    // 2. Build the target screen directly to simulate the push transition
    await tester.pumpWidget(const MaterialApp(
      home: ReportSummaryScreen(),
    ));

    // 3. DO NOT PUMP THE TIMER YET. As soon as the widget is built, 
    // it should be in the "_isLoading = true" state because of our async `_initData()`.
    
    // We expect to find the "Özet Hazırlanıyor..." text IMMEDIATELY without waiting.
    // This proves the UI thread is not blocked by heavy calculations.
    expect(find.text('Özet Hazırlanıyor...'), findsOneWidget, 
      reason: "Ekran açılır açılmaz yükleme yazısı görünmeli, ana thread kilitlenmemeli.");
    
    expect(find.byType(CircularProgressIndicator), findsOneWidget,
      reason: "Yükleme animasyonu anında ekrana basılmalı.");

    // 4. Now, allow the asynchronous _initData to finish.
    // We pump and settle to let all Microtasks and Future.delayed complete.
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 5. After the data is loaded, the loading screen should disappear 
    // and the actual Summary screen (YANGIN RİSK ANALİZİ) should be visible.
    expect(find.text('Özet Hazırlanıyor...'), findsNothing, 
      reason: "Hesaplama bittikten sonra yükleme ekranı kaybolmalı.");
      
    expect(find.text('YANGIN RİSK ANALİZİ'), findsWidgets,
      reason: "Hesaplamalar tamamlandığında gerçek özet verileri ekranda olmalı.");
  });
}
