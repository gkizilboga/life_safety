import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_27_model.dart';
import 'bolum_28_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum27Screen extends StatefulWidget {
  const Bolum27Screen({super.key});

  @override
  State<Bolum27Screen> createState() => _Bolum27ScreenState();
}

class _Bolum27ScreenState extends State<Bolum27Screen> {
  Bolum27Model _model = Bolum27Model();

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'boyut') _model = _model.copyWith(boyut: choice);
      if (type == 'yon') _model = _model.copyWith(yon: choice);
      if (type == 'kilit') _model = _model.copyWith(kilit: choice);
      if (type == 'dayanim') _model = _model.copyWith(dayanim: choice);
    });
  }

  void _onNextPressed() {
    if (_model.boyut == null) return _showError("Lütfen kapı genişliği sorusunu yanıtlayınız.");
    if (_model.yon == null) return _showError("Lütfen kapı açılış yönünü seçiniz.");
    if (_model.kilit == null) return _showError("Lütfen kilit mekanizmasını seçiniz.");
    if (_model.dayanim == null) return _showError("Lütfen kapı dayanımı sorusunu yanıtlayınız.");

    BinaStore.instance.bolum27 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum28Screen()),
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
            title: "Bölüm-27: Kaçış Kapıları",
            subtitle: "Kapıların donanım ve fonksiyonları.",
            currentStep: 17, 
            totalSteps: 26,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildSoru("Yangın merdivenine veya kaçış koridoruna açılan kapıların genişliği ve zemini nasıldır?", 'boyut', 
                    [
                      Bolum27Content.boyutOptionA, 
                      Bolum27Content.boyutOptionB, 
                      Bolum27Content.boyutOptionC
                    ], _model.boyut),

                  _buildSoru("Kaçış kapıları hangi yöne açılıyor ve tipi nedir?", 'yon', 
                    [
                      Bolum27Content.yonOptionA, 
                      Bolum27Content.yonOptionB, 
                      Bolum27Content.yonOptionC,
                      Bolum27Content.yonOptionD
                    ], _model.yon),

                  _buildSoru("Kaçış yollarındaki kapıları açmak için kullanılan mekanizma nasıldır? (Panik Bar / Kapı Kolu vb.)", 'kilit', 
                    [
                      Bolum27Content.kilitOptionA, 
                      Bolum27Content.kilitOptionB, 
                      Bolum27Content.kilitOptionC,
                      Bolum27Content.kilitOptionD
                    ], _model.kilit),

                  _buildSoru("Kaçış yollarındaki kapıların malzemesi ve kapanma özelliği nasıldır?", 'dayanim', 
                    [
                      Bolum27Content.dayanimOptionA, 
                      Bolum27Content.dayanimOptionB, 
                      Bolum27Content.dayanimOptionC,
                      Bolum27Content.dayanimOptionD
                    ], _model.dayanim),
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