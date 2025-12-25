import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_9_model.dart';
import 'bolum_10_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum9Screen extends StatefulWidget {
  const Bolum9Screen({super.key});

  @override
  State<Bolum9Screen> createState() => _Bolum9ScreenState();
}

class _Bolum9ScreenState extends State<Bolum9Screen> {
  Bolum9Model _model = Bolum9Model();

  void _handleSelection(ChoiceResult choice) {
    setState(() {
      _model = _model.copyWith(secim: choice);
    });
  }

  void _onNextPressed() {
    if (_model.secim == null) return;
    
    BinaStore.instance.bolum9 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum10Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ModernHeader(
            title: "Bölüm-9: Otomatik Yangın Söndürme Sistemi Varlığı",
            subtitle: " ",
            currentStep: 9,
            totalSteps: 10,
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
                          "Otomatik Yağmurlama (Sprinkler) Sistemi Durumu:",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        SelectableCard(
                          choice: Bolum9Content.tamKapsam,
                          isSelected: _model.secim?.label == Bolum9Content.tamKapsam.label,
                          onTap: () => _handleSelection(Bolum9Content.tamKapsam),
                        ),
                        SelectableCard(
                          choice: Bolum9Content.yok,
                          isSelected: _model.secim?.label == Bolum9Content.yok.label,
                          onTap: () => _handleSelection(Bolum9Content.yok),
                        ),
                        SelectableCard(
                          choice: Bolum9Content.kismen,
                          isSelected: _model.secim?.label == Bolum9Content.kismen.label,
                          onTap: () => _handleSelection(Bolum9Content.kismen),
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
                  child: const Text("DEVAM ET"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}