import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_35_model.dart';
import 'bolum_36_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum35Screen extends StatefulWidget {
  const Bolum35Screen({super.key});

  @override
  State<Bolum35Screen> createState() => _Bolum35ScreenState();
}

class _Bolum35ScreenState extends State<Bolum35Screen> {
  Bolum35Model _model = Bolum35Model();
  
  // Çıkış sayısına göre Tek Yön / Çift Yön sorusunu belirle
  bool _tekCikis = true;

  @override
  void initState() {
    super.initState();
    _checkCikisSayisi();
  }

  void _checkCikisSayisi() {
    // Bölüm 20'den toplam çıkış sayısını al
    final b20 = BinaStore.instance.bolum20;
    int toplam = (b20?.normalMerdivenSayisi ?? 0) + 
                 (b20?.binaIciYanginMerdiveniSayisi ?? 0) + 
                 (b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0) + 
                 (b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0);
    
    if (toplam > 1) {
      setState(() {
        _tekCikis = false;
      });
    }
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'tekYon') _model = _model.copyWith(tekYon: choice);
      if (type == 'ciftYon') _model = _model.copyWith(ciftYon: choice);
      
      if (type == 'cikmaz') {
        _model = _model.copyWith(cikmaz: choice);
        if (choice.label == Bolum35Content.cikmazOptionA.label) {
          _model = _model.copyWith(cikmazMesafe: null);
        }
      }
      
      if (type == 'cikmazMesafe') _model = _model.copyWith(cikmazMesafe: choice);
    });
  }

  void _onNextPressed() {
    if (_tekCikis) {
      if (_model.tekYon == null) return _showError("Lütfen tek yön kaçış mesafesini seçiniz.");
    } else {
      if (_model.ciftYon == null) return _showError("Lütfen en yakın çıkışa mesafeyi seçiniz.");
    }

    if (_model.cikmaz == null) return _showError("Lütfen çıkmaz koridor durumunu seçiniz.");
    
    // Çıkmaz varsa mesafe zorunlu
    if (_model.cikmaz?.label == Bolum35Content.cikmazOptionB.label && _model.cikmazMesafe == null) {
      return _showError("Lütfen çıkmaz koridor mesafesini seçiniz.");
    }

    BinaStore.instance.bolum35 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum36Screen()),
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
            title: "Bölüm-35: Kaçış Mesafeleri",
            subtitle: "Koridor uzunluklarının analizi.",
            currentStep: 25, 
            totalSteps: 26,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 1. Mesafe Sorusu (Tek veya Çift Çıkışa Göre Değişir)
                  if (_tekCikis) 
                    _buildSoru("Evinizin en uzak noktasından bina merdiven kapısına kadar olan mesafe kaç metredir?", 'tekYon', 
                      [
                        Bolum35Content.tekYonOptionB, 
                        Bolum35Content.tekYonOptionC,
                        Bolum35Content.tekYonOptionD
                      ], _model.tekYon)
                  else
                    _buildSoru("Daire kapınızdan çıktığınızda, size EN YAKIN olan yangın merdivenine mesafe kaç metredir?", 'ciftYon', 
                      [
                        Bolum35Content.ciftYonOptionB, 
                        Bolum35Content.ciftYonOptionC,
                        Bolum35Content.ciftYonOptionD
                      ], _model.ciftYon),

                  // 2. Çıkmaz Koridor
                  _buildSoru("Daireniz koridorun sonunda, 'Çıkmaz' bir noktada mı?", 'cikmaz', 
                    [
                      Bolum35Content.cikmazOptionA, 
                      Bolum35Content.cikmazOptionB
                    ], _model.cikmaz),

                  // Alt Soru: Çıkmaz ise Mesafe
                  if (_model.cikmaz?.label == Bolum35Content.cikmazOptionB.label) ...[
                    const Divider(height: 30),
                    _buildSoru("Daire kapınızdan, koridordaki yol ayrımına kadar olan mesafe kaç metredir?", 'cikmazMesafe', 
                      [
                        Bolum35Content.cikmazOptionD, 
                        Bolum35Content.cikmazOptionE,
                        Bolum35Content.cikmazOptionF
                      ], _model.cikmazMesafe),
                  ],
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