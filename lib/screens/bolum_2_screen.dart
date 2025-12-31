import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_2_model.dart';
import 'bolum_3_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_assets.dart';



class Bolum2Screen extends StatefulWidget {
  const Bolum2Screen({super.key});

  @override
  State<Bolum2Screen> createState() => _Bolum2ScreenState();
}

class _Bolum2ScreenState extends State<Bolum2Screen> {
  Bolum2Model _model = Bolum2Model();

  void _handleSelection(ChoiceResult choice) {
    setState(() {
      _model = _model.copyWith(secim: choice);
    });
  }

  void _onNextPressed() {
    if (_model.secim == null) return;
    
    BinaStore.instance.bolum2 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum3Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-2: Taşıyıcı Sistem",
            subtitle: "...",
            screenType: widget.runtimeType,

            // onBack: () => Navigator.pop(context), // İstersen geri butonu ekleyebilirsin
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
                          choice: Bolum2Content.betonarme,
                          isSelected: _model.secim?.label == Bolum2Content.betonarme.label,
                          onTap: () => _handleSelection(Bolum2Content.betonarme),
                        ),
                        SelectableCard(
                          choice: Bolum2Content.celik,
                          isSelected: _model.secim?.label == Bolum2Content.celik.label,
                          onTap: () => _handleSelection(Bolum2Content.celik),
                        ),
                        TechnicalDrawingButton(
                          assetPath: AppAssets.section2Celik,
                          title: "Çelik Yapı Görseli",
                        ),
                        const SizedBox(height: 12),

                        SelectableCard(
                          choice: Bolum2Content.ahsap,
                          isSelected: _model.secim?.label == Bolum2Content.ahsap.label,
                          onTap: () => _handleSelection(Bolum2Content.ahsap),
                        ),
                        SelectableCard(
                          choice: Bolum2Content.yigma,
                          isSelected: _model.secim?.label == Bolum2Content.yigma.label,
                          onTap: () => _handleSelection(Bolum2Content.yigma),
                        ),
                        SelectableCard(
                          choice: Bolum2Content.bilinmiyor,
                          isSelected: _model.secim?.label == Bolum2Content.bilinmiyor.label,
                          onTap: () => _handleSelection(Bolum2Content.bilinmiyor),
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