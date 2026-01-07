import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../data/bina_store.dart';
import '../models/choice_result.dart';
import '../logic/report_engine.dart';

class PdfService {
  static String _sanitizeText(String text) {
    return text
        .replaceAll('✅', '[UYGUN]')
        .replaceAll('⚠️', '[UYARI]')
        .replaceAll('🚨', '[KRITIK]')
        .replaceAll('☢️', '[TEHLIKE]')
        .replaceAll('❓', '[BILINMIYOR]')
        .replaceAll('❌', '[OLUMSUZ]')
        .replaceAll('<br>', '\n');
  }

  static Future<void> generateAndShowPdf() async {
    final pdf = pw.Document();
    
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);
    final boldFontData = await rootBundle.load("assets/fonts/Roboto-Bold.ttf");
    final ttfBold = pw.Font.ttf(boldFontData);

    final store = BinaStore.instance;
    final yghReasons = ReportEngine.evaluateYghRequirement();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: ttf, bold: ttfBold),
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(40),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.blue900, width: 2),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  children: [
                    pw.Text("BİNA YANGIN RİSK ANALİZİ",
                        style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900),
                        textAlign: pw.TextAlign.center),
                    pw.SizedBox(height: 10),
                    pw.Text("TASLAK ÖN DEĞERLENDİRME RAPORU",
                        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700),
                        textAlign: pw.TextAlign.center),
                    pw.SizedBox(height: 40),
                    pw.Divider(thickness: 1, color: PdfColors.blue900),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("Bina Adı:", store.currentBinaName ?? 'Belirtilmedi'),
                    _buildInfoRow("Konum:", "${store.currentBinaCity} / ${store.currentBinaDistrict}"),
                    _buildInfoRow("Rapor Tipi:", "Kullanıcı Beyanına Dayalı Ön Analiz"),
                    _buildInfoRow("Oluşturma Tarihi:", "${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}"),
                  ],
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(15),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                  ),
                  child: pw.Text(
                    "YASAL UYARI: İşbu belge bir 'Taslak Ön Analiz Raporu'dur. Kullanıcının dijital beyanları doğrultusunda oluşturulmuştur. Resmi evrak niteliği taşımaz, ruhsat veya onay süreçlerinde kullanılamaz. Kesin sonuçlar için yetkili bir yangın uzmanı tarafından yerinde inceleme yapılması zorunludur.",
                    style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey800),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: ttf, bold: ttfBold),
        header: (pw.Context context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(bottom: 20),
          child: pw.Text("Bina Yangın Risk Analizi - Taslak Ön Rapor",
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey500)),
        ),
        footer: (pw.Context context) => pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.only(top: 20),
          child: pw.Column(
            children: [
              pw.Divider(thickness: 0.5, color: PdfColors.grey400),
              pw.Text(
                "BU BİR RESMİ RAPOR DEĞİLDİR. KULLANICI BEYANINA DAYALI TASLAK ÖN DEĞERLENDİRMEDİR.",
                style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold, color: PdfColors.red900)
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                "Resmi işlerde, ruhsat süreçlerinde ve dava dosyalarında kullanılamaz. Sayfa ${context.pageNumber} / ${context.pagesCount}",
                style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600)
              ),
            ],
          ),
        ),
        build: (pw.Context context) {
          return [
            pw.Text("TEKNİK TESPİT VE ANALİZLER",
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
            pw.SizedBox(height: 5),
            pw.Text("Aşağıdaki veriler kullanıcı beyanına göre ön değerlendirmeye tabi tutulmuştur.",
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
            pw.SizedBox(height: 20),

            if (yghReasons.isNotEmpty) ...[
              pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 25),
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  color: PdfColors.orange50,
                  border: pw.Border.all(color: PdfColors.orange200, width: 1),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("YGH (YANGIN GÜVENLİK HOLÜ) ZORUNLULUK DEĞERLENDİRMESİ",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11, color: PdfColors.orange900)),
                    pw.SizedBox(height: 8),
                    pw.Text("Yönetmelik Madde 48 ve ilgili hükümler uyarınca binanızda YGH zorunluluğu aşağıdaki gerekçelerle tespit edilmiştir:",
                        style: const pw.TextStyle(fontSize: 9, color: PdfColors.black)),
                    pw.SizedBox(height: 10),
                    ...yghReasons.map((reason) => pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 4),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text("• ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Expanded(child: pw.Text(reason, style: const pw.TextStyle(fontSize: 9))),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],

            ...List.generate(36, (index) {
              final sectionId = index + 1;
              final ChoiceResult? result = store.getResultForSection(sectionId);
              
              if (result == null) return pw.SizedBox();

              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 15),
                padding: const pw.EdgeInsets.all(10),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(left: pw.BorderSide(color: PdfColors.blue900, width: 2)),
                  color: PdfColors.grey50,
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Bölüm $sectionId: ${_sanitizeText(result.uiTitle)}",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12, color: PdfColors.blue900)),
                    pw.SizedBox(height: 6),
                    pw.Text(_sanitizeText(result.reportText), style: const pw.TextStyle(fontSize: 10, color: PdfColors.black)),
                  ],
                ),
              );
            }),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        children: [
          pw.SizedBox(width: 120, child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12))),
          pw.Expanded(child: pw.Text(value, style: const pw.TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}