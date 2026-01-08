import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import '../../models/bolum_21_model.dart';
import 'bolum_22_screen.dart'; 
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
  bool _isMandatory = false;
  double _hYapi = 0.0;

  @override
  void initState() {
    super.initState();
    _hYapi = BinaStore.instance.bolum4?.hesaplananYapiYuksekligi ?? 0.0;
    _checkMandatory();
  }

  void _checkMandatory() {
    if (_hYapi >= 30.50) {
      setState(() => _isMandatory = true);
    } else {
      bool hasRiskyBasement = BinaStore.instance.bolum10?.bodrumlar.any((e) => e != null && !e.label.contains("10-A")) ?? false;
      setState(() => _isMandatory = hasRiskyBasement);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Yangın Güvenlik Holü (YGH)",
      subtitle: " ",
      screenType: widget.runtimeType,
      isNextEnabled: _model.varlik != null,
      onNext: () {
        BinaStore.instance.bolum21 = _model;
        BinaStore.instance.saveToDisk();
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum22Screen()));
      },
      child: Column(
        children: [
          _buildHeightCard(),
          _buildSoru("Merdivenlerin önünde Yangın Güvenlik Holü var mı?", 'varlik', [Bolum21Content.varlikOptionA, Bolum21Content.varlikOptionB], _model.varlik),
        ],
      ),
    );
  }

  Widget _buildHeightCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _isMandatory ? Colors.orange.shade50 : Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Icon(_isMandatory ? Icons.warning_amber : Icons.info_outline, color: _isMandatory ? Colors.orange.shade900 : Colors.blue.shade900),
        const SizedBox(width: 12),
        Expanded(child: Text("Yapı Yüksekliği: $_hYapi m. ${_isMandatory ? 'YGH zorunludur.' : 'YGH zorunlu değildir.'}", style: TextStyle(fontWeight: FontWeight.bold, color: _isMandatory ? Colors.orange.shade900 : Colors.blue.shade900))),
      ]),
    );
  }

  Widget _buildSoru(String t, String k, List<ChoiceResult> o, ChoiceResult? s) {
    return QuestionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 12), ...o.map((opt) => SelectableCard(choice: opt, isSelected: s?.label == opt.label, onTap: () => setState(() => _model = _model.copyWith(varlik: opt))))]));
  }
}