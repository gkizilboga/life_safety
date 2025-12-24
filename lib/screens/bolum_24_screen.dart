import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_24_model.dart';
import 'bolum_25_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum24Screen extends StatefulWidget {
  const Bolum24Screen({super.key});

  @override
  State<Bolum24Screen> createState() => _Bolum24ScreenState();
}

class _Bolum24ScreenState extends State<Bolum24Screen> {
  Bolum24Model _model = Bolum24Model();

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'tip') {
        _model = _model.copyWith(tip: choice);
        // "İç Koridor" (Option A) seçilirse diğer soruları temizle
        if (choice.label == Bolum24Content.tipOptionA.label) {
          _model = _model.copyWith(pencere: null, kapi: null);
        }
      } else if (type == 'pencere') {
        _model = _model.copyWith(pencere: choice);
      } else if (type == 'kapi') {
        _model = _model.copyWith(kapi: choice);
      }
    });
  }

  void _onNextPressed() {
    if (_model.tip == null) return _showError("Lütfen koridor tipini seçiniz.");

    // Açık Koridor (Option B) seçilirse diğer sorular zorunlu
    if (_model.tip?.label == Bolum24Content.tipOptionB.label) {
      if (_model.pencere == null) return _showError("Lütfen pencere durumunu seçiniz.");
      if (_model.kapi == null) return _showError("Lütfen kapı özelliğini seçiniz.");
    }

    BinaStore.instance.bolum24 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum25Screen()),
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
            title: "Bölüm-24: Açık Koridorlar",
            subtitle: "Dışarıya açık geçitlerin güvenliği.",
            currentStep: 14, 
            totalSteps: 26,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 1. Tip Sorusu
                  _buildSoru("Daire kapınızdan çıktığınızda nereye çıkıyorsunuz?", 'tip', 
                    [
                      Bolum24Content.tipOptionA, 
                      Bolum24Content.tipOptionB
                    ], _model.tip),

                  // Diğer sorular SADECE AÇIK KORİDORSA gösterilir
                  if (_model.tip?.label == Bolum24Content.tipOptionB.label) ...[
                    const Divider(height: 30),
                    
                    // 2. Pencere Sorusu
                    _buildSoru("Bu açık kaçış yoluna bakan daire pencereleriniz var mı?", 'pencere', 
                      [
                        Bolum24Content.pencereOptionA, 
                        Bolum24Content.pencereOptionB
                      ], _model.pencere),

                    // 3. Kapı Sorusu
                    _buildSoru("Bu açık koridora açılan daire kapınızın özelliği nedir?", 'kapi', 
                      [
                        Bolum24Content.kapiOptionA, 
                        Bolum24Content.kapiOptionB
                      ], _model.kapi),
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