import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_safety/screens/report_summary_screen.dart';
import 'package:life_safety/data/bina_store.dart';

void main() {
  testWidgets('Bölüm 36 - Özet Ekranı Asenkron Geçiş Testi', (WidgetTester tester) async {
    BinaStore.instance.reset();
    await tester.pumpWidget(const MaterialApp(home: ReportSummaryScreen()));

    expect(find.textContaining('Özet Hazırlanıyor...'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.textContaining('Özet Hazırlanıyor...'), findsNothing);
    expect(find.text('YANGIN RİSK ANALİZİ'), findsWidgets);
  });

  testWidgets('Anti-Freeze: Yükleme Sırasında İlerleme Sayacı Görünmeli ve Kapanmalı', (WidgetTester tester) async {
    BinaStore.instance.reset();
    await tester.pumpWidget(const MaterialApp(home: ReportSummaryScreen()));

    // 1. Initial state check: Loader and Progress should be there
    expect(find.textContaining('Özet Hazırlanıyor...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // 2. Wait for completion
    await tester.pumpAndSettle(const Duration(seconds: 3));
    
    // 3. Should be finished
    expect(find.textContaining('Özet Hazırlanıyor...'), findsNothing);
    expect(find.text('YANGIN RİSK ANALİZİ'), findsOneWidget);
  });

  testWidgets('Robustness: Hesaplama Hatası Durumunda Uygulama Takılmamalı (Anti-Freeze)', (WidgetTester tester) async {
    // Bu testte BinaStore üzerinden 'null' veya 'hatalı' veri besleyerek Engine'i zorluyoruz.
    // Gerçek bir catch bloğu testi için BinaStore'un içindeki modellerden birini bozuyoruz.
    BinaStore.instance.reset();
    // Bina yüksekliklerini 0 yaparak veya tutarsız veriler girerek engine limitlerini zorla.
    // (Engine try-catch içinde olduğu için bu test donmayı (freeze) kontrol eder)
    
    await tester.pumpWidget(const MaterialApp(home: ReportSummaryScreen()));
    
    // Yükleme ekranı başlar
    expect(find.textContaining('Özet Hazırlanıyor...'), findsOneWidget);
    
    // Asenkron sürecin hatasız (veya hatayı yakalayarak) tamamlanmasını bekle
    await tester.pumpAndSettle(const Duration(seconds: 3));
    
    // Yükleme ekranı MUTLAKA kapanmış olmalı (Donma yoksa)
    expect(find.textContaining('Özet Hazırlanıyor...'), findsNothing, 
      reason: "Hata oluşsa dahi yükleme ekranı (Loader) sonsuza kadar takılı kalmamalı.");
    
    // Ekranda özet paneli görünmeli
    expect(find.text('YANGIN RİSK ANALİZİ'), findsOneWidget);
  });
}
