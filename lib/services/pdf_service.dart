import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../data/bina_store.dart';
import '../logic/report_engine.dart';
import '../models/report_status.dart';
import '../utils/app_strings.dart';
import '../utils/app_content.dart';
import '../logic/active_systems_engine.dart';

// Helper function for Turkish locale-aware uppercase conversion
// Dart's standard toUpperCase() doesn't handle Turkish characters correctly (İ→I, ı→i)
String _toTitleCaseTR(String text) {
  if (text.isEmpty) return text;
  return text
      .split(' ')
      .map((word) {
        if (word.isEmpty) return word;
        String first = word.substring(0, 1);
        String rest = word.substring(1);

        // Convert first letter to TR uppercase
        first = first
            .replaceAll('i', 'İ')
            .replaceAll('ı', 'I')
            .replaceAll('ö', 'Ö')
            .replaceAll('ü', 'Ü')
            .replaceAll('ç', 'Ç')
            .replaceAll('ş', 'Ş')
            .replaceAll('ğ', 'Ğ')
            .toUpperCase();

        // Convert rest to TR lowercase
        rest = rest
            .replaceAll('İ', 'i')
            .replaceAll('I', 'ı')
            .replaceAll('Ö', 'ö')
            .replaceAll('Ü', 'ü')
            .replaceAll('Ç', 'ç')
            .replaceAll('Ş', 'ş')
            .replaceAll('Ğ', 'ğ')
            .toLowerCase();

        return first + rest;
      })
      .join(' ');
}

class PdfService {
  // Keywords that get bold+red highlighting in PDF output.
  // Defined once here and used by both _buildHighlightedText and _buildRichText.
  static const _highlightKeywords = ["YÜKSEK BİNA", "YÜKSEK OLMAYAN BİNA"];

  static pw.Widget _buildBulletPoint(String text, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            margin: const pw.EdgeInsets.only(top: 2, right: 6),
            width: 3,
            height: 3,
            decoration: const pw.BoxDecoration(
              color: PdfColors.blueGrey700,
              shape: pw.BoxShape.circle,
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              text,
              style: pw.TextStyle(
                font: font,
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blueGrey700,
                lineSpacing: 2.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

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

  static PdfColor _getRiskColor(String text) {
    if (text.contains('KRİTİK RİSK')) return PdfColors.red700;
    if (text.contains('UYARI')) return PdfColors.amber700;
    if (text.contains('OLUMLU') || text.contains('Olumlu')) {
      return PdfColors.green700;
    }
    if (text.contains('BİLGİ')) return PdfColors.blue700;
    return PdfColors.grey500;
  }

  static PdfColor _getScoreColorForPdf(int score) {
    if (score >= 80) return PdfColors.green300;
    if (score >= 50) return PdfColors.orange300;
    return PdfColors.red300;
  }

  static pw.PageTheme _buildPageTheme(
    pw.Font base,
    pw.Font bold,
    pw.Font italic,
    pw.Font boldItalic,
  ) {
    return pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
        boldItalic: boldItalic,
      ),
    );
  }

  static pw.Widget _buildGaugeChart(int score) {
    double angle = -180.0 + (score / 100.0) * 180.0;
    
    String svgContent = '''
    <svg width="240" height="130" viewBox="0 0 200 120" xmlns="http://www.w3.org/2000/svg">
      <path d="M 20 100 A 80 80 0 0 1 180 100" fill="none" stroke="#10b981" stroke-width="20" />
      <path d="M 20 100 A 80 80 0 0 1 180 100" fill="none" stroke="#f59e0b" stroke-width="20" stroke-dasharray="201.06 251.33" />
      <path d="M 20 100 A 80 80 0 0 1 180 100" fill="none" stroke="#ef4444" stroke-width="20" stroke-dasharray="125.66 251.33" />
      
      <path d="M 20 100 A 80 80 0 0 1 180 100" fill="none" stroke="#ffffff" stroke-width="22" stroke-dasharray="3 251.33" stroke-dashoffset="-124.66" />
      <path d="M 20 100 A 80 80 0 0 1 180 100" fill="none" stroke="#ffffff" stroke-width="22" stroke-dasharray="3 251.33" stroke-dashoffset="-200.06" />

      <polygon points="100,96 100,104 175,100" fill="#1e293b" transform="rotate($angle 100 100)" />
      
      <circle cx="100" cy="100" r="10" fill="#1e293b" />
      <circle cx="100" cy="100" r="4" fill="#ffffff" />
    </svg>
    ''';
    
    return pw.Container(
      height: 120,
      child: pw.SvgImage(svg: svgContent),
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

    return pw.Page(
      pageTheme: pageTheme,
      build: (context) {
        return pw.Container(
          color: PdfColors.white,
          child: pw.Column(
            children: [
              // Üst Boşluk
              pw.SizedBox(height: 50),

              // Logo - Ortada
              pw.Center(
                child: pw.Container(
                  height: 100, // Daha büyük logo
                  width: 250,
                  child: pw.Image(logoImage, fit: pw.BoxFit.contain),
                ),
              ),

              pw.SizedBox(height: 30),

              // Yönetmelik Başlığı
              pw.Center(
                child: pw.Text(
                  "BİNALARIN YANGINDAN KORUNMASI HAKKINDA YÖNETMELİĞİ'NE GÖRE",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    color: softGray,
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              pw.SizedBox(height: 15),

              // Ana Başlık
              pw.Center(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 20),
                  child: pw.Text(
                    mainTitle,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: navyBlue,
                      fontSize: 32, // Daha büyük ve ihtişamlı ana başlık
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

              pw.SizedBox(height: 40),

              // Skor Yüzdesi ve Gauge Chart (sadece showScore true ise)
              if (showScore) ...[
                pw.Center(
                  child: _buildGaugeChart(metrics['score'] as int),
                ),
                pw.Center(
                  child: pw.Text(
                    "${metrics['score']} / 100",
                    style: pw.TextStyle(
                      fontSize: 32,
                      fontWeight: pw.FontWeight.bold,
                      color: _getScoreColorForPdf(metrics['score'] as int),
                    ),
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Center(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: pw.BoxDecoration(
                      color: _getScoreColorForPdf(metrics['score'] as int).shade(0.1),
                      borderRadius: pw.BorderRadius.circular(20),
                    ),
                    child: pw.Text(
                      (metrics['score'] as int) > 80
                          ? "DÜŞÜK RİSK"
                          : (metrics['score'] as int) > 50
                          ? "ORTA RİSK"
                          : "YÜKSEK RİSK",
                      style: pw.TextStyle(
                        color: _getScoreColorForPdf(metrics['score'] as int),
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
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
                        fontSize: 14,
                        letterSpacing: 1.0,
                      ),
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

  static String _convertToActionableText(String text) {
    if (text.isEmpty) return "";
    String processed = text;
    
    // 1. Etiketleri Temizle
    processed = processed.replaceAll(RegExp(r'^(KRİTİK RİSK:\s*|UYARI:\s*|ÖNERİ:\s*)'), '').trim();
    
    // 2. Aksiyon Dışı Neden ve Rakamları Temizle (Parantez içi)
    processed = processed.replaceAll(RegExp(r'\([^)]*\)'), '').trim();
    processed = processed.replaceAll(RegExp(r'\s{2,}'), ' ').trim();

    // 3. Aksiyon Bildiren Kelimelerle Değiştir
    processed = processed.replaceAll("uygun değildir.", "yönetmelik esaslarına uygun hale getirilmelidir.");
    processed = processed.replaceAll("uygun değildir", "yönetmelik esaslarına uygun hale getirilmelidir");
    processed = processed.replaceAll("bulunmamaktadır.", "ilave edilmeli/tesis edilmelidir.");
    processed = processed.replaceAll("bulunmamaktadır", "ilave edilmeli/tesis edilmelidir");
    processed = processed.replaceAll("tespit edilmiştir.", "ilgili durum düzeltilmelidir.");
    processed = processed.replaceAll("tespit edilmiştir", "ilgili durum düzeltilmelidir");
    processed = processed.replaceAll("ihlal edilmiştir.", "ihlali giderilmeli, asgari yönetmelik sınırları sağlanmalıdır.");
    processed = processed.replaceAll("ihlal edilmiştir", "ihlali giderilmeli, asgari yönetmelik sınırları sağlanmalıdır");
    processed = processed.replaceAll("kullanılamaz.", "kullanılamaz, uygun alternatif bir kaçış rotası sağlanmalıdır.");
    processed = processed.replaceAll("kullanılamaz", "kullanılamaz, uygun alternatif bir kaçış rotası sağlanmalıdır");
    processed = processed.replaceAll("taşımamaktadır.", "taşıyacak şekilde modernize edilmelidir.");
    processed = processed.replaceAll("taşımamaktadır", "taşıyacak şekilde modernize edilmelidir");
    
    if (!processed.endsWith('.') && !processed.endsWith(':')) {
      processed += '.';
    }
    
    return processed;
  }

  static List<pw.Page> _buildExecutiveSummaryPage({
    required pw.PageTheme pageTheme,
    required BinaStore store,
    required Map<String, dynamic> metrics,
    required pw.Font ttf,
    required pw.Font ttfBold,
  }) {
    List<String> actionItems = [];
    
    for (int id = 1; id <= 36; id++) {
      if ([3, 5, 6, 7, 10, 12, 21, 36].contains(id)) {
        final fullReport = ReportEngine.getSectionFullReport(id, store: store);
        final riskColor = _getRiskColor(fullReport);
        if (riskColor == PdfColors.red700 || riskColor == PdfColors.yellow700) {
           String act = _convertToActionableText(fullReport);
           if (!actionItems.contains(act)) actionItems.add(act);
        }
      } else {
        final details = ReportEngine.getSectionDetailedReport(id, store: store);
        for (final item in details) {
          final status = item['status'] as ReportStatus;
          if (status == ReportStatus.risk || status == ReportStatus.warning) {
            String actText = _convertToActionableText((item['report'] ?? '').toString());
            if (actText.isNotEmpty && !actionItems.contains(actText)) {
               actionItems.add(actText);
            }
          }
        }
      }
    }
    
    if (actionItems.isEmpty) {
        actionItems.add("Binada tespit edilmiş acil aksiyon gerektiren kritik bir ihlal veya uyarı bulunmamaktadır.");
    }

    final score = metrics['score'] as int;
    final riskText = score > 80 ? "DÜŞÜK RİSK" : score > 50 ? "ORTA RİSK" : "YÜKSEK RİSK";
    final riskColor = _getScoreColorForPdf(score);

    return [
      pw.MultiPage(
        pageTheme: pageTheme,
        header: (context) => pw.SizedBox(),
        footer: _buildFooter,
        build: (context) => [
          pw.Text(
            "YÖNETİCİ ÖZETİ VE ACİL EYLEM PLANI",
            style: pw.TextStyle(
              font: ttfBold,
              fontSize: 13,
              color: PdfColor.fromInt(0xFF1a365d),
            ),
          ),
          pw.SizedBox(height: 12),
          pw.RichText(
            text: pw.TextSpan(
              style: pw.TextStyle(font: ttf, fontSize: 9.5, lineSpacing: 2.2),
              children: [
                pw.TextSpan(text: "Bu bina, güncel Binaların Yangından Korunması Hakkında Yönetmelik kriterlerine göre genel hatlarıyla "),
                pw.TextSpan(text: "[$riskText]", style: pw.TextStyle(font: ttfBold, color: riskColor)),
                pw.TextSpan(text: " kategorisinde değerlendirilmiştir. Can ve mal güvenliğini asgari düzeyde sağlayabilmek adına, aşağıdaki listede yer alan yapısal/mimari tespitlerin ivedilikle giderilmesi veya ilgili eksikliklerle ilgili aksiyon alınması şiddetle önerilmektedir:"),
              ]
            ),
          ),
          pw.SizedBox(height: 15),
          ...actionItems.map((item) {
             return pw.Padding(
               padding: const pw.EdgeInsets.only(bottom: 15),
               child: pw.Row(
                 crossAxisAlignment: pw.CrossAxisAlignment.start,
                 children: [
                    pw.Container(
                       width: 12,
                       height: 12,
                       margin: const pw.EdgeInsets.only(top: 2, right: 10),
                       decoration: pw.BoxDecoration(
                         border: pw.Border.all(color: PdfColors.grey700, width: 1.2),
                         borderRadius: pw.BorderRadius.circular(2)
                       )
                    ),
                    pw.Expanded(
                       child: pw.Text(
                         item,
                         style: pw.TextStyle(font: ttf, fontSize: 9, color: PdfColors.black, lineSpacing: 2.2),
                       )
                    )
                 ]
               )
             );
          })
        ]
      )
    ];
  }

  static pw.Page _buildLegalPage(pw.PageTheme pageTheme) {
    // Split the content manually for the two-column layout
    final disclaimerParts = AppStrings.legalDisclaimerContent.split('\n\n');
    // Part 1: İŞBU METİN + 1 + 2 + 3
    final leftColumnText = disclaimerParts.sublist(0, 4).join('\n\n');
    // Part 2: 4 + 5 + KVKK
    final rightColumnText = disclaimerParts.sublist(4).join('\n\n');

    return pw.Page(
      pageTheme: pageTheme.copyWith(
        margin: const pw.EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      ),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "EK 1: YASAL DAYANAKLAR VE SORUMLULUK REDDİ BEYANI",
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey700,
              letterSpacing: 1.0,
            ),
          ),
          pw.SizedBox(height: 15),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Text(
                  leftColumnText,
                  style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600, lineSpacing: 1.5),
                  textAlign: pw.TextAlign.justify,
                ),
              ),
              pw.SizedBox(width: 25),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      rightColumnText,
                      style: const pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.grey600,
                        lineSpacing: 1.5,
                      ),
                      textAlign: pw.TextAlign.justify,
                    ),
                    pw.SizedBox(height: 15),
                    pw.Text(
                      AppStrings.kvkkTitle,
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      AppStrings.kvkkContent,
                      style: const pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.grey600,
                        lineSpacing: 1.5,
                      ),
                      textAlign: pw.TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.Spacer(),
          _buildFooter(context),
        ],
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
              "BU BELGE, UYGULAMA İLE ÜRETİLMİŞ OLUP RESMİ BELGE NİTELİĞİ TAŞIMAZ. ISLAK İMZA VEYA KAŞE YERİNE GEÇMEZ. "
              "YASAL UYARILARIN TÜMÜ VE TCK SORUMLULUK BEYANI BU DOKÜMANIN AYRILMAZ PARÇASIDIR.",
              style: const pw.TextStyle(fontSize: 4.2, color: PdfColors.black),
              textAlign: pw.TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // --- Keyword Highlight Helper ---
  // Scans for known keywords and renders them bold+red in the PDF.
  // Called by _buildRichText as a fallback when no <b> tags are present.
  static pw.Widget _buildHighlightedText(
    String text,
    pw.Font font,
    pw.Font fontBold,
  ) {
    final highlights = _highlightKeywords;
    final List<pw.InlineSpan> spans = [];
    String remaining = text;

    while (remaining.isNotEmpty) {
      int bestIndex = -1;
      String bestMatch = "";
      for (final pat in highlights) {
        final idx = remaining.indexOf(pat);
        if (idx != -1 && (bestIndex == -1 || idx < bestIndex)) {
          bestIndex = idx;
          bestMatch = pat;
        }
      }

      if (bestIndex != -1) {
        if (bestIndex > 0) {
          spans.add(
            pw.TextSpan(
              text: remaining.substring(0, bestIndex),
              style: pw.TextStyle(fontSize: 9, font: font, lineSpacing: 2.2),
            ),
          );
        }
        spans.add(
          pw.TextSpan(
            text: bestMatch,
            style: pw.TextStyle(
              fontSize: 9,
              font: fontBold,
              color: PdfColors.red700,
              fontWeight: pw.FontWeight.bold,
              lineSpacing: 2.2,
            ),
          ),
        );
        remaining = remaining.substring(bestIndex + bestMatch.length);
      } else {
        spans.add(
          pw.TextSpan(
            text: remaining,
            style: pw.TextStyle(fontSize: 9, font: font, lineSpacing: 2.2),
          ),
        );
        remaining = "";
      }
    }

    return pw.RichText(text: pw.TextSpan(children: spans));
  }

  // --- Helper for Rich Text Highlighting ---
  // Primary system: <b>...</b> tags in source text → bold in PDF.
  // Fallback: keyword-based highlight via _buildHighlightedText (PDF-only, no tags in source).
  static pw.Widget _buildRichText(String text, pw.Font font, pw.Font fontBold) {
    if (text.isEmpty) return pw.Text("");

    final RegExp regExp = RegExp(r'<b>(.*?)</b>', dotAll: true);
    final matches = regExp.allMatches(text);

    // Fallback: no <b> tags — use keyword-based highlight if relevant
    if (matches.isEmpty) {
      if (_highlightKeywords.any((pat) => text.contains(pat))) {
        return _buildHighlightedText(text, font, fontBold);
      }
      return pw.Text(
        text,
        style: pw.TextStyle(fontSize: 9, font: font, lineSpacing: 2.2),
      );
    }

    // Primary: parse <b> tags into bold spans
    final List<pw.InlineSpan> spans = [];
    int lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(
          pw.TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: pw.TextStyle(
              fontSize: 9,
              font: font,
              color: PdfColors.black,
              lineSpacing: 2.2,
            ),
          ),
        );
      }
      spans.add(
        pw.TextSpan(
          text: match.group(1),
          style: pw.TextStyle(
            fontSize: 9,
            font: fontBold,
            color: PdfColors.black,
            fontWeight: pw.FontWeight.bold,
            lineSpacing: 2.2,
          ),
        ),
      );
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(
        pw.TextSpan(
          text: text.substring(lastMatchEnd),
          style: pw.TextStyle(
            fontSize: 9,
            font: font,
            color: PdfColors.black,
            lineSpacing: 2.2,
          ),
        ),
      );
    }

    return pw.RichText(text: pw.TextSpan(children: spans));
  }

  // --- 1. RİSK ANALİZ RAPORU ---
  static Future<void> generateRiskAnalysisPdf() async {
    final pdf = pw.Document();
    // Bundle edilmiş Roboto fontları - offline çalışır, Türkçe karakterleri destekler
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final fontDataBold = await rootBundle.load("assets/fonts/Roboto-Bold.ttf");
    final fontDataItalic = await rootBundle.load(
      "assets/fonts/Roboto-Italic.ttf",
    );
    final fontDataBoldItalic = await rootBundle.load(
      "assets/fonts/Roboto-BoldItalic.ttf",
    );

    final ttf = pw.Font.ttf(fontData);
    final ttfBold = pw.Font.ttf(fontDataBold);
    final ttfItalic = pw.Font.ttf(fontDataItalic);
    final ttfBoldItalic = pw.Font.ttf(fontDataBoldItalic);

    final logoData = await rootBundle.load("assets/images/ui/logo3.webp");
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

    final store = BinaStore.instance;
    final metrics = ReportEngine.calculateRiskMetrics();

    final pageTheme = _buildPageTheme(ttf, ttfBold, ttfItalic, ttfBoldItalic);

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

    // 2. Executive Summary (Yönetici Özeti)
    for (var page in _buildExecutiveSummaryPage(
      pageTheme: pageTheme,
      store: store,
      metrics: metrics,
      ttf: ttf,
      ttfBold: ttfBold,
    )) {
      pdf.addPage(page);
    }

    // 3. Risk Analizi ve Bölümler
    pdf.addPage(
      pw.MultiPage(
        maxPages: 2000,

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
          pw.SizedBox(height: 12),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildBulletPoint(
                "Bu çalışma yalnızca 19.12.2007 ve sonrasında yapı ruhsatı onaylanmış KONUT ve KONUT+TİCARET amaçlı yapılar için geçerli olup, KONUT ve konut ile ilgili kullanım alanlarının (otopark, teknik hacimler vb.) MİMARİ yangın güvenliği ihtiyaçlarına odaklanmaktadır.",
                ttfBold,
              ),
              _buildBulletPoint(
                "Bina içerisinde ticari işletmeler (işyeri) varsa bu çalışma, ticari işletmelere ait işyeri açma ve çalışma ruhsatı süreçleriyle ilişkilendirilmemelidir.",
                ttfBold,
              ),
              _buildBulletPoint(
                "Ticari işletmelerde alınacak yangın güvenlik tedbirleri hususi olarak değerlendirilmelidir.",
                ttfBold,
              ),
              _buildBulletPoint(
                "Bu dokümanda, binanın MİMARİ özellikleri analiz edilmekte olup, ELEKTROMEKANİK yangın güvenliği ihtiyaçlarıyla ilgili yine bu Uygulama'da sunulan 'Aktif Sistem Gereksinimleri' çalışmasını da telefonunuza indirmeniz önerilir.",
                ttfBold,
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            "Bu doküman içerisinde yer alan renk kodları ve anlamları aşağıda açıklanmıştır:",
            style: const pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey700,
              lineSpacing: 2.2,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildLegendItem(PdfColors.red700, "KRİTİK RİSK", ""),
              pw.SizedBox(width: 20),
              _buildLegendItem(PdfColors.yellow700, "UYARI", ""),
              pw.SizedBox(width: 20),
              _buildLegendItem(PdfColors.blue700, "BİLGİ", ""),
              pw.SizedBox(width: 20),
              _buildLegendItem(PdfColors.green700, "OLUMLU", ""),
              pw.SizedBox(width: 20),
              _buildLegendItem(PdfColors.grey500, "BİLİNMİYOR", ""),
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
            final effectiveSectionRiskColor = id <= 10
                ? PdfColors
                      .blue700 // Info sections are blue
                : riskColor;

            // Each section emits its header + items as individual top-level
            // widgets so MultiPage can freely break them across pages.
            // Wrapping everything in a single Container caused TooManyPagesException
            // when a section's notes didn't fit on one page.
            // 1. Determine which sections use table format
            final bool useTable = [3, 5, 6, 7, 10, 12, 21, 36].contains(id);
            final List<pw.Widget> itemsWidgets = [];

            if (!useTable) {
              for (final item in details) {
                itemsWidgets.add(
                  _buildStandardVerticalItem(
                    item,
                    ttf,
                    ttfBold,
                    riskColor: (id <= 10)
                        ? PdfColors.blue700
                        : _getRiskColor(item['report'] ?? ''),
                    isLast: item == details.last,
                    sectionId: id,
                  ),
                );
              }
            } else {
              List<Map<String, dynamic>> tableGroup = [];
              bool isFirstTableFor36 = true;
              for (int i = 0; i < details.length; i++) {
                final item = details[i];
                final isLast = i == details.length - 1;
                final String report = _cleanEmojis(item['report'] ?? '');
                final String advice = _cleanEmojis(item['advice'] ?? '');

                if (report.isEmpty && advice.isEmpty) {
                  tableGroup.add(item);
                } else {
                  if (tableGroup.isNotEmpty) {
                    if (id == 36 && isFirstTableFor36) {
                      itemsWidgets.add(
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Konu:", style: pw.TextStyle(font: ttfBold, fontSize: 9, color: PdfColors.indigo900)),
                            pw.SizedBox(height: 1),
                            pw.Text("Merdiven Uygunluk Değerlendirmesi", style: pw.TextStyle(font: ttf, fontSize: 9)),
                            pw.SizedBox(height: 5),
                            pw.Text("Kullanıcı Yanıtı:", style: pw.TextStyle(font: ttfBold, fontSize: 9, color: PdfColors.indigo900)),
                            pw.SizedBox(height: 3),
                          ],
                        ),
                      );
                      isFirstTableFor36 = false;
                    }
                    itemsWidgets.add(
                      _buildInfoTable(
                        tableGroup,
                        ttf,
                        ttfBold,
                        (id <= 10 || id == 36)
                            ? const PdfColor.fromInt(0x00000000)
                            : effectiveSectionRiskColor,
                        subjectLabel: id == 36 ? "Merdiven Tipleri" : "Konu",
                      ),
                    );
                    itemsWidgets.add(pw.SizedBox(height: 10));
                    tableGroup = [];
                  }
                  itemsWidgets.add(
                    _buildStandardVerticalItem(
                      item,
                      ttf,
                      ttfBold,
                      riskColor: (id <= 10)
                          ? PdfColors.blue700
                          : _getRiskColor(item['report'] ?? ''),
                      isLast: isLast,
                      sectionId: id,
                    ),
                  );
                }
              }
              if (tableGroup.isNotEmpty) {
                if (id == 36 && isFirstTableFor36) {
                  itemsWidgets.add(
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Konu:", style: pw.TextStyle(font: ttfBold, fontSize: 9, color: PdfColors.indigo900)),
                        pw.SizedBox(height: 1),
                        pw.Text("Merdiven Uygunluk Değerlendirmesi", style: pw.TextStyle(font: ttf, fontSize: 9)),
                        pw.SizedBox(height: 5),
                        pw.Text("Kullanıcı Yanıtı:", style: pw.TextStyle(font: ttfBold, fontSize: 9, color: PdfColors.indigo900)),
                        pw.SizedBox(height: 3),
                      ],
                    ),
                  );
                  isFirstTableFor36 = false;
                }
                itemsWidgets.add(
                  _buildInfoTable(
                    tableGroup,
                    ttf,
                    ttfBold,
                    (id <= 10 || id == 36)
                        ? const PdfColor.fromInt(0x00000000)
                        : effectiveSectionRiskColor,
                    subjectLabel: id == 36 ? "Merdiven Tipleri" : "Konu",
                  ),
                );
              }
            }

            // 2. Build Section Widgets with Orphan Prevention
            final List<pw.Widget> finalSectionWidgets = [];

            final headerWidget = pw.Container(
              margin: const pw.EdgeInsets.only(top: 10, bottom: 4),
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
              decoration: pw.BoxDecoration(
                color: const PdfColor.fromInt(
                  0xFF1a365d,
                ), // Corporate Navy Blue
              ),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      "Bölüm $id: ${_toTitleCaseTR(AppDefinitions.getSectionTitle(id))}",
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ],
              ),
            );

            final dividerWidget = pw.Divider(
              thickness: 0.8,
              color: PdfColors.indigo100,
            );

            if (itemsWidgets.isNotEmpty) {
              // Combine Header + Divider + First Item into an unbreakable block
              // to prevent "Orphan Headers" at the bottom of pages.
              // We use pw.Table here because it's unbreakable by default,
              // serving as a reliable alternative to KeepTogether.
              // Wrap in a Container to make the block unbreakable in MultiPage
              finalSectionWidgets.add(
                pw.Container(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [headerWidget, dividerWidget, itemsWidgets.first],
                  ),
                ),
              );
              // Add remaining items
              if (itemsWidgets.length > 1) {
                finalSectionWidgets.addAll(itemsWidgets.sublist(1));
              }
            } else {
              // No items, just add header (unlikely)
              finalSectionWidgets.add(headerWidget);
              finalSectionWidgets.add(dividerWidget);
            }

            finalSectionWidgets.add(pw.SizedBox(height: 8));
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: finalSectionWidgets,
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
    final fontDataItalic = await rootBundle.load(
      "assets/fonts/Roboto-Italic.ttf",
    );
    final fontDataBoldItalic = await rootBundle.load(
      "assets/fonts/Roboto-BoldItalic.ttf",
    );

    final ttf = pw.Font.ttf(fontData);
    final ttfBold = pw.Font.ttf(fontDataBold);
    final ttfItalic = pw.Font.ttf(fontDataItalic);
    final ttfBoldItalic = pw.Font.ttf(fontDataBoldItalic);

    final logoData = await rootBundle.load("assets/images/ui/logo3.webp");
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

    final store = BinaStore.instance;
    final activeSystems = ActiveSystemsEngine.calculateRequirements(store);
    final pageTheme = _buildPageTheme(ttf, ttfBold, ttfItalic, ttfBoldItalic);

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
        maxPages: 2000,

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
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildBulletPoint(
                "Bu çalışma yalnızca 19.12.2007 ve sonrasında yapı ruhsatı onaylanmış KONUT ve KONUT+TİCARET amaçlı yapılar için geçerli olup, KONUT ve konut ile ilgili kullanım alanlarının (otopark, teknik hacimler vb.) ELEKTROMEKANİK yangın güvenliği ihtiyaçlarını belirlemektedir.",
                ttfBold,
              ),
              _buildBulletPoint(
                "Bina içerisinde ticari işletmeler (işyeri) varsa bu çalışma, ticari işletmelere ait işyeri açma ve çalışma ruhsatı süreçleriyle ilişkilendirilmemelidir.",
                ttfBold,
              ),
              _buildBulletPoint(
                "Ticari işletmelerde alınacak yangın güvenlik tedbirleri hususi olarak değerlendirilmelidir.",
                ttfBold,
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            "Yangın güvenliği için kritik öneme sahip, Binaların Yangından Korunması Hakkında Yönetmeliği'ne göre binada olması gereken algılama, söndürme, duman tahliye vb. sistem gereksinimleri aşağıda listelenmiştir.",
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blueGrey700,
              lineSpacing: 2.2,
            ),
          ),
          pw.SizedBox(height: 20),

          ...activeSystems.map((req) {
            // Redundant prefix cleaning is no longer needed
            String cleanReason = _cleanEmojis(req.reason).trim();

            final isMandatory = req.isMandatory;
            final isWarning = req.isWarning;

            // Determine box decoration based on status
            pw.BoxDecoration boxDecoration;
            if (isMandatory) {
              // Critical Risk: Red background
              boxDecoration = pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFFFEBEE), // Soft Red
                border: pw.Border.all(color: PdfColors.red700, width: 0.5),
                borderRadius: pw.BorderRadius.circular(2),
              );
            } else if (isWarning) {
              // Warning: Amber/Yellow background
              boxDecoration = pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFFFF8E1), // Soft Amber
                border: pw.Border.all(color: PdfColors.amber700, width: 0.5),
                borderRadius: pw.BorderRadius.circular(2),
              );
            } else {
              // Neutral (OLUMLU, BİLGİ, etc.)
              boxDecoration = const pw.BoxDecoration(
                color: PdfColors.white,
                border: pw.Border(
                  left: pw.BorderSide(color: PdfColors.grey400, width: 2),
                ),
              );
            }

            return pw.Wrap(
              children: [
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
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
                                lineSpacing: 2.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        cleanReason,
                        style: const pw.TextStyle(
                          fontSize: 9,
                          color: PdfColors.black,
                          lineSpacing: 2.2,
                        ),
                      ),
                      if (req.note.isNotEmpty) ...[
                        pw.SizedBox(height: 2),
                        pw.Text(
                          "NOT: ${_cleanEmojis(req.note)}",
                          style: const pw.TextStyle(
                            fontSize: 9,
                            color: PdfColors.black,
                            lineSpacing: 2.2,
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

  static pw.Widget _buildInfoTable(
    List<Map<String, dynamic>> items,
    pw.Font font,
    pw.Font fontBold,
    PdfColor sectionColor, {
    String subjectLabel = "Konu",
  }) {
    // If transparent, don't wrap in a border Container
    final table = pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.IntrinsicColumnWidth(),
        1: const pw.IntrinsicColumnWidth(),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.indigo50),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                subjectLabel,
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 9,
                  color: PdfColors.indigo900,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                "Yanıt / Durum",
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 9,
                  color: PdfColors.indigo900,
                ),
              ),
            ),
          ],
        ),
        ...items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          final String value = (item['value'] ?? '').toString();
          // "Mevcut" içeren satırları veya isBold flag'i true olanları bold yap
          final bool shouldBold =
              item['isBold'] == true || value.contains('Mevcut');

          return pw.TableRow(
            decoration: i % 2 == 1
                ? const pw.BoxDecoration(color: PdfColors.grey50)
                : const pw.BoxDecoration(color: PdfColors.white),
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text(
                  item['label'] ?? '',
                  style: pw.TextStyle(
                    font: shouldBold ? fontBold : font,
                    fontSize: 8,
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Handle multi-line values where the first line should be bold
                    ...value.split('\n').asMap().entries.map((vEntry) {
                      final vIdx = vEntry.key;
                      final vText = vEntry.value;
                      if (vText.isEmpty) return pw.SizedBox();
                      return pw.Text(
                        _cleanEmojis(vText),
                        style: pw.TextStyle(
                          font: (vIdx == 0 && value.contains('\n'))
                              ? fontBold
                              : (shouldBold ? fontBold : font),
                          fontSize: 8,
                        ),
                      );
                    }),
                    if (item['subtitle'] != null &&
                        item['subtitle'].toString().isNotEmpty)
                      pw.Text(
                        item['subtitle'].toString(),
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 7,
                          fontStyle: pw.FontStyle.italic,
                          color: PdfColors.grey700,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );

    final tableWithAlign = pw.Align(
      alignment: pw.Alignment.centerLeft,
      child: pw.ConstrainedBox(
        constraints: const pw.BoxConstraints(
          maxWidth: 450,
        ), // Don't force full width
        child: table,
      ),
    );

    if (sectionColor.alpha == 0) {
      return tableWithAlign;
    }

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border(left: pw.BorderSide(color: sectionColor, width: 3)),
      ),
      padding: const pw.EdgeInsets.only(left: 8),
      child: tableWithAlign,
    );
  }

  static pw.Widget _buildStandardVerticalItem(
    Map<String, dynamic> item,
    pw.Font font,
    pw.Font fontBold, {
    required PdfColor riskColor,
    bool isLast = false,
    int? sectionId,
  }) {
    final label = item['label'] ?? '';
    final value = item['value'] ?? '';
    final report = _cleanEmojis(item['report'] ?? '');

    final content = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 5.5),
        if (label.isNotEmpty) ...[
          pw.Text(
            "Konu:",
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              fontStyle: pw.FontStyle.italic,
              color: PdfColors.blue900,
            ),
          ),
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 9,
              font: font,
              color: PdfColors.black,
              lineSpacing: 2.2,
            ),
          ),
          pw.SizedBox(height: 2.5),
        ],
        if (value.isNotEmpty &&
            value != 'Seçilmedi' &&
            sectionId != 4 &&
            sectionId != 14) ...[
          pw.Text(
            "Kullanıcı Yanıtı:",
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              fontStyle: pw.FontStyle.italic,
              color: PdfColors.blue900,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 9,
              font: font,
              color: PdfColors.black,
              lineSpacing: 2.2,
            ),
          ),
          if (item['subtitle'] != null && item['subtitle'].isNotEmpty) ...[
            pw.SizedBox(height: 1),
            pw.Text(
              item['subtitle'],
              style: pw.TextStyle(
                fontSize: 8,
                font: font,
                fontStyle: pw.FontStyle.italic,
                color: PdfColors.grey700,
                lineSpacing: 1.5,
              ),
            ),
          ],
          pw.SizedBox(height: 2.5),
        ],
        if (report.isNotEmpty) ...[
          pw.Text(
            "Değerlendirme:",
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              fontStyle: pw.FontStyle.italic,
              color: PdfColors.blue900,
            ),
          ),
          _buildRichText(report, font, fontBold),
        ],
        if (item['advice'] != null && item['advice']!.isNotEmpty) ...[
          pw.SizedBox(height: 2),
          pw.Text(
            "Öneri:",
            style: pw.TextStyle(
              fontSize: 9, // Match Değerlendirme
              fontWeight: pw.FontWeight.bold,
              fontStyle: pw.FontStyle.italic,
              color: PdfColors.blue900,
            ),
          ),
          pw.Text(
            _cleanEmojis(item['advice']!),
            style: pw.TextStyle(
              fontSize: 9,
              font: font,
              color: PdfColors.black,
              fontStyle: pw.FontStyle.italic,
              lineSpacing: 2.2,
            ),
          ),
        ],
        pw.SizedBox(height: 5.5),
        if (!isLast) pw.Divider(thickness: 0.1, color: PdfColors.grey300),
      ],
    );

    if (riskColor.alpha == 0) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(left: 0),
        child: content,
      );
    }

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border(left: pw.BorderSide(color: riskColor, width: 4)),
      ),
      padding: const pw.EdgeInsets.only(left: 8),
      child: content,
    );
  }
}
