import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';

class ScopeScreen extends StatelessWidget {
  const ScopeScreen({super.key});

  static const List<Map<String, String>> scopeFaqs = [
    {
      'q': 'Hangi binalar için uygundur?',
      'a':
          'Bu çalışma, 19.12.2007 tarihinden sonra yapı ruhsatı onaylanmış KONUT amaçlı yapılar için geçerlidir. Binada zemin veya bodrum katta ticari alan (dükkan, ofis vb.) bulunsa dahi, bu uygulama yalnızca binanın konut bölümlerini ve ortak kullanım alanlarını (merdiven, kaçış yolu, otopark, teknik hacimler vb.) kapsar. Ticari alanlar bu çalışmanın kapsamı dışındadır.',
    },
    {
      'q': 'Kapsam nedir?',
      'a':
          'Bu analiz yalnızca binanın fiziksel (mimari) yapısını inceler. Alarm, söndürme ve duman tahliye sistemleri için bu uygulamadaki "Aktif Sistem Gereksinimleri" dokümanının da incelenmesi önerilir.',
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
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          const ModernHeader(title: "Kapsam ve SSS", screenType: ScopeScreen),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: scopeFaqs.length,
              itemBuilder: (context, index) {
                final faq = scopeFaqs[index];
                final isWarning = faq['q'] == 'Önemli Uyarı';

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: isWarning ? const Color(0xFFFFF8E1) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: isWarning
                          ? const Color(0xFFFFD54F).withValues(alpha: 0.5)
                          : Colors.grey.shade100,
                      width: isWarning ? 1.5 : 1,
                    ),
                  ),
                  child: Theme(
                    data: theme.copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: false,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isWarning
                              ? const Color(0xFFFFA000).withValues(alpha: 0.1)
                              : const Color(0xFF1a365d).withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isWarning
                              ? Icons.warning_amber_rounded
                              : Icons.help_outline_rounded,
                          color: isWarning
                              ? const Color(0xFFD84315)
                              : const Color(0xFF1a365d),
                          size: 20,
                        ),
                      ),
                      title: Text(
                        faq['q']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                          color: isWarning
                              ? const Color(0xFFD84315)
                              : const Color(0xFF1a365d),
                        ),
                      ),
                      iconColor: isWarning
                          ? const Color(0xFFD84315)
                          : const Color(0xFF1a365d),
                      collapsedIconColor: isWarning
                          ? const Color(0xFFFFA000)
                          : Colors.grey,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isWarning ? const Color(0xFFFFF8E1) : Colors.grey[50],
                            border: Border(
                              top: BorderSide(
                                color: isWarning ? const Color(0xFFFFE082) : const Color(0xFFEEEEEE), 
                                width: 0.5,
                              ),
                              left: BorderSide(
                                color: isWarning ? const Color(0xFFD84315) : const Color(0xFF1a365d), 
                                width: 4,
                              ),
                            ),
                          ),
                          child: Text(
                            faq['a']!,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: isWarning ? const Color(0xFF5D4037) : Colors.grey[800],
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
