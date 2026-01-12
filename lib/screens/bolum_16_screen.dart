import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_16_model.dart';
import 'bolum_17_screen.dart'; 
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum16Screen extends StatefulWidget {
  const Bolum16Screen({super.key});

  @override
  State<Bolum16Screen> createState() => _Bolum16ScreenState();
}

class _Bolum16ScreenState extends State<Bolum16Screen> {
  Bolum16Model _model = Bolum16Model();
  bool _askBitisik = false;
  double _hBina = 0.0;

  final GlobalKey _bariyerYanKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _hBina = BinaStore.instance.bolum3?.hBina ?? 0.0;
    final b8 = BinaStore.instance.bolum8;
    if (b8?.secim?.label.contains("Bitişik") == true || b8?.secim?.label == "8-1-B") {
      _askBitisik = true;
    }
  }

  void _scrollToKey(GlobalKey key) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          alignment: 0.1,
        );
      }
    });
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'mantolama') {
        _model = _model.copyWith(mantolama: choice);
        if (choice.label == Bolum16Content.mantolamaOptionA.label) {
          if (_hBina <= 28.50) {
            _scrollToKey(_bariyerYanKey);
          } else {
            _model = _model.copyWith(bariyerYan: null, bariyerUst: null, bariyerZemin: null);
          }
        } else {
          _model = _model.copyWith(bariyerYan: null, bariyerUst: null, bariyerZemin: null);
        }
        if (choice.label != Bolum16Content.giydirmeOptionC.label) {
          _model = _model.copyWith(giydirmeBoslukYalitim: null);
        }
      }
      if (type == 'sagir') {
        _model = _model.copyWith(sagirYuzey: choice);
        if (choice.label != Bolum16Content.sagirYuzeyOptionB.label) {
          _model = _model.copyWith(sagirYuzeySprinkler: null);
        }
      }
      if (type == 'bitisik') {
        _model = _model.copyWith(bitisikNizam: choice);
      }
    });
  }

  bool _isReady() {
    if (_model.mantolama == null) return false;
    if (_model.mantolama?.label == Bolum16Content.mantolamaOptionA.label && _hBina <= 28.50) {
      if (_model.bariyerYan == null || _model.bariyerUst == null || _model.bariyerZemin == null) return false;
    }
    if (_model.mantolama?.label == Bolum16Content.giydirmeOptionC.label && _model.giydirmeBoslukYalitim == null) return false;
    if (_model.sagirYuzey == null) return false;
    if (_model.sagirYuzey?.label == Bolum16Content.sagirYuzeyOptionB.label && _model.sagirYuzeySprinkler == null) return false;
    if (_askBitisik && _model.bitisikNizam == null) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Dış Cephe Özellikleri",
      subtitle: "Cephe malzemesi ve yangın sıçrama",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: () {
        BinaStore.instance.bolum16 = _model;
        BinaStore.instance.saveToDisk();
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum17Screen()));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSoru("Binanızdaki dış cephe kaplama veya ısı yalıtım sistemi nedir?", 'mantolama', [
            Bolum16Content.mantolamaOptionA, 
            Bolum16Content.mantolamaOptionB, 
            Bolum16Content.giydirmeOptionC,
            Bolum16Content.mantolamaOptionD,
            Bolum16Content.mantolamaOptionE
          ], _model.mantolama),

          if (_model.mantolama?.label == Bolum16Content.mantolamaOptionA.label && _hBina <= 28.50) ...[
            _buildSubQuestion(_bariyerYanKey, "Pencerelerin yanlarında en az 15 cm eninde yanmaz bariyer var mı?", _model.bariyerYan, (v) => setState(() => _model = _model.copyWith(bariyerYan: v))),
            _buildSubQuestion(null, "Pencerelerin üstünde 30 cm eninde yanmaz bariyer var mı?", _model.bariyerUst, (v) => setState(() => _model = _model.copyWith(bariyerUst: v))),
            _buildSubQuestion(null, "Zemin seviyesinden 150 cm yüksekliğe kadar yanmaz malzemeyle kaplama var mı?", _model.bariyerZemin, (v) => setState(() => _model = _model.copyWith(bariyerZemin: v))),
          ],

          if (_model.mantolama?.label == Bolum16Content.giydirmeOptionC.label) 
            _buildSubQuestionRadio("Cephe ile döşeme arasındaki boşluklar yalıtılmış mı?", _model.giydirmeBoslukYalitim, (v) => setState(() => _model = _model.copyWith(giydirmeBoslukYalitim: v))),

          _buildSoru("Katlar arasındaki sağır (yanmaz) yüzey yüksekliği ne kadar?", 'sagir', [
            Bolum16Content.sagirYuzeyOptionA,
            Bolum16Content.sagirYuzeyOptionB,
            Bolum16Content.sagirYuzeyOptionC
          ], _model.sagirYuzey),

          if (_model.sagirYuzey?.label == Bolum16Content.sagirYuzeyOptionB.label)
            _buildSubQuestionRadio("Cepheye doğru bakan özel sprinkler sistemi var mı?", _model.sagirYuzeySprinkler, (v) => setState(() => _model = _model.copyWith(sagirYuzeySprinkler: v))),

          if (_askBitisik)
            _buildSoru("3. Binanız bitişik nizamda ve yan binadan daha yüksek mi?", 'bitisik', [
              Bolum16Content.bitisikOptionA,
              Bolum16Content.bitisikOptionB,
              Bolum16Content.bitisikOptionC
            ], _model.bitisikNizam),
        ],
      ),
    );
  }

  Widget _buildSoru(String t, String k, List<ChoiceResult> o, ChoiceResult? s) {
    return QuestionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 12), ...o.map((opt) => SelectableCard(choice: opt, isSelected: s?.label == opt.label, onTap: () => _handleSelection(k, opt)))]));
  }

  Widget _buildSubQuestion(Key? key, String title, int? groupValue, Function(int?) onChanged) {
    return Container(
      key: key,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE0E0E0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF455A64))),
          const SizedBox(height: 8),
          Row(
            children: [
              Radio<int>(value: 1, groupValue: groupValue, activeColor: const Color(0xFF1A237E), onChanged: onChanged),
              const Text("Evet", style: TextStyle(fontSize: 12)),
              Radio<int>(value: 0, groupValue: groupValue, activeColor: const Color(0xFF1A237E), onChanged: onChanged),
              const Text("Hayır", style: TextStyle(fontSize: 12)),
              Radio<int>(value: 2, groupValue: groupValue, activeColor: const Color(0xFF1A237E), onChanged: onChanged),
              const Text("Bilmiyorum", style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubQuestionRadio(String title, bool? groupValue, Function(bool?) onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE0E0E0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF455A64))),
          const SizedBox(height: 4),
          Row(
            children: [
              Radio<bool>(value: true, groupValue: groupValue, activeColor: const Color(0xFF1A237E), onChanged: onChanged),
              const Text("Evet", style: TextStyle(fontSize: 13)),
              const SizedBox(width: 15),
              Radio<bool>(value: false, groupValue: groupValue, activeColor: const Color(0xFF1A237E), onChanged: onChanged),
              const Text("Hayır", style: TextStyle(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}