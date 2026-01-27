import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import '../logic/active_systems_engine.dart';
import '../models/active_system_requirement.dart';
import '../widgets/custom_widgets.dart';

class ActiveSystemsReportScreen extends StatelessWidget {
  const ActiveSystemsReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = BinaStore.instance;

    // Gereksinimleri Hesapla
    final requirements = ActiveSystemsEngine.calculateRequirements(store);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Aktif Sistem Gereksinimleri"),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              if (store.isPremium) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "PDF Raporu başarıyla oluşturuldu ve indirildi: Aktif_Sistemler_Raporu.pdf",
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Bu özellik (Aktif Sistem Gereksinimleri Çıktısı) ayrıca satın alınmalıdır.",
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: requirements.length,
        itemBuilder: (context, index) {
          final req = requirements[index];

          // Determine Style based on Mandatory/Warning/Optional
          Color cardBgColor = Colors.white;
          Color borderColor = Colors.grey.shade300;
          Color badgeColor = Colors.grey.shade400;
          String badgeText = "ZORUNLU DEĞİL";

          if (req.isMandatory) {
            cardBgColor = Colors.red.shade50;
            borderColor = Colors.red.shade900;
            badgeColor = Colors.red.shade900;
            badgeText = "ZORUNLU";
          } else if (req.isWarning) {
            cardBgColor = Colors.orange.shade50;
            borderColor = Colors.orange.shade900;
            badgeColor = Colors.orange.shade900;
            badgeText = "UYARI"; // Or "DİKKAT" / "UZMAN GÖRÜŞÜ"
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: cardBgColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                req.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                            ),
                            if (req.definitionTerm != null &&
                                req.definitionText != null)
                              DefinitionButton(
                                term: req.definitionTerm!,
                                definition: req.definitionText!,
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          badgeText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 4),
                  Text(
                    _cleanReasonText(req.reason),
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (req.note.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      width: double.infinity,
                      child: Text(
                        " UZMAN NOTU: ${req.note}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Cleans reason text by removing emoji prefixes and labels
  static String _cleanReasonText(String text) {
    return text
        .replaceAll(' KRİTİK RİSK: ', '')
        .replaceAll('OLUMLU: ', '')
        .replaceAll('UYARI: ', '')
        .replaceAll(' BİLMİYORUM: ', '')
        .replaceAll(' BİLMİYORUM: ', '')
        .replaceAll(' BİLGİ: ', '')
        .replaceAll('KRİTİK RİSK: ', '')
        .replaceAll('OLUMLU: ', '')
        .replaceAll('UYARI: ', '')
        .replaceAll('BİLMİYORUM: ', '')
        .replaceAll('BİLGİ: ', '')
        .trim();
  }
}
