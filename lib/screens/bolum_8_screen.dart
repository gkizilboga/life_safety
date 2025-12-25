import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_8_model.dart';
import 'bolum_9_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum8Screen extends StatefulWidget {
  const Bolum8Screen({super.key});

  @override
  State<Bolum8Screen> createState() => _Bolum8ScreenState();
}

class _Bolum8ScreenState extends State<Bolum8Screen> {
  Bolum8Model _model = Bolum8Model();

  void _handleSelection(ChoiceResult choice) {
    setState(() {
      _model = _model.copyWith(secim: choice);
    });
  }

  void _onNextPressed() {
    if (_model.secim == null) return;
    
    BinaStore.instance.bolum8 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum9Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ModernHeader(
            title: "Bölüm-8: Bina Nizamı",
            subtitle: "Binanın Komşu Binalara Göre Konumu",
            currentStep: 8,
            totalSteps: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard(
                          choice: Bolum8Content.ayrikNizam,
                          isSelected: _model.secim?.label == Bolum8Content.ayrikNizam.label,
                          onTap: () => _handleSelection(Bolum8Content.ayrikNizam),
                        ),
                        SelectableCard(
                          choice: Bolum8Content.bitisikNizam,
                          isSelected: _model.secim?.label == Bolum8Content.bitisikNizam.label,
                          onTap: () => _handleSelection(Bolum8Content.bitisikNizam),
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