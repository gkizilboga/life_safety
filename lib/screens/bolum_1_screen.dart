import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import '../models/bolum_1_model.dart';
import 'bolum_2_screen.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/selectable_card.dart';
import '../utils/app_content.dart';
import '../models/choice_result.dart';

class Bolum1Screen extends StatefulWidget {
  const Bolum1Screen({super.key});

  @override
  State<Bolum1Screen> createState() => _Bolum1ScreenState();
}

class _Bolum1ScreenState extends State<Bolum1Screen> {
  Bolum1Model _model = Bolum1Model();

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum1 != null) {
      _model = BinaStore.instance.bolum1!;
    }

    // Show startup info regarding "Save & Exit"
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showCustomDialog(
        context: context,
        title: "Bilgilendirme",
        icon: Icons.save_as_rounded,
        iconColor: Colors.green,
        confirmText: "Tamam",
        contentWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("• ", style: TextStyle(fontSize: 13, height: 1.4)),
                Expanded(
                  child: Text(
                    "Analiz süresi yaklaşık 20-30 dakikadır.",
                    style: TextStyle(fontSize: 13, height: 1.4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("• ", style: TextStyle(fontSize: 13, height: 1.4)),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                      children: [
                        TextSpan(
                          text: "İstediğinizde ekranın sağ üst köşesindeki ",
                        ),
                        TextSpan(
                          text: "KAYDET",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              " butonuna basarak çıkabilir, daha sonra kaldığınız yerden devam edebilirsiniz.",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("• ", style: TextStyle(fontSize: 13, height: 1.4)),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                      children: [
                        TextSpan(text: "Analiz yalnızca "),
                        TextSpan(
                          text: "19.12.2007 sonrası ruhsatlı ",
                        ),
                        TextSpan(
                          text: "KONUT",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: " veya "),
                        TextSpan(
                          text: "KONUT+TİCARİ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: " ruhsatlı yapılar için geçerlidir."),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  void _handleSelection(ChoiceResult choice) {
    setState(() {
      _model = _model.copyWith(secim: choice);
    });
  }

  void _onNextPressed() {
    if (_model.secim == null) return;

    if (_model.secim?.label == Bolum1Content.ruhsatSonrasi.label) {
      _navigateToNext();
    } else {
      _showWarningDialog();
    }
  }

  void _navigateToNext() {
    BinaStore.instance.bolum1 = _model;
    BinaStore.instance.saveToDisk();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum2Screen()),
    );
  }

  Future<void> _showWarningDialog() async {
    final confirmed = await showCustomDialog<bool>(
      context: context,
      title: 'UYARI',
      content:
          ' DİKKAT: Binanız 19.12.2007 tarihinden önce ruhsatlandırılmış olmasına rağmen yönetmelikteki "Yeni Bina" hükümlerine göre analiz edilmesini talep ediyorsunuz. Durumunuza uygun yangın risk analizi için Uzman görüşüne başvurmanız tavsiye edilir.',
      confirmText: 'Devam Et',
      cancelText: 'Vazgeç',
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.orange,
      barrierDismissible: false,
    );

    if (confirmed == true) {
      _navigateToNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Yapı Ruhsat Tarihi",
      screenType: widget.runtimeType,
      isNextEnabled: _model.secim != null,
      onNext: _onNextPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuestionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(
                      child: QuestionTitle(
                        "Binanızın yapı ruhsat (inşa) tarihi nedir?",
                      ),
                    ),
                    const DefinitionButton(
                      term: "Yapı Ruhsat Tarihi",
                      definition:
                          'Yapı ruhsat tarihi, bir parselde inşaatın başlayabilmesi için ilgili belediye tarafından düzenlenen "Yapı Ruhsatı" belgesinin üzerinde yazan resmi onay tarihidir.',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SelectableCard(
                  choice: Bolum1Content.ruhsatSonrasi,
                  isSelected:
                      _model.secim?.label == Bolum1Content.ruhsatSonrasi.label,
                  onTap: () => _handleSelection(Bolum1Content.ruhsatSonrasi),
                ),
                SelectableCard(
                  choice: Bolum1Content.ruhsatOncesi,
                  isSelected:
                      _model.secim?.label == Bolum1Content.ruhsatOncesi.label,
                  onTap: () => _handleSelection(Bolum1Content.ruhsatOncesi),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
