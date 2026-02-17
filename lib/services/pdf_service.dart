import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../data/bina_store.dart';
import '../logic/report_engine.dart';
import '../utils/app_strings.dart';
import '../utils/app_content.dart';
import '../logic/active_systems_engine.dart';

// Helper function for Turkish locale-aware uppercase conversion
// Dart's standard toUpperCase() doesn't handle Turkish characters correctly (İ→I, ı→i)
String _toUpperCaseTR(String text) {
  return text
      .replaceAll('i', 'İ')
      .replaceAll('ı', 'I')
      .replaceAll('ö', 'Ö')
      .replaceAll('ü', 'Ü')
      .replaceAll('ç', 'Ç')
      .replaceAll('ş', 'Ş')
      .replaceAll('ğ', 'Ğ')
      .toUpperCase();
}

class PdfService {
  // Badge system removed - plain text only

  static pw.Widget _buildLegendItem(PdfColor color, String label, String desc) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.only(
            top: 2,
          ), // Align dash with first line
          child: pw.Container(width: 8, height: 8, color: color),
        ),
        pw.SizedBox(width: 4),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black,
              ),
            ),
            if (desc.isNotEmpty)
              pw.Text(
                desc,
                style: const pw.TextStyle(
                  fontSize: 7,
                  color: PdfColors.grey700,
                ),
              ),
          ],
        ),
      ],
    );
  }

  static String _cleanEmojis(String? t) {
    if (t == null) return "";
    String cleaned = t
        .replaceAll(
          RegExp(
            r'[\u{1f300}-\u{1f5ff}\u{1f600}-\u{1f64f}\u{1f680}-\u{1f6ff}\u{1f900}-\u{1f9ff}\u{2600}-\u{26ff}\u{2700}-\u{27bf}\u{fe00}-\u{fe0f}]',
            unicode: true,
          ),
          '',
        )
        .trim();

    // Remove category prefixes
    cleaned = cleaned
        .replaceAll(RegExp(r'^KRİTİK RİSK:\s*', multiLine: true), '')
        .replaceAll(RegExp(r'^UYARI:\s*', multiLine: true), '')
        .replaceAll(RegExp(r'^BİLİNMİYOR:\s*', multiLine: true), '')
        .replaceAll(RegExp(r'^BİLGİ:\s*', multiLine: true), '')
        .replaceAll(RegExp(r'^OLUMLU:\s*', multiLine: true), '')
        .trim();

    return cleaned;
  }

  // All text now rendered in black (no color coding)
  static PdfColor _getRiskColor(String text) {
    if (text.contains('KRİTİK RİSK')) return PdfColors.red700;
    if (text.contains('UYARI')) return PdfColors.amber700;
    if (text.contains('OLUMLU')) return PdfColors.green700;
    if (text.contains('BİLGİ')) return PdfColors.blue700;
    if (text.contains('BİLİNMİYOR')) return PdfColors.grey500;
    return PdfColors.grey500;
  }

  static PdfColor _getScoreColorForPdf(int score) {
    if (score >= 80) return PdfColors.green300;
    if (score >= 50) return PdfColors.orange300;
    return PdfColors.red300;
  }

  static pw.PageTheme _buildPageTheme(pw.Font ttf, pw.Font ttfBold) {
    return pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.withFont(base: ttf, bold: ttfBold),
    );
  }

  static pw.Page _buildCoverPage({
    required pw.PageTheme pageTheme,
    required pw.MemoryImage logoImage,
    required String mainTitle,
    required String subTitle,
    required BinaStore store,
    required Map<String, dynamic> metrics,
    bool showScore = true,
  }) {
    // Renk Paleti
    const navyBlue = PdfColor.fromInt(0xFF1a365d);
    const darkNavy = PdfColor.fromInt(0xFF0d2137);
    const softGray = PdfColor.fromInt(0xFF6b7280);
    const lightGray = PdfColor.fromInt(0xFFf3f4f6);
    const accentTeal = PdfColor.fromInt(0xFF0d9488);

    return pw.Page(
      pageTheme: pageTheme,
      build: (context) {
        return pw.Container(
          color: PdfColors.white,
          child: pw.Column(
            children: [
              // Üst Boşluk
              pw.SizedBox(height: 60),

              // Logo - Ortada
              pw.Center(
                child: pw.Container(
                  height: 80,
                  width: 200,
                  child: pw.Image(logoImage, fit: pw.BoxFit.contain),
                ),
              ),

              pw.SizedBox(height: 40),

              // Yönetmelik Başlığı
              pw.Center(
                child: pw.Text(
                  "BİNALARIN YANGINDAN KORUNMASI\nHAKKINDA YÖNETMELİĞİ'NE GÖRE",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    color: softGray,
                    fontSize: 11,
                    letterSpacing: 1.5,
                  ),
                ),
              ),

              pw.SizedBox(height: 30),

              // Ana Başlık
              pw.Center(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 40),
                  child: pw.Text(
                    mainTitle,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: navyBlue,
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),

              pw.SizedBox(height: 15),

              // KONUT Uyarısı kaldırıldı
              pw.SizedBox(height: 20),

              // Skor Badge (sadece showScore true ise)
              if (showScore) ...[
                pw.SizedBox(height: 50),
                pw.Center(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 25,
                    ),
                    decoration: pw.BoxDecoration(
                      color: lightGray,
                      borderRadius: pw.BorderRadius.circular(12),
                      border: pw.Border.all(color: accentTeal, width: 2),
                    ),
                    child: pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        // Sol Kolon: Başlık ve Puan
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "YANGIN GÜVENLİK PUANI",
                              style: pw.TextStyle(color: softGray, fontSize: 8),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              "${metrics['score']} / 100",
                              style: pw.TextStyle(
                                color: _getScoreColorForPdf(
                                  metrics['score'] as int,
                                ),
                                fontSize: 22,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(width: 25), // Kolonlar arası boşluk
                        // Sağ Kolon: Risk Durumu
                        pw.Text(
                          (metrics['score'] as int) > 80
                              ? "DÜŞÜK RİSK"
                              : (metrics['score'] as int) > 50
                              ? "ORTA RİSK"
                              : "YÜKSEK RİSK",
                          style: pw.TextStyle(
                            color: _getScoreColorForPdf(
                              metrics['score'] as int,
                            ),
                            fontSize: 14, // Biraz daha belirgin
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                pw.SizedBox(height: 30),
                if (subTitle.isNotEmpty)
                  pw.Center(
                    child: pw.Text(
                      subTitle,
                      style: pw.TextStyle(color: softGray, fontSize: 12),
                    ),
                  ),
              ],

              pw.Spacer(),

              // Alt Bilgi Şeridi - Koyu Lacivert
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(
                  vertical: 25,
                  horizontal: 30,
                ),
                color: darkNavy,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Bina Adı
                    pw.Text(
                      _cleanEmojis(store.currentBinaName).isEmpty
                          ? "Bina Adı Belirtilmemiş"
                          : _cleanEmojis(store.currentBinaName),
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    // Konum ve Tarih
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          "${_cleanEmojis(store.currentBinaDistrict)} / ${_cleanEmojis(store.currentBinaCity)}",
                          style: const pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 12,
                          ),
                        ),
                        pw.Text(
                          "Tarih: ${DateTime.now().day.toString().padLeft(2, '0')}.${DateTime.now().month.toString().padLeft(2, '0')}.${DateTime.now().year}",
                          style: const pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static pw.Page _buildLegalPage(pw.PageTheme pageTheme) {
    return pw.MultiPage(
      pageTheme: pageTheme,
      footer: _buildFooter,
      build: (context) => [
        pw.Text(
          "YASAL DAYANAKLAR VE SORUMLULUK REDDİ",
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Text(
          AppStrings.legalDisclaimerContent,
          style: const pw.TextStyle(fontSize: 9),
        ),
        pw.SizedBox(height: 20),
        pw.Text(AppStrings.kvkkContent, style: const pw.TextStyle(fontSize: 9)),
      ],
    );
  }

  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.center,
      child: pw.Column(
        children: [
          pw.Divider(color: PdfColors.grey400, thickness: 0.5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                "Version v1.0",
                style: const pw.TextStyle(
                  fontSize: 6,
                  color: PdfColors.grey600,
                ),
              ),
              pw.Text(
                "Sayfa ${context.pageNumber} / ${context.pagesCount}",
                style: const pw.TextStyle(
                  fontSize: 6,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 2),
          pw.Container(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              "BU BELGE, UYGULAMA İLE ÜRETİLMİŞ OLUP RESMİ BELGE NİTELİĞİ TAŞIMAZ. ISLAK İMZA VEYA KAŞE YERİNE GEÇMEZ. "
              "YASAL UYARILARIN TÜMÜ VE TCK SORUMLULUK BEYANI BU DOKÜMANIN AYRILMAZ PARÇASIDIR.",
              style: const pw.TextStyle(fontSize: 5, color: PdfColors.black),
              textAlign: pw.TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper for Rich Text Highlighting ---
  static pw.Widget _buildRichText(String text, pw.Font font, pw.Font fontBold) {
    if (text.isEmpty) return pw.Text("");

    // Support for <b>...</b> tags
    final RegExp regExp = RegExp(r'<b>(.*?)</b>', dotAll: true);
    final List<pw.InlineSpan> spans = [];

    int lastMatchEnd = 0;
    final matches = regExp.allMatches(text);

    for (final match in matches) {
      // Pre-match text
      if (match.start > lastMatchEnd) {
        String preText = text.substring(lastMatchEnd, match.start);
        spans.add(
          pw.TextSpan(
            text: preText,
            style: pw.TextStyle(
              fontSize: 9,
              font: font,
              color: PdfColors.black,
            ),
          ),
        );
      }

      // Bolded text
      spans.add(
        pw.TextSpan(
          text: match.group(1),
          style: pw.TextStyle(
            fontSize: 9,
            font: fontBold,
            color: PdfColors.black,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );

      lastMatchEnd = match.end;
    }

    // Remaining text
    if (lastMatchEnd < text.length) {
      spans.add(
        pw.TextSpan(
          text: text.substring(lastMatchEnd),
          style: pw.TextStyle(fontSize: 9, font: font, color: PdfColors.black),
        ),
      );
    }

    // Secondary pass for specific highlights (Legacy logic)
    // Note: This logic is simplified to work with spans if tags are not used
    if (matches.isEmpty) {
      final highLightPatterns = ["YÜKSEK BİNA", "YÜKSEK OLMAYAN BİNA"];
      bool hasHighlight = highLightPatterns.any((pat) => text.contains(pat));
      if (hasHighlight) {
        // If no tags were found, we apply the legacy highlight logic
        // (Keeping it simple for now)
        List<pw.InlineSpan> highlightSpans = [];
        String remaining = text;
        while (remaining.isNotEmpty) {
          int bestIndex = -1;
          String bestMatch = "";
          for (var pat in highLightPatterns) {
            int idx = remaining.indexOf(pat);
            if (idx != -1 && (bestIndex == -1 || idx < bestIndex)) {
              bestIndex = idx;
              bestMatch = pat;
            }
          }
          if (bestIndex != -1) {
            if (bestIndex > 0)
              highlightSpans.add(
                pw.TextSpan(
                  text: remaining.substring(0, bestIndex),
                  style: pw.TextStyle(fontSize: 9, font: font),
                ),
              );
            highlightSpans.add(
              pw.TextSpan(
                text: bestMatch,
                style: pw.TextStyle(
                  fontSize: 9,
                  font: fontBold,
                  color: PdfColors.red700,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            );
            remaining = remaining.substring(bestIndex + bestMatch.length);
          } else {
            highlightSpans.add(
              pw.TextSpan(
                text: remaining,
                style: pw.TextStyle(fontSize: 9, font: font),
              ),
            );
            remaining = "";
          }
        }
        return pw.RichText(text: pw.TextSpan(children: highlightSpans));
      }
    }

    return pw.RichText(text: pw.TextSpan(children: spans));
  }

  // --- 1. RİSK ANALİZ RAPORU ---
  static Future<void> generateRiskAnalysisPdf() async {
    final pdf = pw.Document();
    // Bundle edilmiş Roboto fontları - offline çalışır, Türkçe karakterleri destekler
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final fontDataBold = await rootBundle.load("assets/fonts/Roboto-Bold.ttf");
    final ttf = pw.Font.ttf(fontData);
    final ttfBold = pw.Font.ttf(fontDataBold);
    final logoData = await rootBundle.load("assets/images/ui/logo3.webp");
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

    final store = BinaStore.instance;
    final metrics = ReportEngine.calculateRiskMetrics();
    final moduleScores = ReportEngine.calculateModuleScores();

    final pageTheme = _buildPageTheme(ttf, ttfBold);

    // 1. Kapak
    pdf.addPage(
      _buildCoverPage(
        pageTheme: pageTheme,
        logoImage: logoImage,
        mainTitle: "YANGIN RİSK ANALİZİ",
        subTitle: "",
        store: store,
        metrics: metrics,
        showScore: true,
      ),
    );

    // 3. Risk Analizi ve Bölümler
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        header: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            "",
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          ),
        ),
        footer: _buildFooter,
        build: (context) => [
          pw.Text(
            "MODÜL BAZINDA PUANLAMA",
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
            children: moduleScores.entries
                .map(
                  (e) => pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(
                          e.key.title,
                          style: const pw.TextStyle(fontSize: 9),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(
                          "%${e.value.toInt()}",
                          style: pw.TextStyle(
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            "DEĞERLENDİRME NOTLARI",
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            "Bu çalışma yalnızca 19.12.2007 ve sonrasında yapı ruhsatı onaylanmış KONUT ve KONUT+TİCARET amaçlı yapılar için geçerli olup KONUT ve KONUTLA ilgili kullanım alanlarının (otopark, teknik hacimler vb.) yangın güvenlik ihtiyaçlarına odaklanmaktadır. Bina içerisinde ticari işletmeler (işyeri) varsa, bu çalışmadaki değerlendirmeler ticari işletmelere ait işyeri açma ve çalışma ruhsatı süreçleriyle ilişkilendirilmemelidir. İşyerlerinde alınacak yangın güvenlik tedbirleri hususi olarak değerlendirilmelidir.",
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blueGrey700,
              lineSpacing: 2,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            "Bu doküman içerisinde yer alan renk kodları ve anlamları aşağıda açıklanmıştır:",
            style: const pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey700,
              lineSpacing: 1.5,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildLegendItem(
                PdfColors.red700,
                "KRİTİK RİSK",
                "(-10 Puan) Acil önlem alınmalı",
              ),
              pw.SizedBox(width: 20),
              _buildLegendItem(
                PdfColors.yellow700,
                "UYARI",
                "(-2 Puan) Önlem gerekebilir",
              ),
              pw.SizedBox(width: 20),
              _buildLegendItem(PdfColors.blue700, "BİLGİ", ""),
              pw.SizedBox(width: 20),
              _buildLegendItem(PdfColors.green700, "OLUMLU", ""),
              pw.SizedBox(width: 20),
              _buildLegendItem(
                PdfColors.grey500,
                "BİLİNMİYOR",
                "(-1 Puan) Tespit yapılamadı",
              ),
            ],
          ),

          pw.SizedBox(height: 15),
          ...List.generate(36, (index) {
            int id = index + 1;
            final res = store.getResultForSection(id);
            if (res == null) return pw.SizedBox();

            // Get detailed list instead of single text
            final details = ReportEngine.getSectionDetailedReport(
              id,
              store: store,
            );
            // Fallback for coloring: use the main result text or first item
            final fullReportForColor = ReportEngine.getSectionFullReport(
              id,
              store: store,
            );
            final riskColor = _getRiskColor(fullReportForColor);

            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 2), // Reduced from 5
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  left: pw.BorderSide(color: riskColor, width: 4),
                ),
                color: PdfColors.grey50,
              ),
              padding: const pw.EdgeInsets.all(5), // Reduced from 8
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Section Header
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        "BÖLÜM $id: ${_toUpperCaseTR(AppDefinitions.getSectionTitle(id))}",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.indigo900,
                        ),
                      ),
                    ],
                  ),
                  pw.Divider(thickness: 0.8, color: PdfColors.indigo100),

                  // Detailed Items Loop
                  ...details.map((item) {
                    final label = item['label'] ?? '';
                    final value = item['value'] ?? '';
                    final report = _cleanEmojis(item['report'] ?? '');
                    final isLast = item == details.last;

                    return pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(height: 4), // Reduced from 8
                        // Soru
                        if (label.isNotEmpty) ...[
                          pw.Text(
                            "Soru:",
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blue900,
                            ),
                          ),
                          pw.Text(
                            label,
                            style: pw.TextStyle(
                              fontSize: 9,
                              font: ttf,
                              color: PdfColors.black,
                            ),
                          ),
                          pw.SizedBox(height: 2), // Reduced from 4
                        ],

                        // Yanıt
                        if (value.isNotEmpty && value != 'Seçilmedi') ...[
                          pw.Text(
                            "Kullanıcı Yanıtı:",
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blue900,
                            ),
                          ),
                          pw.Text(
                            value,
                            style: pw.TextStyle(
                              fontSize: 9,
                              font: ttf,
                              color: PdfColors.black,
                            ),
                          ),
                          pw.SizedBox(height: 2), // Reduced from 4
                        ],

                        // Değerlendirme (Hem başlık hem metin KALIN)
                        if (report.isNotEmpty) ...[
                          pw.Text(
                            "Değerlendirme:",
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blue900,
                            ),
                          ),
                          // Highlight "YÜKSEK BİNA" etc
                          _buildRichText(report, ttf, ttfBold),
                        ],

                        // Öneri (Advice)
                        if (item['advice'] != null &&
                            item['advice']!.isNotEmpty) ...[
                          pw.SizedBox(height: 2), // Reduced from 4
                          pw.Text(
                            "Öneri:",
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blue900,
                            ),
                          ),
                          pw.Text(
                            _cleanEmojis(item['advice']!),
                            style: pw.TextStyle(
                              fontSize: 9,
                              font: ttf,
                              color: PdfColors.black,
                              fontStyle: pw.FontStyle.italic,
                            ),
                          ),
                        ],
                        if (!isLast) ...[
                          pw.SizedBox(height: 4), // Reduced from 8
                          pw.Divider(thickness: 0.1, color: PdfColors.grey300),
                        ],
                      ],
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );

    // Yasal (En Sona Taşındı)
    pdf.addPage(_buildLegalPage(pageTheme));

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  // --- 2. AKTİF SİSTEM GEREKSİNİMLERİ RAPORU ---
  static Future<void> generateActiveSystemsPdf() async {
    final pdf = pw.Document();
    // Bundle edilmiş Roboto fontları - offline çalışır, Türkçe karakterleri destekler
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final fontDataBold = await rootBundle.load("assets/fonts/Roboto-Bold.ttf");
    final ttf = pw.Font.ttf(fontData);
    final ttfBold = pw.Font.ttf(fontDataBold);
    final logoData = await rootBundle.load("assets/images/ui/logo3.webp");
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

    final store = BinaStore.instance;
    final activeSystems = ActiveSystemsEngine.calculateRequirements(store);
    final pageTheme = _buildPageTheme(ttf, ttfBold);

    // 1. Kapak
    pdf.addPage(
      _buildCoverPage(
        pageTheme: pageTheme,
        logoImage: logoImage,
        mainTitle: "AKTİF SİSTEM GEREKSİNİMLERİ",
        subTitle: "",
        store: store,
        metrics: {'score': 0}, // Skor gösterilmeyecek
        showScore: false,
      ),
    );

    // 3. Aktif Sistem Listesi
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        header: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            "Aktif Sistem Gereksinimleri",
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          ),
        ),
        footer: _buildFooter,
        build: (context) => [
          pw.Text(
            "AKTİF SİSTEM GEREKSİNİMLERİ",
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.purple900,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            "Bu çalışma yalnızca 19.12.2007 ve sonrasında yapı ruhsatı onaylanmış KONUT ve KONUT+TİCARET amaçlı yapılar için geçerli olup KONUT ve KONUTLA ilgili kullanım alanlarının (otopark, teknik hacimler vb.) yangın güvenlik ihtiyaçlarına odaklanmaktadır. Bina içerisinde ticari işletmeler (işyeri) varsa, bu çalışmadaki değerlendirmeler ticari işletmelere ait işyeri açma ve çalışma ruhsatı süreçleriyle ilişkilendirilmemelidir. İşyerlerinde alınacak yangın güvenlik tedbirleri hususi olarak değerlendirilmelidir.",
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blueGrey700,
              lineSpacing: 2,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            "Yangın güvenliği için kritik öneme sahip, Binaların Yangından Korunması Hakkında Yönetmeliği 'ne göre binada olması gereken algılama, söndürme, duman tahliye vb. sistem gereksinimleri aşağıda listelenmiştir.",
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.black,
              lineSpacing: 1.5,
            ),
          ),
          pw.SizedBox(height: 20),

          ...activeSystems.map((req) {
            // Clean redundant prefixes for display
            String cleanReason = _cleanEmojis(req.reason)
                .replaceAll("KRİTİK RİSK:", "")
                .replaceAll("UYARI:", "")
                .replaceAll("OLUMLU:", "")
                .replaceAll("BİLGİ:", "")
                .replaceAll("BİLMİYORUM:", "")
                .trim();

            final statusColor = _getRiskColor(req.reason);
            final isMandatory = statusColor == PdfColors.red700;
            final isWarning = statusColor == PdfColors.amber700;

            // Determine box decoration based on status
            pw.BoxDecoration boxDecoration;
            if (isMandatory) {
              // Critical Risk: Red background
              boxDecoration = pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFFFEBEE), // Soft Red
                border: pw.Border.all(color: PdfColors.red700, width: 1.5),
                borderRadius: pw.BorderRadius.circular(4),
              );
            } else if (isWarning) {
              // Warning: Amber/Yellow background
              boxDecoration = pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFFFF8E1), // Soft Amber
                border: pw.Border.all(color: PdfColors.amber700, width: 1.5),
                borderRadius: pw.BorderRadius.circular(4),
              );
            } else {
              // Neutral (OLUMLU, BİLGİ, etc.)
              boxDecoration = const pw.BoxDecoration(
                color: PdfColors.white,
                border: pw.Border(
                  left: pw.BorderSide(color: PdfColors.grey400, width: 4),
                ),
              );
            }

            return pw.Wrap(
              children: [
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  padding: const pw.EdgeInsets.all(8),
                  decoration: boxDecoration,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(
                            child: pw.Text(
                              _cleanEmojis(req.name),
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.black,
                              ),
                            ),
                          ),
                          // Badge removed, maybe just text status if needed?
                          // For now, keeping as is (empty) or minimal
                          pw.SizedBox.shrink(),
                        ],
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        cleanReason,
                        style: const pw.TextStyle(
                          fontSize: 9,
                          color: PdfColors.black,
                        ),
                      ),
                      if (req.note.isNotEmpty) ...[
                        pw.SizedBox(height: 4),
                        pw.Text(
                          "NOT: ${_cleanEmojis(req.note)}",
                          style: pw.TextStyle(
                            fontSize: 8,
                            color: PdfColors.black,
                            // fontStyle: pw.FontStyle.italic removed to fix character issues
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );

    // Yasal (En Sona Taşındı)
    pdf.addPage(_buildLegalPage(pageTheme));

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
