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
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.save_as_rounded, color: Colors.green, size: 28),
              SizedBox(width: 10),
              Text("Bilgilendirme"),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Analize istediğiniz zaman ara verebilirsiniz.",
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "- ",
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Ekranın sağ üst köşesindeki \"KAYDET\" butonuna basarak analizden çıkabilir, daha sonra kaldığınız yerden devam edebilirsiniz.",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "- ",
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: Colors.black87,
                          ),
                          children: [
                            TextSpan(text: "(DİKKAT: Bu analiz yalnızca "),
                            TextSpan(
                              text: "KONUT ve KONUT + TİCARİ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: " ruhsatlı yapılar için geçerlidir.)",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Tamam, Anladım",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 30),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'UYARI',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: const Text(
            ' DİKKAT: Binanız 19.12.2007 tarihinden önce ruhsatlandırılmış olmasına rağmen yönetmelikteki "Yeni Bina" hükümlerine göre analiz edilmesini talep ediyorsunuz. Durumunuza uygun yangın risk analizi için Uzman görüşüne başvurmanız tavsiye edilir.',
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Vazgeç',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _navigateToNext();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Devam Et'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Yapı Ruhsat / Bina İnşa Tarihi",
      subtitle: " ",
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
                const QuestionTitle("Binanızın yapı ruhsat tarihi nedir?"),
                const SizedBox(height: 20),
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
