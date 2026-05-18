import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';

class ScopeScreen extends StatelessWidget {
  const ScopeScreen({super.key});

  static const List<Map<String, String>> scopeFaqs = [
    {
      'q': 'Hangi binalar için uygundur?',
      'a':
          'Bu uygulama, 19.12.2007 tarihinden sonra yapı ruhsatı onaylanmış KONUT amaçlı yapılar için geçerlidir. Binada zemin veya bodrum katta ticari alan (dükkan, ofis vb.) bulunsa dahi, bu uygulama yalnızca binanın konut bölümlerini ve ortak kullanım alanlarını (merdiven, kaçış yolu, otopark, teknik hacimler vb.) kapsar. Ticari alanlar bu çalışmanın kapsamı dışındadır.',
    },
    {
      'q': 'Bu uygulama neleri analiz eder?',
      'a':
          'Uygulama iki ana başlık altında analiz sunar:\n\n1. Yangın Risk Analizi: Binanın merdivenleri, kaçış yolları ve kapıları gibi yapısal (mimari) özelliklerine odaklanır.\n\n2. Aktif Sistem Gereksinimleri: Alarm, söndürme, duman tahliyesi gibi elektromekanik yangın güvenliği ihtiyaçlarını inceler.',
    },
    {
      'q': 'Puanlama ve Risk Seviyeleri ne anlama gelir?',
      'a':
          'Raporlardaki kırmızı (kritik risk / zorunlu), sarı (uyarı) ve yeşil (olumlu) renkler, o konudaki risk veya gereklilik seviyesini gösterir. Puanlar ve değerlendirmeler yalnızca bu uygulama içindeki göreli bir ön değerlendirmedir; resmi evrak niteliği taşımaz.',
    },
    {
      'q': 'Binanızda periyodik testler zorunlu mu?',
      'a':
          'Evet. Kurulumu yapılan yangın alarm, sprinkler, duman tahliye, acil aydınlatma ve söndürme sistemlerinin Binaların Yangından Korunması Hakkında Yönetmeliği ve ilgili TS EN standartları çerçevesinde yetkili servis kuruluşlarınca YILDA EN AZ BİR KEZ periyodik test ve bakımlarının yapılması yasal zorunluluktur. Yangın tüpleri ve yangın dolapları için ise 6 ayda bir kontrol önerilir. Bu sorumluluk bina yönetimine aittir.',
    },
    {
      'q': 'Belgenin geçerlilik süresi var mı?',
      'a':
          'Binanızda yapılan mimari tadilatlar, kullanım amacı değişiklikleri veya mekanik sistem revizyonları durumunda analizin güncellenmesi önerilir. Rapor, üretildiği tarihteki beyan edilen verilere dayanır.',
    },
    {
      'q': 'Önemli Uyarı',
      'a':
          'Bu uygulama bir "ön değerlendirme" aracıdır ve binanızdaki tüm riskleri eksiksiz tespit edemez. Kesin ve eksizsiz analiz için binanın, yetkin bir Yangın Mühendisi tarafından proje üzerinde ve yerinde incelenmesi şarttır.',
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
                      initiallyExpanded:
                          index == 0 ||
                          isWarning, // Hangi binalar ve Önemli uyarı default açık olsun
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
                          fontSize: 15,
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Text(
                            faq['a']!,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: isWarning
                                  ? const Color(0xFF5D4037)
                                  : Colors.grey[800],
                              height: 1.55,
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
