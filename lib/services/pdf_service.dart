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

class PdfService {
  // Badge system removed - plain text only
  static pw.Widget _buildStatusBadge(String text) {
    return pw.SizedBox.shrink(); // Return empty widget
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
    if (text.contains('UYARI')) return PdfColors.yellow700;
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

  static pw.Widget _buildCoverInfoItem(String label, String value) {
    return pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(color: PdfColors.white, fontSize: 8),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value.toUpperCase(),
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
            maxLines: 2,
            overflow: pw.TextOverflow.clip,
          ),
        ],
      ),
    );
  }

  static pw.PageTheme _buildPageTheme(pw.Font ttf, pw.Font ttfBold) {
    return pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.withFont(base: ttf, bold: ttfBold),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Opacity(
          opacity: 0.05,
          child: pw.Center(
            child: pw.Transform.rotate(
              angle: 0.5,
              child: pw.Text(
                "RESMİ BELGE DEĞİLDİR",
                style: pw.TextStyle(
                  fontSize: 30,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
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
                        // Skor Yüzdesi
                        pw.Text(
                          "%${metrics['score']}",
                          style: pw.TextStyle(
                            color: _getScoreColorForPdf(metrics['score'] as int),
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(width: 15),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "YANGIN GÜVENLİK PUANI",
                              style: pw.TextStyle(
                                color: softGray,
                                fontSize: 8,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              (metrics['score'] as int) > 80
                                  ? "DÜŞÜK RİSK"
                                  : (metrics['score'] as int) > 50
                                      ? "ORTA RİSK"
                                      : "YÜKSEK RİSK",
                              style: pw.TextStyle(
                                color: _getScoreColorForPdf(metrics['score'] as int),
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
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
                      style: pw.TextStyle(
                        color: softGray,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],

              pw.Spacer(),

              // Alt Bilgi Şeridi - Koyu Lacivert
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                color: darkNavy,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Bina Adı
                    pw.Text(
                      _cleanEmojis(store.currentBinaName) ?? "Bina Adı Belirtilmemiş",
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
                          "Rapor Tarihi: ${DateTime.now().day.toString().padLeft(2, '0')}.${DateTime.now().month.toString().padLeft(2, '0')}.${DateTime.now().year}",
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
    return pw.Page(
      pageTheme: pageTheme,
      build: (context) => pw.Padding(
        padding: const pw.EdgeInsets.all(30),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
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
            pw.Text(
              AppStrings.kvkkContent,
              style: const pw.TextStyle(fontSize: 9),
            ),
          ],
        ),
      ),
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
              "BU BELGE, UYGULAMA İLE ÜRETİLMİŞ OLUP RESMİ BELGE NİTELİĞİ TAŞIMAZ. Islak imza ve kaşe yerine geçmez. "
              "Yasal uyarıların tamamı ve TCK sorumluluk beyanı raporun ayrılmaz parçasıdır.",
              style: const pw.TextStyle(
                fontSize: 5,
                color: PdfColors.black,
              ),
              textAlign: pw.TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // --- 1. RİSK ANALİZ RAPORU ---
  static Future<void> generateRiskAnalysisPdf() async {
    final pdf = pw.Document();
    // Noto Sans ile Türkçe karakterler tam desteklenir
    final ttf = await PdfGoogleFonts.notoSansRegular();
    final ttfBold = await PdfGoogleFonts.notoSansBold();
    final logoData = await rootBundle.load("assets/images/ui/logo3.webp");
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

    final store = BinaStore.instance;
    final metrics = ReportEngine.calculateRiskMetrics();
    final actionPlan = ReportEngine.getActionPlan();
    final moduleScores = ReportEngine.calculateModuleScores();
    final pageTheme = _buildPageTheme(ttf, ttfBold);

    // 1. Kapak
    pdf.addPage(
      _buildCoverPage(
        pageTheme: pageTheme,
        logoImage: logoImage,
        mainTitle: "YANGIN RİSK ANALİZi",
        subTitle: "",
        store: store,
        metrics: metrics,
        showScore: true,
      ),
    );

    // 2. Yasal
    pdf.addPage(_buildLegalPage(pageTheme));

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
          pw.SizedBox(height: 15),
          ...List.generate(36, (index) {
            int id = index + 1;
            final res = store.getResultForSection(id);
            if (res == null) return pw.SizedBox();
            final fullReport = ReportEngine.getSectionFullReport(id);
            final riskColor = _getRiskColor(fullReport);
            final cleanReport = _cleanEmojis(fullReport);

            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 10),
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  left: pw.BorderSide(color: riskColor, width: 4),
                ),
                color: PdfColors.grey50,
              ),
              padding: const pw.EdgeInsets.all(8),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            "BÖLÜM $id",
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.grey700,
                            ),
                          ),
                          _buildStatusBadge(fullReport),
                        ],
                      ),
                      pw.Text(
                        "Soru: ${AppContent.getQuestionText(id)}",
                        style: const pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.grey800,
                        ),
                      ),
                      pw.Text(
                        "Yanıt: ${res.uiTitle}",
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        _cleanEmojis(cleanReport),
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );

    // 4. İyileştirme Önerileri (Risk Raporunda Kalacak)
    if (actionPlan.isNotEmpty) {
      pdf.addPage(
        pw.Page(
          pageTheme: pageTheme,
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "ÖNERİLER",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.orange900,
                ),
              ),
              pw.SizedBox(height: 20),
              ...actionPlan.map(
                (item) => pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  padding: const pw.EdgeInsets.all(8),
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.orange50,
                    border: pw.Border(
                      left: pw.BorderSide(color: PdfColors.orange900, width: 2),
                    ),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Bölüm ${item['id']}: ${_cleanEmojis(item['title'])}",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        "Öneri: ${_cleanEmojis(item['advice'])}",
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  // --- 2. AKTİF SİSTEM GEREKSİNİMLERİ RAPORU ---
  static Future<void> generateActiveSystemsPdf() async {
    final pdf = pw.Document();
    // Noto Sans ile Türkçe karakterler tam desteklenir
    final ttf = await PdfGoogleFonts.notoSansRegular();
    final ttfBold = await PdfGoogleFonts.notoSansBold();
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
        subTitle: "${activeSystems.length} Tespit",
        store: store,
        metrics: {'score': 0}, // Skor gösterilmeyecek
        showScore: false,
      ),
    );

    // 2. Yasal
    pdf.addPage(_buildLegalPage(pageTheme));

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
          pw.SizedBox(height: 10),
          pw.Text(
            "Yangın güvenliği için kritik öneme sahip algılama, söndürme, duman tahliye vb. sistem gereksinimleri aşağıda listelenmiştir.",
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
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

            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 10),
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  left: pw.BorderSide(color: statusColor, width: 4),
                ),
                color: PdfColors.grey50,
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        _cleanEmojis(req.name),
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      _buildStatusBadge(req.reason),
                    ],
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    cleanReason,
                    style: pw.TextStyle(fontSize: 9, color: statusColor),
                  ),
                  if (req.note.isNotEmpty) ...[
                    pw.SizedBox(height: 4),
                    pw.Text(
                      "NOT: ${_cleanEmojis(req.note)}",
                      style: pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.grey700,
                        fontStyle: pw.FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
