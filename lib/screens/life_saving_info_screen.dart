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
        'Duman Dedektörü: Evinize duman dedektörü takın.',
        'Yangın Söndürücü: Evinizde küçük bir yangın söndürme tüpü bulundurmanız hayat kurtarır. Eğer yoksa, kat koridorunuzdaki büyük yangın tüplerinin ve dolaplarının tam yerini önceden mutlaka öğrenin ve kullanım talimatlarını okuyun.',
        'Çıkış Kapıları: Binanızdaki elektrikli veya şifreli kapıların elektrik kesildiğinde otomatik açıldığını yönetimden teyit edin.',
        'Kaçış Planı: Ailenizle kaçış planı yapın. Dış kapı anahtarlarını kapı yakınında sabit bir yerde tutun.',
      ],
    },
    {
      'title': '2. Yangın Anında Ne Yapmalı?',
      'icon': Icons.run_circle_outlined,
      'color': Color(0xFFE65100), // Dark Orange
      'bgColor': Color(0xFFFFF3E0), // Light Orange
      'items': [
        'Müdahale veya Çıkış: Yangın çok küçükse (başlangıç aşamasında) ve kendinize güveniyorsanız tüp/battaniye ile müdahale edin. Ateş büyümüşse eşyaları bırakıp hemen dışarı çıkın.',
        'Eğilin: Dumandan korunmak için emekleyerek veya yere yakın ilerleyin.',
        'Kapıları Kapatın: Çıkarken arkanızdan geçtiğiniz tüm kapıları kapatın.',
        'Asansörü KULLANMAYIN: Sadece yangın merdivenini veya normal merdivenleri kullanın.',
        '112\'yi Arayın: Güvenli bir yere ulaştığınızda 112\'yi arayıp itfaiye isteyin.',
      ],
    },
    {
      'title': '3. Evde Mahsur Kalırsanız',
      'icon': Icons.home_work_outlined,
      'color': Color(0xFFB71C1C), // Dark Red
      'bgColor': Color(0xFFFFEBEE), // Light Red
      'items': [
        'Odaya Sığının: Pencereli ve dışarıya/caddeye bakan bir odaya geçip kapıyı kapatın.',
        'Dumanı Kesin: Kapı altlarını ve kenarlarını ıslak havlu veya bez ile sıkıca tıkayın.',
        'Yardım İsteyin: Pencereden dikkat çekin, 112\'ye bulunduğunuz odanın tam yerini bildirin.',
      ],
    },
    {
      'title': '4. Yangın Tipleri & Söndürme Yöntemleri',
      'icon': Icons.fire_extinguisher_outlined,
      'color': Color(0xFF0D47A1), // Dark Blue
      'bgColor': Color(0xFFE3F2FD), // Light Blue
      'items': [
        'Katı (Ahşap, Tekstil, Kağıt): Su dökerek soğutun veya yangın tüpü kullanın.',
        'Sıvı (Kolonya, Alkol, Tiner, Benzin): KESİNLİKLE SU DÖKMEYİN (alevleri yayar). Üzerini kum, toprak veya nemli örtüyle kapatarak havayı kesin ya da yangın tüpü kullanın.',
        'Mutfak Yağı (Tava Yangınları): KESİNLİKLE SU DÖKMEYİN! Ateşin üstünü metal kapak, yangın battaniyesi veya sıkıca sıkılmış nemli büyük bir havlu ile tamamen kapatıp ocağı söndürün.',
        'Gaz (Tüp, LPG, Doğalgaz): Gazı kapatmadan alevi SÖNDÜRMEYİN (gaz birikir ve patlar). Önce mutlaka vanayı kapatın, alev kendiliğinden sönecektir.',
        'Elektrik (Priz, Cihaz, Kablo): KESİNLİKLE SU DÖKMEYİN (çarpılırsınız). Önce şalteri indirin, sadece kuru kimyevi toz (KKT) veya CO2 söndürücü kullanın.',
        'E-Bisiklet / E-Scooter: Evde yoksanız veya uyuyorsanız şarj ETMEYİN. Kaçış yolunu (koridor) kapatmayın. Batarya yangınlarına asla suyla veya normal tüple müdahale etmeyin, söndürülemez. Hemen kaçıp 112\'yi arayın.',
      ],
    },
  ];

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
                            Icon(
                              section['icon'],
                              color: themeColor,
                              size: 24,
                            ),
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
                          children: (section['items'] as List<String>)
                              .map(
                                (item) {
                                  final parts = item.split(': ');
                                  final hasPrefix = parts.length > 1;
                                  final String boldPart = hasPrefix ? parts[0] : '';
                                  final String normalPart = hasPrefix ? parts.sublist(1).join(': ') : item;

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
                                                TextSpan(text: normalPart),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                              .toList(),
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
