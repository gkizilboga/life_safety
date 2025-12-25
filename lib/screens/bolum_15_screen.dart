import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_15_model.dart';
import 'bolum_16_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum15Screen extends StatefulWidget {
  const Bolum15Screen({super.key});

  @override
  State<Bolum15Screen> createState() => _Bolum15ScreenState();
}

class _Bolum15ScreenState extends State<Bolum15Screen> {
  Bolum15Model _model = Bolum15Model();

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'kaplama') _model = _model.copyWith(kaplama: choice);
      if (type == 'yalitim') {
        _model = _model.copyWith(yalitim: choice);
        // Seçim değişirse alt soruyu sıfırla
        if (choice.label != Bolum15Content.yalitimOptionB.label) {
          _model = _model.copyWith(yalitimSapVar: null);
        }
      }
      if (type == 'tavan') {
        _model = _model.copyWith(tavan: choice);
        // Seçim değişirse alt soruyu sıfırla
        if (choice.label != Bolum15Content.tavanOptionB.label) {
          _model = _model.copyWith(tavanMalzemesi: null);
        }
      }
      if (type == 'tesisat') _model = _model.copyWith(tesisat: choice);
    });
  }

  void _onNextPressed() {
    // Validasyonlar
    if (_model.kaplama == null) return _showError("Lütfen zemin kaplama sorusunu yanıtlayınız.");
    if (_model.yalitim == null) return _showError("Lütfen zemin yalıtım sorusunu yanıtlayınız.");
    
    // Yalıtım varsa şap sorusu zorunlu
    if (_model.yalitim?.label == Bolum15Content.yalitimOptionB.label && _model.yalitimSapVar == null) {
      return _showError("Lütfen yalıtım üzerindeki şap durumunu belirtiniz.");
    }

    if (_model.tavan == null) return _showError("Lütfen tavan sorusunu yanıtlayınız.");
    
    // Asma tavan varsa malzeme sorusu zorunlu
    if (_model.tavan?.label == Bolum15Content.tavanOptionB.label && _model.tavanMalzemesi == null) {
      return _showError("Lütfen asma tavan malzemesini seçiniz.");
    }

    if (_model.tesisat == null) return _showError("Lütfen tesisat geçiş sorusunu yanıtlayınız.");

    BinaStore.instance.bolum15 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum16Screen()),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ModernHeader(
            title: "Bölüm-15: İç Mekan",
            subtitle: "Kaplama ve dekorasyon malzemeleri.",
            currentStep: 5, 
            totalSteps: 26,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 1. Zemin Kaplaması
                  _buildSoru("Zeminlerinizde kullandığınız kaplama malzemesi nedir?", 'kaplama', 
                    [
                      Bolum15Content.kaplamaOptionA, 
                      Bolum15Content.kaplamaOptionB, 
                      Bolum15Content.kaplamaOptionC
                    ], _model.kaplama),

                  // 2. Isı Yalıtımı
                  _buildSoru("Döşeme betonunun üzerinde strafor/köpük vb. ısı yalıtımı var mı?", 'yalitim', 
                    [
                      Bolum15Content.yalitimOptionA, 
                      Bolum15Content.yalitimOptionB, 
                      Bolum15Content.yalitimOptionC
                    ], _model.yalitim),

                  // Alt Soru: Yalıtım Varsa Şap
                  if (_model.yalitim?.label == Bolum15Content.yalitimOptionB.label) 
                    Container(
                      margin: const EdgeInsets.only(left: 20, bottom: 20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Yalıtım malzemesinin üzerinde en az 2 cm şap (beton) var mı?", style: TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Radio<bool>(
                                value: true, 
                                groupValue: _model.yalitimSapVar, 
                                onChanged: (v) => setState(() => _model = _model.copyWith(yalitimSapVar: v))
                              ),
                              const Text("Evet Var"),
                              const SizedBox(width: 20),
                              Radio<bool>(
                                value: false, 
                                groupValue: _model.yalitimSapVar, 
                                onChanged: (v) => setState(() => _model = _model.copyWith(yalitimSapVar: v))
                              ),
                              const Text("Hayır Yok"),
                            ],
                          )
                        ],
                      ),
                    ),

                  // 3. Tavan
                  _buildSoru("Koridorlarda veya daire içlerinde Asma Tavan var mı?", 'tavan', 
                    [
                      Bolum15Content.tavanOptionA, 
                      Bolum15Content.tavanOptionB, 
                      Bolum15Content.tavanOptionC
                    ], _model.tavan),

                  // Alt Soru: Tavan Malzemesi
                  if (_model.tavan?.label == Bolum15Content.tavanOptionB.label) 
                    Container(
                      margin: const EdgeInsets.only(left: 20, bottom: 20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Asma tavan malzemesi nedir?", style: TextStyle(fontWeight: FontWeight.bold)),
                          RadioListTile<String>(
                            title: const Text("Alçıpanel, metal vb. yanmaz malzeme"),
                            value: "yanmaz",
                            groupValue: _model.tavanMalzemesi,
                            onChanged: (v) => setState(() => _model = _model.copyWith(tavanMalzemesi: v)),
                          ),
                          RadioListTile<String>(
                            title: const Text("Ahşap, plastik, lambiri vs. yanıcı malzeme"),
                            value: "yanici",
                            groupValue: _model.tavanMalzemesi,
                            onChanged: (v) => setState(() => _model = _model.copyWith(tavanMalzemesi: v)),
                          ),
                        ],
                      ),
                    ),

                  // 4. Tesisat Geçişleri
                  _buildSoru("Döşemeden geçen boru ve kablo boşlukları nasıl kapatılmış?", 'tesisat', 
                    [
                      Bolum15Content.tesisatOptionA, 
                      Bolum15Content.tesisatOptionB, 
                      Bolum15Content.tesisatOptionC
                    ], _model.tesisat),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onNextPressed,
                  child: const Text("DEVAM ET"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoru(String title, String key, List<ChoiceResult> options, ChoiceResult? selected) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...options.map((opt) => SelectableCard(
            choice: opt,
            isSelected: selected?.label == opt.label,
            onTap: () => _handleSelection(key, opt),
          )).toList(),
        ],
      ),
    );
  }
}