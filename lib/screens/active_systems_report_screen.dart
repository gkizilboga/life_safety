import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import '../logic/active_systems_engine.dart';
import '../models/active_system_requirement.dart';
import '../widgets/custom_widgets.dart';
import '../services/pdf_service.dart';

class ActiveSystemsReportScreen extends StatelessWidget {
  const ActiveSystemsReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = BinaStore.instance;

    // Gereksinimleri Hesapla
    final requirements = ActiveSystemsEngine.calculateRequirements(store);

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Aktif Sistem Gereksinimleri",
            screenType: ActiveSystemsReportScreen,
            onSave: () async {
              if (store.isPremium) {
                await PdfService.generateActiveSystemsPdf(context);
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
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: requirements.length,
              itemBuilder: (context, index) {
                final req = requirements[index];

                // Neutral styling - no color coding
                Color cardBgColor = Colors.white;
                Color borderColor = Colors.grey.shade300;
                String badgeText = req.isMandatory
                    ? "ZORUNLU"
                    : (req.isWarning ? "UYARI" : "İSTEĞE BAĞLI");

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: cardBgColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: borderColor, width: 1),
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
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                badgeText,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
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
                              " ${req.note}",
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
          ),
        ],
      ),
    );
  }

  /// Cleans reason text by removing extra whitespaces if any
  static String _cleanReasonText(String text) {
    return text.trim();
  }
}
