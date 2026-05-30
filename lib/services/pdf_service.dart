import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../data/bina_store.dart';
import '../logic/report_engine.dart';
import '../models/report_status.dart';
import '../utils/app_strings.dart';
import '../utils/app_content.dart';
import '../logic/active_systems_engine.dart';
import 'package:flutter/material.dart';
import '../screens/pdf_preview_screen.dart';

class PdfService {
  static ByteData? _fontData;
  static ByteData? _fontDataBold;
  static ByteData? _fontDataItalic;
  static ByteData? _fontDataBoldItalic;
  static ByteData? _logoData;

  static Future<void> _ensureAssetsLoaded() async {
    _fontData ??= await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    _fontDataBold ??= await rootBundle.load("assets/fonts/Roboto-Bold.ttf");
    _fontDataItalic ??= await rootBundle.load("assets/fonts/Roboto-Italic.ttf");
    _fontDataBoldItalic ??= await rootBundle.load("assets/fonts/Roboto-BoldItalic.ttf");
    _logoData ??= await rootBundle.load("assets/images/ui/logo3.webp");
  }

  // Keywords that get bold+red highlighting in PDF output.
  // Defined once here and used by both _buildHighlightedText and _buildRichText.
  static const _highlightKeywords = ["YÜKSEK BİNA", "YÜKSEK OLMAYAN BİNA"];



  static pw.Widget _buildLegendItem(PdfColor color, String label, String desc) {
    final titleRow = pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Container(
          width: 7,
          height: 7,
          color: color,
        ),
        pw.SizedBox(width: 5),
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.black,
          ),
        ),
      ],
    );

    if (desc.isEmpty) {
      return titleRow;
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        titleRow,
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 12),
          child: pw.Text(
            desc,
            style: const pw.TextStyle(
              fontSize: 7,
              color: PdfColors.grey700,
            ),
          ),
        ),
      ],
    );
  }

  static String _cleanEmojis(String? t) {
    if (t == null) return "";

    // 1. Emoji Clean
    String cleaned = t
        .replaceAll(
          RegExp(
            r'[\u{1f300}-\u{1f5ff}\u{1f600}-\u{1f64f}\u{1f680}-\u{1f6ff}\u{1f900}-\u{1f9ff}\u{2600}-\u{26ff}\u{2700}-\u{27bf}\u{fe00}-\u{fe0f}]',
            unicode: true,
          ),
          '',
        )
        .trim();

    // 2. Technical Prefix Clean (PDF Output Only)
    final List<String> prefixesToRemove = [
      "KRİTİK RİSK",
      "UYARI",
      "BİLİNMİYOR",
      "BİLGİ",
      "OLUMLU",
      "UYGUN",
      "ÖNERİ",
    ];

    for (var prefix in prefixesToRemove) {
      cleaned = cleaned.replaceAll(
        RegExp(
          '^(DURUM:\\s*)?$prefix:?\\s*',
          multiLine: true,
          caseSensitive: false,
        ),
        '',
      );
    }

    // Preserve DURUM: ZORUNLU but clean DURUM: OLUMLU etc.
    if (cleaned.startsWith(
      RegExp(r'^DURUM:\s*(?!ZORUNLU|ŞART DEĞİL)', caseSensitive: false),
    )) {
      cleaned = cleaned.replaceFirst(
        RegExp(r'^DURUM:\s*', caseSensitive: false),
        '',
      );
    }

    return cleaned.trim();
  }

  static PdfColor _getRiskColor(String text) {
    final t = text.trim();
    if (t.startsWith('KRİTİK RİSK')) return PdfColors.red700;
    if (t.startsWith('UYARI')) return PdfColors.amber700;
    if (t.startsWith('OLUMLU') || t.startsWith('Olumlu')) {
      return PdfColors.green700;
    }
    if (t.startsWith('BİLGİ')) return PdfColors.blue700;
    if (t.startsWith('BİLİNMİYOR') || t.startsWith('Bilinmiyor')) {
      return PdfColors.grey500;
    }
    if (t.startsWith('DURUM:') || t.startsWith('ZORUNLU')) {
      return PdfColors.red700;
    }
    return PdfColors.grey500;
  }

  static PdfColor _getColorForItem(Map<String, dynamic> item) {
    // 1. ÖNCELİK: Kod Mantığı (Status Nesnesi)
    // Eğer logic handler açıkça bir statü atamışsa, metin içeriğinden bağımsız olarak onu baz al.
    // Bu yöntem en stabil ve hatasız yaklaşımdır.
    if (item['status'] != null && item['status'] is ReportStatus) {
      return _getColorFromStatus(item['status'] as ReportStatus);
    }

    // 2. ÖNCELİK: Metin Öneki (Fallback)
    // Eğer statü nesnesi yoksa, rapor metninin en başındaki anahtar kelimeye bak.
    final String reportText = item['report']?.toString() ?? '';
    if (reportText.trim().isNotEmpty) {
      return _getRiskColor(reportText);
    }

    return PdfColors.grey500;
  }

  static PdfColor _getColorFromStatus(ReportStatus status) {
    if (status == ReportStatus.risk) return PdfColors.red700;
    if (status == ReportStatus.warning) return PdfColors.amber700;
    if (status == ReportStatus.compliant) return PdfColors.green700;
    if (status == ReportStatus.info) return PdfColors.blue700;
    if (status == ReportStatus.unknown) return PdfColors.grey500;
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

    // SVG parser of pdf package has limited support for stroke-dasharray/stroke-dashoffset.
    // Instead, we use three mathematically calculated arc segments (Red, Orange, Green)
    // and draw explicit white divider lines. This renders 100% correctly and beautifully on all PDF viewers.
    String svgContent =
        '''
    <svg width="240" height="130" viewBox="0 0 200 120" xmlns="http://www.w3.org/2000/svg">
      <!-- Kirmizi Segment (Sol: 180 derece -> 120 derece) -->
      <path d="M 20 100 A 80 80 0 0 1 60 30.72" fill="none" stroke="#ef4444" stroke-width="20" />
      
      <!-- Turuncu Segment (Orta: 120 derece -> 60 derece) -->
      <path d="M 60 30.72 A 80 80 0 0 1 140 30.72" fill="none" stroke="#f59e0b" stroke-width="20" />
      
      <!-- Yesil Segment (Sag: 60 derece -> 0 derece) -->
      <path d="M 140 30.72 A 80 80 0 0 1 180 100" fill="none" stroke="#10b981" stroke-width="20" />
      
      <!-- Beyaz Bolucu Cizgiler (Segmentler arasi sik bosluk hissi) -->
      <line x1="65" y1="39.38" x2="55" y2="22.06" stroke="#ffffff" stroke-width="3" />
      <line x1="135" y1="39.38" x2="145" y2="22.06" stroke="#ffffff" stroke-width="3" />
      
      <!-- Gosterge Ignesi -->
      <polygon points="100,96 100,104 175,100" fill="#1e293b" transform="rotate($angle 100 100)" />
      
      <!-- Igne Gobegi -->
      <circle cx="100" cy="100" r="10" fill="#1e293b" />
      <circle cx="100" cy="100" r="4" fill="#ffffff" />
    </svg>
    ''';

    return pw.Container(height: 120, child: pw.SvgImage(svg: svgContent));
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
    const slateGray = PdfColor.fromInt(0xFF334155);

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
                    color: slateGray,
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
                pw.Center(child: _buildGaugeChart(metrics['score'] as int)),
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
                      color: _getScoreColorForPdf(
                        metrics['score'] as int,
                      ).shade(0.1),
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
                        color: slateGray,
                        fontSize: 14,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
              ],

              pw.Spacer(),

              // Alt Bilgi Şeridi - Yönetici Özeti ile Aynı Lacivert Tonu
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
                color: navyBlue,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Raporlanan Bina Etiketi
                    pw.Text(
                      "RAPORLANAN BİNA / YAPI",
                      style: pw.TextStyle(
                        color: PdfColor.fromInt(0xFF93C5FD), // Soft Açık Mavi (#93C5FD)
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    // Bina Adı (14pt Bold)
                    pw.Text(
                      _cleanEmojis(store.currentBinaName).isEmpty
                          ? "Bina Adı Belirtilmemiş"
                          : _cleanEmojis(store.currentBinaName),
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    // İnce Bölücü Çizgi (%20 Şeffaflıkta)
                    pw.Container(
                      height: 1,
                      color: const PdfColor.fromInt(0x33FFFFFF),
                    ),
                    pw.SizedBox(height: 10),
                    // Lokasyon ve Rapor Tarihi Kolonları
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Sol Kolon: Lokasyon
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "BÖLGE / LOKASYON",
                              style: pw.TextStyle(
                                color: PdfColor.fromInt(0xFF93C5FD),
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              "${_cleanEmojis(store.currentBinaDistrict)} / ${_cleanEmojis(store.currentBinaCity)}",
                              style: pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // Sağ Kolon: Rapor Tarihi
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                              "RAPOR TARİHİ",
                              style: pw.TextStyle(
                                color: PdfColor.fromInt(0xFF93C5FD),
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              "${DateTime.now().day.toString().padLeft(2, '0')}.${DateTime.now().month.toString().padLeft(2, '0')}.${DateTime.now().year} - ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}",
                              style: pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
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

  /// Yönetici Özeti için: Teknik önekleri (KRİTİK RİSK, DURUM, ZORUNLU vb.) temizler
  /// ve PDF'in render edemediği emoji karakterlerini kaldırır.
  static String _cleanFullEvaluationText(String text) {
    if (text.isEmpty) return "";

    // 1. Emoji temizliği (PDF çökmemesi için kritik)
    String processed = text.replaceAll(
      RegExp(
        r'[\u{1f300}-\u{1f5ff}\u{1f600}-\u{1f64f}\u{1f680}-\u{1f6ff}'
        r'\u{1f900}-\u{1f9ff}\u{2600}-\u{26ff}\u{2700}-\u{27bf}'
        r'\u{fe00}-\u{fe0f}]',
        unicode: true,
      ),
      '',
    );

    // 2. Teknik öneklerin güvenli temizliği
    processed = ReportEngine.cleanPrefix(processed);

    // 3. Yer tutucuları temizle (Bölüm 16 vb. için güvenlik katmanı)
    processed = processed
        .replaceAll("[LİMİT]", "28.50")
        .replaceAll("[LIMIT]", "28.50");

    // Başta veya sonunda kalan gereksiz karakterleri temizle
    if (processed.startsWith(':')) processed = processed.substring(1).trim();

    return processed;
  }

  static List<pw.Page> _buildExecutiveSummaryPage({
    required pw.PageTheme pageTheme,
    required BinaStore store,
    required Map<String, dynamic> metrics,
    required pw.Font ttf,
    required pw.Font ttfBold,
    required String docNo,
  }) {
    List<String> actionItems = [];

    // Red Bar Logic Matcher: PDF bölümlerinde kırmızı bar çizen mantıkla birebir aynı
    bool isRedBar(String text, ReportStatus? status, int sectionId) {
      if (sectionId <= 10 || sectionId == 14)
        return false; // Bu bölümler PDF'de hep mavidir
      if (status == ReportStatus.risk) return true;
      return _getRiskColor(text) == PdfColors.red700;
    }

    for (int id = 1; id <= 36; id++) {
      // 33 (Kapasite Analizi) eklendi
      if ([3, 5, 6, 7, 10, 12, 21, 33, 36].contains(id)) {
        final fullReport = ReportEngine.getSectionSummaryReport(
          id,
          store: store,
        );
        if (isRedBar(fullReport, null, id)) {
          // Değerlendirme notunun TAMAMINI al
          String act = _cleanFullEvaluationText(fullReport);
          if (act.isNotEmpty && !actionItems.contains(act))
            actionItems.add(act);
        }
      } else {
        final details = ReportEngine.getSectionDetailedReport(id, store: store);
        for (final item in details) {
          final status = item['status'] as ReportStatus? ?? ReportStatus.info;
          final reportText = (item['report'] ?? '').toString();

          if (isRedBar(reportText, status, id)) {
            // Değerlendirme notunun TAMAMINI al
            String actText = _cleanFullEvaluationText(reportText);
            if (actText.isNotEmpty && !actionItems.contains(actText)) {
              actionItems.add(actText);
            }
          }
        }
      }
    }

    if (actionItems.isEmpty) {
      actionItems.add(
        "Binada tespit edilmiş acil aksiyon gerektiren herhangi bir eksiklik veya aykırılık bulunmamaktadır.",
      );
    }

    final score = metrics['score'] as int;
    final riskText = score > 80
        ? "DÜŞÜK RİSK"
        : score > 50
        ? "ORTA RİSK"
        : "YÜKSEK RİSK";
    final riskColor = _getScoreColorForPdf(score);

    return [
      pw.MultiPage(
        pageTheme: pageTheme,
        header: (context) =>
            _buildHeader(context, docNo, ttfBold, "YANGIN RİSK ANALİZİ"),
        footer: (context) => _buildFooter(context, ttf, ttfBold),
        build: (context) => [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF1a365d)),
            child: pw.Text(
              "YÖNETİCİ ÖZETİ VE ACİL EYLEM PLANI",
              style: pw.TextStyle(
                font: ttfBold,
                fontSize: 11,
                color: PdfColors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
          pw.SizedBox(height: 16),
          pw.RichText(
            text: pw.TextSpan(
              style: pw.TextStyle(font: ttf, fontSize: 8.5, lineSpacing: 2.2),
              children: [
                pw.TextSpan(
                  text:
                      "Bu bina, Uygulama tarafından belirlenen yangın güvenlik skorlamasına göre ",
                ),
                pw.TextSpan(
                  text: "[$riskText]",
                  style: pw.TextStyle(font: ttfBold, color: riskColor),
                ),
                pw.TextSpan(
                  text:
                      " kategorisinde olduğu tespit edilmiştir. Aşağıda Binaların Yangından Korunması Hakkında Yönetmelik 'ine göre tespit edilen ve eylem planı çerçevesinde incelenmesi gereken kritik bulgular yer almaktadır:",
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 15),
          // Çok uzun metinlerin (overflow) PDF'i çökertmemesi için pw.Bullet yapısına geçildi
          ...actionItems.map((item) {
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 12),
              child: pw.Bullet(
                text: item,
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 8.5,
                  color: PdfColors.black,
                  lineSpacing: 2.2,
                ),
                bulletColor: PdfColors.red700,
                bulletMargin: const pw.EdgeInsets.only(top: 4, right: 10),
                bulletSize: 3,
              ),
            );
          }),
        ],
      ),
    ];
  }

  // --- KAPSAM VE SIK SORULAN SORULAR SAYFASI ---
  // Risk Analizi ve Aktif Sistem PDF'lerinde ortak kullanılır.
  static pw.Page _buildFaqPage({
    required pw.PageTheme pageTheme,
    required pw.Font ttf,
    required pw.Font ttfBold,
    required String docNo,
    required String headerTitle,
    required List<Map<String, String>> faqs,
  }) {
    const navyBlue = PdfColor.fromInt(0xFF1a365d);
    const lightBlue = PdfColor.fromInt(0xFFe8eef7);

    return pw.Page(
      pageTheme: pageTheme,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Sayfa Başlığı
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: const pw.BoxDecoration(color: navyBlue),
              child: pw.Text(
                "KAPSAM",
                style: pw.TextStyle(
                  font: ttfBold,
                  fontSize: 11,
                  color: PdfColors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            pw.SizedBox(height: 16),
            // SSS Kartları
            ...faqs.map(
              (faq) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 12),
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    left: const pw.BorderSide(color: navyBlue, width: 3),
                  ),
                  color: PdfColors.white,
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Soru
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      color: lightBlue,
                      child: pw.Text(
                        faq['q'] ?? '',
                        style: pw.TextStyle(
                          font: ttfBold,
                          fontSize: 9,
                          color: navyBlue,
                        ),
                      ),
                    ),
                    // Cevap
                    pw.Padding(
                      padding: const pw.EdgeInsets.fromLTRB(10, 6, 10, 8),
                      child: pw.Text(
                        faq['a'] ?? '',
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 8.5,
                          color: PdfColors.grey800,
                          lineSpacing: 2.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static pw.Page _buildLifeSavingInfoPage(
    pw.PageTheme pageTheme,
    pw.Font font,
    pw.Font fontBold,
  ) {
    const navyBlue = PdfColor.fromInt(0xFF1a365d);
    
    final List<Map<String, dynamic>> sections = [
      {
        'title': '1. Önlemler & Hazırlık',
        'color': PdfColor.fromInt(0xFF1B5E20), // Dark Green
        'items': [
          'Duman Dedektörü (Pilli): Kablo tesisatı gerektirmeyen, pille çalışan <b>portatif duman dedektörleri</b> alarak evinizde (özellikle koridor ve yatak odası girişlerine) çift taraflı bantla veya vida ile kolayca tavana monte edin. Piyasadan alacağınız cihazın mutlaka <b>CE işaretli ve TS EN 14604 sertifikalı</b> olmasına dikkat edin.',
          'Yangın Söndürücü: Evinizde <b>TS EN 3 sertifikalı ve CE işaretli</b> küçük bir yangın söndürme tüpü (tercihen 2-6 kg ABC Tozlu veya Köpüklü) bulundurmanız hayat kurtarır. Eğer yoksa, kat koridorunuzdaki <b>büyük yangın tüplerinin ve dolaplarının yerini</b> önceden mutlaka öğrenin ve kullanım talimatlarını okuyun.',
          'Çıkış Kapıları: Binanızdaki <b>elektrikli veya şifreli kapıların</b> elektrik kesildiğinde <b>otomatik açıldığını</b> yönetimden teyit edin.',
          'Kaçış Planı: Ailenizle <b>kaçış planı</b> yapın. Dış kapı anahtarlarını kapı yakınında <b>sabit bir yerde</b> tutun.',
        ],
      },
      {
        'title': '2. Yangın Anında Ne Yapmalı?',
        'color': PdfColor.fromInt(0xFFE65100), // Dark Orange
        'items': [
          'Müdahale veya Çıkış: Yangın çok küçükse (başlangıç aşamasında) tüp/battaniye ile müdahale edin. <b>Ateş büyümüşse eşyaları bırakıp hemen dışarı çıkın!</b>',
          'Eğilin: Dumandan korunmak için <b>emekleyerek veya yere yakın</b> ilerleyin.',
          'Kapıları Kapatın: Çıkarken arkanızdan geçtiğiniz <b>tüm kapıları kapatın</b> (yangının yayılmasını yavaşlatır).',
          'Asansör Yasağı: Sadece yangın merdivenini veya normal merdivenleri kullanın; <b>asansörü KESİNLİKLE KULLANMAYIN.</b>',
          '112\'yi Arayın: Güvenli bir yere ulaştığınızda <b>hemen 112\'yi arayıp</b> itfaiye isteyin.',
        ],
      },
      {
        'title': '3. Evde Mahsur Kalırsanız',
        'color': PdfColor.fromInt(0xFFB71C1C), // Dark Red
        'items': [
          'Odaya Sığının: Pencereli ve dışarıya/caddeye bakan bir odaya geçip <b>kapıyı kapatın</b>.',
          'Dumanı Kesin: Kapı altlarını ve kenarlarını <b>ıslak havlu veya bez</b> ile sıkıca tıkayın.',
          'Yardım İsteyin: Pencereden dikkat çekin, 112\'ye bulunduğunuz odanın <b>tam yerini (kat/oda)</b> bildirin.',
        ],
      },
      {
        'title': '4. Yangın Tipleri & Söndürme Yöntemleri',
        'color': PdfColor.fromInt(0xFF0D47A1), // Dark Blue
        'items': [
          'Katı (Ahşap, Tekstil, Kağıt): <b>Su dökerek soğutun</b> veya yangın tüpü kullanın.',
          'Sıvı (Kolonya, Alkol, Tiner, Benzin): <b>KESİNLİKLE SU DÖKMEYİN</b> (alevleri yayar). Üzerini kum, toprak veya nemli örtüyle kapatarak havayı kesin ya da yangın tüpü kullanın.',
          'Mutfak Yağı (Tava Yangınları): <b>KESİNLİKLE SU DÖKMEYİN!</b> Ateşin üstünü metal kapak, yangın battaniyesi veya <b>sıkıca sıkılmış nemli büyük bir havlu</b> ile tamamen kapatıp ocağı söndürün.',
          'Gaz (Tüp, LPG, Doğalgaz): <b>Gazı kapatmadan alevi SÖNDÜRMEYİN</b> (gaz birikir ve patlar). Önce mutlaka vanayı kapatın, alev kendiliğinden sönecektir.',
          'Elektrik (Priz, Cihaz, Kablo): <b>KESİNLİKLE SU DÖKMEYİN!</b> Önce <b>şalteri indirin</b>, sadece kuru kimyevi toz (KKT) veya CO2 söndürücü kullanın.',
          'E-Bisiklet / E-Scooter: Evde yoksanız veya uyuyorsanız <b>şarj ETMEYİN</b>. Kaçış yolunu (koridor) kapatmayın. Batarya yangınlarına <b>asla suyla veya normal tüple müdahale etmeyin, söndürülemez!</b> Hemen kaçıp 112\'yi arayın.',
        ],
      },
    ];

    return pw.Page(
      pageTheme: pageTheme,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Sayfa Başlığı
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: const pw.BoxDecoration(color: navyBlue),
              child: pw.Text(
                "HAYAT KURTARICI BİLGİLER",
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 11,
                  color: PdfColors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              "Konutlarda yaşayan bireylerin yangın öncesinde, esnasında ve sonrasında kendi güvenliklerini sağlamaları adına hayati önem taşıyan pratik rehber aşağıda özetlenmiştir.",
              style: pw.TextStyle(
                font: font,
                fontSize: 8.5,
                color: PdfColors.grey700,
                lineSpacing: 2.2,
              ),
            ),
            pw.SizedBox(height: 12),
            
            // 2 Sütunlu Grid Layout (Sayfaya mükemmel sığması için)
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Sol Sütun (1 & 2)
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildPdfSectionBox(sections[0], font, fontBold),
                      pw.SizedBox(height: 12),
                      _buildPdfSectionBox(sections[1], font, fontBold),
                    ],
                  ),
                ),
                pw.SizedBox(width: 15),
                // Sağ Sütun (3 & 4)
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildPdfSectionBox(sections[2], font, fontBold),
                      pw.SizedBox(height: 12),
                      _buildPdfSectionBox(sections[3], font, fontBold),
                    ],
                  ),
                ),
              ],
            ),
            pw.Spacer(),
            _buildFooter(context, font, fontBold),
          ],
        );
      },
    );
  }

  static List<pw.InlineSpan> _buildPdfLifeSavingRichSpans(
    String text,
    pw.Font font,
    pw.Font fontBold,
    PdfColor titleColor,
  ) {
    final List<pw.InlineSpan> spans = [];
    final RegExp regExp = RegExp(r'<b>(.*?)</b>', dotAll: true);
    final matches = regExp.allMatches(text);

    if (matches.isEmpty) {
      spans.add(pw.TextSpan(text: text));
      return spans;
    }

    int lastMatchEnd = 0;
    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(pw.TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }
      final String groupVal = match.group(1) ?? '';
      final bool isWarningText = groupVal.contains('SU DÖKMEYİN') || 
                                 groupVal.contains('SÖNDÜRMEYİN') || 
                                 groupVal.contains('şarj etmeyin') ||
                                 groupVal.contains('şarj ETMEYİN') ||
                                 groupVal.contains('KULLANMAYIN') ||
                                 groupVal.contains('müdahale etmeyin');
      
      spans.add(
        pw.TextSpan(
          text: groupVal,
          style: pw.TextStyle(
            font: fontBold,
            color: isWarningText ? PdfColors.red800 : titleColor,
          ),
        ),
      );
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(pw.TextSpan(text: text.substring(lastMatchEnd)));
    }

    return spans;
  }

  static pw.Widget _buildPdfSectionBox(
    Map<String, dynamic> section,
    pw.Font font,
    pw.Font fontBold,
  ) {
    final titleColor = section['color'] as PdfColor;
    final List<String> items = section['items'];

    return pw.Container(
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: PdfColors.grey200, width: 0.5),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Bölüm Başlığı
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey50,
              border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200, width: 0.5)),
            ),
            child: pw.Text(
              section['title'],
              style: pw.TextStyle(
                font: fontBold,
                fontSize: 9,
                color: titleColor,
              ),
            ),
          ),
          // Maddeler
          pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: items.map((item) {
                final parts = item.split(': ');
                final hasPrefix = parts.length > 1;
                final String boldPart = hasPrefix ? parts[0] : '';
                final String normalPart = hasPrefix ? parts.sublist(1).join(': ') : item;

                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 3, right: 6),
                        child: pw.Container(
                          width: 3.5,
                          height: 3.5,
                          decoration: pw.BoxDecoration(
                            color: titleColor,
                            shape: pw.BoxShape.circle,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.RichText(
                          text: pw.TextSpan(
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 8.5,
                              color: PdfColors.grey900,
                              lineSpacing: 2.2,
                            ),
                            children: [
                              if (boldPart.isNotEmpty)
                                pw.TextSpan(
                                  text: "$boldPart: ",
                                  style: pw.TextStyle(font: fontBold),
                                ),
                              ..._buildPdfLifeSavingRichSpans(normalPart, font, fontBold, titleColor),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Page _buildLegalPage(
    pw.PageTheme pageTheme,
    pw.Font font,
    pw.Font fontBold,
  ) {
    return pw.MultiPage(
      pageTheme: pageTheme,
      header: (context) => pw.Container(
        width: double.infinity,
        margin: const pw.EdgeInsets.only(bottom: 16),
        padding: const pw.EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF1a365d)),
        child: pw.Text(
          "EK 1: YASAL DAYANAKLAR VE SORUMLULUK REDDİ BEYANI",
          style: pw.TextStyle(
            font: fontBold,
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
      footer: (context) => _buildFooter(context, font, fontBold),
      build: (context) => [
        pw.Text(
          AppStrings.legalDisclaimerContent,
          style: const pw.TextStyle(
            fontSize: 8,
            color: PdfColors.grey600,
            lineSpacing: 2.2,
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
            lineSpacing: 2.2,
          ),
          textAlign: pw.TextAlign.justify,
        ),
      ],
    );
  }

  static pw.Widget _buildHeader(
    pw.Context context,
    String docNo,
    pw.Font fontBold,
    String title,
  ) {
    const slateMavi = PdfColor.fromInt(0xFF64748B); // Premium Slate 500
    const dividerColor = PdfColor.fromInt(0xFFCBD5E1); // Soft Slate 300

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 15),
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 8,
                  color: slateMavi,
                  letterSpacing: 0.5,
                ),
              ),
              pw.Text(
                "Doküman No: $docNo",
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 8,
                  color: slateMavi,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Divider(color: dividerColor, thickness: 1),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(
    pw.Context context,
    pw.Font font,
    pw.Font fontBold,
  ) {
    const slateMavi = PdfColor.fromInt(0xFF64748B); // Premium Slate 500
    const dividerColor = PdfColor.fromInt(0xFFCBD5E1); // Soft Slate 300

    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 15),
      child: pw.Column(
        children: [
          pw.Divider(color: dividerColor, thickness: 0.5),
          pw.SizedBox(height: 4),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Expanded(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 1.0),
                  child: pw.Text(
                    "Bu doküman, Uygulama tarafından otomatik üretilmiştir. Resmi evrak niteliği taşımamaktadır.Dokümanın sonunda yer alan Yasal Uyarılar bu belgenin ayrılmaz bir parçasıdır.",
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 5,
                      color: PdfColors.grey600,
                    ),
                  ),
                ),
              ),
              pw.Text(
                "Sayfa ${context.pageNumber} / ${context.pagesCount}",
                style: pw.TextStyle(
                  font: font,
                  fontSize: 8,
                  color: slateMavi,
                ),
              ),
            ],
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
  // --- 1. RİSK ANALİZ RAPORU ---
  static Future<Uint8List> generatePdf(BinaStore store) async {
    final pdf = await _buildRiskAnalysisDocument(providedStore: store);
    return pdf.save();
  }

  static Future<void> generateRiskAnalysisPdf(BuildContext context) async {
    final store = BinaStore.instance;
    final pdf = await _buildRiskAnalysisDocument(providedStore: store);

    if (!context.mounted) return;

    final now = DateTime.now();
    final timestamp = "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfPreviewScreen(
          onLayout: (format) async => pdf.save(),
          title: "YANGIN RİSK ANALİZİ",
          fileName:
              "Yangin_Risk_Analizi_${(store.currentBinaName ?? 'Bina').replaceAll(' ', '_')}_$timestamp.pdf",
        ),
      ),
    );
  }

  static Future<pw.Document> _buildRiskAnalysisDocument({
    BinaStore? providedStore,
  }) async {
    await _ensureAssetsLoaded();
    final pdf = pw.Document();

    final ttf = pw.Font.ttf(_fontData!);
    final ttfBold = pw.Font.ttf(_fontDataBold!);
    final ttfItalic = pw.Font.ttf(_fontDataItalic!);
    final ttfBoldItalic = pw.Font.ttf(_fontDataBoldItalic!);

    final logoImage = pw.MemoryImage(_logoData!.buffer.asUint8List());

    final store = providedStore ?? BinaStore.instance;
    final metrics = ReportEngine.calculateRiskMetrics(store: store);

    final pageTheme = _buildPageTheme(ttf, ttfBold, ttfItalic, ttfBoldItalic);

    // Doküman No Oluştur (Risk Analizi)
    final now = DateTime.now();
    final docNo =
        "LS-YRA-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}";

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
      docNo: docNo,
    )) {
      pdf.addPage(page);
    }

    // 3. Kapsam ve Sık Sorulan Sorular
    pdf.addPage(
      _buildFaqPage(
        pageTheme: pageTheme,
        ttf: ttf,
        ttfBold: ttfBold,
        docNo: docNo,
        headerTitle: "YANGIN RİSK ANALİZİ",
        faqs: [
          {
            'q': 'Hangi binalar için uygundur?',
            'a':
                'Bu çalışma, 19.12.2007 tarihinden sonra yapı ruhsatı onaylanmış KONUT amaçlı yapılar için geçerlidir. Binada zemin veya bodrum katta ticari alan (dükkan, ofis vb.) bulunsa dahi, bu uygulama yalnızca binanın konut bölümlerini ve ortak kullanım alanlarını (merdiven, kaçış yolu, otopark, teknik hacimler vb.) kapsar. Ticari alanlar bu çalışmanın kapsamı dışındadır.',
          },
          {
            'q': 'Kapsam nedir?',
            'a':
                'Bu analiz yalnızca binanın mimari yapısını inceler. Algılama, söndürme, duman tahliye vb. sistemler için bu uygulamadaki "Aktif Sistem Gereksinimleri" dokümanını da incelemenizi öneririz.',
          },
          {
            'q': 'Puanlama ve risk seviyeleri ne anlama gelir?',
            'a':
                'Raporlardaki kırmızı, sarı, mavi, yeşil ve gri renkler, o konudaki risk veya gereklilik seviyesini gösterir.',
          },
          {
            'q': '"Konu", "Kullanıcı Yanıtı" ve "Değerlendirme" neyi ifade eder?',
            'a':
                'Konu: İncelenen yangın güvenliği başlığını belirtir. Kullanıcı Yanıtı: Uygulama üzerinde binanız için beyan ettiğiniz mevcut saha durumudur. Değerlendirme: Beyan ettiğiniz duruma ve yönetmelik kriterlerine göre oluşturulan uygunluk kontrolü, risk derecesi veya tavsiyelerdir.',
          },
          {
            'q': 'Dokümanın geçerlilik süresi var mı?',
            'a':
                'Binanızda yapılan tadilat veya değişiklikler sonucunda analizin güncellenmesi önerilir. Doküman, üretildiği tarihteki beyan edilen bilgilere dayanır.',
          },
          {
            'q': 'Bu çalışma hangi mevzuata dayanmaktadır?',
            'a':
                'Bu çalışmadaki tüm kriterler ve değerlendirmelerde, "Binaların Yangından Korunması Hakkında Yönetmelik" hükümleri ile bu yönetmelikte atıfta bulunulan TS EN (Türk Standartları) esas alınmıştır.',
          },
          {
            'q': 'Önemli Uyarı',
            'a':
                'Bu uygulama bir "ön değerlendirme" aracıdır ve binanızdaki tüm riskleri eksiksiz tespit edemez. Kesin ve eksiksiz analiz için binanın, yetkin bir Yangın Güvenlik Uzmanı tarafından proje üzerinde ve yerinde incelenmesi şarttır.',
          },
        ],
      ),
    );

    // 4. Risk Analizi ve Bölümler
    pdf.addPage(
      pw.MultiPage(
        maxPages: 2000,
        pageTheme: pageTheme,
        header: (context) =>
            _buildHeader(context, docNo, ttfBold, "YANGIN RİSK ANALİZİ"),
        footer: (context) => _buildFooter(context, ttf, ttfBold),
        build: (context) => [
          ..._buildRiskAnalysisSectionContent(store: store, ttf: ttf, ttfBold: ttfBold, sectionTitle: "DEĞERLENDİRME NOTLARI"),
          pw.SizedBox(height: 30),
          _buildPromoQRBox(ttf, ttfBold),
        ],
      ),
    );

    // Hayat Kurtarıcı Bilgiler
    pdf.addPage(_buildLifeSavingInfoPage(pageTheme, ttf, ttfBold));

    // Yasal (En Sona Taşındı)
    pdf.addPage(_buildLegalPage(pageTheme, ttf, ttfBold));

    return pdf;
  }

  // ---------------------------------------------------------------------------
  // SHARED HELPER: Risk Analizi bölüm içeriklerini döndürür.
  // Hem _buildRiskAnalysisDocument hem _buildCombinedDocument tarafından
  // kullanılır — böylece herhangi bir stil değişikliği tek noktada yapılır.
  // ---------------------------------------------------------------------------
  static List<pw.Widget> _buildRiskAnalysisSectionContent({
    required BinaStore store,
    required pw.Font ttf,
    required pw.Font ttfBold,
    String sectionTitle = "DEĞERLENDİRME NOTLARI",
  }) {
    final List<pw.Widget> result = [];

    result.add(
      pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF1a365d)),
        child: pw.Text(
          sectionTitle,
          style: pw.TextStyle(
            font: ttfBold,
            fontSize: 11,
            color: PdfColors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
    result.add(pw.SizedBox(height: 8));
    result.add(
      pw.Text(
        "Bu doküman içerisinde (paragrafların hemen solunda yer alan) renk kodları ve anlamları aşağıda açıklanmıştır:",
        style: const pw.TextStyle(
          fontSize: 9,
          color: PdfColors.grey700,
          lineSpacing: 2.2,
        ),
      ),
    );
    result.add(pw.SizedBox(height: 10));
    result.add(
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
    );
    result.add(pw.SizedBox(height: 15));

    // Bölüm widget'larını oluştur
    final List<pw.Widget> sectionWidgets = [];
    for (int index = 0; index < 36; index++) {
      int id = index + 1;
      final res = store.getResultForSection(id);
      if (res == null) continue;

      final details = ReportEngine.getSectionDetailedReport(id, store: store);
      ReportStatus sectionStatus = ReportStatus.info;
      bool hasValidStatus = false;
      for (final item in details) {
        if (item['status'] != null && item['status'] is ReportStatus) {
          final status = item['status'] as ReportStatus;
          if (!hasValidStatus || status.priority > sectionStatus.priority) {
            sectionStatus = status;
            hasValidStatus = true;
          }
        }
      }

      PdfColor riskColor;
      if (hasValidStatus) {
        riskColor = _getColorFromStatus(sectionStatus);
      } else {
        final fullReportForColor = ReportEngine.getSectionFullReport(id, store: store);
        riskColor = _getRiskColor(fullReportForColor);
      }

      final effectiveSectionRiskColor = (id <= 10) ? PdfColors.blue700 : riskColor;
      final bool useTable = [3, 5, 6, 7, 10, 12, 21, 33, 36].contains(id);
      final List<pw.Widget> itemsWidgets = [];

      if (!useTable) {
        for (final item in details) {
          itemsWidgets.add(
            _buildStandardVerticalItem(
              item,
              ttf,
              ttfBold,
              riskColor: (id <= 10 || id == 14)
                  ? PdfColors.blue700
                  : (id == 12 ? effectiveSectionRiskColor : _getColorForItem(item)),
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
          final bool isTableRow =
              (item['isTable'] == true) ||
              (report.isEmpty && advice.isEmpty && item['isTable'] != false);

          if (isTableRow) {
            tableGroup.add(item);
          } else {
            if (tableGroup.isNotEmpty) {
              if (id == 36) {
                if (isFirstTableFor36) {
                  itemsWidgets.add(
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Konu:",
                          style: pw.TextStyle(
                            font: ttfBold,
                            fontSize: 9,
                            fontStyle: pw.FontStyle.italic,
                            color: PdfColors.blue900,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 6),
                          child: pw.Text(
                            "Merdiven Uygunluk Değerlendirmesi",
                            style: pw.TextStyle(font: ttf, fontSize: 9),
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          "Kullanıcı Yanıtı:",
                          style: pw.TextStyle(
                            font: ttfBold,
                            fontSize: 9,
                            fontStyle: pw.FontStyle.italic,
                            color: PdfColors.blue900,
                          ),
                        ),
                        pw.SizedBox(height: 3),
                      ],
                    ),
                  );
                  isFirstTableFor36 = false;
                }

                final zeminUpperGroup = tableGroup.where((item) {
                  final lbl = (item['label'] ?? '').toString();
                  return !lbl.startsWith("Bodrum") && !lbl.startsWith("BODRUM");
                }).toList();

                final bodrumGroup = tableGroup.where((item) {
                  final lbl = (item['label'] ?? '').toString();
                  return lbl.startsWith("Bodrum") || lbl.startsWith("BODRUM");
                }).toList();

                if (zeminUpperGroup.isNotEmpty) {
                  itemsWidgets.add(
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 4, top: 2),
                      child: pw.Text(
                        "Zemin ve Üst Katlar:",
                        style: pw.TextStyle(
                          font: ttfBold,
                          fontSize: 8.5,
                          color: PdfColors.blue800,
                        ),
                      ),
                    ),
                  );
                  itemsWidgets.add(
                    _buildInfoTable(
                      zeminUpperGroup, ttf, ttfBold,
                      const PdfColor.fromInt(0x00000000),
                      subjectLabel: "Merdiven Tipleri",
                    ),
                  );
                  itemsWidgets.add(pw.SizedBox(height: 8));
                }

                if (bodrumGroup.isNotEmpty) {
                  itemsWidgets.add(
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 4, top: 4),
                      child: pw.Text(
                        "Bodrum Katlar:",
                        style: pw.TextStyle(
                          font: ttfBold,
                          fontSize: 8.5,
                          color: PdfColors.blue800,
                        ),
                      ),
                    ),
                  );
                  itemsWidgets.add(
                    _buildInfoTable(
                      bodrumGroup, ttf, ttfBold,
                      const PdfColor.fromInt(0x00000000),
                      subjectLabel: "Merdiven Tipleri",
                    ),
                  );
                  itemsWidgets.add(pw.SizedBox(height: 8));
                }
              } else {
                itemsWidgets.add(
                  _buildInfoTable(
                    tableGroup, ttf, ttfBold,
                    (id <= 10 || id == 12 || id == 33)
                        ? const PdfColor.fromInt(0x00000000)
                        : effectiveSectionRiskColor,
                    subjectLabel: "Konu",
                  ),
                );
                itemsWidgets.add(pw.SizedBox(height: 10));
              }
              tableGroup = [];
            }
            itemsWidgets.add(
              _buildStandardVerticalItem(
                item, ttf, ttfBold,
                riskColor: (id <= 10 || id == 14)
                    ? PdfColors.blue700
                    : (id == 12 ? effectiveSectionRiskColor : _getColorForItem(item)),
                isLast: isLast,
                sectionId: id,
              ),
            );
          }
        }
        if (tableGroup.isNotEmpty) {
          if (id == 36) {
            if (isFirstTableFor36) {
              itemsWidgets.add(
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Konu:",
                      style: pw.TextStyle(
                        font: ttfBold,
                        fontSize: 9,
                        fontStyle: pw.FontStyle.italic,
                        color: PdfColors.blue900,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 6),
                      child: pw.Text(
                        "Merdiven Uygunluk Değerlendirmesi",
                        style: pw.TextStyle(font: ttf, fontSize: 9),
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      "Kullanıcı Yanıtı:",
                      style: pw.TextStyle(
                        font: ttfBold,
                        fontSize: 9,
                        fontStyle: pw.FontStyle.italic,
                        color: PdfColors.blue900,
                      ),
                    ),
                    pw.SizedBox(height: 3),
                  ],
                ),
              );
              isFirstTableFor36 = false;
            }

            final zeminUpperGroup = tableGroup.where((item) {
              final lbl = (item['label'] ?? '').toString();
              return !lbl.startsWith("Bodrum") && !lbl.startsWith("BODRUM");
            }).toList();

            final bodrumGroup = tableGroup.where((item) {
              final lbl = (item['label'] ?? '').toString();
              return lbl.startsWith("Bodrum") || lbl.startsWith("BODRUM");
            }).toList();

            if (zeminUpperGroup.isNotEmpty) {
              itemsWidgets.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4, top: 2),
                  child: pw.Text(
                    "Zemin ve Üst Katlar:",
                    style: pw.TextStyle(
                      font: ttfBold,
                      fontSize: 8.5,
                      color: PdfColors.blue800,
                    ),
                  ),
                ),
              );
              itemsWidgets.add(
                _buildInfoTable(
                  zeminUpperGroup, ttf, ttfBold,
                  const PdfColor.fromInt(0x00000000),
                  subjectLabel: "Merdiven Tipleri",
                ),
              );
              itemsWidgets.add(pw.SizedBox(height: 8));
            }

            if (bodrumGroup.isNotEmpty) {
              itemsWidgets.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4, top: 4),
                  child: pw.Text(
                    "Bodrum Katlar:",
                    style: pw.TextStyle(
                      font: ttfBold,
                      fontSize: 8.5,
                      color: PdfColors.blue800,
                    ),
                  ),
                ),
              );
              itemsWidgets.add(
                _buildInfoTable(
                  bodrumGroup, ttf, ttfBold,
                  const PdfColor.fromInt(0x00000000),
                  subjectLabel: "Merdiven Tipleri",
                ),
              );
              itemsWidgets.add(pw.SizedBox(height: 8));
            }
            itemsWidgets.add(
              pw.Padding(
                padding: const pw.EdgeInsets.only(left: 2, top: 4, bottom: 4),
                child: pw.Text(
                  "(*) Not: Raporlanan merdiven uygunluğu kullanıcının beyan ettiği verilere dayanmaktadır. Yönetmelik Madde 41 kapsamındaki basamak, baş yüksekliği vb. ölçüleri, sahanlık detayları yerinde ölçüm gerektirdiğinden bu dokümandaki notlar ön değerlendirme niteliğindedir.",
                  style: pw.TextStyle(
                    font: ttf,
                    fontSize: 7,
                    fontStyle: pw.FontStyle.italic,
                    color: PdfColors.grey600,
                    lineSpacing: 1.3,
                  ),
                ),
              ),
            );
          } else {
            itemsWidgets.add(
              _buildInfoTable(
                tableGroup, ttf, ttfBold,
                (id <= 10 || id == 33)
                    ? const PdfColor.fromInt(0x00000000)
                    : effectiveSectionRiskColor,
                subjectLabel: "Konu",
              ),
            );
          }
        }
      }

      final headerWidget = pw.Container(
        margin: const pw.EdgeInsets.only(top: 14, bottom: 6),
        padding: const pw.EdgeInsets.only(bottom: 4),
        decoration: const pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(
              color: PdfColor.fromInt(0xFF1a365d), // corporate navy bottom line
              width: 1.5,
            ),
          ),
        ),
        child: pw.Row(
          children: [
            pw.Expanded(
              child: pw.Text(
                "Bölüm $id: ${AppDefinitions.getSectionTitle(id)}",
                style: pw.TextStyle(
                  font: ttfBold,
                  fontSize: 10,
                  color: const PdfColor.fromInt(0xFF1a365d), // corporate dark navy text
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      );

      if (itemsWidgets.isNotEmpty) {
        // Başlık + ilk madde asla ayrılmaz (Inseparable)
        sectionWidgets.add(
          pw.Inseparable(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [headerWidget, itemsWidgets.first],
            ),
          ),
        );
        if (itemsWidgets.length > 1) {
          sectionWidgets.addAll(itemsWidgets.sublist(1));
        }
      } else {
        sectionWidgets.add(
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [headerWidget],
          ),
        );
      }
      sectionWidgets.add(pw.SizedBox(height: 8));
    }

    result.addAll(sectionWidgets);
    return result;
  }

  // ---------------------------------------------------------------------------
  // SHARED HELPER: Aktif sistem kart widget listesini döndürür.
  // Hem _buildActiveSystemsDocument hem _buildCombinedDocument tarafından
  // kullanılır — böylece herhangi bir stil değişikliği tek noktada yapılır.
  // ---------------------------------------------------------------------------
  static List<pw.Widget> _buildActiveSystemsCardContent({
    required List<dynamic> activeSystems,
    required pw.Font ttf,
    required pw.Font ttfBold,
    String sectionTitle = "DEĞERLENDİRME NOTLARI",
  }) {
    final List<pw.Widget> result = [];

    result.add(
      pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF1a365d)),
        child: pw.Text(
          sectionTitle,
          style: pw.TextStyle(
            font: ttfBold,
            fontSize: 11,
            color: PdfColors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
    result.add(pw.SizedBox(height: 8));
    result.add(
      pw.Text(
        "Bu doküman içerisinde (paragrafların hemen solunda yer alan) renk kodları ve anlamları aşağıda açıklanmıştır:",
        style: const pw.TextStyle(
          fontSize: 9,
          color: PdfColors.grey700,
          lineSpacing: 2.2,
        ),
      ),
    );
    result.add(pw.SizedBox(height: 10));
    result.add(
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
    );
    result.add(pw.SizedBox(height: 15));
    result.add(
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "Yangın güvenliği için kritik öneme sahip, Binaların Yangından Korunması Hakkında Yönetmeliği'ne göre binada olması gereken algılama, söndürme, duman tahliye vb. sistem gereksinimleri aşağıda listelenmiştir.",
            style: pw.TextStyle(
              fontSize: 8.5,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blueGrey700,
              lineSpacing: 2.2,
            ),
          ),
        ],
      ),
    );
    result.add(pw.SizedBox(height: 15));

    for (final req in activeSystems) {
      final String cleanReason = _cleanEmojis(req.reason).trim();
      final bool isMandatory = req.isMandatory;
      final bool isWarning = req.isWarning;

      pw.BoxDecoration boxDecoration;
      if (isMandatory) {
        boxDecoration = pw.BoxDecoration(
          color: const PdfColor.fromInt(0xFFFFEBEE),
          border: pw.Border.all(color: PdfColors.red700, width: 0.5),
          borderRadius: pw.BorderRadius.circular(2),
        );
      } else if (isWarning) {
        boxDecoration = pw.BoxDecoration(
          color: const PdfColor.fromInt(0xFFFFF8E1),
          border: pw.Border.all(color: PdfColors.amber700, width: 0.5),
          borderRadius: pw.BorderRadius.circular(2),
        );
      } else {
        boxDecoration = const pw.BoxDecoration(
          color: PdfColors.white,
          border: pw.Border(
            left: pw.BorderSide(color: PdfColors.grey400, width: 2),
          ),
        );
      }

      result.add(
        pw.Inseparable(
          child: pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 10),
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                          fontSize: 9.5,
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
                    fontSize: 8.5,
                    color: PdfColors.black,
                    lineSpacing: 2.2,
                  ),
                ),
                if (req.note.isNotEmpty) ...[
                  pw.SizedBox(height: 2),
                  pw.Text(
                    _cleanEmojis(req.note),
                    style: const pw.TextStyle(
                      fontSize: 8.5,
                      color: PdfColors.black,
                      lineSpacing: 2.2,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    return result;
  }

  // --- 2. AKTİF SİSTEM GEREKSİNİMLERİ DOKÜMANI ---
  static Future<pw.Document> _buildActiveSystemsDocument({
    BinaStore? providedStore,
  }) async {
    await _ensureAssetsLoaded();
    final pdf = pw.Document();

    final ttf = pw.Font.ttf(_fontData!);
    final ttfBold = pw.Font.ttf(_fontDataBold!);
    final ttfItalic = pw.Font.ttf(_fontDataItalic!);
    final ttfBoldItalic = pw.Font.ttf(_fontDataBoldItalic!);

    final logoImage = pw.MemoryImage(_logoData!.buffer.asUint8List());

    final store = providedStore ?? BinaStore.instance;
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
        metrics: const {'score': 0}, // Skor gösterilmeyecek
        showScore: false,
      ),
    );

    // Doküman No Oluştur (Aktif Sistemler)
    final now = DateTime.now();
    final docNo =
        "LS-ASG-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}";

    // 2. Kapsam ve Sık Sorulan Sorular
    pdf.addPage(
      _buildFaqPage(
        pageTheme: pageTheme,
        ttf: ttf,
        ttfBold: ttfBold,
        docNo: docNo,
        headerTitle: "AKTİF SİSTEM GEREKSİNİMLERİ",
        faqs: [
          {
            'q': 'Kapsam nedir?',
            'a':
                'Bu çalışma yalnızca binanın ELEKTROMEKANİK yangın güvenliği ihtiyaçlarını (alarm, söndürme, duman tahliyesi vb.) ele alır. Mimari (yapısal) risk analizi için uygulamadaki "Yangın Risk Analizi" çalışmasının da incelenmesi önerilir.',
          },
          {
            'q': 'Hangi binalar için uygundur?',
            'a':
                'Bu çalışma, 19.12.2007 tarihinden sonra yapı ruhsatı onaylanmış KONUT amaçlı yapılar için geçerlidir. Binada zemin veya bodrum katta ticari alan (dükkan, ofis vb.) bulunsa dahi, bu uygulama yalnızca binanın konut bölümlerini ve ortak kullanım alanlarını (merdiven, kaçış yolu, otopark, teknik hacimler vb.) kapsar. Ticari alanlar bu çalışmanın kapsamı dışındadır.',
          },
          {
            'q': 'Bu çalışma hangi mevzuata dayanmaktadır?',
            'a':
                'Bu çalışmadaki tüm kriterler ve değerlendirmelerde, "Binaların Yangından Korunması Hakkında Yönetmelik" hükümleri ile bu yönetmelikte atıfta bulunulan TS EN (Türk Standartları) esas alınmıştır.',
          },
          {
            'q': 'Binanızda periyodik testler zorunlu mu?',
            'a':
                'Evet. Kurulumu yapılan yangın algılama, söndürme, duman tahliye, acil aydınlatma vb. sistemlerin, "Binaların Yangından Korunması Hakkında Yönetmelik" ve ilgili TS EN standartları çerçevesinde yetkili servis kuruluşları veya yetkin kişiler tarafından YILDA EN AZ BİR KEZ periyodik test ve bakımlarının yapılması yasal zorunluluktur. Yangın tüpleri ve yangın dolapları için 6 ayda bir kontrol önerilebilir. Bu sorumluluk bina yönetimine aittir.',
          },
        ],
      ),
    );

    // 3. Aktif Sistem Listesi
    pdf.addPage(
      pw.MultiPage(
        maxPages: 2000,
        pageTheme: pageTheme,
        header: (context) => _buildHeader(context, docNo, ttfBold, "AKTİF SİSTEM GEREKSİNİMLERİ"),
        footer: (context) => _buildFooter(context, ttf, ttfBold),
        build: (context) => [
          ..._buildActiveSystemsCardContent(
            activeSystems: activeSystems,
            ttf: ttf,
            ttfBold: ttfBold,
            sectionTitle: "DEĞERLENDİRME NOTLARI",
          ),
          pw.SizedBox(height: 30),
          _buildPromoQRBox(ttf, ttfBold),
        ],
      ),
    );

    // Yasal (En Sona Taşındı)
    pdf.addPage(_buildLegalPage(pageTheme, ttf, ttfBold));

    return pdf;
  }

  static Future<void> generateActiveSystemsPdf(BuildContext context) async {
    final store = BinaStore.instance;
    final pdf = await _buildActiveSystemsDocument(providedStore: store);

    if (!context.mounted) return;

    final now = DateTime.now();
    final timestamp = "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfPreviewScreen(
          onLayout: (format) async => pdf.save(),
          title: "AKTİF SİSTEM GEREKSİNİMLERİ",
          fileName:
              "Aktif_Sistem_Gereksinimleri_${(store.currentBinaName ?? 'Bina').replaceAll(' ', '_')}_$timestamp.pdf",
        ),
      ),
    );
  }

  // --- 3. BİRLEŞİK RAPOR (TEK PDF) ---
  static Future<pw.Document> _buildCombinedDocument({
    BinaStore? providedStore,
  }) async {
    await _ensureAssetsLoaded();
    final pdf = pw.Document();

    final ttf = pw.Font.ttf(_fontData!);
    final ttfBold = pw.Font.ttf(_fontDataBold!);
    final ttfItalic = pw.Font.ttf(_fontDataItalic!);
    final ttfBoldItalic = pw.Font.ttf(_fontDataBoldItalic!);

    final logoImage = pw.MemoryImage(_logoData!.buffer.asUint8List());

    final store = providedStore ?? BinaStore.instance;
    final metrics = ReportEngine.calculateRiskMetrics(store: store);
    final activeSystems = ActiveSystemsEngine.calculateRequirements(store);
    final pageTheme = _buildPageTheme(ttf, ttfBold, ttfItalic, ttfBoldItalic);

    // Doküman No Oluştur (Birleşik Doküman)
    final now = DateTime.now();
    final docNo =
        "LS-BYD-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}";

    // 1. Ortak Kapak
    pdf.addPage(
      _buildCoverPage(
        pageTheme: pageTheme,
        logoImage: logoImage,
        mainTitle: "YANGIN RİSK ANALİZİ VE AKTİF SİSTEM GEREKSİNİMLERİ",
        subTitle: "",
        store: store,
        metrics: metrics,
        showScore: true,
      ),
    );

    // 2. Yönetici Özeti
    for (var page in _buildExecutiveSummaryPage(
      pageTheme: pageTheme,
      store: store,
      metrics: metrics,
      ttf: ttf,
      ttfBold: ttfBold,
      docNo: docNo,
    )) {
      pdf.addPage(page);
    }

    // 3. Ortak Kapsam ve Sık Sorulan Sorular (Unified FAQ)
    pdf.addPage(
      _buildFaqPage(
        pageTheme: pageTheme,
        ttf: ttf,
        ttfBold: ttfBold,
        docNo: docNo,
        headerTitle: "YANGIN RİSK ANALİZİ VE AKTİF SİSTEM GEREKSİNİMLERİ",
        faqs: [
          {
            'q': 'Hangi binalar için uygundur?',
            'a':
                'Bu çalışma, 19.12.2007 tarihinden sonra yapı ruhsatı onaylanmış KONUT amaçlı yapılar için geçerlidir. Binada zemin veya bodrum katta ticari alan (dükkan, ofis vb.) bulunsa dahi, bu uygulama yalnızca binanın konut bölümlerini ve ortak kullanım alanlarını (merdiven, kaçış yolu, otopark, teknik hacimler vb.) kapsar. Ticari alanlar bu dokümanın kapsamı dışındadır.',
          },
          {
            'q': 'Dokümanın kapsamı nedir?',
            'a':
                'Bu çalışma, binanın hem mimari yapısal risk analizi değerlendirmelerini hem de yangın algılama, söndürme, duman tahliye, acil aydınlatma gibi elektromekanik yangın güvenliği sistem gereksinimlerini kapsamaktadır.',
          },
          {
            'q': 'Puanlama ve renk kodları ne anlama gelir?',
            'a':
                'Doküman içerisindeki kırmızı, sarı, mavi, yeşil ve gri renkler, o konudaki risk veya gereklilik/uygunluk seviyesini göstermektedir.',
          },
          {
            'q': 'Bu çalışma hangi mevzuata dayanmaktadır?',
            'a':
                'Bu çalışmadaki tüm kriterler ve değerlendirmelerde, "Binaların Yangından Korunması Hakkında Yönetmelik" hükümleri ile bu yönetmelikte atıfta bulunulan TS EN (Türk Standartları) esas alınmıştır.',
          },
          {
            'q': 'Binanızda periyodik testler zorunlu mu?',
            'a':
                'Evet. Kurulumu yapılan yangın algılama, söndürme, duman tahliye, acil aydınlatma vb. sistemlerin, yönetmelik ve ilgili TS EN standartları çerçevesinde yetkili servis kuruluşlarınca yılda en az bir kez periyodik test ve bakımlarının yapılması yasal zorunluluktur. Bu sorumluluk bina yönetimine aittir.',
          },
          {
            'q': 'Önemli Uyarı',
            'a':
                'Bu uygulama bir "ön değerlendirme" aracıdır ve binanızdaki tüm riskleri eksiksiz tespit edemez. Kesin ve eksiksiz analiz için binanın, yetkin bir Yangın Güvenlik Uzmanı tarafından proje üzerinde ve yerinde incelenmesi şarttır.',
          },
        ],
      ),
    );

    // 4. Kısım I: Yangın Risk Analizi
    pdf.addPage(
      pw.MultiPage(
        maxPages: 2000,
        pageTheme: pageTheme,
        header: (context) => _buildHeader(
          context, docNo, ttfBold,
          "KISIM I: YANGIN RİSK ANALİZ DOKÜMANI",
        ),
        footer: (context) => _buildFooter(context, ttf, ttfBold),
        build: (context) => [
          ..._buildRiskAnalysisSectionContent(
            store: store,
            ttf: ttf,
            ttfBold: ttfBold,
            sectionTitle: "KISIM I: YANGIN RİSK ANALİZ DEĞERLENDİRMESİ",
          ),
          pw.SizedBox(height: 30),
          _buildPromoQRBox(ttf, ttfBold),
        ],
      ),
    );

    // 5. Kısım II: Aktif Sistem Gereksinimleri
    pdf.addPage(
      pw.MultiPage(
        maxPages: 2000,
        pageTheme: pageTheme,
        header: (context) => _buildHeader(
          context, docNo, ttfBold,
          "KISIM II: AKTİF SİSTEM GEREKSİNİMLERİ DOKÜMANI",
        ),
        footer: (context) => _buildFooter(context, ttf, ttfBold),
        build: (context) => [
          ..._buildActiveSystemsCardContent(
            activeSystems: activeSystems,
            ttf: ttf,
            ttfBold: ttfBold,
            sectionTitle: "KISIM II: AKTİF SİSTEM GEREKSİNİMLERİ",
          ),
          pw.SizedBox(height: 30),
          _buildPromoQRBox(ttf, ttfBold),
        ],
      ),
    );

    // 6. Hayat Kurtarıcı Bilgiler
    pdf.addPage(_buildLifeSavingInfoPage(pageTheme, ttf, ttfBold));

    // 7. Yasal (En Sona Taşındı - Tek Sefer)
    pdf.addPage(_buildLegalPage(pageTheme, ttf, ttfBold));

    return pdf;
  }

  static Future<void> generateCombinedPdf(BuildContext context) async {
    final store = BinaStore.instance;
    final pdf = await _buildCombinedDocument(providedStore: store);

    if (!context.mounted) return;

    final now = DateTime.now();
    final timestamp = "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfPreviewScreen(
          onLayout: (format) async => pdf.save(),
          title: "YANGIN RİSK ANALİZİ VE AKTİF SİSTEM GEREKSİNİMLERİ",
          fileName:
              "Birlesik_Rapor_${(store.currentBinaName ?? 'Bina').replaceAll(' ', '_')}_$timestamp.pdf",
        ),
      ),
    );
  }

  static pw.Widget _buildInfoTable(
    List<Map<String, dynamic>> items,
    pw.Font font,
    pw.Font fontBold,
    PdfColor sectionColor, {
    String subjectLabel = "Konu",
  }) {
    final footnoteItems = items
        .where((item) => (item['label'] ?? '').toString().startsWith('(*)'))
        .toList();
    final tableItems = items
        .where((item) => !(item['label'] ?? '').toString().startsWith('(*)'))
        .toList();

    // --- AKILLI DİNAMİK GENİŞLİK HESABI (Multi-line ve Taşma Korumalı) ---
    int maxCols = 2;
    for (var item in tableItems) {
      final value = (item['value'] ?? '').toString();
      if (value.contains('|')) {
        int partsCount = value.split('|').length + 1;
        if (partsCount > maxCols) maxCols = partsCount;
      }
    }

    final double maxPageWidth = 480.0;
    List<double> calculatedWidths = List.filled(maxCols, 0.0);
    final dummyDoc = pw.Document();
    final pFont = font.getFont(pw.Context(document: dummyDoc.document));
    final pFontBold = fontBold.getFont(pw.Context(document: dummyDoc.document));

    // Yardımcı Ölçüm Fonksiyonu
    double measure(String text, bool isBold, double size) {
      if (text.isEmpty) return 0;
      final f = isBold ? pFontBold : pFont;
      double maxLineW = 0;
      // Çok satırlı metinlerde her satırı ölç ve en genişini al
      for (var line in text.split('\n')) {
        final w = f.stringSize(line).x * size;
        if (w > maxLineW) maxLineW = w;
      }
      return maxLineW;
    }

    // 1. Başlıkları Ölç
    if (maxCols == 2) {
      calculatedWidths[0] = measure(subjectLabel, true, 9) + 15;
      calculatedWidths[1] = measure("Yanıt / Durum", true, 9) + 15;
    } else if (maxCols == 3) {
      calculatedWidths[0] = measure("Kat/Konum", true, 9) + 15;
      calculatedWidths[1] = measure("Kullanım Amacı", true, 9) + 15;
      calculatedWidths[2] = measure("Değerlendirme / Durum", true, 9) + 15;
    }

    // 2. İçerik Satırlarını Ölç
    for (var item in tableItems) {
      final label = (item['label'] ?? '').toString();
      final valueRaw = (item['value'] ?? '').toString();
      final List<String> parts = valueRaw.split('|');
      final bool isSubHeader = label == "KAT TİPİ";
      final bool isBold = item['isBold'] == true || isSubHeader;

      double lW = measure(label, isBold, 8.5) + 15;
      if (lW > calculatedWidths[0]) calculatedWidths[0] = lW;

      for (int i = 0; i < parts.length; i++) {
        if (i + 1 >= maxCols) break;
        double pW = measure(parts[i], isBold, 8.5) + 15;
        // Çok sütunlu tablolarda veri hücrelerinin tek satır genişlik ölçümünü sınırlayarak
        // çok uzun açıklamaların tablo ölçeğini bozmasını engelliyoruz.
        if (maxCols >= 3 && pW > 180.0) {
          pW = 180.0;
        }
        if (pW > calculatedWidths[i + 1]) calculatedWidths[i + 1] = pW;
      }
    }

    // 3. Güvenlik ve Hizalama Kontrolleri
    // Etiket sütununu (Col 0) çok genişlememesi için sınırla (%45)
    if (calculatedWidths[0] > maxPageWidth * 0.45)
      calculatedWidths[0] = maxPageWidth * 0.45;

    double currentTotal = calculatedWidths.reduce((a, b) => a + b);
    if (currentTotal > maxPageWidth) {
      // Sayfa sınırını aşıyorsa, ilk sütunu sıkışmaması için koruyup
      // daraltmayı diğer sütunlara orantılı olarak dağıtıyoruz.
      double col0Width = calculatedWidths[0];
      double remainingWidth = maxPageWidth - col0Width;
      double remainingTotal = 0;
      for (int i = 1; i < maxCols; i++) {
        remainingTotal += calculatedWidths[i];
      }
      if (remainingTotal > 0 && remainingWidth > 0) {
        double scale = remainingWidth / remainingTotal;
        for (int i = 1; i < maxCols; i++) {
          calculatedWidths[i] *= scale;
        }
      }
    } else if (currentTotal < maxPageWidth) {
      // Sayfadan darsa, son sütunu genişleterek sayfayı doldur
      calculatedWidths[maxCols - 1] += (maxPageWidth - currentTotal);
    }

    final Map<int, pw.TableColumnWidth> columnWidths = {
      for (int i = 0; i < maxCols; i++)
        i: pw.FixedColumnWidth(calculatedWidths[i]),
    };

    final List<pw.Widget> rows = [];

    // 1. Header Row
    if (maxCols == 2) {
      rows.add(
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          columnWidths: columnWidths,
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
          ],
        ),
      );
    } else if (maxCols == 3) {
      rows.add(
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          columnWidths: columnWidths,
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.indigo50),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text(
                    "Kat/Konum",
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
                    "Kullanım Amacı",
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
                    "Değerlendirme / Durum",
                    style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 9,
                      color: PdfColors.indigo900,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (maxCols == 4) {
      // Bölüm 33 için en üstteki 'Bölge | Birim Yük...' satırı gereksiz bulunduğu için kaldırıldı.
      // Tablo doğrudan 'KAT TİPİ' satırı ile başlayacak.
    }

    // 2. Data Rows (Each as a separate table for splitting)
    for (int i = 0; i < tableItems.length; i++) {
      final item = tableItems[i];
      final String label = (item['label'] ?? '').toString();
      final String valueRaw = (item['value'] ?? '').toString();
      final List<String> parts = valueRaw.split('|');
      final bool isSubHeader = label == "KAT TİPİ";

      bool capacityFail = false;
      if (maxCols == 4 && !isSubHeader && parts.length >= 3) {
        try {
          final int req = int.tryParse(parts[1].split(' ')[0]) ?? 0;
          final int current = int.tryParse(parts[2].split(' ')[0]) ?? 0;
          if (req > current) capacityFail = true;
        } catch (_) {}
      }

      final bool highlightRow = label.contains(
        "Doğrudan Dışarı Açılan Merdiven",
      );
      final bool shouldBold =
          item['isBold'] == true ||
          valueRaw.contains('Mevcut') ||
          capacityFail ||
          highlightRow;

      rows.add(
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          columnWidths: columnWidths,
          children: [
            pw.TableRow(
              decoration: isSubHeader
                  ? const pw.BoxDecoration(color: PdfColors.indigo50)
                  : (highlightRow
                        ? const pw.BoxDecoration(color: PdfColors.orange50)
                        : (i % 2 == 1
                              ? const pw.BoxDecoration(color: PdfColors.grey50)
                              : const pw.BoxDecoration(
                                  color: PdfColors.white,
                                ))),
              children: [
                // Column 1: Label
                pw.Padding(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text(
                    label,
                    style: pw.TextStyle(
                      font: (isSubHeader || shouldBold) ? fontBold : font,
                      fontSize: 8.5,
                      color: isSubHeader
                          ? PdfColors.indigo900
                          : PdfColors.black,
                    ),
                  ),
                ),
                // Data Columns
                if (maxCols == 2)
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        ...valueRaw.split('\n').asMap().entries.map((vEntry) {
                          final vIdx = vEntry.key;
                          final vText = vEntry.value;
                          if (vText.isEmpty) return pw.SizedBox();
                          return pw.Text(
                            _cleanEmojis(vText),
                            style: pw.TextStyle(
                              font: (vIdx == 0 && valueRaw.contains('\n'))
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
                  )
                else ...[
                  for (var p in parts)
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: isSubHeader && p.contains('\n')
                          ? pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: p.split('\n').asMap().entries.map((e) {
                                final isFirstLine = e.key == 0;
                                return pw.Text(
                                  _cleanEmojis(e.value),
                                  style: pw.TextStyle(
                                    font: isFirstLine ? fontBold : font,
                                    fontSize: isFirstLine ? 8.5 : 7.5,
                                    fontStyle: isFirstLine
                                        ? pw.FontStyle.normal
                                        : pw.FontStyle.italic,
                                    color: PdfColors.indigo900,
                                  ),
                                );
                              }).toList(),
                            )
                          : pw.Text(
                              _cleanEmojis(p),
                              style: pw.TextStyle(
                                font: (isSubHeader || shouldBold)
                                    ? fontBold
                                    : font,
                                fontSize: 8.5,
                                color: isSubHeader
                                    ? PdfColors.indigo900
                                    : PdfColors.black,
                              ),
                            ),
                    ),
                  for (
                    int fill = 0;
                    fill < (maxCols - 1 - parts.length);
                    fill++
                  )
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.SizedBox(),
                    ),
                ],
              ],
            ),
          ],
        ),
      );
    }

    // 3. Footnotes
    if (footnoteItems.isNotEmpty) {
      rows.add(pw.SizedBox(height: 3));
      for (var note in footnoteItems) {
        rows.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 2, top: 1),
            child: pw.Text(
              (note['label'] ?? '').toString(),
              style: pw.TextStyle(
                font: font,
                fontSize: 7,
                fontStyle: pw.FontStyle.italic,
                color: PdfColors.grey600,
              ),
            ),
          ),
        );
      }
    }

    // Wrap in Container for the side border if sectionColor is provided
    if (sectionColor.alpha == 0) {
      return pw.Inseparable(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: rows,
        ),
      );
    }

    final decoratedRows = rows
        .map(
          (r) => pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border(
                left: pw.BorderSide(color: sectionColor, width: 3),
              ),
            ),
            padding: const pw.EdgeInsets.only(left: 8),
            child: r,
          ),
        )
        .toList();

    return pw.Inseparable(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: decoratedRows,
      ),
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
    // Rengi tetikleyen ancak görsel kirlilik yaratan önekleri (BİLGİ, DURUM vb.) temizle
    final report = ReportEngine.cleanPrefix(_cleanEmojis(item['report'] ?? ''));

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
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 6),
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 9,
                font: font,
                color: PdfColors.black,
                lineSpacing: 2.2,
              ),
            ),
          ),
          pw.SizedBox(height: 5.0),
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
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 6),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  value,
                  style: pw.TextStyle(
                    fontSize: 9,
                    font: font,
                    color: PdfColors.black,
                    lineSpacing: 2.2,
                  ),
                ),
                if (item['subtitle'] != null &&
                    item['subtitle'].isNotEmpty) ...[
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
              ],
            ),
          ),
          pw.SizedBox(height: 5.0),
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
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 6),
            child: _buildRichText(report, font, fontBold),
          ),
          pw.SizedBox(height: 5.0),
        ],
        if (item['advice'] != null && item['advice']!.isNotEmpty) ...[
          pw.Text(
            "Öneri:",
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              fontStyle: pw.FontStyle.italic,
              color: PdfColors.blue900,
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 6),
            child: pw.Text(
              _cleanEmojis(item['advice']!),
              style: pw.TextStyle(
                fontSize: 9,
                font: font,
                color: PdfColors.black,
                fontStyle: pw.FontStyle.italic,
                lineSpacing: 2.2,
              ),
            ),
          ),
          pw.SizedBox(height: 5.0),
        ],
        pw.SizedBox(height: 3.5),

        if (!isLast) pw.Divider(thickness: 0.1, color: PdfColors.grey300),
      ],
    );

    final result = riskColor.alpha == 0
        ? pw.Padding(
            padding: const pw.EdgeInsets.only(left: 0),
            child: content,
          )
        : pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border(left: pw.BorderSide(color: riskColor, width: 4)),
            ),
            padding: const pw.EdgeInsets.only(left: 8),
            child: content,
          );

    return pw.Inseparable(child: result);
  }

  static pw.Widget _buildPromoQRBox(pw.Font font, pw.Font fontBold) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFf8fafc), // Çok açık gri/mavi arka plan
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: PdfColors.blueGrey100, width: 1),
      ),
      padding: const pw.EdgeInsets.all(15),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          // Sol Taraf: QR Kod
          pw.Container(
            width: 90,
            height: 90,
            padding: const pw.EdgeInsets.all(5),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(),
              data: AppStrings.qrDownloadUrl,
              drawText: false,
              color: const PdfColor.fromInt(0xFF1a365d), // Kurumsal lacivert
            ),
          ),
          pw.SizedBox(width: 20),
          // Sağ Taraf: Tanıtım Metni
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  "Bu Uygulama, uluslararası yetkinlik sertifikalarına sahip ve alanında tecrübeli Yangın Güvenlik Uzmanları tarafından hazırlanmıştır.",
                  style: pw.TextStyle(
                    font: fontBold,
                    fontSize: 10,
                    color: const PdfColor.fromInt(0xFF1a365d),
                    lineSpacing: 1.2,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  "Binanız için yeni bir yangın risk analizi yapmak veya profesyonel destek almak için aşağıdaki karekodu okutarak uygulamayı indirebilirsiniz.",
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 9,
                    color: PdfColors.blueGrey700,
                    lineSpacing: 1.6,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  "Google Play'den indirin.",
                  style: pw.TextStyle(
                    font: fontBold,
                    fontSize: 8,
                    color: PdfColors.blueGrey400,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> shareRiskAnalysisPdf(BuildContext context) async {
    final store = BinaStore.instance;
    final pdf = await _buildRiskAnalysisDocument(providedStore: store);
    final timestamp = _generateTimestamp();
    final fileName = "Yangin_Risk_Analizi_${(store.currentBinaName ?? 'Bina').replaceAll(' ', '_')}_$timestamp.pdf";
    final bytes = await pdf.save();
    await Printing.sharePdf(bytes: bytes, filename: fileName);
  }

  static Future<void> shareActiveSystemsPdf(BuildContext context) async {
    final store = BinaStore.instance;
    final pdf = await _buildActiveSystemsDocument(providedStore: store);
    final timestamp = _generateTimestamp();
    final fileName = "Aktif_Sistem_Gereksinimleri_${(store.currentBinaName ?? 'Bina').replaceAll(' ', '_')}_$timestamp.pdf";
    final bytes = await pdf.save();
    await Printing.sharePdf(bytes: bytes, filename: fileName);
  }

  static Future<void> shareCombinedPdf(BuildContext context) async {
    final store = BinaStore.instance;
    final pdf = await _buildCombinedDocument(providedStore: store);
    final timestamp = _generateTimestamp();
    final fileName = "Birlesik_Rapor_${(store.currentBinaName ?? 'Bina').replaceAll(' ', '_')}_$timestamp.pdf";
    final bytes = await pdf.save();
    await Printing.sharePdf(bytes: bytes, filename: fileName);
  }

  static String _generateTimestamp() {
    final now = DateTime.now();
    return "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";
  }

  static Future<String> saveRiskAnalysisPdfToDevice(BuildContext context) async {
    final store = BinaStore.instance;
    final pdf = await _buildRiskAnalysisDocument(providedStore: store);
    final timestamp = _generateTimestamp();
    final fileName = "Yangin_Risk_Analizi_${(store.currentBinaName ?? 'Bina').replaceAll(' ', '_')}_$timestamp.pdf";
    final bytes = await pdf.save();
    return _saveBytesToDevice(bytes, fileName);
  }

  static Future<String> saveActiveSystemsPdfToDevice(BuildContext context) async {
    final store = BinaStore.instance;
    final pdf = await _buildActiveSystemsDocument(providedStore: store);
    final timestamp = _generateTimestamp();
    final fileName = "Aktif_Sistem_Gereksinimleri_${(store.currentBinaName ?? 'Bina').replaceAll(' ', '_')}_$timestamp.pdf";
    final bytes = await pdf.save();
    return _saveBytesToDevice(bytes, fileName);
  }

  static Future<String> saveCombinedPdfToDevice(BuildContext context) async {
    final store = BinaStore.instance;
    final pdf = await _buildCombinedDocument(providedStore: store);
    final timestamp = _generateTimestamp();
    final fileName = "Birlesik_Rapor_${(store.currentBinaName ?? 'Bina').replaceAll(' ', '_')}_$timestamp.pdf";
    final bytes = await pdf.save();
    return _saveBytesToDevice(bytes, fileName);
  }

  static Future<String> _saveBytesToDevice(List<int> bytes, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }
}
