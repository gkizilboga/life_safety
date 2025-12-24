import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_11_model.dart';
import 'bolum_12_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum11Screen extends StatefulWidget {
  const Bolum11Screen({super.key});

  @override
  State<Bolum11Screen> createState() => _Bolum11ScreenState();
}

class _Bolum11ScreenState extends State<Bolum11Screen> {
  Bolum11Model _model = Bolum11Model();

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'mesafe') {
        _model = _model.copyWith(mesafe: choice);
      } else if (type == 'engel') {
        _model = _model.copyWith(engel: choice);
      } else if (type == 'zayifNokta') {
        _model = _model.copyWith(zayifNokta: choice);
      }
    });
  }

  void _onNextPressed() {
    // 3 soru da cevaplanmalı
    if (_model.mesafe == null || _model.engel == null) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm soruları yanıtlayınız.")),
      );
      return;
    }
    
    // Zayıf nokta sorusu, sadece engel varsa mantıklı olabilir ama 
    // genelde hepsinin cevaplanması istenir.
    if (_model.zayifNokta == null) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen zayıf geçiş noktası sorusunu da yanıtlayınız.")),
      );
      return;
    }

    BinaStore.instance.bolum11 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum12Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ModernHeader(
            title: "Bölüm-11: İtfaiye Erişimi",
            subtitle: "İtfaiye aracı binaya yanaşabiliyor mu?",
            currentStep: 1, // Detaylı Analiz Adım 1
            totalSteps: 26, // Toplam 26 Detay Adımı Var (11-36 arası)
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // SORU 1
                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "1. İtfaiye aracının binaya yaklaşım mesafesi 45 metreyi geçiyor mu?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        SelectableCard(
                          choice: Bolum11Content.mesafeOptionA,
                          isSelected: _model.mesafe?.label == Bolum11Content.mesafeOptionA.label,
                          onTap: () => _handleSelection('mesafe', Bolum11Content.mesafeOptionA),
                        ),
                        SelectableCard(
                          choice: Bolum11Content.mesafeOptionB,
                          isSelected: _model.mesafe?.label == Bolum11Content.mesafeOptionB.label,
                          onTap: () => _handleSelection('mesafe', Bolum11Content.mesafeOptionB),
                        ),
                        SelectableCard(
                          choice: Bolum11Content.mesafeOptionC,
                          isSelected: _model.mesafe?.label == Bolum11Content.mesafeOptionC.label,
                          onTap: () => _handleSelection('mesafe', Bolum11Content.mesafeOptionC),
                        ),
                      ],
                    ),
                  ),

                  // SORU 2
                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "2. Bahçe duvarı, çevre duvarı veya kilitli kapı engeli var mı?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        SelectableCard(
                          choice: Bolum11Content.engelOptionA,
                          isSelected: _model.engel?.label == Bolum11Content.engelOptionA.label,
                          onTap: () => _handleSelection('engel', Bolum11Content.engelOptionA),
                        ),
                        SelectableCard(
                          choice: Bolum11Content.engelOptionB,
                          isSelected: _model.engel?.label == Bolum11Content.engelOptionB.label,
                          onTap: () => _handleSelection('engel', Bolum11Content.engelOptionB),
                        ),
                        SelectableCard(
                          choice: Bolum11Content.engelOptionC,
                          isSelected: _model.engel?.label == Bolum11Content.engelOptionC.label,
                          onTap: () => _handleSelection('engel', Bolum11Content.engelOptionC),
                        ),
                      ],
                    ),
                  ),

                  // SORU 3
                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "3. Duvarda 'Kırmızı Çarpı (X)' ile işaretlenmiş zayıf geçiş noktası var mı?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        SelectableCard(
                          choice: Bolum11Content.zayifNoktaOptionA,
                          isSelected: _model.zayifNokta?.label == Bolum11Content.zayifNoktaOptionA.label,
                          onTap: () => _handleSelection('zayifNokta', Bolum11Content.zayifNoktaOptionA),
                        ),
                        SelectableCard(
                          choice: Bolum11Content.zayifNoktaOptionB,
                          isSelected: _model.zayifNokta?.label == Bolum11Content.zayifNoktaOptionB.label,
                          onTap: () => _handleSelection('zayifNokta', Bolum11Content.zayifNoktaOptionB),
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
}