import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_21_model.dart';
import 'bolum_22_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum21Screen extends StatefulWidget {
  const Bolum21Screen({super.key});

  @override
  State<Bolum21Screen> createState() => _Bolum21ScreenState();
}

class _Bolum21ScreenState extends State<Bolum21Screen> {
  Bolum21Model _model = Bolum21Model();

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'varlik') {
        _model = _model.copyWith(varlik: choice);
        // Eğer "YGH Yok" (B seçeneği) seçilirse, diğer cevapları temizle
        if (choice.label == Bolum21Content.varlikOptionB.label) {
          _model = _model.copyWith(malzeme: null, kapi: null, esya: null);
        }
      } else if (type == 'malzeme') {
        _model = _model.copyWith(malzeme: choice);
      } else if (type == 'kapi') {
        _model = _model.copyWith(kapi: choice);
      } else if (type == 'esya') {
        _model = _model.copyWith(esya: choice);
      }
    });
  }

  void _onNextPressed() {
    if (_model.varlik == null) return _showError("Lütfen YGH varlığı sorusunu yanıtlayınız.");

    // Eğer YGH varsa (Option A), diğer sorular da zorunlu
    if (_model.varlik?.label == Bolum21Content.varlikOptionA.label) {
      if (_model.malzeme == null) return _showError("Lütfen YGH malzemesi sorusunu yanıtlayınız.");
      if (_model.kapi == null) return _showError("Lütfen YGH kapı özellikleri sorusunu yanıtlayınız.");
      if (_model.esya == null) return _showError("Lütfen YGH 'de bulunabilecek eşya durumu sorusunu yanıtlayınız.");
    }

    BinaStore.instance.bolum21 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum22Screen()),
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
          ModernHeader(
            title: "Bölüm-21: Yangın Güvenlik Holü (YGH)",
            subtitle: "...",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 1. Varlık Sorusu
                  _buildSoru("Daire kapınızdan çıktığınızda merdivene doğru yürürken, merdivene girmeden evvel ufak bir odadan (YGH'den) geçiyor musunuz?", 'varlik', 
                    [
                      Bolum21Content.varlikOptionA, 
                      Bolum21Content.varlikOptionB
                    ], _model.varlik),

                  // Diğer sorular SADECE YGH VARSA gösterilir
                  if (_model.varlik?.label == Bolum21Content.varlikOptionA.label) ...[
                    const Divider(height: 30),
                    
                    // 2. Malzeme Sorusu
                    _buildSoru("YGH duvarlarında, zemininde, tavanında kullanılan malzeme nedir?", 'malzeme', 
                      [
                        Bolum21Content.malzemeOptionA, 
                        Bolum21Content.malzemeOptionB,
                        Bolum21Content.malzemeOptionC
                      ], _model.malzeme),

                    // 3. Kapı Sorusu
                    _buildSoru("Bu YGH'ye giriş-çıkış sağlayan kapıların özelliği nedir?", 'kapi', 
                      [
                        Bolum21Content.kapiOptionA, 
                        Bolum21Content.kapiOptionB,
                        Bolum21Content.kapiOptionC
                      ], _model.kapi),

                    // 4. Eşya Sorusu
                    _buildSoru("YGH'nin içinde geçici veya kalıcı sebeplerle herhangi bir eşya vs.  bekletiliyor mu veya bu holde kaçışa engel bir unsur var mı?", 'esya', 
                      [
                        Bolum21Content.esyaOptionA, 
                        Bolum21Content.esyaOptionB,
                        Bolum21Content.esyaOptionC
                      ], _model.esya),
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
          )),
        ],
      ),
    );
  }
}