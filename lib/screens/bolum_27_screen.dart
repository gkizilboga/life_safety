import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../data/bina_store.dart';
import '../../models/bolum_27_model.dart';
import 'bolum_28_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_assets.dart';

class Bolum27Screen extends StatefulWidget {
  const Bolum27Screen({super.key});

  @override
  State<Bolum27Screen> createState() => _Bolum27ScreenState();
}

class _Bolum27ScreenState extends State<Bolum27Screen> {
  Bolum27Model _model = Bolum27Model();
  bool _needsFireDoor = false; 
  double _maxUserLoad = 0;

  @override
  void initState() {
    super.initState();
    _loadLogicData();
  }

  void _loadLogicData() {
    final b20 = BinaStore.instance.bolum20;
    
    // KRİTİK MANTIK: Sadece 2. ve 3. tip merdivenler varsa Adım-4 açılır
    int closedStairsCount = 0;
    if (b20 != null) {
      closedStairsCount += b20.binaIciYanginMerdiveniSayisi; // Tip 2
      closedStairsCount += b20.binaDisiKapaliYanginMerdiveniSayisi; // Tip 3
    }
    bool needsFireDoor = closedStairsCount > 0;

    final b33 = BinaStore.instance.bolum33;
    double maxLoad = 0;
    if (b33 != null) {
      maxLoad = math.max(b33.yukZemin ?? 0, math.max(b33.yukNormal ?? 0, b33.yukBodrum ?? 0));
    }

    setState(() {
      _needsFireDoor = needsFireDoor;
      _maxUserLoad = maxLoad;
    });
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'boyut') _model = _model.copyWith(boyut: choice);
      if (type == 'yon') {
        _model = _model.copyWith(yon: choice);
        if (_maxUserLoad > 50 && choice.label == Bolum27Content.yonOptionB.label) {
          _showWarning("⚠️ DİKKAT: Kullanıcı yükü 50 kişiyi aştığı için kapıların kaçış yönüne açılması zorunludur!");
        }
      }
      if (type == 'kilit') {
        _model = _model.copyWith(kilit: choice);
        if (_maxUserLoad > 100 && choice.label == Bolum27Content.kilitOptionB.label) {
          _showWarning("⚠️ DİKKAT: Kullanıcı yükü 100 kişiyi aştığı için PANİK BAR zorunludur!");
        }
      }
      if (type == 'dayanim') _model = _model.copyWith(dayanim: choice);
    });
  }

  void _showWarning(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg), backgroundColor: Colors.orange[900], duration: const Duration(seconds: 4)
    ));
  }

  bool _isReady() {
    if (_model.boyut == null || _model.yon == null || _model.kilit == null) return false;
    if (_needsFireDoor && _model.dayanim == null) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Kaçış Yolu Kapıları",
      subtitle: "Kapıların yön, kilit ve dayanım analizi",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: () {
        BinaStore.instance.bolum27 = _model;
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum28Screen()));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEnZayifHalkaUyarisi(),

          // --- ADIM 1 ---
          _buildSoruHeader("1. Kaçış kapılarının genişliği ve zemini ne durumdadır?"),
          TechnicalDrawingButton(assetPath: AppAssets.section27YanginKapisi, title: "Kapı Genişliği ve Eşik Standartı"),
          _buildSoruCard('boyut', [Bolum27Content.boyutOptionA, Bolum27Content.boyutOptionB, Bolum27Content.boyutOptionC], _model.boyut),

          // --- ADIM 2 ---
          _buildSoruHeader("2. Kaçış kapıları hangi yöne açılıyor?"),
          TechnicalDrawingButton(assetPath: AppAssets.section27KacisYonu, title: "Kapı Açılış Yönü Kriterleri"),
          _buildSoruCard('yon', [Bolum27Content.yonOptionA, Bolum27Content.yonOptionB, Bolum27Content.yonOptionC, Bolum27Content.yonOptionD], _model.yon),

          // --- ADIM 3 ---
          _buildSoruHeader("3. Kapı kilit mekanizması nasıldır?"),
          TechnicalDrawingButton(assetPath: AppAssets.section27KilitTipi, title: "Kilit ve Panik Bar Tipleri"),
          _buildSoruCard('kilit', [Bolum27Content.kilitOptionA, Bolum27Content.kilitOptionB, Bolum27Content.kilitOptionC, Bolum27Content.kilitOptionD], _model.kilit),

          // --- ADIM 4 (Şartlı) ---
          if (_needsFireDoor) ...[
            const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(thickness: 1.5)),
            _buildInfoNote("Binada kapalı yangın merdiveni tespit edildiği için dayanım sorusu açılmıştır."),
            _buildSoruHeader("4. Kapalı yangın merdiveni kapısının malzemesi nedir?"),
            _buildSoruCard('dayanim', [Bolum27Content.dayanimOptionA, Bolum27Content.dayanimOptionB, Bolum27Content.dayanimOptionC, Bolum27Content.dayanimOptionD], _model.dayanim),
          ],
        ],
      ),
    );
  }

  Widget _buildSoruHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 12),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF263238))),
    );
  }

  Widget _buildSoruCard(String key, List<ChoiceResult> options, ChoiceResult? selected) {
    return QuestionCard(
      child: Column(
        children: options.map((opt) => SelectableCard(
          choice: opt,
          isSelected: selected?.label == opt.label,
          onTap: () => _handleSelection(key, opt),
        )).toList(),
      ),
    );
  }

  Widget _buildEnZayifHalkaUyarisi() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.red.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red.withOpacity(0.2))),
      child: const Row(children: [
        Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
        SizedBox(width: 12),
        Expanded(child: Text("Lütfen kaçış yolunuz üzerindeki durumu EN KÖTÜ olan kapıyı baz alarak cevap veriniz.", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12))),
      ]),
    );
  }

  Widget _buildInfoNote(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.blue.withOpacity(0.2))),
      child: Row(children: [
        const Icon(Icons.info_outline, color: Colors.blue, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(color: Color(0xFF1565C0), fontWeight: FontWeight.bold, fontSize: 12))),
      ]),
    );
  }
}