import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_19_model.dart';
import 'bolum_20_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum19Screen extends StatefulWidget {
  const Bolum19Screen({super.key});

  @override
  State<Bolum19Screen> createState() => _Bolum19ScreenState();
}

class _Bolum19ScreenState extends State<Bolum19Screen> {
  Bolum19Model _model = Bolum19Model();

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'engel') _model = _model.copyWith(engel: choice);
      if (type == 'levha') _model = _model.copyWith(levha: choice);
      
      if (type == 'yaniltici') {
        _model = _model.copyWith(yanilticiKapi: choice);
        // Seçim değişirse alt soruyu sıfırla
        if (choice.label == Bolum19Content.yanilticiOptionA.label) {
          _model = _model.copyWith(yanilticiEtiketVar: null);
        }
      }
    });
  }

  void _onNextPressed() {
    if (_model.engel == null) return _showError("Lütfen engeller sorusunu yanıtlayınız.");
    if (_model.levha == null) return _showError("Lütfen yönlendirme levhaları sorusunu yanıtlayınız.");
    if (_model.yanilticiKapi == null) return _showError("Lütfen yanıltıcı kapı sorusunu yanıtlayınız.");
    
    // Yanıltıcı kapı varsa etiket sorusu zorunlu
    if (_model.yanilticiKapi?.label == Bolum19Content.yanilticiOptionB.label && _model.yanilticiEtiketVar == null) {
      return _showError("Lütfen yanıltıcı kapıların üzerindeki yazıları belirtiniz.");
    }

    BinaStore.instance.bolum19 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum20Screen()),
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
            title: "Bölüm-19: Kaçış Yolu",
            subtitle: "Koridorlar ve yönlendirmeler.",
            currentStep: 9, 
            totalSteps: 26,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 1. Engeller
                  _buildSoru("Yangın merdivenine giden koridorlarda veya merdiven kapılarında aşağıdakilerden hangisi var?", 'engel', 
                    [
                      Bolum19Content.engelOptionA, 
                      Bolum19Content.engelOptionB, 
                      Bolum19Content.engelOptionC,
                      Bolum19Content.engelOptionD
                    ], _model.engel),

                  // 2. Levhalar
                  _buildSoru("Koridorlarda, ledli veya ışıklı 'ÇIKIŞ' ve koşan adam figürleri asılı mı?", 'levha', 
                    [Bolum19Content.levhaOptionA, Bolum19Content.levhaOptionB, Bolum19Content.levhaOptionC], _model.levha),

                  // 3. Yanıltıcı Kapılar
                  _buildSoru("Koridorda, yangın merdiveni kapısına benzeyen ama aslında depo, elektrik odası veya çöp odası olan kapılar var mı?", 'yaniltici', 
                    [Bolum19Content.yanilticiOptionA, Bolum19Content.yanilticiOptionB], _model.yanilticiKapi),

                  // Alt Soru: Yanıltıcı Kapı Varsa
                  if (_model.yanilticiKapi?.label == Bolum19Content.yanilticiOptionB.label) 
                    Container(
                      margin: const EdgeInsets.only(left: 20, bottom: 20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Bu kapıların üzerinde ne olduğu yazıyor mu? (Depo, Elektrik Odası vb.)", style: TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Radio<bool>(
                                value: true, 
                                groupValue: _model.yanilticiEtiketVar, 
                                onChanged: (v) => setState(() => _model = _model.copyWith(yanilticiEtiketVar: v))
                              ),
                              const Text("Evet Yazıyor"),
                              const SizedBox(width: 10),
                              Radio<bool>(
                                value: false, 
                                groupValue: _model.yanilticiEtiketVar, 
                                onChanged: (v) => setState(() => _model = _model.copyWith(yanilticiEtiketVar: v))
                              ),
                              const Text("Hayır Yazmıyor"),
                            ],
                          )
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