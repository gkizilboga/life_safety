import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_28_model.dart';
import 'bolum_29_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum28Screen extends StatefulWidget {
  const Bolum28Screen({super.key});

  @override
  State<Bolum28Screen> createState() => _Bolum28ScreenState();
}

class _Bolum28ScreenState extends State<Bolum28Screen> {
  Bolum28Model _model = Bolum28Model();

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'mesafe') _model = _model.copyWith(mesafe: choice);
      
      if (type == 'dubleks') {
        _model = _model.copyWith(dubleks: choice);
        // Normal daire seçilirse alt soruları temizle
        if (choice.label == Bolum28Content.dubleksOptionA.label) {
          _model = _model.copyWith(alan: null, cikis: null);
        }
      }

      if (type == 'alan') {
        _model = _model.copyWith(alan: choice);
        // Küçük alan seçilirse çıkış sorusunu temizle
        if (choice.label == Bolum28Content.alanOption1.label) {
          _model = _model.copyWith(cikis: null);
        }
      }

      if (type == 'cikis') _model = _model.copyWith(cikis: choice);
    });
  }

  void _onNextPressed() {
    if (_model.mesafe == null) return _showError("Lütfen mesafe sorusunu yanıtlayınız.");
    if (_model.dubleks == null) return _showError("Lütfen daire tipini seçiniz.");

    // Dubleks seçildiyse alan sorusu zorunlu
    if (_model.dubleks?.label == Bolum28Content.dubleksOptionB.label) {
      if (_model.alan == null) return _showError("Lütfen üst kat alanını belirtiniz.");
      
      // Büyük alan seçildiyse çıkış sorusu zorunlu
      if (_model.alan?.label == Bolum28Content.alanOption2.label && _model.cikis == null) {
        return _showError("Lütfen üst kat çıkış kapısı durumunu belirtiniz.");
      }
    }

    BinaStore.instance.bolum28 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum29Screen()),
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
            title: "Bölüm-28: Daire İçi",
            subtitle: "Mesafeler ve kat planı.",
            currentStep: 18, 
            totalSteps: 26,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 1. Mesafe
                  _buildSoru("Evinizin içindeki en uzak odadan daire giriş kapısına kadar olan yürüme mesafesi yaklaşık ne kadardır?", 'mesafe', 
                    [
                      Bolum28Content.mesafeOptionA, 
                      Bolum28Content.mesafeOptionB, 
                      Bolum28Content.mesafeOptionC
                    ], _model.mesafe),

                  // 2. Dubleks
                  _buildSoru("Daireniz Dubleks (İki katlı) mi?", 'dubleks', 
                    [
                      Bolum28Content.dubleksOptionA, 
                      Bolum28Content.dubleksOptionB
                    ], _model.dubleks),

                  // Alt Soru 1: Alan (Sadece Dubleks ise)
                  if (_model.dubleks?.label == Bolum28Content.dubleksOptionB.label) ...[
                    const Divider(height: 30),
                    _buildSoru("Üst katınızın alanı 70 m²'den büyük mü?", 'alan', 
                      [
                        Bolum28Content.alanOption1, 
                        Bolum28Content.alanOption2
                      ], _model.alan),
                  ],

                  // Alt Soru 2: Çıkış (Sadece Büyük Alan ise)
                  if (_model.alan?.label == Bolum28Content.alanOption2.label) ...[
                    const Divider(height: 30),
                    _buildSoru("Üst kattan apartman koridoruna açılan ikinci bir çelik kapı (çıkış) var mı?", 'cikis', 
                      [
                        Bolum28Content.cikisOptionA, 
                        Bolum28Content.cikisOptionB
                      ], _model.cikis),
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