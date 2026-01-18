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
  static String _cleanEmojis(String t) {
    return t.replaceAll(RegExp(r'[🚨☢️⚠️✅❓ℹ️]'), '').trim();
  }

  static PdfColor _getRiskColor(String text) {
    final upper = text.toUpperCase();
    
    // KRİTİK RİSK → Kırmızı
    if (upper.contains("KRİTİK RİSK") || upper.contains("RİSK") || upper.contains("TEHLİKE") || upper.contains("ACİL"))
      return const PdfColor.fromInt(0xFFE53935); // Kırmızı
    
    // UYARI → Sarı
    if (upper.contains("UYARI") || upper.contains("DİKKAT"))
      return const PdfColor.fromInt(0xFFFFC107); // Sarı
    
    // BİLMİYORUM → Gri
    if (upper.contains("BİLMİYORUM") || upper.contains("BELİRSİZ") || upper.contains("BİLİNMİYOR"))
      return const PdfColor.fromInt(0xFF9E9E9E); // Gri
    
    // BİLGİ → Mavi
    if (upper.contains("BİLGİ"))
      return const PdfColor.fromInt(0xFF1E88E5); // Mavi
    
    // OLUMLU → Yeşil (Varsayılan)
    return const PdfColor.fromInt(0xFF43A047); // Yeşil
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
              child: pw.Text(
                "RESMİ EVRAK DEĞİLDİR",
                style: pw.TextStyle(
                  fontSize: 40,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Load logo
    final logoData = await rootBundle.load("assets/images/ui/logo.jpg");
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

    // 1. PREMIUM KAPAK SAYFASI
    pdf.addPage(
      pw.Page(
        pageTheme: pageTheme,
        build: (context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              gradient: pw.LinearGradient(
                colors: [PdfColors.blue900, PdfColors.blue800],
                begin: pw.Alignment.topCenter,
                end: pw.Alignment.bottomCenter,
              ),
            ),
            child: pw.Stack(
              children: [
                // Arkaplan Deseni (Opak)
                pw.Positioned(
                  bottom: -100,
                  right: -100,
                  child: pw.Opacity(
                    opacity: 0.1,
                    child: pw.Transform.rotate(
                      angle: -0.5,
                      child: pw.Icon(
                        const pw.IconData(0xe32a), // Shield icon code if available or just circle
                        size: 600,
                        color: PdfColors.white,
                      ),
                    ),
                  ),
                ),
                
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    // ÜST HEADER (Logo ve Tarih)
                    pw.Container(
                      padding: const pw.EdgeInsets.all(30),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            height: 60,
                            width: 150,
                             decoration: pw.BoxDecoration(
                                color: PdfColors.white,
                                borderRadius: pw.BorderRadius.circular(8),
                             ),
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Image(logoImage, fit: pw.BoxFit.contain),
                          ),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Text(
                                "RAPOR TARİHİ",
                                style: pw.TextStyle(
                                  color: PdfColors.blue100,
                                  fontSize: 8,
                                  letterSpacing: 1,
                                ),
                              ),
                              pw.SizedBox(height: 4),
                              pw.Text(
                                "${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}",
                                style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    pw.Spacer(),

                    // ORTA ALAN (Başlık ve Skor)
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "YANGIN GÜVENLİĞİ",
                            style: pw.TextStyle(
                              color: PdfColors.blue100,
                              fontSize: 14,
                              letterSpacing: 5,
                            ),
                          ),
                          pw.SizedBox(height: 10),
                          pw.Text(
                            "RİSK ANALİZİ\n& DENETİM RAPORU",
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 34,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 40),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                            decoration: pw.BoxDecoration(
                              color: const PdfColor.fromInt(0x1Affffff), // 10% white
                              borderRadius: pw.BorderRadius.circular(16),
                              border: pw.Border.all(color: PdfColors.white, width: 2),
                            ),
                            child: pw.Row(
                              mainAxisSize: pw.MainAxisSize.min,
                              children: [
                                pw.Text(
                                  "${metrics['score']}",
                                  style: pw.TextStyle(
                                    color: _getScoreColorForPdf(metrics['score'] as int),
                                    fontSize: 48,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.SizedBox(width: 15),
                                pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      "GÜVENLİK",
                                      style: const pw.TextStyle(
                                        color: PdfColors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                    pw.Text(
                                      "PUANI",
                                      style: const pw.TextStyle(
                                        color: PdfColors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                pw.Container(
                                  margin: const pw.EdgeInsets.symmetric(horizontal: 20),
                                  width: 1,
                                  height: 40,
                                  color: const PdfColor.fromInt(0x80ffffff), // 50% white
                                ),
                                pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      "RİSK SEVİYESİ",
                                      style: const pw.TextStyle(
                                        color: PdfColors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                    pw.Text(
                                      (metrics['score'] as int) > 80 ? "DÜŞÜK" : (metrics['score'] as int) > 50 ? "ORTA" : "YÜKSEK",
                                       style: pw.TextStyle(
                                        color: (metrics['score'] as int) > 80 ? PdfColors.green300 : (metrics['score'] as int) > 50 ? PdfColors.orange300 : PdfColors.red300,
                                        fontSize: 16,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    pw.Spacer(),

                    // ALT BİLGİ ALANI (Grid)
                    pw.Container(
                      padding: const pw.EdgeInsets.all(30),
                      color: const PdfColor.fromInt(0x33000000), // 20% black
                      child: pw.Row(
                        children: [
                          _buildCoverInfoItem("PROJE / BİNA ADI", store.currentBinaName ?? "-"),
                          pw.SizedBox(width: 20),
                          _buildCoverInfoItem("LOKASYON", "${store.currentBinaDistrict} / ${store.currentBinaCity}"),
                          pw.SizedBox(width: 20),
                          _buildCoverInfoItem("DENETLEYEN", "Kullanıcı Beyanı"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    // 2. HUKUKİ BİLGİLENDİRME
    pdf.addPage(
      pw.Page(
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
      ),
    );

    // 3. ANALİZ TABLOSU
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        header: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            "Bina Yangın Güvenliği Risk Analizi",
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          ),
        ),
        footer: (context) => pw.Container(
          alignment: pw.Alignment.center,
          child: pw.Column(
            children: [
              pw.Divider(color: PdfColors.grey400),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                   pw.Text(
                    "Yangın Güvenlik Asistanı v1.0 - Algoritmik Ön Rapor",
                    style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
                  ),
                  pw.Text(
                    "Sayfa ${context.pageNumber} / ${context.pagesCount} - RESMİ EVRAK DEĞİLDİR, ISLAK İMZA GEÇERLİLİĞİ YOKTUR",
                    style: const pw.TextStyle(fontSize: 7, color: PdfColors.red900, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        build: (context) => [
          pw.Text(
            "YANGIN RİSK ANALİZİ",
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
            "ANALİZ VE RİSK DURUMU",
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
            // Emojileri temizle ama metni (KRİTİK RİSK vb.) koru
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
                  pw.Text(
                    "BÖLÜM $id",
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey700,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    "SORU: ${AppContent.getQuestionText(id)}",
                    style: const pw.TextStyle(
                      fontSize: 8,
                      color: PdfColors.grey800,
                    ),
                  ),
                  pw.Text(
                    "YANIT: ${res.uiTitle}",
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(cleanReport, style: const pw.TextStyle(fontSize: 9)),
                ],
              ),
            );
          }),
        ],
      ),
    );

    // 4. (YENİ) AKTİF SİSTEM GEREKSİNİMLERİ (PREMIUM)
    pdf.addPage(
      pw.Page(
        pageTheme: pageTheme,
        build: (context) {
          final isPremium = BinaStore.instance.isPremium;
          // Calculate anyway to show count or if premium
          // Note: If data is missing, this might return empty or defaults.
          // But we blocked Dashboard access if test not completed, however here we are generating PDF manually.
          // Let's assume best effort.
          final activeSystems = ActiveSystemsEngine.calculateRequirements(
            store,
          );

          return pw.Container(
            padding: const pw.EdgeInsets.all(30),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
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
                  "Yangın güvenliği için kritik öneme sahip algılama, söndürme ve tahliye sistemleri analizidir.",
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.SizedBox(height: 20),
                if (!isPremium) ...[
                  // TEASER VIEW
                  pw.Container(
                    width: double.infinity,
                    height: 200,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Stack(
                      alignment: pw.Alignment.center,
                      children: [
                        // Blurred-like content (fake lines)
                        pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            8,
                            (index) => pw.Container(
                              width: 300,
                              height: 10,
                              color: PdfColors.grey300,
                            ),
                          ),
                        ),
                        // Lock overlay
                        pw.Container(
                          padding: const pw.EdgeInsets.all(20),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.white,
                            borderRadius: pw.BorderRadius.circular(10),
                            boxShadow: const [
                              pw.BoxShadow(
                                color: PdfColors.black,
                                blurRadius: 10,
                                spreadRadius: -5,
                              ),
                            ],
                          ),
                          child: pw.Column(
                            mainAxisSize: pw.MainAxisSize.min,
                            children: [
                              pw.Text(
                                "🔒 BU BÖLÜM KİLİTLİDİR",
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.red900,
                                ),
                              ),
                              pw.SizedBox(height: 5),
                              pw.Text(
                                "Binanız için ${activeSystems.length} adet sistem gereksinimi hesaplanmıştır.",
                                style: const pw.TextStyle(fontSize: 10),
                              ),
                              pw.SizedBox(height: 5),
                              pw.Text(
                                "Detayları görmek için Premium Modülü aktif ediniz.",
                                style: const pw.TextStyle(
                                  fontSize: 10,
                                  color: PdfColors.blue900,
                                  decoration: pw.TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // PREMIUM CONTENT VIEW
                  pw.Text(
                    "Aşağıdaki liste, bina özelliklerinize göre hesaplanan sistem gereksinimlerini içerir.",
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.green900,
                    ),
                  ),
                  pw.SizedBox(height: 15),
                  ...activeSystems.map((req) {
                    final badgeColor = req.isMandatory
                        ? PdfColors.red900
                        : (req.isWarning
                              ? PdfColors.orange900
                              : PdfColors.grey500);
                    final badgeText = req.isMandatory
                        ? "ZORUNLU"
                        : (req.isWarning ? "UYARI" : "ZORUNLU DEĞİL");

                    return pw.Container(
                      margin: const pw.EdgeInsets.only(bottom: 10),
                      padding: const pw.EdgeInsets.all(8),
                      decoration: pw.BoxDecoration(
                        border: pw.Border(
                          left: pw.BorderSide(color: badgeColor, width: 3),
                        ),
                        color: PdfColors.grey50,
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                req.name,
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                badgeText,
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  color: badgeColor,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            req.reason,
                            style: const pw.TextStyle(fontSize: 9),
                          ),
                          if (req.isWarning && req.note.isNotEmpty)
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(top: 4),
                              child: pw.Text(
                                "NOT: ${req.note}",
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  color: PdfColors.orange800,
                                  fontStyle: pw.FontStyle.italic,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }), // removed .toList()
                ],
              ],
            ),
          );
        },
      ),
    );

    // 5. EYLEM PLANI (Renumbered)
    if (actionPlan.isNotEmpty) {
      pdf.addPage(
        pw.Page(
          pageTheme: pageTheme,
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "İYİLEŞTİRME ÖNERİLERİ",
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
                        "Bölüm ${item['id']}: ${item['title']}",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        "ÖNERİ: ${item['advice']}",
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(height: 40),
              pw.Container(
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(5),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "İLETİŞİM",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                        color: PdfColors.blue900,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      "Detaylı saha incelemesi ve raporlama hizmetleri için Yangın Güvenlik Uzmanı 'yla WhatsApp ve E-posta üzerinden iletişime geçebilirsiniz.",
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  static pw.Widget _buildInfoRow(String label, String val) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
          pw.Text(val, style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    );
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

  static PdfColor _getScoreColorForPdf(int score) {
    if (score >= 80) return PdfColors.green300;
    if (score >= 50) return PdfColors.orange300;
    return PdfColors.red300;
  }
}
