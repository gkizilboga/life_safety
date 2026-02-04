import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_21_model.dart';
import 'bolum_22_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';

class Bolum21Screen extends StatefulWidget {
  const Bolum21Screen({super.key});

  @override
  State<Bolum21Screen> createState() => _Bolum21ScreenState();
}

class _Bolum21ScreenState extends State<Bolum21Screen> {
  Bolum21Model _model = Bolum21Model();
  bool _isMandatory = false;
  String _mandatoryReason = "";
  double _hYapi = 0.0;

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum21 != null) {
      _model = BinaStore.instance.bolum21!;
    }
    _hYapi = BinaStore.instance.bolum4?.hesaplananYapiYuksekligi ?? 0.0;
    _checkMandatory();
  }

  void _checkMandatory() {
    bool heightRisk = _hYapi >= 30.50;
    bool basementRisk =
        BinaStore.instance.bolum10?.bodrumlar.any(
          (e) =>
              e != null &&
              (e.label.contains("10-B") ||
                  e.label.contains("10-C") ||
                  e.label.contains("10-D") ||
                  e.label.contains("10-E")),
        ) ??
        false;

    if (heightRisk) {
      setState(() {
        _isMandatory = true;
        _mandatoryReason =
            "Yapı yüksekliği 30.50m üzerinde olduğu için YGH zorunludur.";
      });
    } else if (basementRisk) {
      setState(() {
        _isMandatory = true;
        _mandatoryReason =
            "Bodrum katlardaki farklı kullanım amacı nedeniyle YGH zorunludur.";
      });
    } else {
      setState(() {
        _isMandatory = false;
        _mandatoryReason = "Mevcut verilere göre YGH zorunlu değildir.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Yangın Güvenlik Holü (YGH)",
      subtitle: "",
      screenType: widget.runtimeType,
      isNextEnabled: _model.varlik != null,
      onNext: () {
        BinaStore.instance.bolum21 = _model;
        BinaStore.instance.saveToDisk();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bolum22Screen()),
        );
      },
      child: Column(
        children: [
          // YGH görseli - sorulardan bağımsız, her zaman görünür
          // YGH görseli - Buton olarak
          const TechnicalDrawingButton(
            assetPath: 'assets/images/sections/ygh_1.webp',
            title: "Örnek YGH Yerleşimi ve Detayını İncele",
          ),
          const SizedBox(height: 16),
          _buildInfoCard(),
          _buildSoru(
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Merdiven önünde Yangın Güvenlik Holü var mı?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DefinitionButton(
                  term: "Yangın Güvenlik Holü (YGH)",
                  definition: AppDefinitions.yanginGuvenlikHolu,
                ),
              ],
            ),
            'varlik',
            [Bolum21Content.varlikOptionA, Bolum21Content.varlikOptionB],
            _model.varlik,
          ),

          if (_model.varlik?.label == Bolum21Content.varlikOptionA.label) ...[
            _buildSoru(
              "YGH (Hol) içindeki kaplama malzemeleri yanmaz özellikte mi?",
              'malzeme',
              [
                Bolum21Content.malzemeOptionA,
                Bolum21Content.malzemeOptionB,
                Bolum21Content.malzemeOptionC,
              ],
              _model.malzeme,
            ),
            _buildSoru(
              "YGH (Hol) kapıları duman sızdırmaz ve yangına dayanıklı mı?",
              'kapi',
              [
                Bolum21Content.kapiOptionA,
                Bolum21Content.kapiOptionB,
                Bolum21Content.kapiOptionC,
              ],
              _model.kapi,
            ),
            _buildSoru(
              "YGH (Hol) içinde eşya (bisiklet, dolap vb.) var mı?",
              'esya',
              [
                Bolum21Content.esyaOptionA,
                Bolum21Content.esyaOptionB,
                Bolum21Content.esyaOptionC,
              ],
              _model.esya,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isMandatory ? Colors.orange.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isMandatory ? Colors.orange.shade200 : Colors.blue.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isMandatory ? Icons.warning_amber : Icons.info_outline,
            color: _isMandatory ? Colors.orange.shade900 : Colors.blue.shade900,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isMandatory ? "YGH ZORUNLUDUR" : "YGH ZORUNLU DEĞİLDİR",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isMandatory
                        ? Colors.orange.shade900
                        : Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _mandatoryReason,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoru(
    dynamic title,
    String keyParam,
    List<ChoiceResult> options,
    ChoiceResult? selected,
  ) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title is String)
            Text(title, style: AppStyles.questionTitle)
          else if (title is Widget)
            title,
          const SizedBox(height: 12),
          ...options.map(
            (opt) => SelectableCard(
              choice: opt,
              isSelected: selected?.label == opt.label,
              onTap: () => setState(() {
                if (keyParam == 'varlik') {
                  _model = _model.copyWith(varlik: opt);
                }
                if (keyParam == 'malzeme')
                  _model = _model.copyWith(malzeme: opt);
                if (keyParam == 'kapi') _model = _model.copyWith(kapi: opt);
                if (keyParam == 'esya') _model = _model.copyWith(esya: opt);
                _checkMandatory();
              }),
            ),
          ),
        ],
      ),
    );
  }
}
