import 'dart:typed_data';
import 'package:flutter/material.dart' show Color, Colors;
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../data/bina_store.dart';
import '../models/choice_result.dart';
import '../logic/report_engine.dart';
import '../utils/app_content.dart';

class PdfService {
  static String _sanitize(String t) => t.replaceAll(RegExp(r'[🚨☢️⚠️✅❓ℹ️]'), '').trim();

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

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: ttf, bold: ttfBold),
        build: (pw.Context context) => [
          pw.Header(
            level: 0, 
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start, 
              children: [
                pw.Text("BİNA YANGIN GÜVENLİK KARNESİ", style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                pw.SizedBox(height: 5),
                pw.Text("GENEL GÜVENLİK SKORU: %${metrics['score']}", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.red900)),
              ]
            )
          ),
          pw.SizedBox(height: 20),
          
          pw.Text("MODÜL BAZLI GÜVENLİK ANALİZİ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
            children: moduleScores.entries.map((e) => pw.TableRow(children: [
              pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(e.key.title, style: const pw.TextStyle(fontSize: 10))),
              pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("%${e.value.toInt()}", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: e.value > 70 ? PdfColors.green : PdfColors.red))),
            ])).toList(),
          ),
          
          pw.SizedBox(height: 30),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
            columnWidths: {0: const pw.FixedColumnWidth(30), 1: const pw.FlexColumnWidth(3), 2: const pw.FlexColumnWidth(2)},
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.blueGrey100),
                children: [
                  pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("No", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("Soru ve Kullanıcı Beyanı", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("Teknik Analiz / Risk Durumu", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                ],
              ),
              ...List.generate(36, (index) {
                int id = index + 1;
                final res = store.getResultForSection(id);
                if (res == null) return pw.TableRow(children: [pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("$id")), pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("Kapsam Dışı")), pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("Değerlendirme Gerekli Değil"))]);
                return pw.TableRow(children: [
                  pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text("$id")),
                  pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start, 
                    children: [
                      pw.Text("SORU: ${AppContent.getQuestionText(id)}", style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                      pw.SizedBox(height: 2),
                      pw.Text("YANIT: ${res.uiTitle}", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                    ]
                  )),
                  pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(_sanitize(res.reportText).replaceAll("UYGUN", "OLUMLU"), style: const pw.TextStyle(fontSize: 9))),
                ]);
              }),
            ],
          ),
          if (actionPlan.isNotEmpty) ...[
            pw.Header(level: 0, child: pw.Text("YANGIN GÜVENLİĞİ İYİLEŞTİRME REÇETESİ VE EYLEM PLANI", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.orange900))),
            pw.SizedBox(height: 10),
            ...actionPlan.map((item) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 15),
              padding: const pw.EdgeInsets.all(10),
              decoration: const pw.BoxDecoration(color: PdfColors.orange50, border: pw.Border(left: pw.BorderSide(color: PdfColors.orange900, width: 3))),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start, 
                children: [
                  pw.Text("Bölüm ${item['id']}: ${item['title']}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11, color: PdfColors.orange900)),
                  pw.SizedBox(height: 5),
                  pw.Text("TAVSİYE: ${item['advice']}", style: const pw.TextStyle(fontSize: 10, color: PdfColors.black)),
                ]
              ),
            )),
          ],
        ],
      ),
    );
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}