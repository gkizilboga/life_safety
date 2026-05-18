import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';

class LifeSavingInfoScreen extends StatelessWidget {
  const LifeSavingInfoScreen({super.key});

  static const List<Map<String, dynamic>> sections = [
    {
      'title': '1. Önlemler & Hazırlık',
      'icon': Icons.shield_outlined,
      'color': Color(0xFF1B5E20), // Dark Green
      'bgColor': Color(0xFFE8F5E9), // Light Green
      'items': [
        'Duman Dedektörü (Pilli): Kablo tesisatı gerektirmeyen, pille çalışan <b>portatif duman dedektörleri</b> alarak evinizde (özellikle koridor ve yatak odası girişlerine) çift taraflı bantla veya vida ile tavana monte edin. Piyasadan alacağınız cihazın mutlaka <b>CE işaretli ve TS EN 14604 sertifikalı</b> olmasına dikkat edin.',
        'Yangın Söndürücü: Evinizde <b>TS EN 3 sertifikalı ve CE işaretli</b> küçük bir yangın söndürme tüpü (tercihen 2-6 kg ABC Tozlu veya Köpüklü) bulundurmanız hayat kurtarır. Eğer yoksa, kat koridorunuzdaki <b>büyük yangın tüplerinin ve dolaplarının yerini</b> önceden mutlaka öğrenin ve kullanım talimatlarını okuyun.',
        'Çıkış Kapıları: Binanızdaki <b>elektrikli, şifreli, kartlı veya butonlu kapıların</b> elektrik kesildiğinde <b>otomatik açıldığını</b> yönetimden teyit edin.',
        'Kaçış Planı: Ailenizle <b>kaçış planı</b> yapın. Dış kapı anahtarlarını kapı yakınında <b>sabit bir yerde</b> tutun.',
      ],
    },
    {
      'title': '2. Yangın Anında Ne Yapmalı?',
      'icon': Icons.run_circle_outlined,
      'color': Color(0xFFE65100), // Dark Orange
      'bgColor': Color(0xFFFFF3E0), // Light Orange
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
      'icon': Icons.home_work_outlined,
      'color': Color(0xFFB71C1C), // Dark Red
      'bgColor': Color(0xFFFFEBEE), // Light Red
      'items': [
        'Odaya Sığının: Pencereli ve dışarıya/caddeye bakan bir odaya geçip <b>kapıyı kapatın</b>.',
        'Dumanı Kesin: Kapı altlarını ve kenarlarını <b>ıslak havlu veya bez</b> ile sıkıca tıkayın.',
        'Yardım İsteyin: Pencereden dikkat çekin, 112\'ye bulunduğunuz odanın <b>tam yerini (kat/oda)</b> bildirin.',
      ],
    },
    {
      'title': '4. Yangın Tipleri & Söndürme Yöntemleri',
      'icon': Icons.fire_extinguisher_outlined,
      'color': Color(0xFF0D47A1), // Dark Blue
      'bgColor': Color(0xFFE3F2FD), // Light Blue
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

  static List<TextSpan> _buildRichSpans(String text, Color sectionColor) {
    final List<TextSpan> spans = [];
    final RegExp regExp = RegExp(r'<b>(.*?)</b>', dotAll: true);
    final matches = regExp.allMatches(text);

    if (matches.isEmpty) {
      spans.add(TextSpan(text: text));
      return spans;
    }

    int lastMatchEnd = 0;
    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }
      final String groupVal = match.group(1) ?? '';
      final bool isWarningText =
          groupVal.contains('SU DÖKMEYİN') ||
          groupVal.contains('SÖNDÜRMEYİN') ||
          groupVal.contains('şarj etmeyin') ||
          groupVal.contains('şarj ETMEYİN') ||
          groupVal.contains('KULLANMAYIN') ||
          groupVal.contains('müdahale etmeyin');

      spans.add(
        TextSpan(
          text: groupVal,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isWarningText ? const Color(0xFFC62828) : sectionColor,
          ),
        ),
      );
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          const ModernHeader(
            title: "Hayat Kurtarıcı Bilgiler",
            screenType: LifeSavingInfoScreen,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                final Color themeColor = section['color'];
                final Color bgColor = section['bgColor'];

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: themeColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(section['icon'], color: themeColor, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                section['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: themeColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Section Items
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: (section['items'] as List<String>).map((
                            item,
                          ) {
                            final parts = item.split(': ');
                            final hasPrefix = parts.length > 1;
                            final String boldPart = hasPrefix ? parts[0] : '';
                            final String normalPart = hasPrefix
                                ? parts.sublist(1).join(': ')
                                : item;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Icon(
                                      Icons.fiber_manual_record,
                                      size: 8,
                                      color: themeColor,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          color: Colors.grey[850],
                                          height: 1.5,
                                        ),
                                        children: [
                                          if (boldPart.isNotEmpty)
                                            TextSpan(
                                              text: "$boldPart: ",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ..._buildRichSpans(
                                            normalPart,
                                            themeColor,
                                          ),
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
