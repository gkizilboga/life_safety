import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_34_model.dart';
import 'bolum_35_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum34Screen extends StatefulWidget {
  const Bolum34Screen({super.key});

  @override
  State<Bolum34Screen> createState() => _Bolum34ScreenState();
}

class _Bolum34ScreenState extends State<Bolum34Screen> {
  Bolum34Model _model = Bolum34Model();
  bool _hasTicari = false;

  @override
  void initState() {
    super.initState();
    _checkTicari();
  }

  void _checkTicari() {
    final b6 = BinaStore.instance.bolum6;
    if (b6?.hasTicari == true) {
      _hasTicari = true;
    }
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'zemin') _model = _model.copyWith(zemin: choice);
      if (type == 'bodrum') _model = _model.copyWith(bodrum: choice);
    });
  }

  void _onNextPressed() {
    if (_hasTicari) {
      if (_model.zemin == null) return _showError("Lütfen zemin kat ticari çıkış durumunu seçiniz.");
      if (_model.bodrum == null) return _showError("Lütfen bodrum kat ticari çıkış durumunu seçiniz.");
    }

    BinaStore.instance.bolum34 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum35Screen()),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasTicari) {
      return Scaffold(
        appBar: AppBar(title: const Text("Bölüm-34")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Binanızda Ticari Alan bulunmadığı için bu bölüm atlanmıştır."),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _onNextPressed, child: const Text("DEVAM ET"))
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          const ModernHeader(
            title: "Bölüm-34: Ticari Alanlar",
            subtitle: "Dükkan ve mağaza çıkışları.",
            currentStep: 24, 
            totalSteps: 26,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildSoru("Zemin kattaki dükkan, mağaza veya restoranların doğrudan sokağa açılan kapıları var mı?", 'zemin', 
                    [
                      Bolum34Content.zeminOptionA, 
                      Bolum34Content.zeminOptionB, 
                      Bolum34Content.zeminOptionC
                    ], _model.zemin),

                  _buildSoru("Bodrum kattaki ticari alanların doğrudan dışarıya çıkan kendilerine ait bir merdiveni var mı?", 'bodrum', 
                    [
                      Bolum34Content.bodrumOptionA, 
                      Bolum34Content.bodrumOptionB, 
                      Bolum34Content.bodrumOptionC
                    ], _model.bodrum),
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