import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../data/bina_store.dart';
import '../logic/report_engine.dart';
import '../utils/app_strings.dart';
import '../utils/app_content.dart';

class PdfService {
  static String _cleanText(String t) {
    return t.replaceAll(RegExp(r'[🚨☢️⚠️✅❓ℹ️]'), '')
            .replaceAll('KRİTİK RİSK:', '')
            .replaceAll('RİSK:', '')
            .replaceAll('UYARI:', '')
            .replaceAll('OLUMLU:', '')
            .replaceAll('BİLGİ:', '')
            .replaceAll('UYGUN', 'OLUMLU')
            .trim();
  }

  static PdfColor _getRiskColor(String text) {
    if (text.contains("KRİTİK RİSK") || text.contains("RİSK")) return PdfColors.red900;
    if (text.contains("UYARI")) return PdfColors.orange900;
    if (text.contains("BİLGİ")) return PdfColors.blue900;
    return PdfColors.green900;
  }

  static Future<void> generateAndShowPdf() async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);
    final boldData = await rootBundle.load("assets/fonts/Roboto-Bold.ttf");
    final ttfBold = pw.Font.ttf(boldData);
    final store = BinaStore.instance;
    final metrics = ReportEngine.calculateRiskMetrics();
    final actionPlan = ReportEngine.getActionPlan();
    final moduleScores = ReportEngine.calculateModuleScores();

    final pageTheme = pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.withFont(base: ttf, bold: ttfBold),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Opacity(
          opacity: 0.05,
          child: pw.Center(
            child: pw.Transform.rotate(
              angle: 0.5,
              child: pw.Text("RESMİ EVRAK DEĞİLDİR", 
                style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold)),
            ),
          ),
        ),
      ),
    );

    // 1. KAPAK SAYFASI
    pdf.addPage(pw.Page(
      pageTheme: pageTheme,
      build: (context) => pw.Container(
        padding: const pw.EdgeInsets.all(40),
        decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.blue900, width: 2)),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(children: [
              pw.Text("YANGIN GÜVENLİĞİ RİSK ANALİZİ", style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900), textAlign: pw.TextAlign.center),
              pw.SizedBox(height: 10),
              pw.Text("ÖN RAPOR", style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),
              pw.SizedBox(height: 40),
              pw.Divider(color: PdfColors.blue900),
            ]),
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              _buildInfoRow("Bina Adı:", store.currentBinaName ?? "-"),
              _buildInfoRow("Konum:", "${store.currentBinaCity} / ${store.currentBinaDistrict}"),
              _buildInfoRow("Analiz Tarihi:", "${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}"),
              _buildInfoRow("Yangın Güvenlik Skoru:", "%${metrics['score']}"),
            ]),
            pw.Text("İşbu rapor kullanıcı beyanına dayalı bir ön analizdir.", style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
          ],
        ),
      ),
    ));

    // 2. HUKUKİ BİLGİLENDİRME
    pdf.addPage(pw.Page(
      pageTheme: pageTheme,
      build: (context) => pw.Padding(
        padding: const pw.EdgeInsets.all(30),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text("YASAL DAYANAKLAR VE SORUMLULUK REDDİ", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
          pw.SizedBox(height: 20),
          pw.Text(AppStrings.legalDisclaimerContent, style: const pw.TextStyle(fontSize: 9)),
          pw.SizedBox(height: 20),
          pw.Text(AppStrings.kvkkContent, style: const pw.TextStyle(fontSize: 9)),
        ]),
      ),
    ));

    // 3. ANALİZ TABLOSU
    pdf.addPage(pw.MultiPage(
      pageTheme: pageTheme,
      header: (context) => pw.Container(alignment: pw.Alignment.centerRight, child: pw.Text("Bina Yangın Güvenliği Risk Analizi", style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500))),
      footer: (context) => pw.Container(alignment: pw.Alignment.center, child: pw.Text("Sayfa ${context.pageNumber} / ${context.pagesCount} - RESMİ EVRAK DEĞİLDİR", style: const pw.TextStyle(fontSize: 7, color: PdfColors.red900))),
      build: (context) => [
        pw.Text("YANGIN RİSK ANALİZİ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
          children: moduleScores.entries.map((e) => pw.TableRow(children: [
            pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(e.key.title, style: const pw.TextStyle(fontSize: 9))),
            pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("%${e.value.toInt()}", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold))),
          ])).toList(),
        ),
        pw.SizedBox(height: 20),
        pw.Text("ANALİZ VE RİSK DURUMU", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
        pw.SizedBox(height: 15),
        ...List.generate(36, (index) {
          int id = index + 1;
          final res = store.getResultForSection(id);
          if (res == null) return pw.SizedBox();
          final fullReport = ReportEngine.getSectionFullReport(id);
          final riskColor = _getRiskColor(fullReport);
          final cleanReport = _cleanText(fullReport);
          return pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 10),
            decoration: pw.BoxDecoration(border: pw.Border(left: pw.BorderSide(color: riskColor, width: 4)), color: PdfColors.grey50),
            padding: const pw.EdgeInsets.all(8),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text("BÖLÜM $id", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
                pw.Text(riskColor == PdfColors.red900 ? "KRİTİK RİSK" : riskColor == PdfColors.orange900 ? "UYARI" : riskColor == PdfColors.green900 ? "OLUMLU" : "BİLGİ", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: riskColor)),
              ]),
              pw.SizedBox(height: 4),
              pw.Text("SORU: ${AppContent.getQuestionText(id)}", style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey800)),
              pw.Text("YANIT: ${res.uiTitle}", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 4),
              pw.Text(cleanReport, style: const pw.TextStyle(fontSize: 9)),
            ]),
          );
        }),
      ],
    ));

    // 4. EYLEM PLANI
    if (actionPlan.isNotEmpty) {
      pdf.addPage(pw.Page(
        pageTheme: pageTheme,
        build: (context) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text("İYİLEŞTİRME ÖNERİLERİ", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.orange900)),
          pw.SizedBox(height: 20),
          ...actionPlan.map((item) => pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 10),
            padding: const pw.EdgeInsets.all(8),
            decoration: const pw.BoxDecoration(color: PdfColors.orange50, border: pw.Border(left: pw.BorderSide(color: PdfColors.orange900, width: 2))),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text("Bölüm ${item['id']}: ${item['title']}", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
              pw.Text("ÖNERİ: ${item['advice']}", style: const pw.TextStyle(fontSize: 9)),
            ]),
          )),
          pw.SizedBox(height: 40),
          pw.Container(
            padding: const pw.EdgeInsets.all(15),
            decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300), borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5))),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text("İLETİŞİM", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: PdfColors.blue900)),
              pw.SizedBox(height: 5),
              pw.Text("Detaylı saha incelemesi ve raporlama hizmetleri için Yangın Güvenlik Uzmanı 'yla WhatsApp üzerinden iletişime geçebilirsiniz.", style: const pw.TextStyle(fontSize: 9)),
            ]),
          ),
        ]),
      ));
    }

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  static pw.Widget _buildInfoRow(String label, String val) {
    return pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 4), child: pw.Row(children: [
      pw.SizedBox(width: 100, child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
      pw.Text(val, style: const pw.TextStyle(fontSize: 10)),
    ]));
  }
}