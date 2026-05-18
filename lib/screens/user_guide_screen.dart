import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({super.key});

  static const List<Map<String, String>> guideFaqs = [
    {
      'q': 'Bu Uygulamayı Nasıl Kullanmalıyım?',
      'a':
          'Uygulama, binanızın yangın güvenliği durumunu adım adım analiz etmenizi sağlar. Karşınıza çıkan soruları yanıtlarken, binanızın mevcut durumunu (örneğin merdiven genişlikleri, kapı yönleri, yangın dolaplarının varlığı vb.) göz önünde bulundurmalısınız. Yanıtlarınızı verirken olabildiğince dürüst ve objektif olmanız, risk analizinin doğruluğu için çok önemlidir.',
    },
    {
      'q': 'Soruların Yanıtlarını Bilmiyorsam Ne Yapmalıyım?',
      'a':
          'Bazı teknik detayları (örneğin yangın merdiveninin basınçlandırılması, yangın algılama sisteminin özellikleri) bilmiyor olabilirsiniz. Bu durumda, soruların altındaki "Emin Değilim" veya "Bilmiyorum" seçeneklerini kullanabilirsiniz. Ancak en doğru sonuç için binanızın apartman veya site yöneticisine, güvenlik görevlilerine veya teknik personeline danışarak doğru bilgileri öğrenmeniz tavsiye edilir.',
    },
    {
      'q': 'Hiçbir Bilgim Yoksa Testi Başkasına Çözdürebilir miyim?',
      'a':
          'Evet! Eğer binanızın mimari veya teknik detaylarına hakim değilseniz, uygulamayı binanızın yönetim kuruluna, site müdürüne veya binanızdaki teknik personele önerebilirsiniz. Kendi dairenize ait analizleri yapmak yerine, yetkili kişilerin bu uygulamayı kullanarak tüm bina için ortak bir analiz yapmasını sağlayabilirsiniz. Dilerseniz, ana ekrandaki "Paylaşım ve Transfer" bölümünden yarım kalmış analizi dosya olarak dışa aktarıp (export) yöneticinize gönderebilirsiniz. Onlar kendi telefonlarına bu dosyayı içe aktararak (import) analizi kaldığı yerden tamamlayabilirler!',
    },
    {
      'q': 'Promo Kod "Al" ve "Gönder" Ne Anlama Gelir?',
      'a':
          'Ana ekranda yer alan "Promosyon İşlemleri" bölümündeki bu iki buton, analizinizi başkalarıyla paylaşmanın ve transfer etmenin en kolay yoludur:\n\n• Promo Kod Gönder: Kendi telefonunuzda başlattığınız veya tamamladığınız bir analizi, binanızdaki başka bir komşunuza veya yöneticinize aktarmak için bir paylaşım kodu oluşturur. Bu kodu gönderdiğiniz kişi analizinizi kendi telefonuna yükleyebilir.\n\n• Promo Kod Al: Yöneticinizden veya başka bir komşunuzdan aldığınız promosyon kodunu buraya girerek, onların başlattığı analizi ve tüm yanıtları kendi telefonunuza anında yükleyebilir, kaldığı yerden devam ettirebilirsiniz.',
    },
    {
      'q': 'Uygulamadaki Puanlar ve Renk Kodları Ne Anlama Geliyor?',
      'a':
          'Raporunuzdaki veya soru ekranlarındaki renkler risk düzeyini belirtir:\n\n• Kırmızı (Kritik Risk): Yönetmeliğe aykırı olan ve acilen düzeltilmesi gereken can güvenliği açıklarını temsil eder.\n\n• Sarı (Uyarı): İyileştirilmesi gereken hususları gösterir.\n\n• Yeşil (Olumlu): Yönetmeliğe tam uyumlu, güvenli alanları ifade eder.',
    },
    {
      'q': 'Sonuç Raporunu (PDF) Ne Yapmalıyım?',
      'a':
          'Tüm soruları yanıtladıktan sonra uygulama size detaylı bir PDF raporu sunar. Bu raporu telefonunuza indirebilir ve binanızın WhatsApp veya Telegram grubunda komşularınızla paylaşabilir, veya site yönetimine sunarak binanızdaki olası yangın risklerinin giderilmesi için bir farkındalık ve aksiyon başlatabilirsiniz.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                          color: const Color(0xFF1a365d).withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.help_outline_rounded,
                          color: Color(0xFF1a365d),
                          size: 20,
                        ),
                      ),
                      title: Text(
                        faq['q']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                          color: Color(0xFF1a365d),
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Text(
                            faq['a']!,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.grey[700],
                              height: 1.6,
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
