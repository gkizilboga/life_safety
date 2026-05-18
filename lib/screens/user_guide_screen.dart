import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({super.key});

  static const List<Map<String, String>> guideFaqs = [
    {
      'q': 'Bu uygulamayı nasıl kullanmalıyım?',
      'a':
          'Uygulama, binanızın yangın güvenliği durumunu <b>adım adım analiz etmenizi</b> sağlar. Karşınıza çıkan soruları yanıtlarken, binanızın mevcut durumunu (örneğin <b>merdiven genişlikleri</b>, <b>kapı yönleri</b>, <b>yangın dolaplarının varlığı</b> vb.) göz önünde bulundurmalısınız. Yanıtlarınızı verirken olabildiğince <b>dürüst ve objektif</b> olmanız, risk analizinin doğruluğu için çok önemlidir.',
    },
    {
      'q': 'Soruların yanıtlarını bilmiyorsam ne yapmalıyım?',
      'a':
          'Bazı teknik detayları (örneğin yangın merdiveninin basınçlandırılması, yangın algılama sisteminin özellikleri) bilmiyor olabilirsiniz. Bu durumda, soruların altındaki <b>"Emin Değilim"</b> veya <b>"Bilmiyorum"</b> seçeneklerini kullanabilirsiniz. Ancak en doğru sonuç için binanızın <b>apartman veya site yöneticisine</b>, <b>güvenlik görevlilerine</b> veya <b>teknik personeline</b> danışarak doğru bilgileri öğrenmeniz tavsiye edilir.',
    },
    {
      'q': 'Hiçbir bilgim yoksa testi başkasına çözdürebilir miyim?',
      'a':
          'Evet! Eğer binanızın mimari veya teknik detaylarına hakim değilseniz, uygulamayı binanızın <b>yönetim kuruluna</b>, <b>site müdürüne</b> veya binanızdaki <b>teknik personele</b> önerebilirsiniz. Kendi dairenize ait analizleri yapmak yerine, yetkili kişilerin bu uygulamayı kullanarak tüm bina için ortak bir analiz yapmasını sağlayabilirsiniz. Dilerseniz, ana ekrandaki <b>"Paylaşım ve Transfer"</b> bölümünden yarım kalmış analizi dosya olarak <b>dışa aktarıp (export)</b> yöneticinize gönderebilirsiniz. Onlar kendi telefonlarına bu dosyayı <b>içe aktararak (import)</b> analizi kaldığı yerden tamamlayabilirler!',
    },
    {
      'q': 'Promo kod "Al" ve "Gönder" ne anlama gelir?',
      'a':
          'Ana ekranda yer alan <b>"Promosyon İşlemleri"</b> bölümündeki bu iki buton, analizinizi başkalarıyla paylaşmanın ve transfer etmenin en kolay yoludur:\n\n• <b>Promo Kod Gönder:</b> Kendi telefonunuzda başlattığınız veya tamamladığınız bir analizi, binanızdaki başka bir komşunuza veya yöneticinize aktarmak için bir paylaşım kodu oluşturur. Bu kodu gönderdiğiniz kişi analizinizi kendi telefonuna yükleyebilir.\n\n• <b>Promo Kod Al:</b> Yöneticinizden veya başka bir komşunuzdan aldığınız promosyon kodunu buraya girerek, onların başlattığı analizi ve tüm yanıtları kendi telefonunuza anında yükleyebilir, kaldığı yerden devam ettirebilirsiniz.',
    },
    {
      'q': 'Uygulamadaki puanlar ve renk kodları ne anlama geliyor?',
      'a':
          'Dokümanınızdaki veya soru ekranlarındaki renkler risk düzeyini belirtir:\n\n• <b>Kritik Risk (Kırmızı):</b> Yönetmeliğe aykırı olan ve acilen düzeltilmesi gereken can güvenliği açıklarını temsil eder.\n\n• <b>Uyarı (Sarı):</b> İyileştirilmesi gereken hususları gösterir.\n\n• <b>Olumlu (Yeşil):</b> Yönetmeliğe tam uyumlu, güvenli alanları ifade eder.',
    },
    {
      'q': 'Sonuç dokümanını (PDF) ne yapmalıyım?',
      'a':
          'Tüm soruları yanıtladıktan sonra uygulama size detaylı bir <b>PDF dokümanı</b> sunar. Bu dokümanı telefonunuza indirebilir ve binanızın <b>WhatsApp veya Telegram</b> grubunda komşularınızla paylaşabilir, veya <b>site yönetimine sunarak</b> binanızdaki olası yangın risklerinin giderilmesi için bir <b>farkındalık ve aksiyon</b> başlatabilirsiniz.',
    },
  ];

  static List<TextSpan> _buildRichSpans(String text, Color primaryColor) {
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
      
      // Determine colors based on specific key terms for visual guidance
      Color textColor = primaryColor;
      if (groupVal.contains('Kritik Risk') || groupVal.contains('Kırmızı')) {
        textColor = const Color(0xFFC62828); // Red
      } else if (groupVal.contains('Uyarı') || groupVal.contains('Sarı')) {
        textColor = const Color(0xFFF57C00); // Amber/Orange
      } else if (groupVal.contains('Olumlu') || groupVal.contains('Yeşil')) {
        textColor = const Color(0xFF2E7D32); // Green
      }

      spans.add(
        TextSpan(
          text: groupVal,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
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
    final theme = Theme.of(context);
    const primaryColor = Color(0xFF1a365d);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          const ModernHeader(title: "Kullanım Kılavuzu", screenType: UserGuideScreen),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: guideFaqs.length,
              itemBuilder: (context, index) {
                final faq = guideFaqs[index];
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  clipBehavior: Clip.antiAlias, // Ensures the inner background color is clipped to the card's rounded corners
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
                      color: Colors.grey.shade100,
                      width: 1,
                    ),
                  ),
                  child: Theme(
                    data: theme.copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: index == 0,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.help_outline_rounded,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        faq['q']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                          color: primaryColor,
                        ),
                      ),
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey[50], // Soft grey background for clear separation
                            border: const Border(
                              top: BorderSide(color: Color(0xFFEEEEEE), width: 0.5),
                              left: BorderSide(color: primaryColor, width: 4), // Solid blue vertical accent line
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 13.5,
                                color: Colors.grey[800],
                                height: 1.6,
                                fontFamily: theme.textTheme.bodyMedium?.fontFamily,
                              ),
                              children: _buildRichSpans(faq['a']!, primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
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
