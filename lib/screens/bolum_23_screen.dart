import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_23_model.dart';
import 'bolum_24_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum23Screen extends StatefulWidget {
  const Bolum23Screen({super.key});

  @override
  State<Bolum23Screen> createState() => _Bolum23ScreenState();
}

class _Bolum23ScreenState extends State<Bolum23Screen> {
  Bolum23Model _model = Bolum23Model();

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'bodrum') _model = _model.copyWith(bodrum: choice);
      if (type == 'yanginModu') _model = _model.copyWith(yanginModu: choice);
      if (type == 'konum') _model = _model.copyWith(konum: choice);
      if (type == 'levha') _model = _model.copyWith(levha: choice);
      if (type == 'havalandirma') _model = _model.copyWith(havalandirma: choice);
    });
  }

  void _onNextPressed() {
    if (_model.bodrum == null) return _showError("Lütfen bodrum kata iniş durumunu seçiniz.");
    if (_model.yanginModu == null) return _showError("Lütfen yangın modu durumunu seçiniz.");
    if (_model.konum == null) return _showError("Lütfen asansör kapı konumunu seçiniz.");
    if (_model.levha == null) return _showError("Lütfen uyarı levhası durumunu seçiniz.");
    if (_model.havalandirma == null) return _showError("Lütfen kuyu havalandırma durumunu seçiniz.");

    BinaStore.instance.bolum23 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum24Screen()),
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
            title: "Bölüm-23: Normal Asansörler",
            subtitle: "Genel asansör güvenlik kontrolleri.",
            currentStep: 13, 
            totalSteps: 26,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 1. Bodrum
                  _buildSoru("Asansörünüz bodrum kata (Otopark, Depo vb.) iniyor mu?", 'bodrum', 
                    [
                      Bolum23Content.bodrumOptionA, 
                      Bolum23Content.bodrumOptionB, 
                      Bolum23Content.bodrumOptionC,
                      Bolum23Content.bodrumOptionD
                    ], _model.bodrum),

                  // 2. Yangın Modu
                  _buildSoru("Yangın alarmı çaldığında asansörler otomatik zemin kata inip kapılarını açıyor mu?", 'yanginModu', 
                    [
                      Bolum23Content.yanginModuOptionA, 
                      Bolum23Content.yanginModuOptionB,
                      Bolum23Content.yanginModuOptionC
                    ], _model.yanginModu),

                  // 3. Kapı Konumu
                  _buildSoru("Asansör kapıları (zemin üstü) normal katlarda nereye açılıyor?", 'konum', 
                    [
                      Bolum23Content.konumOptionA, 
                      Bolum23Content.konumOptionB,
                      Bolum23Content.konumOptionC
                    ], _model.konum),

                  // 4. Levha
                  _buildSoru("Kapıların üzerinde 'YANGIN ANINDA KULLANILMAZ' uyarısı var mı?", 'levha', 
                    [
                      Bolum23Content.levhaOptionA, 
                      Bolum23Content.levhaOptionB,
                      Bolum23Content.levhaOptionC
                    ], _model.levha),

                  // 5. Havalandırma
                  _buildSoru("Asansör kuyusunun tepesinde duman tahliyesi için bir havalandırma var mı?", 'havalandirma', 
                    [
                      Bolum23Content.havalandirmaOptionA, 
                      Bolum23Content.havalandirmaOptionB,
                      Bolum23Content.havalandirmaOptionC
                    ], _model.havalandirma),
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