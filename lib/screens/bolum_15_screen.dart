import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_15_model.dart';
import 'bolum_16_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum15Screen extends StatefulWidget {
  const Bolum15Screen({super.key});

  @override
  State<Bolum15Screen> createState() => _Bolum15ScreenState();
}

class _Bolum15ScreenState extends State<Bolum15Screen> {
  Bolum15Model _model = Bolum15Model();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'kaplama') _model = _model.copyWith(kaplama: choice);
      if (type == 'yalitim') {
        _model = _model.copyWith(yalitim: choice);
        if (choice.label != Bolum15Content.yalitimOptionB.label) _model = _model.copyWith(yalitimSap: null);
        else _scrollToBottom();
      }
      if (type == 'yalitimSap') _model = _model.copyWith(yalitimSap: choice);
      if (type == 'tavan') {
        _model = _model.copyWith(tavan: choice);
        if (choice.label != Bolum15Content.tavanOptionB.label) _model = _model.copyWith(tavanMalzeme: null);
        else _scrollToBottom();
      }
      if (type == 'tavanMalzeme') _model = _model.copyWith(tavanMalzeme: choice);
      if (type == 'tesisat') _model = _model.copyWith(tesisat: choice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-15: İç Mekan Analizi",
            subtitle: "Kaplama, yalıtım ve tavan detayları",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 1. Zemin Kaplaması
                  _buildSoru("1. Zeminlerinizde kullandığınız kaplama malzemesi nedir?", 'kaplama', 
                    [Bolum15Content.kaplamaOptionA, Bolum15Content.kaplamaOptionB, Bolum15Content.kaplamaOptionC], _model.kaplama),

                  // 2. Isı Yalıtımı
                  _buildSoru("2. Döşeme betonunun üzerinde ısı yalıtım malzemesi (strafor vb.) var mı?", 'yalitim', 
                    [Bolum15Content.yalitimOptionA, Bolum15Content.yalitimOptionB, Bolum15Content.yalitimOptionC], _model.yalitim),

                  // Alt Soru: Şap
                  if (_model.yalitim?.label == Bolum15Content.yalitimOptionB.label) ...[
                    _buildInfoNote("Yalıtım malzemesi tespit edildiği için koruma katmanı (şap) sorgulanmaktadır."),
                    _buildSoru("Yalıtım malzemesinin üzerinde en az 2 cm şap (beton) var mı?", 'yalitimSap', 
                      [Bolum15Content.yalitimSapOptionA, Bolum15Content.yalitimSapOptionB, Bolum15Content.yalitimSapOptionC], _model.yalitimSap),
                  ],

                  // 3. Tavan
                  _buildSoru("3. Koridorlarda veya daire içlerinde Asma Tavan var mı?", 'tavan', 
                    [Bolum15Content.tavanOptionA, Bolum15Content.tavanOptionB, Bolum15Content.tavanOptionC], _model.tavan),

                  // Alt Soru: Tavan Malzemesi
                  if (_model.tavan?.label == Bolum15Content.tavanOptionB.label) ...[
                    _buildInfoNote("Asma tavan tespit edildiği için malzeme yanıcılık sınıfı sorgulanmaktadır."),
                    _buildSoru("Asma tavan malzemesi nedir?", 'tavanMalzeme', 
                      [Bolum15Content.tavanMalzemeOptionA, Bolum15Content.tavanMalzemeOptionB, Bolum15Content.tavanMalzemeOptionC], _model.tavanMalzeme),
                  ],

                  // 4. Tesisat Geçişleri
                  _buildSoru("4. Döşemeden geçen boru ve kablo boşlukları nasıl kapatılmış?", 'tesisat', 
                    [Bolum15Content.tesisatOptionA, Bolum15Content.tesisatOptionB, Bolum15Content.tesisatOptionC], _model.tesisat),
                ],
              ),
            ),
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildSoru(String title, String key, List<ChoiceResult> options, ChoiceResult? selected) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          ...options.map((opt) => SelectableCard(
            choice: opt,
            isSelected: selected?.label == opt.label,
            onTap: () => _handleSelection(key, opt),
          )),
        ],
      ),
    );
  }

  Widget _buildInfoNote(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.arrow_downward, color: Colors.orange, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))]),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _checkIfComplete() ? () {
              BinaStore.instance.bolum15 = _model;
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum16Screen()));
            } : null,
            child: const Text("DEVAM ET"),
          ),
        ),
      ),
    );
  }

  bool _checkIfComplete() {
    if (_model.kaplama == null || _model.yalitim == null || _model.tavan == null || _model.tesisat == null) return false;
    if (_model.yalitim?.label == Bolum15Content.yalitimOptionB.label && _model.yalitimSap == null) return false;
    if (_model.tavan?.label == Bolum15Content.tavanOptionB.label && _model.tavanMalzeme == null) return false;
    return true;
  }
}