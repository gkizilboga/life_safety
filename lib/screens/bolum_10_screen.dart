import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_10_model.dart';
import 'bolum_11_screen.dart'; // ARTIK DETAYLI ANALİZE GEÇİYORUZ
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum10Screen extends StatefulWidget {
  const Bolum10Screen({super.key});

  @override
  State<Bolum10Screen> createState() => _Bolum10ScreenState();
}

class _Bolum10ScreenState extends State<Bolum10Screen> {
  Bolum10Model _model = Bolum10Model();

  void _handleSelection(ChoiceResult choice) {
    setState(() {
      _model = _model.copyWith(secim: choice);
    });
  }

  void _onNextPressed() {
    if (_model.secim == null) return;
    
    BinaStore.instance.bolum10 = _model;
    
    // Buradan sonra Bölüm 11'e (Detaylı Analize) geçiyoruz
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum11Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-10: Kat Kullanım Amacı ve Yoğunlukları",
            subtitle: "...",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Binanın Kullanım Sınıfı ve Yoğunluğu Nedir?",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        SelectableCard(
                          choice: Bolum10Content.konut,
                          isSelected: _model.secim?.label == Bolum10Content.konut.label,
                          onTap: () => _handleSelection(Bolum10Content.konut),
                        ),
                        SelectableCard(
                          choice: Bolum10Content.azYogunTicari,
                          isSelected: _model.secim?.label == Bolum10Content.azYogunTicari.label,
                          onTap: () => _handleSelection(Bolum10Content.azYogunTicari),
                        ),
                        SelectableCard(
                          choice: Bolum10Content.ortaYogunTicari,
                          isSelected: _model.secim?.label == Bolum10Content.ortaYogunTicari.label,
                          onTap: () => _handleSelection(Bolum10Content.ortaYogunTicari),
                        ),
                        SelectableCard(
                          choice: Bolum10Content.yuksekYogunTicari,
                          isSelected: _model.secim?.label == Bolum10Content.yuksekYogunTicari.label,
                          onTap: () => _handleSelection(Bolum10Content.yuksekYogunTicari),
                        ),
                        SelectableCard(
                          choice: Bolum10Content.teknikDepo,
                          isSelected: _model.secim?.label == Bolum10Content.teknikDepo.label,
                          onTap: () => _handleSelection(Bolum10Content.teknikDepo),
                        ),
                      ],
                    ),
                  ),
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
                  onPressed: _model.secim == null ? null : _onNextPressed,
                  child: const Text("BİNA HAKKINDA TEMEL BİLGİLERİ TAMAMLA"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}